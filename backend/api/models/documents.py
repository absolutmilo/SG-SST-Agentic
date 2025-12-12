from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import date, datetime

class DocumentBase(BaseModel):
    Nombre: str = Field(..., max_length=200)
    Tipo: str = Field(..., max_length=50) # Politica, Acta, etc.
    CategoriaSGSST: Optional[str] = Field(None, max_length=100)
    Area: Optional[str] = Field(None, max_length=100)
    Estado: str = Field("Vigente", max_length=20)
    descripcion: Optional[str] = None
    version: int = 1

class DocumentCreate(DocumentBase):
    pass

class DocumentUpdate(BaseModel):
    Nombre: Optional[str] = None
    CategoriaSGSST: Optional[str] = None
    Area: Optional[str] = None
    Estado: Optional[str] = None
    descripcion: Optional[str] = None
    version: Optional[int] = None

class DocumentRead(DocumentBase):
    id_documento: int
    Codigo: Optional[str] = None
    FechaCreacion: datetime
    FechaUltimaRevision: Optional[date] = None
    ProximaRevision: Optional[date] = None
    Responsable: Optional[int] = None
    RutaArchivo: str
    mime_type: Optional[str] = None
    tamano_bytes: Optional[int] = None
    
    class Config:
        from_attributes = True
        populate_by_name = True
