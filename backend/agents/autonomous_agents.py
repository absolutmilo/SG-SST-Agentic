from typing import Dict, List, Any, Optional
from datetime import datetime, timedelta
from enum import Enum
import json
from sqlalchemy.orm import Session
from sqlalchemy import text

class AgentAction(str, Enum):
    """Acciones que puede realizar un agente"""
    CREATE_TASK = "create_task"
    SEND_ALERT = "send_alert"
    ESCALATE = "escalate"
    APPROVE = "approve"
    REJECT = "reject"
    REQUEST_INFO = "request_info"
    SCHEDULE = "schedule"
    ASSIGN = "assign"
    CLOSE = "close"
    GENERATE_REPORT = "generate_report"


class Priority(str, Enum):
    """Niveles de prioridad"""
    CRITICAL = "Crítica"
    HIGH = "Alta"
    MEDIUM = "Media"
    LOW = "Baja"


# ============================================================
# 1. AGENTE COORDINADOR DE TAREAS (Task Coordinator Agent)
# ============================================================

class TaskCoordinatorAgent:
    """
    Agente que coordina y prioriza tareas automáticamente
    basado en:
    - Fechas de vencimiento (SP_Monitorear_Tareas_Vencidas)
    - Requisitos legales (SP_Generar_Tareas_Vigencia)
    - Carga de trabajo de responsables
    """
    
    def __init__(self, db_session: Session):
        self.db = db_session
        self.rules = self._load_rules()
    
    def _load_rules(self) -> Dict:
        """Carga reglas de priorización"""
        return {
            "legal_urgency": {
                "examen_medico_vencido": {"priority": Priority.CRITICAL, "days": 0},
                "reporte_arl_pendiente": {"priority": Priority.CRITICAL, "days": 2},
                "comite_vencido": {"priority": Priority.HIGH, "days": 0},
                "capacitacion_obligatoria": {"priority": Priority.HIGH, "days": 30},
                "inspeccion_equipos": {"priority": Priority.MEDIUM, "days": 15},
            },
            "workload_threshold": 10,  # Máximo de tareas activas por persona
            "escalation_days": 3,  # Días antes de escalar
        }
    
    def analyze_and_coordinate(self) -> List[Dict]:
        """
        Analiza el estado actual y coordina acciones
        """
        actions = []
        
        # 1. Analizar tareas vencidas (Usa SP existente)
        actions.extend(self._handle_overdue_tasks())
        
        # 2. Crear tareas preventivas (Usa SP existente)
        actions.extend(self._create_preventive_tasks())
        
        # 3. Redistribuir carga de trabajo
        actions.extend(self._rebalance_workload())
        
        # 4. Escalar tareas críticas
        actions.extend(self._escalate_critical_tasks())
        
        return actions
    
    def _handle_overdue_tasks(self) -> List[Dict]:
        """Maneja tareas vencidas usando SP_Monitorear_Tareas_Vencidas"""
        actions = []
        
        # Ejecutar SP que actualiza estados y devuelve tareas vencidas
        result = self.db.execute(text("EXEC SP_Monitorear_Tareas_Vencidas"))
        tasks = result.fetchall() # Fetch all to avoid cursor issues during updates
        
        for task in tasks:
            # El SP devuelve DiasVencida (índice 7 en el resultado)
            days_overdue = task[7]  # DiasVencida column
            
            if days_overdue > 7:
                # AUTOMATIZACIÓN: Escalar al supervisor inmediatamente
                
                # 1. Buscar ID del supervisor del responsable actual
                # Necesitamos el ID del empleado responsable, el SP no lo devuelve directamente pero podemos buscarlo por correo
                # O mejor, hacer una query directa para obtener el supervisor
                
                supervisor_query = text("""
                    SELECT e.id_supervisor, s.Nombre + ' ' + s.Apellidos as NombreSupervisor, s.Correo as CorreoSupervisor
                    FROM EMPLEADO e
                    JOIN EMPLEADO s ON e.id_supervisor = s.id_empleado
                    WHERE e.Correo = :correo
                """)
                
                supervisor = self.db.execute(supervisor_query, {"correo": task[5]}).fetchone()  # task[5] = CorreoResponsable
                
                if supervisor:
                    # 2. Ejecutar el cambio de responsable (Escalamiento)
                    update_sql = text("""
                        UPDATE TAREA 
                        SET id_empleado_responsable = :new_resp,
                            Prioridad = 'Crítica',
                            Descripcion = Descripcion + ' [ESCALADA AUTOMÁTICAMENTE POR AGENTE]',
                            Fecha_Actualizacion = GETDATE()
                        WHERE id_tarea = :task_id
                    """)
                    
                    self.db.execute(update_sql, {
                        "new_resp": supervisor[0],  # id_supervisor
                        "task_id": task[0]  # id_tarea
                    })
                    self.db.commit()
                    
                    actions.append({
                        "action": AgentAction.ESCALATE,
                        "task_id": task.id_tarea,
                        "escalated_to": supervisor.NombreSupervisor,
                        "reason": f"Tarea vencida hace {days_overdue} días. Reasignada automáticamente al supervisor.",
                        "priority": Priority.CRITICAL,
                        "status": "EXECUTED"
                    })
                else:
                    # No tiene supervisor asignado, notificar a RRHH o Admin (fallback)
                    actions.append({
                        "action": AgentAction.ESCALATE,
                        "task_id": task[0],  # id_tarea
                        "reason": f"Tarea vencida hace {days_overdue} días. No se pudo escalar (sin supervisor asignado).",
                        "priority": Priority.CRITICAL,
                        "status": "FAILED"
                    })
                    
            elif days_overdue > 3:
                # Enviar alerta al responsable
                actions.append({
                    "action": AgentAction.SEND_ALERT,
                    "task_id": task[0],  # id_tarea
                    "recipient": task[5],  # CorreoResponsable
                    "message": f"Tarea '{task[1]}' vencida hace {days_overdue} días. Requiere acción inmediata.",  # task[1] = Descripcion
                    "priority": Priority.HIGH,
                    "details": dict(task._mapping)
                })
        
        return actions
    
    def _create_preventive_tasks(self) -> List[Dict]:
        """Crea tareas preventivas usando SP_Generar_Tareas_Vigencia"""
        actions = []
        
        # Asumimos ID Coordinador SST = 101 (como en el script SQL)
        # Este SP genera tareas automáticamente en la BD
        result = self.db.execute(text("EXEC SP_Generar_Tareas_Vigencia @IdCoordinadorSST = 101"))
        row = result.fetchone()
        
        if row and row.TareasGeneradas > 0:
            actions.append({
                "action": AgentAction.CREATE_TASK,
                "description": f"Se generaron automáticamente {row.TareasGeneradas} tareas preventivas por vencimientos.",
                "count": row.TareasGeneradas,
                "priority": Priority.HIGH
            })
            self.db.commit() # Confirmar la creación de tareas
            
        return actions
    
    def _rebalance_workload(self) -> List[Dict]:
        """Redistribuye carga de trabajo si es necesario"""
        actions = []
        
        # Consultar carga de trabajo por empleado
        query = """
        SELECT 
            e.id_empleado,
            e.Nombre,
            e.Area,
            COUNT(t.id_tarea) as TareasPendientes,
            AVG(DATEDIFF(DAY, GETDATE(), t.Fecha_Vencimiento)) as DiasPromedio
        FROM EMPLEADO e
        LEFT JOIN TAREA t ON e.id_empleado = t.id_empleado_responsable
        WHERE e.Estado = 1 AND t.Estado IN ('Pendiente', 'En Curso')
        GROUP BY e.id_empleado, e.Nombre, e.Area
        HAVING COUNT(t.id_tarea) > 0
        ORDER BY COUNT(t.id_tarea) DESC
        """
        
        workload = self.db.execute(text(query)).fetchall()
        threshold = self.rules["workload_threshold"]
        
        for employee in workload:
            if employee.TareasPendientes > threshold:
                actions.append({
                    "action": AgentAction.SEND_ALERT,
                    "recipient": "coordinador_sst",
                    "message": f"{employee.Nombre} tiene {employee.TareasPendientes} tareas activas (umbral: {threshold}). Considerar redistribución.",
                    "priority": Priority.MEDIUM,
                    "data": {
                        "employee_id": employee.id_empleado,
                        "workload": employee.TareasPendientes
                    }
                })
        
        return actions
    
    def _escalate_critical_tasks(self) -> List[Dict]:
        """Escala tareas críticas que no han sido atendidas"""
        actions = []
        
        query = """
        SELECT t.id_tarea, t.Descripcion, t.Fecha_Creacion,
               e.Nombre, e.id_supervisor
        FROM TAREA t
        JOIN EMPLEADO e ON t.id_empleado_responsable = e.id_empleado
        WHERE t.Estado = 'Pendiente'
        AND t.Prioridad IN ('Crítica', 'Alta')
        AND DATEDIFF(DAY, t.Fecha_Creacion, GETDATE()) >= 3
        """
        
        tasks_to_escalate = self.db.execute(text(query)).fetchall()
        
        for task in tasks_to_escalate:
            actions.append({
                "action": AgentAction.ESCALATE,
                "task_id": task.id_tarea,
                "escalate_to": task.id_supervisor,
                "reason": "Tarea crítica sin atención por más de 3 días",
                "priority": Priority.CRITICAL
            })
        
        return actions


