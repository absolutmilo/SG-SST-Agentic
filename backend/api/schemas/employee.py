from pydantic import BaseModel, Field, computed_field
from typing import Optional, List
from datetime import date, datetime

class EmployeeBase(BaseModel):
    id_sede: int
    TipoDocumento: str
    NumeroDocumento: str
    Nombre: str
    Apellidos: str
    Cargo: str
    Area: str
    TipoContrato: str
    Fecha_Ingreso: date
    Fecha_Retiro: Optional[date] = None
    Nivel_Riesgo_Laboral: int
    Correo: Optional[str] = None
    Telefono: Optional[str] = None
    DireccionResidencia: Optional[str] = None
    ContactoEmergencia: Optional[str] = None
    TelefonoEmergencia: Optional[str] = None
    GrupoSanguineo: Optional[str] = None
    Estado: bool = True
    id_supervisor: Optional[int] = None
    
    # New Compliance Fields
    ARL: Optional[str] = None
    FechaAfiliacionARL: Optional[date] = None
    EPS: Optional[str] = None
    AFP: Optional[str] = None

class EmployeeCreate(EmployeeBase):
    pass

class EmployeeUpdate(BaseModel):
    id_sede: Optional[int] = None
    TipoDocumento: Optional[str] = None
    NumeroDocumento: Optional[str] = None
    Nombre: Optional[str] = None
    Apellidos: Optional[str] = None
    Cargo: Optional[str] = None
    Area: Optional[str] = None
    TipoContrato: Optional[str] = None
    Fecha_Ingreso: Optional[date] = None
    Fecha_Retiro: Optional[date] = None
    Nivel_Riesgo_Laboral: Optional[int] = None
    Correo: Optional[str] = None
    Telefono: Optional[str] = None
    DireccionResidencia: Optional[str] = None
    ContactoEmergencia: Optional[str] = None
    TelefonoEmergencia: Optional[str] = None
    GrupoSanguineo: Optional[str] = None
    Estado: Optional[bool] = None
    id_supervisor: Optional[int] = None
    ARL: Optional[str] = None
    FechaAfiliacionARL: Optional[date] = None
    EPS: Optional[str] = None
    AFP: Optional[str] = None

class EmployeeResponse(EmployeeBase):
    id_empleado: int
    FechaCreacion: Optional[datetime] = None
    FechaActualizacion: Optional[datetime] = None
    
    # Fields from View
    NombreCompleto: Optional[str] = None
    NombreSede: Optional[str] = None
    Ciudad: Optional[str] = None
    Departamento: Optional[str] = None
    Supervisor: Optional[str] = None
    AniosAntiguedad: Optional[int] = None

    @computed_field
    def nombre_completo_computed(self) -> str:
        # Fallback if NombreCompleto is not provided
        if self.NombreCompleto:
            return self.NombreCompleto
        return f"{self.Nombre} {self.Apellidos}"

    class Config:
        from_attributes = True
