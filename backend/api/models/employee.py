"""
Employee model - EMPLEADO table
Compliant with Decreto 1072/2015 Article 2.2.4.6.8
"""

from sqlalchemy import Column, Integer, String, Date, DateTime, Boolean, ForeignKey, CheckConstraint
from sqlalchemy.orm import relationship
from datetime import datetime

from api.database import Base


class Employee(Base):
    """
    Employee model representing EMPLEADO table.
    Stores all employee information required by Colombian labor law.
    """
    __tablename__ = "EMPLEADO"

    # Primary key
    id_empleado = Column(Integer, primary_key=True, autoincrement=True)
    
    # Foreign keys
    id_sede = Column(Integer, ForeignKey("SEDE.id_sede"), nullable=False)
    id_supervisor = Column(Integer, ForeignKey("EMPLEADO.id_empleado"), nullable=True)
    
    # Personal information
    TipoDocumento = Column(String(20), nullable=False)
    NumeroDocumento = Column(String(20), unique=True, nullable=False, index=True)
    Nombre = Column(String(100), nullable=False)
    Apellidos = Column(String(100), nullable=False)
    
    # Employment information
    Cargo = Column(String(100), nullable=False)
    Area = Column(String(100), nullable=False)
    TipoContrato = Column(String(50), nullable=False)
    Fecha_Ingreso = Column(Date, nullable=False)
    Fecha_Retiro = Column(Date, nullable=True)
    Nivel_Riesgo_Laboral = Column(Integer, nullable=False)
    
    # Contact information
    Correo = Column(String(150), index=True)
    Telefono = Column(String(20))
    DireccionResidencia = Column(String(300))
    
    # Emergency contact
    ContactoEmergencia = Column(String(100))
    TelefonoEmergencia = Column(String(20))
    
    # Medical information
    GrupoSanguineo = Column(String(5))
    
    # Insurance information (added for compliance)
    ARL = Column(String(100))  # Administradora de Riesgos Laborales
    EPS = Column(String(100))  # Entidad Promotora de Salud
    AFP = Column(String(100))  # Administradora de Fondos de Pensiones
    FechaAfiliacionARL = Column(Date)
    
    # Status and audit
    Estado = Column(Boolean, default=True, nullable=False)
    FechaCreacion = Column(DateTime, default=datetime.utcnow, nullable=False)
    FechaActualizacion = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    CreadoPor = Column(Integer, ForeignKey("EMPLEADO.id_empleado"), nullable=True)
    ModificadoPor = Column(Integer, ForeignKey("EMPLEADO.id_empleado"), nullable=True)
    
    # Constraints
    __table_args__ = (
        CheckConstraint(
            "TipoDocumento IN ('CC', 'CE', 'PEP', 'Pasaporte')",
            name="chk_tipo_documento"
        ),
        CheckConstraint(
            "TipoContrato IN ('Indefinido', 'Fijo', 'Obra o Labor', 'Aprendizaje', 'Prestación de Servicios')",
            name="chk_tipo_contrato"
        ),
        CheckConstraint(
            "Nivel_Riesgo_Laboral BETWEEN 1 AND 5",
            name="chk_nivel_riesgo"
        ),
    )
    
    # Relationships
    sede = relationship("Site", back_populates="employees", foreign_keys=[id_sede])
    supervisor = relationship("Employee", remote_side=[id_empleado], foreign_keys=[id_supervisor])
    
    # Related entities
    roles = relationship("EmployeeRole", back_populates="employee")
    medical_exams = relationship("MedicalExam", back_populates="employee")
    events = relationship("Event", back_populates="employee")
    trainings = relationship("Attendance", back_populates="employee")
    ppe_deliveries = relationship("PPEDelivery", back_populates="employee")
    exposures = relationship("Exposure", back_populates="employee")
    
    def __repr__(self):
        return f"<Employee(id={self.id_empleado}, name='{self.Nombre} {self.Apellidos}', document='{self.NumeroDocumento}')>"
    
    @property
    def full_name(self):
        """Get employee's full name."""
        return f"{self.Nombre} {self.Apellidos}"
    
    @property
    def is_active(self):
        """Check if employee is currently active."""
        return self.Estado and (self.Fecha_Retiro is None or self.Fecha_Retiro > datetime.now().date())
    
    def to_dict(self):
        """Convert employee to dictionary."""
        return {
            "id_empleado": self.id_empleado,
            "id_sede": self.id_sede,
            "tipo_documento": self.TipoDocumento,
            "numero_documento": self.NumeroDocumento,
            "nombre": self.Nombre,
            "apellidos": self.Apellidos,
            "nombre_completo": self.full_name,
            "cargo": self.Cargo,
            "area": self.Area,
            "tipo_contrato": self.TipoContrato,
            "fecha_ingreso": self.Fecha_Ingreso.isoformat() if self.Fecha_Ingreso else None,
            "fecha_retiro": self.Fecha_Retiro.isoformat() if self.Fecha_Retiro else None,
            "nivel_riesgo_laboral": self.Nivel_Riesgo_Laboral,
            "correo": self.Correo,
            "telefono": self.Telefono,
            "direccion_residencia": self.DireccionResidencia,
            "contacto_emergencia": self.ContactoEmergencia,
            "telefono_emergencia": self.TelefonoEmergencia,
            "grupo_sanguineo": self.GrupoSanguineo,
            "arl": self.ARL,
            "eps": self.EPS,
            "afp": self.AFP,
            "fecha_afiliacion_arl": self.FechaAfiliacionARL.isoformat() if self.FechaAfiliacionARL else None,
            "estado": self.Estado,
            "is_active": self.is_active,
            "fecha_creacion": self.FechaCreacion.isoformat() if self.FechaCreacion else None,
            "fecha_actualizacion": self.FechaActualizacion.isoformat() if self.FechaActualizacion else None,
        }