# ============================================================
# 2. AGENTE PLANIFICADOR (Planning Agent)
# ============================================================

class PlanningAgent:
    """
    Agente que crea planes automáticamente basado en:
    - Requisitos legales
    - Historial de la empresa (SP_Calcular_Indicadores_Siniestralidad)
    - Mejores prácticas
    """
    
    def __init__(self, db_session: Session):
        self.db = db_session
    
    def generate_annual_plan(self, year: int) -> Dict:
        """Genera plan de trabajo anual automáticamente"""
        
        plan = {
            "year": year,
            "objectives": self._generate_objectives(),
            "tasks": [],
            "budget_estimate": 0
        }
        
        # 1. Tareas obligatorias por ley
        plan["tasks"].extend(self._generate_legal_tasks(year))
        
        # 2. Tareas basadas en riesgos identificados
        plan["tasks"].extend(self._generate_risk_based_tasks())
        
        # 3. Tareas de mejora continua
        plan["tasks"].extend(self._generate_improvement_tasks())
        
        # 4. Calcular presupuesto estimado
        plan["budget_estimate"] = self._estimate_budget(plan["tasks"])
        
        return plan
    
    def _generate_objectives(self) -> List[Dict]:
        """Genera objetivos SMART automáticamente usando SP de indicadores"""
        
        # Consultar indicadores del año anterior
        prev_year = datetime.now().year - 1
        query = text("EXEC SP_Calcular_Indicadores_Siniestralidad @Anio = :anio")
        
        result = self.db.execute(query, {"anio": prev_year}).fetchone()
        
        objectives = []
        
        if result:
            # Objetivo 1: Reducir accidentalidad
            # El SP retorna índices en posiciones: [2]=Indice_Frecuencia, [3]=Indice_Severidad
            if result[2] > 5:  # Indice_Frecuencia
                reduction_target = result[2] * 0.8  # 20% reducción
                objectives.append({
                    "description": f"Reducir el Índice de Frecuencia de {result[2]:.2f} a {reduction_target:.2f}",
                    "metric": "Indice_Frecuencia",
                    "baseline": result.Indice_Frecuencia,
                    "target": reduction_target,
                    "deadline": f"{datetime.now().year}-12-31"
                })
        
        # Objetivo 2: Cumplimiento de capacitaciones
        objectives.append({
            "description": "Alcanzar 95% de cumplimiento en el plan de capacitación",
            "metric": "Porcentaje_Cumplimiento_Capacitacion",
            "baseline": 0,
            "target": 95,
            "deadline": f"{datetime.now().year}-12-31"
        })
        
        # Objetivo 3: Exámenes médicos al día
        objectives.append({
            "description": "Mantener 100% de empleados con exámenes médicos vigentes",
            "metric": "Porcentaje_EMO_Vigentes",
            "baseline": 0,
            "target": 100,
            "deadline": f"{datetime.now().year}-12-31"
        })
        
        return objectives
    
    def _generate_legal_tasks(self, year: int) -> List[Dict]:
        """Genera tareas obligatorias por ley"""
        tasks = []
        
        # Capacitaciones obligatorias
        capacitaciones = [
            {"tema": "Inducción SST", "frecuencia": "mensual", "duracion": 2},
            {"tema": "Riesgos Específicos", "frecuencia": "trimestral", "duracion": 3},
            {"tema": "Plan de Emergencias", "frecuencia": "semestral", "duracion": 4},
            {"tema": "Primeros Auxilios", "frecuencia": "anual", "duracion": 8},
        ]
        
        for cap in capacitaciones:
            if cap["frecuencia"] == "mensual":
                for month in range(1, 13):
                    tasks.append({
                        "descripcion": f"Capacitación: {cap['tema']}",
                        "tipo": "Capacitación",
                        "fecha_estimada": datetime(year, month, 15).isoformat(),
                        "duracion_horas": cap["duracion"],
                        "prioridad": Priority.HIGH,
                        "obligatoria": True
                    })
        
        # Reuniones COPASST (mensuales)
        for month in range(1, 13):
            tasks.append({
                "descripcion": f"Reunión COPASST #{month}",
                "tipo": "Comité",
                "fecha_estimada": datetime(year, month, 10).isoformat(),
                "prioridad": Priority.HIGH,
                "obligatoria": True
            })
        
        # Inspecciones (trimestrales)
        inspecciones = ["Extintores", "Botiquines", "Instalaciones", "EPP"]
        for quarter in range(1, 5):
            month = quarter * 3
            for insp in inspecciones:
                tasks.append({
                    "descripcion": f"Inspección de {insp} - Q{quarter}",
                    "tipo": "Inspección",
                    "fecha_estimada": datetime(year, month, 15).isoformat(),
                    "prioridad": Priority.MEDIUM,
                    "obligatoria": True
                })
        
        # Auditoría interna anual
        tasks.append({
            "descripcion": "Auditoría Interna SG-SST",
            "tipo": "Auditoría",
            "fecha_estimada": datetime(year, 11, 15).isoformat(),
            "prioridad": Priority.CRITICAL,
            "obligatoria": True
        })
        
        # Revisión por la dirección
        tasks.append({
            "descripcion": "Revisión por la Dirección",
            "tipo": "Revisión",
            "fecha_estimada": datetime(year, 12, 15).isoformat(),
            "prioridad": Priority.CRITICAL,
            "obligatoria": True
        })
        
        return tasks
    
    def _generate_risk_based_tasks(self) -> List[Dict]:
        """Genera tareas basadas en riesgos identificados"""
        tasks = []
        
        # Consultar riesgos altos
        query = """
        SELECT r.id_riesgo, r.Peligro, r.Proceso, 
               r.Nivel_Riesgo_Inicial, r.Zona_Area
        FROM RIESGO r
        WHERE r.Nivel_Riesgo_Inicial >= 600  -- Riesgo alto
        AND r.Estado = 'Vigente'
        """
        
        high_risks = self.db.execute(text(query)).fetchall()
        
        for risk in high_risks:
            # Crear tarea de control trimestral
            tasks.append({
                "descripcion": f"Verificar controles para: {risk.Peligro} en {risk.Zona_Area}",
                "tipo": "Control de Riesgo",
                "area": risk.Zona_Area,
                "prioridad": Priority.HIGH,
                "frecuencia": "trimestral"
            })
        
        return tasks
    
    def _generate_improvement_tasks(self) -> List[Dict]:
        """Genera tareas de mejora continua"""
        tasks = []
        
        # Basado en hallazgos de auditorías anteriores (si la tabla existe, el script SQL no la mostraba explícitamente pero el user code la usaba)
        # Asumiremos que HALLAZGO_INSPECCION es lo que tenemos
        query = """
        SELECT Descripcion, NivelRiesgo
        FROM HALLAZGO_INSPECCION
        WHERE EstadoAccion IN ('Pendiente', 'En Proceso')
        AND NivelRiesgo IN ('Alto', 'Crítico')
        """
        
        try:
            hallazgos = self.db.execute(text(query)).fetchall()
            
            for hallazgo in hallazgos:
                tasks.append({
                    "descripcion": f"Atender hallazgo crítico: {hallazgo.Descripcion[:100]}...",
                    "tipo": "Mejora",
                    "prioridad": Priority.HIGH,
                    "origen": "Inspección anterior"
                })
        except Exception:
            # Tabla podría no existir o tener otro nombre
            pass
        
        return tasks
    
    def _estimate_budget(self, tasks: List[Dict]) -> float:
        """Estima presupuesto necesario"""
        
        costs = {
            "Capacitación": 150000,  # Por capacitación
            "Inspección": 50000,
            "Auditoría": 2000000,
            "EPP": 100000,
            "Mantenimiento": 200000,
        }
        
        total = 0
        for task in tasks:
            tipo = task.get("tipo", "")
            total += costs.get(tipo, 0)
        
        # Agregar 10% de contingencia
        total *= 1.1
        
        return total


