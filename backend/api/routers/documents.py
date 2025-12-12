from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, status
from sqlalchemy.orm import Session
from sqlalchemy import desc, or_
from typing import List, Optional
from datetime import datetime
from fastapi.responses import FileResponse, JSONResponse
import logging

from api.models import get_db, Base, AuthorizedUser
from api.dependencies import get_current_active_user
from api.models.documents import DocumentRead, DocumentCreate, DocumentUpdate
from api.utils.file_storage import save_upload_file, get_file_path_absolute, delete_file

logger = logging.getLogger(__name__)

router = APIRouter()

def get_document_model():
    try:
        return getattr(Base.classes, 'DOCUMENTO')
    except AttributeError:
        # Fallback/Retry logic or critical failure
        raise HTTPException(status_code=500, detail="DOCUMENTO table not found. Restart backend.")

@router.get("/", response_model=List[DocumentRead])
def get_documents(
    type: Optional[str] = None,
    category: Optional[str] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """List all documents with filters"""
    Documento = get_document_model()
    query = db.query(Documento)
    
    if type:
        query = query.filter(Documento.Tipo == type)
    
    if category:
        query = query.filter(Documento.CategoriaSGSST == category)
        
    if search:
        search_term = f"%{search}%"
        query = query.filter(or_(
            Documento.Nombre.like(search_term),
            Documento.descripcion.like(search_term),
            Documento.Codigo.like(search_term)
        ))
        
    return query.order_by(desc(Documento.FechaCreacion)).all()

@router.post("/upload", response_model=DocumentRead)
async def upload_document(
    file: UploadFile = File(...),
    nombre: str = Form(...),
    tipo: str = Form(...),
    categoria: Optional[str] = Form(None),
    area: Optional[str] = Form(None),
    descripcion: Optional[str] = Form(None),
    version: int = Form(1),
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """Upload a file and create document record"""
    Documento = get_document_model()
    
    # 1. Save File
    try:
        # Use category as subfolder if provided, else 'general'
        subfolder = "general"
        if categoria:
            # Simple sanitization
            subfolder = "".join([c if c.isalnum() else "_" for c in categoria]).lower()
            
        file_meta = await save_upload_file(file, subfolder)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
    # 2. Create DB Record
    try:
        new_doc = Documento(
            Nombre=nombre,
            Tipo=tipo,
            CategoriaSGSST=categoria,
            Area=area,
            descripcion=descripcion,
            version=version,
            RutaArchivo=file_meta["relative_path"],
            mime_type=file_meta["mime_type"],
            tamano_bytes=file_meta["size_bytes"],
            Responsable=current_user.id_autorizado,
            FechaCreacion=datetime.now(),
            Estado="Vigente"
        )
        
        db.add(new_doc)
        db.commit()
        db.refresh(new_doc)
        return new_doc
        
    except Exception as e:
        # Cleanup file if DB insert fails
        delete_file(file_meta["relative_path"])
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

@router.get("/{document_id}/download")
def download_document(
    document_id: int,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """Download document file"""
    Documento = get_document_model()
    doc = db.query(Documento).filter(Documento.id_documento == document_id).first()
    
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")
        
    file_path = get_file_path_absolute(doc.RutaArchivo)
    
    if not file_path.exists():
        raise HTTPException(status_code=404, detail="File not found on server")
        
    return FileResponse(
        path=file_path,
        filename=f"{doc.Nombre}{file_path.suffix}",
        media_type=doc.mime_type or "application/octet-stream"
    )

@router.delete("/{document_id}")
def delete_document(
    document_id: int,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """Soft delete or Hard delete (currently Hard Delete for simplicity)"""
    # Check admin or owner? For now, any authorized user can delete
    # In strict mode, only admin or responsible
    
    Documento = get_document_model()
    doc = db.query(Documento).filter(Documento.id_documento == document_id).first()
    
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")
        
    # Delete from Storage
    if doc.RutaArchivo:
        delete_file(doc.RutaArchivo)
        
    # Delete from DB
    db.delete(doc)
    db.commit()
    
    return {"message": "Document deleted successfully"}