class Company(Base):
    """Company model representing EMPRESA table."""
    __tablename__ = "EMPRESA"
    
    id_empresa = Column(Integer, primary_key=True, autoincrement=True)
    RazonSocial = Column(String(200), nullable=False)
    NIT = Column(String(20), unique=True, nullable=False)
    ActividadEconomica = Column(String(200), nullable=False)
    ClaseRiesgo = Column(Integer, nullable=False)
    NumeroTrabajadores = Column(Integer, default=0, nullable=False)
    DireccionPrincipal = Column(String(300))
    Telefono = Column(String(20))
    FechaConstitucion = Column(Date)
    
    __table_args__ = (
        CheckConstraint("ClaseRiesgo BETWEEN 1 AND 5", name="chk_clase_riesgo"),
    )
    
    # Relationships
    sites = relationship("Site", back_populates="company")
    
    def __repr__(self):
        return f"<Company(id={self.id_empresa}, name='{self.RazonSocial}', nit='{self.NIT}')>"


class Site(Base):
    """Site/Work location model representing SEDE table."""
    __tablename__ = "SEDE"
    
    id_sede = Column(Integer, primary_key=True, autoincrement=True)
    id_empresa = Column(Integer, ForeignKey("EMPRESA.id_empresa"), nullable=False)
    NombreSede = Column(String(100), nullable=False)
    Direccion = Column(String(300), nullable=False)
    Ciudad = Column(String(100), nullable=False)
    Departamento = Column(String(100), nullable=False)
    TelefonoContacto = Column(String(20))
    Estado = Column(Boolean, default=True)
    
    # Relationships
    company = relationship("Company", back_populates="sites")
    employees = relationship("Employee", back_populates="sede", foreign_keys="Employee.id_sede")
    
    def __repr__(self):
        return f"<Site(id={self.id_sede}, name='{self.NombreSede}', city='{self.Ciudad}')>"


class Role(Base):
    """Role model representing ROL table."""
    __tablename__ = "ROL"
    
    id_rol = Column(Integer, primary_key=True, autoincrement=True)
    NombreRol = Column(String(100), nullable=False)
    Descripcion = Column(String(200))
    EsRolSST = Column(Boolean, default=False)
    
    # Relationships
    employee_roles = relationship("EmployeeRole", back_populates="role")
    
    def __repr__(self):
        return f"<Role(id={self.id_rol}, name='{self.NombreRol}')>"


class EmployeeRole(Base):
    """Employee-Role relationship representing EMPLEADO_ROL table."""
    __tablename__ = "EMPLEADO_ROL"
    
    id_empleado = Column(Integer, ForeignKey("EMPLEADO.id_empleado"), primary_key=True)
    id_rol = Column(Integer, ForeignKey("ROL.id_rol"), primary_key=True)
    FechaAsignacion = Column(Date, default=datetime.utcnow)
    FechaFinalizacion = Column(Date, nullable=True)
    
    # Relationships
    employee = relationship("Employee", back_populates="roles")
    role = relationship("Role", back_populates="employee_roles")
    
    def __repr__(self):
        return f"<EmployeeRole(employee_id={self.id_empleado}, role_id={self.id_rol})>"
