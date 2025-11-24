"""
Event and incident models - Resolución 1401/2007 compliant
Decreto 1072/2015 Articles 2.2.4.6.19 and 2.2.4.6.20 - Accident reporting and investigation
"""

from sqlalchemy import Column, Integer, String, Date, DateTime, Time, Boolean, ForeignKey, CheckConstraint, Text
from sqlalchemy.orm import relationship
from datetime import datetime

from api.database import Base


class Event(Base):
    """
    Event model representing EVENTO table.
    Covers accidents, incidents, occupational diseases, and unsafe conditions.
    Compliant with Resolución 1401/2007 for accident investigation.
    """
    __tablename__ = "EVENTO"
    
    # Primary key
    id_evento = Column(Integer, primary_key=True, autoincrement=True)
    
    # Event classification
    Tipo_Evento = Column(String(50), nullable=False)
    
    # Event details
    Fecha_Evento = Column(DateTime, nullable=False)
    Hora_Evento = Column(Time)
    id_empleado = Column(Integer, ForeignKey("EMPLEADO.id_empleado"), nullable=False)
    Lugar_Evento = Column(String(200))
    Descripcion_Evento = Column(Text, nullable=False)
    
    # Injury details (if applicable)
    Parte_Cuerpo_Afectada = Column(String(100))
    Naturaleza_Lesion = Column(String(100))
    Mecanismo_Accidente = Column(String(200))
    Testigos = Column(String(500))
    
    # Medical attention details (added for compliance)
    LugarAtencionMedica = Column(String(200))
    NombreMedicoTratante = Column(String(100))
    
    # Disability information
    Dias_Incapacidad = Column(Integer, default=0)
    ClasificacionIncapacidad = Column(String(50))
    
    # ARL reporting (Administradora de Riesgos Laborales)
    Reportado_ARL = Column(Boolean, default=False)
    Fecha_Reporte_ARL = Column(DateTime)
    Numero_Caso_ARL = Column(String(50))
    
    # Investigation (Resolución 1401/2007)
    Requiere_Investigacion = Column(Boolean, default=True)
    Estado_Investigacion = Column(String(50), default='Pendiente', nullable=False)
    Fecha_Investigacion = Column(Date)
    Causas_Inmediatas = Column(Text)  # Immediate causes
    Causas_Basicas = Column(Text)     # Basic causes
    Analisis_Causas = Column(Text)    # Root cause analysis
    id_responsable_investigacion = Column(Integer, ForeignKey("EMPLEADO.id_empleado"))
    
    # Audit trail
    FechaRegistro = Column(DateTime, default=datetime.utcnow, nullable=False)
    CreadoPor = Column(Integer, ForeignKey("EMPLEADO.id_empleado"))
    ModificadoPor = Column(Integer, ForeignKey("EMPLEADO.id_empleado"))
    FechaUltimaModificacion = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Constraints
    __table_args__ = (
        CheckConstraint(
            "Tipo_Evento IN ('Accidente de Trabajo', 'Incidente', 'Enfermedad Laboral', 'Acto Inseguro', 'Condición Insegura')",
            name="chk_tipo_evento"
        ),
        CheckConstraint(
            "ClasificacionIncapacidad IN ('Temporal', 'Permanente Parcial', 'Permanente Total', 'Muerte', 'Sin Incapacidad')",
            name="chk_clasificacion_incapacidad"
        ),
        CheckConstraint(
            "Estado_Investigacion IN ('Pendiente', 'En Proceso', 'Cerrada')",
            name="chk_estado_investigacion"
        ),
    )
    
    # Relationships
    employee = relationship("Employee", foreign_keys=[id_empleado], back_populates="events")
    investigator = relationship("Employee", foreign_keys=[id_responsable_investigacion])
    corrective_actions = relationship("CorrectiveAction", back_populates="event")
    
    def __repr__(self):
        return f"<Event(id={self.id_evento}, type='{self.Tipo_Evento}', date='{self.Fecha_Evento}')>"
    
    @property
    def requires_arl_report(self):
        """Check if event requires ARL reporting."""
        return self.Tipo_Evento in ['Accidente de Trabajo', 'Enfermedad Laboral']
    
    @property
    def is_severe(self):
        """Check if event is severe (requires immediate action)."""
        return (
            self.Tipo_Evento == 'Accidente de Trabajo' and 
            (self.Dias_Incapacidad > 1 or 
             self.ClasificacionIncapacidad in ['Permanente Parcial', 'Permanente Total', 'Muerte'])
        )
    
    def to_dict(self):
        """Convert event to dictionary."""
        return {
            "id_evento": self.id_evento,
            "tipo_evento": self.Tipo_Evento,
            "fecha_evento": self.Fecha_Evento.isoformat() if self.Fecha_Evento else None,
            "hora_evento": self.Hora_Evento.isoformat() if self.Hora_Evento else None,
            "id_empleado": self.id_empleado,
            "lugar_evento": self.Lugar_Evento,
            "descripcion_evento": self.Descripcion_Evento,
            "parte_cuerpo_afectada": self.Parte_Cuerpo_Afectada,
            "naturaleza_lesion": self.Naturaleza_Lesion,
            "mecanismo_accidente": self.Mecanismo_Accidente,
            "testigos": self.Testigos,
            "lugar_atencion_medica": self.LugarAtencionMedica,
            "nombre_medico_tratante": self.NombreMedicoTratante,
            "dias_incapacidad": self.Dias_Incapacidad,
            "clasificacion_incapacidad": self.ClasificacionIncapacidad,
            "reportado_arl": self.Reportado_ARL,
            "fecha_reporte_arl": self.Fecha_Reporte_ARL.isoformat() if self.Fecha_Reporte_ARL else None,
            "numero_caso_arl": self.Numero_Caso_ARL,
            "requiere_investigacion": self.Requiere_Investigacion,
            "estado_investigacion": self.Estado_Investigacion,
            "fecha_investigacion": self.Fecha_Investigacion.isoformat() if self.Fecha_Investigacion else None,
            "causas_inmediatas": self.Causas_Inmediatas,
            "causas_basicas": self.Causas_Basicas,
            "analisis_causas": self.Analisis_Causas,
            "requires_arl_report": self.requires_arl_report,
            "is_severe": self.is_severe,
        }


