"""
Stored Procedures router - wraps your existing SQL Server stored procedures as API endpoints.
This lets us use all your existing business logic!
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import Dict, Any, Optional, List
from datetime import date, datetime
import logging

from api.models import get_db, call_stored_procedure, STORED_PROCEDURES, AuthorizedUser
from api.dependencies import get_current_active_user

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/monitor-overdue-tasks")
def monitor_overdue_tasks(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Monitorear_Tareas_Vencidas.
    Updates overdue tasks and returns list of vencidas tasks.
    """
    try:
        result = db.execute(text("EXEC SP_Monitorear_Tareas_Vencidas"))
        
        # Fetch results BEFORE commit
        tasks = []
        for row in result:
            tasks.append({
                "id_tarea": row[0],
                "descripcion": row[1],
                "tipo_tarea": row[2],
                "responsable": row[3],
                "correo_responsable": row[4],
                "area": row[5],
                "fecha_vencimiento": row[6].isoformat() if row[6] else None,
                "dias_vencida": row[7],
                "prioridad": row[8],
                "origen_tarea": row[9],
            })
            
        db.commit()
        return {"total": len(tasks), "tasks": tasks}
    except Exception as e:
        db.rollback()
        logger.error(f"Error executing SP_Monitorear_Tareas_Vencidas: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/generate-tasks-expiration")