# ============================================================
# 3. AGENTE ANALÍTICO (Analytics Agent)
# ============================================================

class AnalyticsAgent:
    """
    Agente que analiza datos y genera insights automáticamente
    """
    
    def __init__(self, db_session: Session):
        self.db = db_session
    
    def analyze_trends(self) -> Dict:
        """Analiza tendencias y genera insights"""
        
        insights = {
            "accident_trends": self._analyze_accident_trends(),
            "training_effectiveness": self._analyze_training_effectiveness(),
            "risk_hotspots": self._identify_risk_hotspots(),
            "compliance_gaps": self._identify_compliance_gaps(),
            "recommendations": []
        }
        
        # Generar recomendaciones basadas en análisis
        insights["recommendations"] = self._generate_recommendations(insights)
        
        return insights
    
    def _analyze_accident_trends(self) -> Dict:
        """Analiza tendencias de accidentalidad usando SP"""
        
        monthly_data = []
        current_year = datetime.now().year
        
        # Llamar al SP solo para el año completo (no acepta @Mes)
        result = self.db.execute(
            text("EXEC SP_Calcular_Indicadores_Siniestralidad @Anio = :anio"),
            {"anio": current_year}
        ).fetchone()
        
        if result:
            # Usar datos anuales en lugar de mensuales
            monthly_data.append({
                "Anio": current_year,
                "NumAccidentes": result[5],  # Total_Accidentes
                    "DiasIncapacidad": result.Dias_Incapacidad_Total
                })
        
        # Calcular tendencia simple (solo tenemos datos anuales)
        trend = "stable"  # Sin datos mensuales, asumimos estable
        change_pct = 0
        
        return {
            "trend": trend,
            "change_percentage": change_pct,
            "monthly_data": monthly_data
        }
    
    def _analyze_training_effectiveness(self) -> Dict:
        """Analiza efectividad de capacitaciones"""
        
        query = """
        SELECT 
            c.Tema,
            COUNT(DISTINCT a.id_empleado) as NumAsistentes,
            AVG(a.Calificacion) as CalificacionPromedio,
            SUM(CASE WHEN a.Aprobo = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as TasaAprobacion
        FROM CAPACITACION c
        LEFT JOIN ASISTENCIA a ON c.id_capacitacion = a.id_capacitacion
        WHERE c.Estado = 'Realizada'
        AND c.Fecha_Realizacion >= DATEADD(MONTH, -6, GETDATE())
        GROUP BY c.Tema
        HAVING COUNT(DISTINCT a.id_empleado) > 0
        """
        
        effectiveness = self.db.execute(text(query)).fetchall()
        
        return {
            "by_topic": [dict(row) for row in effectiveness],
            "overall_satisfaction": sum(row.CalificacionPromedio for row in effectiveness) / len(effectiveness) if effectiveness else 0
        }
    
    def _identify_risk_hotspots(self) -> List[Dict]:
        """Identifica áreas con mayor concentración de riesgos"""
        
        query = """
        SELECT 
            r.Zona_Area,
            COUNT(*) as NumRiesgos,
            AVG(r.Nivel_Riesgo_Inicial) as PromedioNivelRiesgo,
            SUM(CASE WHEN r.Nivel_Riesgo_Inicial >= 600 THEN 1 ELSE 0 END) as RiesgosAltos
        FROM RIESGO r
        WHERE r.Estado = 'Vigente'
        GROUP BY r.Zona_Area
        HAVING AVG(r.Nivel_Riesgo_Inicial) > 300
        ORDER BY AVG(r.Nivel_Riesgo_Inicial) DESC
        """
        
        hotspots = self.db.execute(text(query)).fetchall()
        
        return [dict(row) for row in hotspots]
    
    def _identify_compliance_gaps(self) -> List[Dict]:
        """Identifica brechas de cumplimiento usando SP"""
        
        gaps = []
        
        # Gap 1: EMO vencidos (Usa SP_Reporte_Cumplimiento_EMO)
        result_emo = self.db.execute(text("EXEC SP_Reporte_Cumplimiento_EMO")).fetchone()
        
        # El SP retorna: Total_Empleados_Activos, EMO_Vigentes, Sin_EMO, EMO_Por_Vencer_45_Dias, Porcentaje
        if result_emo:
            # Sin EMO
            if result_emo[2] > 0: # Sin_EMO es indice 2
                gaps.append({
                    "area": "Exámenes Médicos",
                    "gap": f"{result_emo[2]} empleados sin EMO registrado",
                    "severity": "high"
                })
            
            # Por Vencer
            if result_emo[3] > 0: # EMO_Por_Vencer_45_Dias es indice 3
                gaps.append({
                    "area": "Exámenes Médicos",
                    "gap": f"{result_emo[3]} empleados con EMO por vencer en 45 días",
                    "severity": "medium"
                })
        
        # Gap 2: Capacitaciones pendientes
        query_cap = """
        SELECT COUNT(*) as Count
        FROM CAPACITACION
        WHERE Estado = 'Programada'
        AND Fecha_Programada < GETDATE()
        """
        
        cap_gap = self.db.execute(text(query_cap)).fetchone()
        if cap_gap and cap_gap.Count > 0:
            gaps.append({
                "area": "Capacitaciones",
                "gap": f"{cap_gap.Count} capacitaciones pendientes de realizar",
                "severity": "medium"
            })
        
        return gaps
    
    def _generate_recommendations(self, insights: Dict) -> List[str]:
        """Genera recomendaciones basadas en insights"""
        recommendations = []
        
        # Basado en tendencia de accidentes
        if insights["accident_trends"]["trend"] == "increasing":
            recommendations.append(
                f"⚠️ Los accidentes han aumentado un {insights['accident_trends']['change_percentage']:.1f}%. "
                "Recomendación: Revisar controles de riesgo y reforzar capacitaciones."
            )
        
        # Basado en hotspots
        if insights["risk_hotspots"]:
            top_area = insights["risk_hotspots"][0]
            recommendations.append(
                f"📍 El área '{top_area['Zona_Area']}' concentra {top_area['RiesgosAltos']} riesgos altos. "
                "Recomendación: Priorizar inspecciones y controles en esta zona."
            )
        
        # Basado en gaps de cumplimiento
        for gap in insights["compliance_gaps"]:
            if gap["severity"] == "high":
                recommendations.append(
                    f"🚨 {gap['gap']}. "
                    "Acción requerida: Implementar plan correctivo inmediato."
                )
        
        return recommendations
