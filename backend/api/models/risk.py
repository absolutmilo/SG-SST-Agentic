"""
Risk management models - GTC 45 compliant
Decreto 1072/2015 Article 2.2.4.6.15 - Risk identification and assessment
"""

from sqlalchemy import Column, Integer, String, Date, DateTime, ForeignKey, CheckConstraint, Text
from sqlalchemy.orm import relationship
from datetime import datetime

from api.database import Base


class HazardCatalog(Base):
    """
    Hazard catalog model representing CATALOGO_PELIGRO table.
    Based on GTC 45 hazard classification.
    """
    __tablename__ = "CATALOGO_PELIGRO"
    
    id_catalogo_peligro = Column(Integer, primary_key=True, autoincrement=True)
    Clasificacion = Column(String(50), nullable=False)
    TipoPeligro = Column(String(100), nullable=False)
    Descripcion = Column(String(500))
    
    __table_args__ = (
        CheckConstraint(
            "Clasificacion IN ('Biológico', 'Físico', 'Químico', 'Psicosocial', 'Biomecánico', 'Condiciones de Seguridad', 'Fenómenos Naturales')",
            name="chk_clasificacion_peligro"
        ),
    )
    
    # Relationships
    risks = relationship("Risk", back_populates="hazard_catalog")
    
    def __repr__(self):
        return f"<HazardCatalog(id={self.id_catalogo_peligro}, classification='{self.Clasificacion}', type='{self.TipoPeligro}')>"


class ProbabilityAssessment(Base):
    """
    Probability assessment model representing VALORACION_PROB table.
    GTC 45 probability calculation.
    """
    __tablename__ = "VALORACION_PROB"
    
    id_probabilidad = Column(Integer, primary_key=True)
    Nivel_Deficiencia = Column(Integer, nullable=False)
    Nivel_Exposicion = Column(Integer, nullable=False)
    Nivel_Probabilidad = Column(Integer, nullable=False)
    Interpretacion = Column(String(50), nullable=False)
    
    # Relationships
    risks = relationship("Risk", back_populates="probability_assessment")
    
    def __repr__(self):
        return f"<ProbabilityAssessment(id={self.id_probabilidad}, interpretation='{self.Interpretacion}')>"


class ConsequenceAssessment(Base):
    """
    Consequence assessment model representing VALORACION_CONSEC table.
    GTC 45 consequence calculation.
    """
    __tablename__ = "VALORACION_CONSEC"
    
    id_consecuencia = Column(Integer, primary_key=True)
    Nivel_Dano = Column(String(50), nullable=False)
    Valor_NC = Column(Integer, nullable=False)
    
    # Relationships
    risks = relationship("Risk", back_populates="consequence_assessment")
    
    def __repr__(self):
        return f"<ConsequenceAssessment(id={self.id_consecuencia}, damage_level='{self.Nivel_Dano}')>"


class Risk(Base):
    """
    Risk matrix model representing RIESGO table.
    Complete GTC 45 risk assessment methodology.
    """
    __tablename__ = "RIESGO"
    
    id_riesgo = Column(Integer, primary_key=True, autoincrement=True)
    id_catalogo_peligro = Column(Integer, ForeignKey("CATALOGO_PELIGRO.id_catalogo_peligro"), nullable=False)
    
    # Risk identification
    Peligro = Column(String(100), nullable=False)
    Proceso = Column(String(100), nullable=False)
    Actividad = Column(String(200), nullable=False)
    Zona_Area = Column(String(100))
    
    # Risk assessment
    id_probabilidad = Column(Integer, ForeignKey("VALORACION_PROB.id_probabilidad"), nullable=False)
    id_consecuencia = Column(Integer, ForeignKey("VALORACION_CONSEC.id_consecuencia"), nullable=False)
    Nivel_Riesgo_Inicial = Column(Integer, nullable=False)
    Nivel_Riesgo_Residual = Column(Integer)
    
    # Control measures (Hierarchy of controls)
    Controles_Fuente = Column(Text)  # Source controls
    Controles_Medio = Column(Text)   # Medium controls
    Controles_Individuo = Column(Text)  # Individual controls (PPE)
    MedidasIntervencion = Column(Text)  # Intervention measures
    
    # Dates and status
    FechaEvaluacion = Column(Date, nullable=False)
    ProximaRevision = Column(Date)
    Estado = Column(String(20), default='Vigente', nullable=False)
    
    # Audit trail
    CreadoPor = Column(Integer, ForeignKey("EMPLEADO.id_empleado"))
    ModificadoPor = Column(Integer, ForeignKey("EMPLEADO.id_empleado"))
    FechaUltimaModificacion = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    __table_args__ = (
        CheckConstraint(
            "Estado IN ('Vigente', 'Controlado', 'En Revisión')",
            name="chk_estado_riesgo"
        ),
    )
    
    # Relationships
    hazard_catalog = relationship("HazardCatalog", back_populates="risks")
    probability_assessment = relationship("ProbabilityAssessment", back_populates="risks")
    consequence_assessment = relationship("ConsequenceAssessment", back_populates="risks")
    exposures = relationship("Exposure", back_populates="risk")
    
    def __repr__(self):
        return f"<Risk(id={self.id_riesgo}, hazard='{self.Peligro}', process='{self.Proceso}')>"
    
    @property
    def risk_level_category(self):
        """Categorize risk level based on value."""
        if self.Nivel_Riesgo_Inicial >= 600:
            return "I - No Aceptable"
        elif self.Nivel_Riesgo_Inicial >= 150:
            return "II - No Aceptable o Aceptable con control específico"
        elif self.Nivel_Riesgo_Inicial >= 40:
            return "III - Mejorable"
        else:
            return "IV - Aceptable"
    
    def to_dict(self):
        """Convert risk to dictionary."""
        return {
            "id_riesgo": self.id_riesgo,
            "id_catalogo_peligro": self.id_catalogo_peligro,
            "peligro": self.Peligro,
            "proceso": self.Proceso,
            "actividad": self.Actividad,
            "zona_area": self.Zona_Area,
            "nivel_riesgo_inicial": self.Nivel_Riesgo_Inicial,
            "nivel_riesgo_residual": self.Nivel_Riesgo_Residual,
            "categoria_riesgo": self.risk_level_category,
            "controles_fuente": self.Controles_Fuente,
            "controles_medio": self.Controles_Medio,
            "controles_individuo": self.Controles_Individuo,
            "medidas_intervencion": self.MedidasIntervencion,
            "fecha_evaluacion": self.FechaEvaluacion.isoformat() if self.FechaEvaluacion else None,
            "proxima_revision": self.ProximaRevision.isoformat() if self.ProximaRevision else None,
            "estado": self.Estado,
        }


class Exposure(Base):
    """
    Employee exposure to risks model representing EXPOSICION table.
    """
    __tablename__ = "EXPOSICION"
    
    id_empleado = Column(Integer, ForeignKey("EMPLEADO.id_empleado"), primary_key=True)
    id_riesgo = Column(Integer, ForeignKey("RIESGO.id_riesgo"), primary_key=True)
    TiempoExposicionDiario = Column(Integer)  # Hours
    FrecuenciaExposicion = Column(String(50))  # Diaria, Semanal, Ocasional
    FechaRegistro = Column(Date, default=datetime.utcnow)
    
    # Relationships
    employee = relationship("Employee", back_populates="exposures")
    risk = relationship("Risk", back_populates="exposures")
    
    def __repr__(self):
        return f"<Exposure(employee_id={self.id_empleado}, risk_id={self.id_riesgo})>"