def generate_tasks_expiration(
    id_coordinador_sst: int,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Generar_Tareas_Vigencia.
    Generates automatic tasks for upcoming expirations.
    """
    try:
        result = db.execute(
            text("EXEC SP_Generar_Tareas_Vigencia @IdCoordinadorSST = :id"),
            {"id": id_coordinador_sst}
        )
        
        # Fetch result BEFORE commit
        row = result.fetchone()
        tasks_generated = row[0] if row else 0
        
        db.commit()
        return {"tasks_generated": tasks_generated}
    except Exception as e:
        db.rollback()
        logger.error(f"Error executing SP_Generar_Tareas_Vigencia: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/accident-indicators/{year}")
def calculate_accident_indicators(
    year: int,
    periodo: Optional[str] = Query(None, description="Period: Q1, Q2, Q3, Q4, or specific month"),
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Calcular_Indicadores_Siniestralidad.
    Calculates safety indicators (frequency, severity, etc.).
    
    Parameters:
    - year: Year (e.g., 2025)
    - periodo: Optional period (e.g., "Q3", "Q1", or specific month)
    """
    try:
        logger.info(f"Calling SP_Calcular_Indicadores_Siniestralidad with year={year}, periodo={periodo}")
        
        # Use raw connection to handle multiple result sets
        connection = db.connection()
        cursor = connection.connection.cursor()
        
        if periodo:
            cursor.execute("EXEC SP_Calcular_Indicadores_Siniestralidad @Anio = ?, @Periodo = ?", year, periodo)
        else:
            cursor.execute("EXEC SP_Calcular_Indicadores_Siniestralidad @Anio = ?", year)
        
        # Consume all result sets until we find the data
        row = None
        while True:
            try:
                row = cursor.fetchone()
                if row:
                    break
                # Move to next result set
                if not cursor.nextset():
                    break
            except Exception:
                # Try next result set
                if not cursor.nextset():
                    break
        
        cursor.close()
        db.commit()
        
        data = None
        if row:
            # SP returns: Anio, Periodo, FechaInicio, FechaFin, Accidentes_Trabajo, Incidentes, 
            # Dias_Incapacidad, Promedio_Trabajadores, HHT_Estimadas, Indice_Frecuencia_IF, 
            # Indice_Frecuencia_Accidentalidad_IFA, Indice_Severidad_IS, 
            # Indice_Lesiones_Incapacitantes_ILI, Interpretacion_IF
            data = {
                "anio": row[0],
                "periodo": row[1],
                "fecha_inicio": str(row[2]) if len(row) > 2 and row[2] else None,
                "fecha_fin": str(row[3]) if len(row) > 3 and row[3] else None,
                "total_accidentes": row[4] if len(row) > 4 else 0,
                "total_incidentes": row[5] if len(row) > 5 else 0,
                "dias_incapacidad_total": row[6] if len(row) > 6 else 0,
                "promedio_empleados": row[7] if len(row) > 7 else 0,
                "hht_estimadas": float(row[8]) if len(row) > 8 and row[8] else 0,
                "indice_frecuencia": float(row[9]) if len(row) > 9 and row[9] else 0,
                "indice_frecuencia_accidentalidad": float(row[10]) if len(row) > 10 and row[10] else 0,
                "indice_severidad": float(row[11]) if len(row) > 11 and row[11] else 0,
                "indice_lesion_incapacitante": float(row[12]) if len(row) > 12 and row[12] else 0,
                "interpretacion": row[13] if len(row) > 13 else None,
            }
            logger.info(f"Successfully retrieved indicators: {data}")
        else:
            logger.warning(f"No data returned from SP for year={year}, periodo={periodo}")
            # Return empty data structure instead of None
            data = {
                "anio": year,
                "periodo": periodo,
                "indice_frecuencia": 0,
                "indice_severidad": 0,
                "indice_lesion_incapacitante": 0,
                "total_accidentes": 0,
                "total_incidentes": 0,
                "dias_incapacidad_total": 0,
                "promedio_empleados": 0,
                "hht_estimadas": 0,
            }
        
        return data
    except Exception as e:
        db.rollback()
        logger.error(f"Error executing SP_Calcular_Indicadores_Siniestralidad: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Error al calcular indicadores: {str(e)}")


@router.get("/work-plan-compliance")
def work_plan_compliance_report(
    id_plan: Optional[int] = None,
    fecha_corte: Optional[date] = None,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Reporte_Cumplimiento_Plan.
    Returns work plan compliance report.
    If id_plan is not provided, uses the most recent plan.
    """
    try:
        # If no id_plan provided, get the latest one
        if not id_plan:
            # We need to reflect the table or use raw SQL since we might not have the model loaded
            # Assuming PLAN_TRABAJO table exists as per previous context
            latest_plan = db.execute(text("SELECT TOP 1 id_plan FROM PLAN_TRABAJO ORDER BY Anio DESC")).fetchone()
            if latest_plan:
                id_plan = latest_plan[0]
            else:
                # If no plan exists, return empty structure
                return {
                    "summary": {
                        "anio": date.today().year,
                        "presupuesto_asignado": 0,
                        "tareas_totales": 0,
                        "tareas_cerradas": 0,
                        "tareas_en_curso": 0,
                        "tareas_pendientes": 0,
                        "tareas_vencidas": 0,
                        "porcentaje_cumplimiento": 0,
                        "tareas_a_tiempo": 0,
                        "tareas_fuera_tiempo": 0,
                    },
                    "by_type": []
                }

        params = {"id_plan": id_plan}
        sql = "EXEC SP_Reporte_Cumplimiento_Plan @IdPlan = :id_plan"
        
        if fecha_corte:
            params["fecha_corte"] = fecha_corte
            sql += ", @FechaCorte = :fecha_corte"
        
        # Use raw connection for multiple result sets
        connection = db.connection()
        cursor = connection.connection.cursor()
        
        params_list = [id_plan]
        sql = "EXEC SP_Reporte_Cumplimiento_Plan @IdPlan = ?"
        
        if fecha_corte:
            sql += ", @FechaCorte = ?"
            params_list.append(fecha_corte)
            
        cursor.execute(sql, *params_list)
        
        # Find first result set with data
        summary_row = None
        while True:
            try:
                summary_row = cursor.fetchone()
                if summary_row:
                    break
                if not cursor.nextset():
                    break
            except Exception:
                if not cursor.nextset():
                    break
        if summary_row:
            logger.info(f"Work Plan Summary Row: {summary_row}")
            # Check if column 1 is a date (which caused the error)
            idx_offset = 0
            if len(summary_row) > 1 and isinstance(summary_row[1], (date, datetime)):
                idx_offset = 2 # Skip FechaInicio, FechaFin
            
            # Helper to safe float
            def safe_float(val):
                try:
                    return float(val) if val is not None else 0
                except (ValueError, TypeError):
                    return 0

            summary = {
                "anio": summary_row[0],
                "presupuesto_asignado": safe_float(summary_row[1 + idx_offset]) if len(summary_row) > 1 + idx_offset else 0,
                "tareas_totales": summary_row[2 + idx_offset] if len(summary_row) > 2 + idx_offset else 0,
                "tareas_cerradas": summary_row[3 + idx_offset] if len(summary_row) > 3 + idx_offset else 0,
                "tareas_en_curso": summary_row[4 + idx_offset] if len(summary_row) > 4 + idx_offset else 0,
                "tareas_pendientes": summary_row[5 + idx_offset] if len(summary_row) > 5 + idx_offset else 0,
                "tareas_vencidas": summary_row[6 + idx_offset] if len(summary_row) > 6 + idx_offset else 0,
                "porcentaje_cumplimiento": safe_float(summary_row[7 + idx_offset]) if len(summary_row) > 7 + idx_offset else 0,
                "tareas_a_tiempo": summary_row[8 + idx_offset] if len(summary_row) > 8 + idx_offset else 0,
                "tareas_fuera_tiempo": summary_row[9 + idx_offset] if len(summary_row) > 9 + idx_offset else 0,
            }
        else:
             summary = {}
        
        # Second result set - by task type
        by_type = []
        if cursor.nextset():
            rows = cursor.fetchall()
            for row in rows:
                by_type.append({
                    "tipo_tarea": row[0],
                    "total": row[1],
                    "cerradas": row[2],
                    "porcentaje_cumplimiento": float(row[3]) if row[3] else 0,
                })
                
        cursor.close()
        
        return {
            "summary": summary,
            "by_type": by_type
        }
    except Exception as e:
        logger.error(f"Error executing SP_Reporte_Cumplimiento_Plan: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/medical-exam-compliance")
def medical_exam_compliance_report(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Reporte_Cumplimiento_EMO.
    Returns medical exam compliance report.
    """
    try:
        # Use raw connection for multiple result sets
        connection = db.connection()
        cursor = connection.connection.cursor()
        
        cursor.execute("EXEC SP_Reporte_Cumplimiento_EMO")
        
        # Find first result set with data
        summary_row = None
        while True:
            try:
                summary_row = cursor.fetchone()
                if summary_row:
                    break
                if not cursor.nextset():
                    break
            except Exception:
                if not cursor.nextset():
                    break
        summary = {}
        if summary_row:
            summary = {
                "total_empleados_activos": summary_row[0],
                "emo_vigentes": summary_row[1],
                "sin_emo": summary_row[2],
                "emo_por_vencer_45_dias": summary_row[3],
                "porcentaje_cumplimiento": float(summary_row[4]) if summary_row[4] else 0,
            }
        
        # Second result set - employees without valid EMO
        employees_without_emo = []
        if cursor.nextset():
            rows = cursor.fetchall()
            for row in rows:
                employees_without_emo.append({
                    "id_empleado": row[0],
                    "numero_documento": row[1],
                    "nombre_completo": row[2],
                    "cargo": row[3],
                    "area": row[4],
                    "correo": row[5],
                    "estado": row[6],
                    "fecha_vencimiento": row[7].isoformat() if row[7] and hasattr(row[7], 'isoformat') else None,
                    "dias_vencidos": row[8] if row[8] is not None else None,
                })
        cursor.close()
        
        return {
            "summary": summary,
            "employees_without_valid_emo": employees_without_emo
        }
    except Exception as e:
        logger.error(f"Error executing SP_Reporte_Cumplimiento_EMO: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/executive-report")
def executive_report(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Reporte_Ejecutivo_CEO.
    Returns executive dashboard for CEO.
    """
    try:
        result = db.execute(text("EXEC SP_Reporte_Ejecutivo_CEO"))
        
        # This SP returns multiple result sets
        # You'll need to parse them according to your SP structure
        data = []
        # Basic handling for now, assuming single result set or we just want the first one
        # If it returns multiple, we need to know the structure of each
        if result.returns_rows:
            for row in result:
                data.append(dict(row))
        
        return {"executive_report": data}
    except Exception as e:
        logger.error(f"Error executing SP_Reporte_Ejecutivo_CEO: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/generate-automatic-alerts")
def generate_automatic_alerts(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Generar_Alertas_Automaticas.
    Generates automatic alerts for upcoming deadlines.
    """
    try:
        result = db.execute(text("EXEC SP_Generar_Alertas_Automaticas"))
        
        # Count alerts generated BEFORE commit
        count = 0
        if result.returns_rows:
            for row in result:
                count += 1
            
        db.commit()
        return {"alerts_generated": count}
    except Exception as e:
        db.rollback()
        logger.error(f"Error executing SP_Generar_Alertas_Automaticas: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/pending-alerts")
def get_pending_alerts(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Obtener_Alertas_Pendientes.
    Returns list of pending alerts.
    """
    try:
        result = db.execute(text("EXEC SP_Obtener_Alertas_Pendientes"))
        
        alerts = []
        for row in result:
            alerts.append({
                "id_alerta": row[0],
                "tipo": row[1],
                "prioridad": row[2],
                "descripcion": row[3],
                "fecha_generacion": row[4].isoformat() if row[4] else None,
                "fecha_evento": row[5].isoformat() if row[5] else None,
                "destinatarios_correo": row[6],
            })
        
        return {"total": len(alerts), "alerts": alerts}
    except Exception as e:
        logger.error(f"Error executing SP_Obtener_Alertas_Pendientes: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/mark-alerts-sent")
def mark_alerts_sent(
    alert_ids: List[int],
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Marcar_Alertas_Enviadas.
    Marks alerts as sent.
    """
    try:
        # Convert list to comma-separated string
        ids_str = ",".join(map(str, alert_ids))
        
        result = db.execute(
            text("EXEC SP_Marcar_Alertas_Enviadas @IdsAlertas = :ids"),
            {"ids": ids_str}
        )
        db.commit()
        
        return {"message": f"Marked {len(alert_ids)} alerts as sent"}
    except Exception as e:
        db.rollback()
        logger.error(f"Error executing SP_Marcar_Alertas_Enviadas: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/create-task-from-email")
def create_task_from_email(
    descripcion: str,
    fecha_vencimiento: date,
    id_responsable: int,
    prioridad: str = "Media",
    tipo_tarea: str = "Solicitud CEO",
    id_conversacion: Optional[int] = None,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Crear_Tarea_Desde_Correo.
    Creates a task from an email or agent request.
    """
    try:
        params = {
            "Descripcion": descripcion,
            "FechaVencimiento": fecha_vencimiento,
            "IdResponsable": id_responsable,
            "Prioridad": prioridad,
            "TipoTarea": tipo_tarea,
            "IdConversacion": id_conversacion
        }
        
        # Build SQL with named parameters
        sql = """
            EXEC SP_Crear_Tarea_Desde_Correo 
            @Descripcion = :Descripcion, 
            @FechaVencimiento = :FechaVencimiento, 
            @IdResponsable = :IdResponsable, 
            @Prioridad = :Prioridad, 
            @TipoTarea = :TipoTarea, 
            @IdConversacion = :IdConversacion
        """
        
        result = db.execute(text(sql), params)
        
        # Fetch result BEFORE commit
        row = result.fetchone()
        response_data = {}
        if row:
            response_data = {
                "id_tarea": row[0],
                "mensaje": row[1],
                "descripcion": row[2],
                "fecha_vencimiento": row[3],
                "responsable": row[4],
                "correo_responsable": row[5]
            }
        else:
            response_data = {"message": "Task created but no result returned"}
            
        db.commit()
        return response_data
    except Exception as e:
        db.rollback()
        logger.error(f"Error executing SP_Crear_Tarea_Desde_Correo: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/generate-expiration-alerts")
def generate_expiration_alerts(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute sp_GenerarAlertasVencimientos.
    Generates alerts for expired items (Tasks, Equipment, etc.).
    """
    try:
        # Note: The SP name in DB is sp_GenerarAlertasVencimientos (lowercase sp)
        result = db.execute(text("EXEC sp_GenerarAlertasVencimientos"))
        
        # Fetch results BEFORE commit
        alerts = []
        if result.returns_rows:
            for row in result:
                 # The result set structure depends on the SP output
                 # Based on script: Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, DestinatariosCorreo, Estado
                 alerts.append(dict(row))
             
        db.commit()
        return {"generated_alerts": len(alerts), "details": alerts}
    except Exception as e:
        db.rollback()
        logger.error(f"Error executing sp_GenerarAlertasVencimientos: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/agent-context")
def get_agent_context(
    correo_usuario: str,
    ultimas_n: int = 5,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Obtener_Contexto_Agente.
    Gets recent context for the AI agent based on user email.
    """
    try:
        result = db.execute(
            text("EXEC SP_Obtener_Contexto_Agente @CorreoUsuario = :email, @UltimasN = :n"),
            {"email": correo_usuario, "n": ultimas_n}
        )
        
        context = []
        for row in result:
            context.append({
                "id_conversacion": row[0],
                "asunto": row[1],
                "fecha_recepcion": row[2].isoformat() if row[2] else None,
                "tipo_solicitud": row[3],
                "contenido_original": row[4],
                "interpretacion_agente": row[5],
                "respuesta_generada": row[6],
                "acciones_realizadas": row[7],
                "confianza": float(row[8]) if row[8] else 0
            })
            
        return {"context": context}
    except Exception as e:
        logger.error(f"Error executing SP_Obtener_Contexto_Agente: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/register-agent-conversation")
def register_agent_conversation(
    correo_origen: str,
    asunto: str,
    contenido_original: str,
    tipo_solicitud: str,
    interpretacion_agente: Optional[str] = None,
    respuesta_generada: Optional[str] = None,
    acciones_realizadas: Optional[str] = None,
    confianza_respuesta: Optional[float] = None,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Execute SP_Registrar_Conversacion_Agente.
    Logs an interaction with the AI agent.
    """
    try:
        params = {
            "CorreoOrigen": correo_origen,
            "Asunto": asunto,
            "ContenidoOriginal": contenido_original,
            "TipoSolicitud": tipo_solicitud,
            "InterpretacionAgente": interpretacion_agente,
            "RespuestaGenerada": respuesta_generada,
            "AccionesRealizadas": acciones_realizadas,
            "ConfianzaRespuesta": confianza_respuesta
        }
        
        sql = """
            EXEC SP_Registrar_Conversacion_Agente
            @CorreoOrigen = :CorreoOrigen,
            @Asunto = :Asunto,
            @ContenidoOriginal = :ContenidoOriginal,
            @TipoSolicitud = :TipoSolicitud,
            @InterpretacionAgente = :InterpretacionAgente,
            @RespuestaGenerada = :RespuestaGenerada,
            @AccionesRealizadas = :AccionesRealizadas,
            @ConfianzaRespuesta = :ConfianzaRespuesta
        """
        
        result = db.execute(text(sql), params)
        
        # Fetch result BEFORE commit
        row = result.fetchone()
        response_data = {}
        if row:
            response_data = {
                "id_conversacion": row[0],
                "mensaje": row[1],
                "tipo_solicitud": row[2]
            }
        else:
            response_data = {"message": "Conversation registered"}
            
        db.commit()
        return response_data
    except Exception as e:
        db.rollback()
        logger.error(f"Error executing SP_Registrar_Conversacion_Agente: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/regulatory-compliance")
def regulatory_compliance(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Calculate Regulatory Compliance (Resolución 0312).
    Based on EVALUACION_LEGAL table.
    """
    try:
        # Query to get the latest evaluation for each requirement and calculate compliance
        sql = """
        WITH LatestEval AS (
            SELECT 
                id_requisito, 
                EstadoCumplimiento,
                ROW_NUMBER() OVER (PARTITION BY id_requisito ORDER BY FechaEvaluacion DESC) as rn
            FROM EVALUACION_LEGAL
        )
        SELECT 
            COUNT(*) as TotalEvaluated,
            SUM(CASE WHEN EstadoCumplimiento = 'Cumple' THEN 1 ELSE 0 END) as Cumple,
            SUM(CASE WHEN EstadoCumplimiento = 'Cumple Parcialmente' THEN 1 ELSE 0 END) as CumpleParcial,
            SUM(CASE WHEN EstadoCumplimiento = 'No Aplica' THEN 1 ELSE 0 END) as NoAplica
        FROM LatestEval
        WHERE rn = 1
        """
        
        result = db.execute(text(sql)).fetchone()
        
        compliance_score = 0
        if result and result[0] > 0:
            total = result[0]
            cumple = result[1] or 0
            parcial = result[2] or 0
            no_aplica = result[3] or 0
            
            # Formula: (Cumple + 0.5 * Parcial) / (Total - NoAplica) * 100
            denominator = total - no_aplica
            if denominator > 0:
                score = (cumple + (0.5 * parcial)) / denominator * 100
                compliance_score = round(score, 2)
        
        return {
            "compliance_score": compliance_score,
            "details": {
                "total_evaluated": result[0] if result else 0,
                "fully_compliant": result[1] if result else 0,
                "partially_compliant": result[2] if result else 0,
                "not_applicable": result[3] if result else 0
            }
        }
    except Exception as e:
        logger.error(f"Error calculating regulatory compliance: {e}")
        # Return 0 instead of erroring out to keep dashboard stable
        return {"compliance_score": 0, "error": str(e)}
