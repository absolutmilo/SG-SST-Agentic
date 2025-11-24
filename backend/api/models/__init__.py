"""
Auto-generate models from existing database using SQLAlchemy reflection.
This is MUCH faster than manually creating each model!
"""

from sqlalchemy import create_engine, MetaData, text
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
import logging

from api.config import get_settings

logger = logging.getLogger(__name__)
settings = get_settings()

# Create engine
engine = create_engine(
    settings.database.sqlalchemy_url,
    pool_size=settings.database.pool_size,
    max_overflow=settings.database.max_overflow,
    pool_timeout=settings.database.pool_timeout,
    pool_recycle=settings.database.pool_recycle,
    echo=settings.app.debug,
)

# Reflect existing database
metadata = MetaData()
metadata.reflect(engine)

# Auto-generate models from existing tables
Base = automap_base(metadata=metadata)
Base.prepare()

# Now all your tables are available as classes!
# Example: Base.classes.EMPLEADO, Base.classes.RIESGO, etc.

# Export commonly used models
try:
    Employee = Base.classes.EMPLEADO
    Company = Base.classes.EMPRESA
    Site = Base.classes.SEDE
    Role = Base.classes.ROL
    EmployeeRole = Base.classes.EMPLEADO_ROL
    
    # Risk management
    HazardCatalog = Base.classes.CATALOGO_PELIGRO
    Risk = Base.classes.RIESGO
    ProbabilityAssessment = Base.classes.VALORACION_PROB
    ConsequenceAssessment = Base.classes.VALORACION_CONSEC
    Exposure = Base.classes.EXPOSICION
    
    # Events
    Event = Base.classes.EVENTO
    CorrectiveAction = Base.classes.ACCION_CORRECTIVA
    ImprovementAction = Base.classes.ACCION_MEJORA
    
    # Medical
    MedicalExam = Base.classes.EXAMEN_MEDICO
    SurveillanceProgram = Base.classes.PROGRAMA_VIGILANCIA
    Absenteeism = Base.classes.AUSENTISMO
    
    # Training
    Training = Base.classes.CAPACITACION
    Attendance = Base.classes.ASISTENCIA
    SSTCompetency = Base.classes.COMPETENCIA_SST
    
    # PPE
    PPE = Base.classes.EPP
    PPEDelivery = Base.classes.ENTREGA_EPP
    
    # Committees
    Committee = Base.classes.COMITE
    CommitteeMember = Base.classes.MIEMBRO_COMITE
    CommitteeMeeting = Base.classes.REUNION_COMITE
    
    # Tasks
    WorkPlan = Base.classes.PLAN_TRABAJO
    Task = Base.classes.TAREA
    SSTObjective = Base.classes.OBJETIVO_SST
    
    # Audits
    Audit = Base.classes.AUDITORIA
    AuditFinding = Base.classes.HALLAZGO_AUDITORIA
    AuditActionPlan = Base.classes.PLAN_ACCION_AUDITORIA
    
    # Documents
    Document = Base.classes.DOCUMENTO
    DocumentVersion = Base.classes.VERSION_DOCUMENTO
    DocumentTemplate = Base.classes.PLANTILLA_DOCUMENTO
    
    # Alerts
    Alert = Base.classes.ALERTA
    NotificationHistory = Base.classes.HISTORIAL_NOTIFICACION
    
    # Users
    AuthorizedUser = Base.classes.USUARIOS_AUTORIZADOS
    AgentConversation = Base.classes.CONVERSACION_AGENTE
    AgentLog = Base.classes.LOG_AGENTE
    AgentConfig = Base.classes.CONFIG_AGENTE
    
    # Equipment
    Equipment = Base.classes.EQUIPO
    EquipmentMaintenance = Base.classes.MANTENIMIENTO_EQUIPO
    
    # Inspections
    Inspection = Base.classes.INSPECCION
    InspectionFinding = Base.classes.HALLAZGO_INSPECCION
    
    # Emergency
    Threat = Base.classes.AMENAZA
    Brigade = Base.classes.BRIGADA
    BrigadeMember = Base.classes.MIEMBRO_BRIGADA
    Drill = Base.classes.SIMULACRO
    
    # Contractors
    Contractor = Base.classes.CONTRATISTA
    ContractorEvaluation = Base.classes.EVALUACION_CONTRATISTA
    ContractorWorker = Base.classes.TRABAJADOR_CONTRATISTA
    
    # Indicators
    Indicator = Base.classes.INDICADOR
    IndicatorResult = Base.classes.RESULTADO_INDICADOR
    
    # Legal
    LegalRequirement = Base.classes.REQUISITO_LEGAL
    LegalEvaluation = Base.classes.EVALUACION_LEGAL
    
    # Reports
    GeneratedReport = Base.classes.REPORTE_GENERADO
    ManagementReview = Base.classes.REVISION_DIRECCION
    
    logger.info("✅ All models auto-generated from database successfully!")
    