class CorrectiveAction(Base):
    """
    Corrective action model representing ACCION_CORRECTIVA table.
    Actions derived from event investigations.
    """
    __tablename__ = "ACCION_CORRECTIVA"
    
    id_accion = Column(Integer, primary_key=True, autoincrement=True)
    id_evento = Column(Integer, ForeignKey("EVENTO.id_evento"), nullable=False)
    TipoAccion = Column(String(50), nullable=False)
    Descripcion = Column(Text, nullable=False)
    ResponsableEjecucion = Column(Integer, ForeignKey("EMPLEADO.id_empleado"), nullable=False)
    FechaCompromiso = Column(Date, nullable=False)
    FechaCierre = Column(Date)
    Estado = Column(String(50), default='Abierta', nullable=False)
    EficaciaVerificada = Column(Boolean, default=False)
    Observaciones = Column(Text)
    
    __table_args__ = (
        CheckConstraint(
            "TipoAccion IN ('Correctiva', 'Preventiva', 'Mejora')",
            name="chk_tipo_accion"
        ),
        CheckConstraint(
            "Estado IN ('Abierta', 'En Ejecución', 'Cerrada', 'Vencida')",
            name="chk_estado_accion"
        ),
    )
    
    # Relationships
    event = relationship("Event", back_populates="corrective_actions")
    responsible = relationship("Employee", foreign_keys=[ResponsableEjecucion])
    
    def __repr__(self):
        return f"<CorrectiveAction(id={self.id_accion}, type='{self.TipoAccion}', status='{self.Estado}')>"
    
    @property
    def is_overdue(self):
        """Check if action is overdue."""
        if self.Estado in ['Abierta', 'En Ejecución'] and self.FechaCompromiso:
            return self.FechaCompromiso < datetime.now().date()
        return False
    
    def to_dict(self):
        """Convert corrective action to dictionary."""
        return {
            "id_accion": self.id_accion,
            "id_evento": self.id_evento,
            "tipo_accion": self.TipoAccion,
            "descripcion": self.Descripcion,
            "responsable_ejecucion": self.ResponsableEjecucion,
            "fecha_compromiso": self.FechaCompromiso.isoformat() if self.FechaCompromiso else None,
            "fecha_cierre": self.FechaCierre.isoformat() if self.FechaCierre else None,
            "estado": self.Estado,
            "eficacia_verificada": self.EficaciaVerificada,
            "observaciones": self.Observaciones,
            "is_overdue": self.is_overdue,
        }


class ImprovementAction(Base):
    """
    Improvement action model representing ACCION_MEJORA table.
    General improvement actions not necessarily linked to events.
    """
    __tablename__ = "ACCION_MEJORA"
    
    id_accion_mejora = Column(Integer, primary_key=True, autoincrement=True)
    Origen = Column(String(100))  # Source: Audit, Management Review, Suggestion, etc.
    IdOrigenRelacionado = Column(Integer)  # ID of source record
    Descripcion = Column(Text, nullable=False)
    TipoAccion = Column(String(50), nullable=False)
    ResponsableEjecucion = Column(Integer, ForeignKey("EMPLEADO.id_empleado"), nullable=False)
    FechaCreacion = Column(Date, default=datetime.utcnow)
    FechaCompromiso = Column(Date, nullable=False)
    FechaCierre = Column(Date)
    Estado = Column(String(50), default='Abierta', nullable=False)
    EficaciaVerificada = Column(Boolean, default=False)
    FechaVerificacion = Column(Date)
    ResultadoVerificacion = Column(Text)
    
    __table_args__ = (
        CheckConstraint(
            "TipoAccion IN ('Correctiva', 'Preventiva', 'Mejora')",
            name="chk_tipo_accion_mejora"
        ),
        CheckConstraint(
            "Estado IN ('Abierta', 'En Ejecución', 'Cerrada', 'Cancelada', 'Vencida')",
            name="chk_estado_accion_mejora"
        ),
    )
    
    # Relationships
    responsible = relationship("Employee", foreign_keys=[ResponsableEjecucion])
    
    def __repr__(self):
        return f"<ImprovementAction(id={self.id_accion_mejora}, type='{self.TipoAccion}', status='{self.Estado}')>"
