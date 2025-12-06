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
        
        # 5. Monitorear alertas del Dashboard (NUEVO)
        actions.extend(self._monitor_dashboard_alerts())
        
        # 6. Corrección Proactiva de Brechas (NUEVO - Solicitud Usuario)
        actions.extend(self._correct_compliance_gaps())
        
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

    def _get_responsible_for_alert(self, message: str, tipo: str) -> int:
        """
        Determina el responsable basado en el contenido de la alerta y la normativa.
        Retorna el ID del empleado.
        """
        # 1. Definir mapeo de Palabras Clave -> Rol Responsable
        routing_rules = [
            # COPASST
            {"keywords": ["COPASST", "Comité Paritario", "Acta Reunión"], "role": "Presidente COPASST"},
            # Convivencia
            {"keywords": ["Convivencia", "Acoso", "Conflicto"], "role": "Comité Convivencia"}, # Asignar a un miembro
            # Emergencias / Brigadas
            {"keywords": ["Brigada", "Simulacro", "Extintor", "Botiquín", "Emergencia"], "role": "Líder de Brigada"},
            {"keywords": ["Primeros Auxilios"], "role": "Brigadista Primeros Auxilios"},
            {"keywords": ["Evacuación"], "role": "Brigadista Evacuación"},
            # Auditoría
            {"keywords": ["Auditoría", "Hallazgo", "No Conformidad"], "role": "Auditor Interno"},
            # Investigación Accidentes
            {"keywords": ["Accidente", "Incidente", "Investigación"], "role": "Investigador de Accidentes"},
            # Alta Dirección
            {"keywords": ["Presupuesto", "Revisión Dirección", "Política"], "role": "Gerente General"},
        ]
        
        target_role = "Coordinador SST" # Default
        
        # 2. Buscar coincidencia
        message_lower = message.lower()
        tipo_lower = tipo.lower()
        
        for rule in routing_rules:
            for keyword in rule["keywords"]:
                if keyword.lower() in message_lower or keyword.lower() in tipo_lower:
                    target_role = rule["role"]
                    break
            if target_role != "Coordinador SST":
                break
        
        # 3. Buscar ID del empleado con ese rol
        # Priorizamos el rol específico, si no existe, fallback al Coordinador
        query = text("""
            SELECT TOP 1 e.id_empleado 
            FROM EMPLEADO e
            JOIN EMPLEADO_ROL er ON e.id_empleado = er.id_empleado
            JOIN ROL r ON er.id_rol = r.id_rol
            WHERE r.NombreRol = :role
            AND e.Estado = 1
        """)
        
        responsible_id = self.db.execute(query, {"role": target_role}).scalar()
        
        if not responsible_id:
            # Si no se encuentra el rol específico (ej. no hay Presidente COPASST asignado),
            # buscar al Coordinador SST como respaldo.
            fallback_query = text("""
                SELECT TOP 1 e.id_empleado 
                FROM EMPLEADO e
                JOIN EMPLEADO_ROL er ON e.id_empleado = er.id_empleado
                JOIN ROL r ON er.id_rol = r.id_rol
                WHERE r.NombreRol IN ('Coordinador SST', 'Responsable SG-SST', 'Director SST')
                AND e.Estado = 1
                ORDER BY r.id_rol DESC
            """)
            responsible_id = self.db.execute(fallback_query).scalar()
            
            if not responsible_id:
                responsible_id = 1 # Fallback final (Admin)
                
        return responsible_id

    def _monitor_dashboard_alerts(self) -> List[Dict]:
        """
        Monitorea alertas activas en VW_Dashboard_Alertas y toma acciones.
        Integra la vista de alertas con la lógica de agentes.
        """
        actions = []
        
        try:
            # Consultar la vista
            query = text("SELECT * FROM VW_Dashboard_Alertas ORDER BY Prioridad DESC")
            alerts = self.db.execute(query).fetchall()
            
            for alert in alerts:
                # Mapeo de columnas basado en la definición de la vista proporcionada
                alert_data = dict(alert._mapping)
                
                tipo = alert_data.get('Tipo', 'General')
                mensaje = alert_data.get('Mensaje', 'Alerta sin descripción')
                prioridad = alert_data.get('Prioridad', 'Media')
                
                # LÓGICA DE ENRUTAMIENTO INTELIGENTE (Normativa)
                assigned_to = self._get_responsible_for_alert(mensaje, tipo)
                
                # Lógica de acción basada en prioridad
                if prioridad == 'Crítica':
                    # Para alertas críticas: Crear Tarea + Escalar
                    description = f"Atender alerta crítica: {mensaje}"
                    
                    # Insertar Tarea
                    insert_sql = text("""
                        INSERT INTO TAREA (id_empleado_responsable, Descripcion, Fecha_Vencimiento, Prioridad, Estado, Tipo_Tarea)
                        VALUES (:resp, :desc, DATEADD(day, 1, GETDATE()), 'Crítica', 'Pendiente', 'Gestión Alerta')
                    """)
                    self.db.execute(insert_sql, {"resp": assigned_to, "desc": description})
                    self.db.commit()

                    actions.append({
                        "action": AgentAction.ESCALATE,
                        "reason": f"Alerta Crítica de Dashboard: {mensaje}",
                        "priority": Priority.CRITICAL,
                        "details": alert_data
                    })
                    
                    actions.append({
                        "action": AgentAction.CREATE_TASK,
                        "description": description,
                        "assigned_to": assigned_to,
                        "priority": Priority.CRITICAL,
                        "tipo": "Corrección Inmediata"
                    })
                    
                elif prioridad == 'Alta':
                    # Para alertas altas: Crear Tarea + Notificar
                    description = f"Gestionar alerta: {mensaje}"
                    
                    # Insertar Tarea
                    insert_sql = text("""
                        INSERT INTO TAREA (id_empleado_responsable, Descripcion, Fecha_Vencimiento, Prioridad, Estado, Tipo_Tarea)
                        VALUES (:resp, :desc, DATEADD(day, 3, GETDATE()), 'Alta', 'Pendiente', 'Gestión Alerta')
                    """)
                    self.db.execute(insert_sql, {"resp": assigned_to, "desc": description})
                    self.db.commit()

                    actions.append({
                        "action": AgentAction.CREATE_TASK,
                        "description": description,
                        "assigned_to": assigned_to,
                        "priority": Priority.HIGH,
                        "tipo": "Gestión de Alerta"
                    })
                    
                    actions.append({
                        "action": AgentAction.SEND_ALERT,
                        "message": f"Nueva alerta alta en dashboard: {mensaje}",
                        "priority": Priority.HIGH
                    })
                    
                else:
                    # Para otras: Solo registrar/sugerir tarea (sin insertar en BD para no saturar)
                    actions.append({
                        "action": AgentAction.CREATE_TASK,
                        "description": f"Revisar: {mensaje}",
                        "priority": Priority.MEDIUM,
                        "tipo": "Revisión Rutinaria"
                    })
                    
        except Exception as e:
            # Log error but don't crash the agent
            print(f"Error monitoring dashboard alerts: {e}")
            
        return actions

    def _correct_compliance_gaps(self) -> List[Dict]:
        """
        Acción Proactiva: Ejecuta SPs de reporte y asigna tareas correctivas automáticamente.
        Garantiza que el agente 'decide corregir' asignando tareas específicas.
        
        GAPS (Brechas de Cumplimiento):
        1. EMOs vencidos/faltantes
        2. Capacitaciones obligatorias pendientes
        3. Inspecciones vencidas
        4. Reuniones COPASST pendientes
        """
        actions = []
        
        try:
            # ========================================
            # GAP 1: EMOs Vencidos o Faltantes
            # ========================================
            query_emo = text("""
                SELECT 
                    E.id_empleado,
                    E.Nombre + ' ' + E.Apellidos AS NombreCompleto,
                    E.Correo,
                    CASE 
                        WHEN EM.id_examen IS NULL THEN 'Sin EMO Registrado'
                        WHEN EM.Fecha_Vencimiento < CAST(GETDATE() AS DATE) THEN 'EMO Vencido'
                    END AS Estado
                FROM EMPLEADO E
                LEFT JOIN (
                    SELECT EM1.id_empleado, EM1.id_examen, EM1.Fecha_Vencimiento
                    FROM EXAMEN_MEDICO EM1
                    WHERE EM1.Tipo_Examen = 'Periodico'
                    AND EM1.id_examen = (
                        SELECT TOP 1 id_examen FROM EXAMEN_MEDICO 
                        WHERE id_empleado = EM1.id_empleado AND Tipo_Examen = 'Periodico'
                        ORDER BY Fecha_Realizacion DESC
                    )
                ) EM ON E.id_empleado = EM.id_empleado
                WHERE E.Estado = 1
                AND (EM.id_examen IS NULL OR EM.Fecha_Vencimiento < CAST(GETDATE() AS DATE))
            """)
            
            employees_emo = self.db.execute(query_emo).fetchall()
            
            for emp in employees_emo:
                description = f"Realizar Examen Médico Ocupacional ({emp.Estado})"
                
                # Verificar duplicados
                check_task = text("""
                    SELECT COUNT(*) FROM TAREA 
                    WHERE id_empleado_responsable = :emp_id 
                    AND Descripcion LIKE :desc 
                    AND Estado IN ('Pendiente', 'En Curso')
                """)
                exists = self.db.execute(check_task, {"emp_id": emp.id_empleado, "desc": f"%Examen Médico%"}).scalar()
                
                if exists == 0:
                    insert_task = text("""
                        INSERT INTO TAREA (id_empleado_responsable, Descripcion, Fecha_Vencimiento, Prioridad, Estado, Tipo_Tarea)
                        VALUES (:emp_id, :desc, DATEADD(day, 15, GETDATE()), 'Alta', 'Pendiente', 'Salud')
                    """)
                    self.db.execute(insert_task, {"emp_id": emp.id_empleado, "desc": description})
                    self.db.commit()
                    
                    actions.append({
                        "action": AgentAction.CREATE_TASK,
                        "gap_type": "EMO",
                        "recipient": emp.NombreCompleto,
                        "task": description,
                        "status": "ASSIGNED_AUTOMATICALLY"
                    })

            # ========================================
            # GAP 2: Capacitaciones Obligatorias Pendientes
            # ========================================
            # Buscar capacitaciones programadas que no se han realizado
            query_cap = text("""
                SELECT 
                    c.id_capacitacion,
                    c.Tema,
                    c.Fecha_Programada,
                    DATEDIFF(DAY, c.Fecha_Programada, GETDATE()) AS DiasVencidos
                FROM CAPACITACION c
                WHERE c.Estado = 'Programada'
                AND c.Fecha_Programada < GETDATE()
            """)
            
            capacitaciones_pendientes = self.db.execute(query_cap).fetchall()
            
            # Buscar al Coordinador SST para asignarle la tarea
            coord_query = text("""
                SELECT TOP 1 e.id_empleado 
                FROM EMPLEADO e
                JOIN EMPLEADO_ROL er ON e.id_empleado = er.id_empleado
                JOIN ROL r ON er.id_rol = r.id_rol
                WHERE r.NombreRol IN ('Coordinador SST', 'Director SST')
                AND e.Estado = 1
            """)
            coord_id = self.db.execute(coord_query).scalar() or 1
            
            for cap in capacitaciones_pendientes:
                description = f"Ejecutar capacitación pendiente: {cap.Tema} (vencida hace {cap.DiasVencidos} días)"
                
                # Verificar duplicados
                check_task = text("""
                    SELECT COUNT(*) FROM TAREA 
                    WHERE id_empleado_responsable = :coord_id 
                    AND Descripcion LIKE :desc 
                    AND Estado IN ('Pendiente', 'En Curso')
                """)
                exists = self.db.execute(check_task, {"coord_id": coord_id, "desc": f"%{cap.Tema}%"}).scalar()
                
                if exists == 0:
                    insert_task = text("""
                        INSERT INTO TAREA (id_empleado_responsable, Descripcion, Fecha_Vencimiento, Prioridad, Estado, Tipo_Tarea)
                        VALUES (:coord_id, :desc, DATEADD(day, 7, GETDATE()), 'Alta', 'Pendiente', 'Capacitación')
                    """)
                    self.db.execute(insert_task, {"coord_id": coord_id, "desc": description})
                    self.db.commit()
                    
                    actions.append({
                        "action": AgentAction.CREATE_TASK,
                        "gap_type": "CAPACITACION",
                        "task": description,
                        "assigned_to": coord_id,
                        "status": "ASSIGNED_AUTOMATICALLY"
                    })

            # ========================================
            # GAP 3: Reuniones COPASST Pendientes
            # ========================================
            # Verificar si hay reunión mensual del COPASST
            query_copasst = text("""
                SELECT COUNT(*) 
                FROM REUNION_COMITE rc
                JOIN COMITE c ON rc.id_comite = c.id_comite
                WHERE c.Tipo_Comite = 'COPASST'
                AND MONTH(rc.Fecha_Reunion) = MONTH(GETDATE())
                AND YEAR(rc.Fecha_Reunion) = YEAR(GETDATE())
            """)
            
            reuniones_mes = self.db.execute(query_copasst).scalar()
            
            if reuniones_mes == 0:
                # No hay reunión este mes, asignar al Presidente COPASST
                pres_query = text("""
                    SELECT TOP 1 e.id_empleado 
                    FROM EMPLEADO e
                    JOIN EMPLEADO_ROL er ON e.id_empleado = er.id_empleado
                    JOIN ROL r ON er.id_rol = r.id_rol
                    WHERE r.NombreRol = 'Presidente COPASST'
                    AND e.Estado = 1
                """)
                pres_id = self.db.execute(pres_query).scalar() or coord_id
                
                description = f"Programar reunión mensual COPASST - {datetime.now().strftime('%B %Y')}"
                
                # Verificar duplicados
                check_task = text("""
                    SELECT COUNT(*) FROM TAREA 
                    WHERE id_empleado_responsable = :pres_id 
                    AND Descripcion LIKE :desc 
                    AND Estado IN ('Pendiente', 'En Curso')
                """)
                exists = self.db.execute(check_task, {"pres_id": pres_id, "desc": f"%reunión mensual COPASST%"}).scalar()
                
                if exists == 0:
                    insert_task = text("""
                        INSERT INTO TAREA (id_empleado_responsable, Descripcion, Fecha_Vencimiento, Prioridad, Estado, Tipo_Tarea)
                        VALUES (:pres_id, :desc, DATEADD(day, 5, GETDATE()), 'Crítica', 'Pendiente', 'Comité')
                    """)
                    self.db.execute(insert_task, {"pres_id": pres_id, "desc": description})
                    self.db.commit()
                    
                    actions.append({
                        "action": AgentAction.CREATE_TASK,
                        "gap_type": "COPASST",
                        "task": description,
                        "assigned_to": pres_id,
                        "status": "ASSIGNED_AUTOMATICALLY"
                    })

            # ========================================
            # GAP 4: Inspecciones de Seguridad Vencidas
            # ========================================
            # Schema: id_inspeccion, Tipo_Inspeccion, Area_Inspeccionada, Fecha_Programada, Estado
            query_inspeccion = text("""
                SELECT id_inspeccion, Tipo_Inspeccion, Area_Inspeccionada, Fecha_Programada
                FROM INSPECCION
                WHERE Estado = 'Programada' 
                AND Fecha_Programada < CAST(GETDATE() AS DATE)
            """)
            try:
                inspecciones = self.db.execute(query_inspeccion).fetchall()
                for insp in inspecciones:
                    description = f"Realizar inspección de seguridad: {insp.Tipo_Inspeccion} en {insp.Area_Inspeccionada} (vencida)"
                    
                    # Responsable: Buscar rol "Inspector SST" o "Vigía SST", fallback Coordinador
                    insp_query = text("""
                        SELECT TOP 1 e.id_empleado FROM EMPLEADO e
                        JOIN EMPLEADO_ROL er ON e.id_empleado = er.id_empleado
                        JOIN ROL r ON er.id_rol = r.id_rol
                        WHERE r.NombreRol IN ('Inspector SST', 'Vigía SST') AND e.Estado = 1
                    """)
                    assigned_to = self.db.execute(insp_query).scalar() or coord_id
                    
                    # Evitar duplicados
                    check = text("""
                        SELECT COUNT(*) FROM TAREA WHERE id_empleado_responsable = :emp AND Descripcion LIKE :desc AND Estado IN ('Pendiente','En Curso')
                    """)
                    exists = self.db.execute(check, {"emp": assigned_to, "desc": f"%{insp.Tipo_Inspeccion}%"}).scalar()
                    if not exists:
                        insert = text("""
                            INSERT INTO TAREA (id_empleado_responsable, Descripcion, Fecha_Vencimiento, Prioridad, Estado, Tipo_Tarea)
                            VALUES (:emp, :desc, DATEADD(day, 5, GETDATE()), 'Alta', 'Pendiente', 'Inspección')
                        """)
                        self.db.execute(insert, {"emp": assigned_to, "desc": description})
                        self.db.commit()
                        actions.append({
                            "action": AgentAction.CREATE_TASK,
                            "gap_type": "INSPECCION",
                            "description": description,
                            "assigned_to": assigned_to,
                            "priority": Priority.HIGH,
                            "tipo": "Gestión Inspección"
                        })
            except Exception as e:
                print(f"Error checking Inspections gap: {e}")

            # ========================================
            # GAP 5: Mantenimiento de Equipos Vencido
            # ========================================
            # Schema: id_equipo, Nombre, FechaProximoMantenimiento, Estado
            query_mantenimiento = text("""
                SELECT id_equipo, Nombre, FechaProximoMantenimiento
                FROM EQUIPO
                WHERE Estado = 'Activo'
                AND FechaProximoMantenimiento < CAST(GETDATE() AS DATE)
            """)
            try:
                equipos = self.db.execute(query_mantenimiento).fetchall()
                for eq in equipos:
                    description = f"Programar mantenimiento del equipo: {eq.Nombre} (vencido el {eq.FechaProximoMantenimiento})"
                    
                    # Responsable: Responsable de Mantenimiento (rol "Responsable Mantenimiento")
                    maint_query = text("""
                        SELECT TOP 1 e.id_empleado FROM EMPLEADO e
                        JOIN EMPLEADO_ROL er ON e.id_empleado = er.id_empleado
                        JOIN ROL r ON er.id_rol = r.id_rol
                        WHERE r.NombreRol = 'Responsable Mantenimiento' AND e.Estado = 1
                    """)
                    assigned_to = self.db.execute(maint_query).scalar() or coord_id
                    
                    check = text("""
                        SELECT COUNT(*) FROM TAREA WHERE id_empleado_responsable = :emp AND Descripcion LIKE :desc AND Estado IN ('Pendiente','En Curso')
                    """)
                    exists = self.db.execute(check, {"emp": assigned_to, "desc": f"%{eq.Nombre}%"}).scalar()
                    if not exists:
                        insert = text("""
                            INSERT INTO TAREA (id_empleado_responsable, Descripcion, Fecha_Vencimiento, Prioridad, Estado, Tipo_Tarea)
                            VALUES (:emp, :desc, DATEADD(day, 7, GETDATE()), 'Media', 'Pendiente', 'Mantenimiento')
                        """)
                        self.db.execute(insert, {"emp": assigned_to, "desc": description})
                        self.db.commit()
                        actions.append({
                            "action": AgentAction.CREATE_TASK,
                            "gap_type": "MANTENIMIENTO",
                            "description": description,
                            "assigned_to": assigned_to,
                            "priority": Priority.MEDIUM,
                            "tipo": "Mantenimiento Equipo"
                        })
            except Exception as e:
                print(f"Error checking Maintenance gap: {e}")

            # ========================================
            # GAP 6: Evaluaciones de Riesgo Pendientes
            # ========================================
            # Using new table EVALUACION_RIESGO
            query_riesgo = text("""
                SELECT id_evaluacion, Descripcion, Fecha_Programada
                FROM EVALUACION_RIESGO
                WHERE Estado = 'Programada' AND Fecha_Programada < CAST(GETDATE() AS DATE)
            """)
            try:
                riesgos = self.db.execute(query_riesgo).fetchall()
                for ris in riesgos:
                    description = f"Ejecutar evaluación de riesgo: {ris.Descripcion} (vencida)"
                    assigned_to = coord_id
                    check = text("""
                        SELECT COUNT(*) FROM TAREA WHERE id_empleado_responsable = :emp AND Descripcion LIKE :desc AND Estado IN ('Pendiente','En Curso')
                    """)
                    exists = self.db.execute(check, {"emp": assigned_to, "desc": f"%{ris.Descripcion}%"}).scalar()
                    if not exists:
                        insert = text("""
                            INSERT INTO TAREA (id_empleado_responsable, Descripcion, Fecha_Vencimiento, Prioridad, Estado, Tipo_Tarea)
                            VALUES (:emp, :desc, DATEADD(day, 10, GETDATE()), 'Alta', 'Pendiente', 'Evaluación Riesgo')
                        """)
                        self.db.execute(insert, {"emp": assigned_to, "desc": description})
                        self.db.commit()
                        actions.append({
                            "action": AgentAction.CREATE_TASK,
                            "gap_type": "RIESGO",
                            "description": description,
                            "assigned_to": assigned_to,
                            "priority": Priority.HIGH,
                            "tipo": "Evaluación de Riesgo"
                        })
            except Exception as e:
                # Table might not exist yet if script wasn't run
                pass

            # ========================================
            # GAP 7: Reuniones de Comité de Convivencia Mensuales
            # ========================================
            # Schema: REUNION_COMITE (TipoReunion, FechaReunion)
            query_convivencia = text("""
                SELECT COUNT(*) FROM REUNION_COMITE
                WHERE TipoReunion = 'Convivencia'
                AND MONTH(FechaReunion) = MONTH(GETDATE())
                AND YEAR(FechaReunion) = YEAR(GETDATE())
            """)
            try:
                reuniones = self.db.execute(query_convivencia).scalar()
                if reuniones == 0:
                    # Asignar al presidente del Comité de Convivencia (rol "Presidente Comité Convivencia")
                    pres_query = text("""
                        SELECT TOP 1 e.id_empleado FROM EMPLEADO e
                        JOIN EMPLEADO_ROL er ON e.id_empleado = er.id_empleado
                        JOIN ROL r ON er.id_rol = r.id_rol
                        WHERE r.NombreRol = 'Presidente Comité Convivencia' AND e.Estado = 1
                    """)
                    pres_id = self.db.execute(pres_query).scalar() or coord_id
                    description = f"Programar reunión mensual del Comité de Convivencia - {datetime.now().strftime('%B %Y')}"
                    check = text("""
                        SELECT COUNT(*) FROM TAREA WHERE id_empleado_responsable = :emp AND Descripcion LIKE :desc AND Estado IN ('Pendiente','En Curso')
                    """)
                    exists = self.db.execute(check, {"emp": pres_id, "desc": f"%reunión mensual del Comité de Convivencia%"}).scalar()
                    if not exists:
                        insert = text("""
                            INSERT INTO TAREA (id_empleado_responsable, Descripcion, Fecha_Vencimiento, Prioridad, Estado, Tipo_Tarea)
                            VALUES (:emp, :desc, DATEADD(day, 5, GETDATE()), 'Crítica', 'Pendiente', 'Comité')
                        """)
                        self.db.execute(insert, {"emp": pres_id, "desc": description})
                        self.db.commit()
                        actions.append({
                            "action": AgentAction.CREATE_TASK,
                            "gap_type": "CONVIVENCIA",
                            "description": description,
                            "assigned_to": pres_id,
                            "priority": Priority.CRITICAL,
                            "tipo": "Reunión Comité Convivencia"
                        })
            except Exception as e:
                print(f"Error checking Convivencia gap: {e}")

        except Exception as e:
            print(f"Error in proactive correction: {e}")
            
        return actions


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