except AttributeError as e:
    logger.error(f"❌ Error loading models: {e}")
    logger.error("Make sure your database is created and accessible")
    raise


def get_db():
    """Get database session."""
    session = Session(engine)
    try:
        yield session
    finally:
        session.close()


def call_stored_procedure(proc_name: str, params: dict = None):
    """
    Call a stored procedure from your database.
    
    Example:
        call_stored_procedure('SP_Calcular_Indicadores_Siniestralidad', {'Anio': 2024})
    """
    with Session(engine) as session:
        if params:
            param_str = ", ".join([f"@{k}={v}" for k, v in params.items()])
            sql = text(f"EXEC {proc_name} {param_str}")
        else:
            sql = text(f"EXEC {proc_name}")
        
        result = session.execute(sql)
        session.commit()
        return result.fetchall()


# List of your stored procedures (from the database)
STORED_PROCEDURES = {
    'monitor_overdue_tasks': 'SP_Monitorear_Tareas_Vencidas',
    'generate_tasks_expiration': 'SP_Generar_Tareas_Vigencia',
    'calculate_accident_indicators': 'SP_Calcular_Indicadores_Siniestralidad',
    'work_plan_compliance_report': 'SP_Reporte_Cumplimiento_Plan',
    'medical_exam_compliance_report': 'SP_Reporte_Cumplimiento_EMO',
    'executive_report': 'SP_Reporte_Ejecutivo_CEO',
    'generate_automatic_alerts': 'SP_Generar_Alertas_Automaticas',
    'get_pending_alerts': 'SP_Obtener_Alertas_Pendientes',
    'mark_alerts_sent': 'SP_Marcar_Alertas_Enviadas',
    'get_agent_context': 'SP_Obtener_Contexto_Agente',
    'register_agent_conversation': 'SP_Registrar_Conversacion_Agente',
    'create_task_from_email': 'SP_Crear_Tarea_Desde_Correo',
    'generate_expiration_alerts': 'sp_GenerarAlertasVencimientos',
}


__all__ = [
    'Base',
    'engine',
    'metadata',
    'get_db',
    'call_stored_procedure',
    'STORED_PROCEDURES',
    # All model classes
    'Employee', 'Company', 'Site', 'Role', 'EmployeeRole',
    'HazardCatalog', 'Risk', 'ProbabilityAssessment', 'ConsequenceAssessment', 'Exposure',
    'Event', 'CorrectiveAction', 'ImprovementAction',
    'MedicalExam', 'SurveillanceProgram', 'Absenteeism',
    'Training', 'Attendance', 'SSTCompetency',
    'PPE', 'PPEDelivery',
    'Committee', 'CommitteeMember', 'CommitteeMeeting',
    'WorkPlan', 'Task', 'SSTObjective',
    'Audit', 'AuditFinding', 'AuditActionPlan',
    'Document', 'DocumentVersion', 'DocumentTemplate',
    'Alert', 'NotificationHistory',
    'AuthorizedUser', 'AgentConversation', 'AgentLog', 'AgentConfig',
    'Equipment', 'EquipmentMaintenance',
    'Inspection', 'InspectionFinding',
    'Threat', 'Brigade', 'BrigadeMember', 'Drill',
    'Contractor', 'ContractorEvaluation', 'ContractorWorker',
    'Indicator', 'IndicatorResult',
    'LegalRequirement', 'LegalEvaluation',
    'GeneratedReport', 'ManagementReview',
]
