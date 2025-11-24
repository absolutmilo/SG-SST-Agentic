"""
Generic CRUD router - works for ANY table in your database!
This saves us from writing individual routers for each entity.
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import inspect, and_, or_
from typing import List, Dict, Any, Optional
import logging

from api.models import get_db, Base

logger = logging.getLogger(__name__)

router = APIRouter()


def get_model_class(table_name: str):
    """Get model class by table name."""
    try:
        return getattr(Base.classes, table_name)
    except AttributeError:
        raise HTTPException(status_code=404, detail=f"Table '{table_name}' not found")


def model_to_dict(instance) -> Dict[str, Any]:
    """Convert SQLAlchemy model instance to dictionary."""
    if instance is None:
        return None
    
    result = {}
    for column in inspect(instance).mapper.column_attrs:
        value = getattr(instance, column.key)
        # Convert datetime/date to ISO format
        if hasattr(value, 'isoformat'):
            value = value.isoformat()
        result[column.key] = value
    return result


@router.get("/{table_name}")
def get_all(
    table_name: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    db: Session = Depends(get_db)
):
    """
    Get all records from any table with pagination.
    
    Example: GET /api/v1/crud/EMPLEADO?skip=0&limit=10
    """
    Model = get_model_class(table_name)
    
    try:
        total = db.query(Model).count()
        items = db.query(Model).offset(skip).limit(limit).all()
        
        return {
            "total": total,
            "skip": skip,
            "limit": limit,
            "items": [model_to_dict(item) for item in items]
        }
    except Exception as e:
        logger.error(f"Error querying {table_name}: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/{table_name}/{record_id}")
def get_one(
    table_name: str,
    record_id: int,
    db: Session = Depends(get_db)
):
    """
    Get a single record by ID.
    
    Example: GET /api/v1/crud/EMPLEADO/100
    """
    Model = get_model_class(table_name)
    
    # Get primary key column name
    pk_column = inspect(Model).primary_key[0].name
    
    try:
        item = db.query(Model).filter(getattr(Model, pk_column) == record_id).first()
        
        if not item:
            raise HTTPException(status_code=404, detail=f"Record {record_id} not found in {table_name}")
        
        return model_to_dict(item)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting {table_name}/{record_id}: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/{table_name}")
def create(
    table_name: str,
    data: Dict[str, Any],
    db: Session = Depends(get_db)
):
    """
    Create a new record.
    
    Example: POST /api/v1/crud/EMPLEADO
    Body: {"Nombre": "Juan", "Apellidos": "Pérez", ...}
    """
    Model = get_model_class(table_name)
    
    try:
        # Create new instance
        new_item = Model(**data)
        db.add(new_item)
        db.commit()
        db.refresh(new_item)
        
        return {
            "message": f"Record created successfully in {table_name}",
            "data": model_to_dict(new_item)
        }
    except Exception as e:
        db.rollback()
        logger.error(f"Error creating record in {table_name}: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.put("/{table_name}/{record_id}")
def update(
    table_name: str,
    record_id: int,
    data: Dict[str, Any],
    db: Session = Depends(get_db)
):
    """
    Update an existing record.
    
    Example: PUT /api/v1/crud/EMPLEADO/100
    Body: {"Telefono": "3001234567"}
    """
    Model = get_model_class(table_name)
    pk_column = inspect(Model).primary_key[0].name
    
    try:
        item = db.query(Model).filter(getattr(Model, pk_column) == record_id).first()
        
        if not item:
            raise HTTPException(status_code=404, detail=f"Record {record_id} not found in {table_name}")
        
        # Update fields
        for key, value in data.items():
            if hasattr(item, key):
                setattr(item, key, value)
        
        db.commit()
        db.refresh(item)
        
        return {
            "message": f"Record {record_id} updated successfully in {table_name}",
            "data": model_to_dict(item)
        }
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error updating {table_name}/{record_id}: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/{table_name}/{record_id}")
def delete(
    table_name: str,
    record_id: int,
    db: Session = Depends(get_db)
):
    """
    Delete a record (or soft delete if Estado column exists).
    
    Example: DELETE /api/v1/crud/EMPLEADO/100
    """
    Model = get_model_class(table_name)
    pk_column = inspect(Model).primary_key[0].name
    
    try:
        item = db.query(Model).filter(getattr(Model, pk_column) == record_id).first()
        
        if not item:
            raise HTTPException(status_code=404, detail=f"Record {record_id} not found in {table_name}")
        
        # Soft delete if Estado column exists
        if hasattr(item, 'Estado'):
            item.Estado = False
            db.commit()
            return {"message": f"Record {record_id} soft deleted (Estado=False) in {table_name}"}
        else:
            # Hard delete
            db.delete(item)
            db.commit()
            return {"message": f"Record {record_id} permanently deleted from {table_name}"}
            
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error deleting {table_name}/{record_id}: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/{table_name}/search")
def search(
    table_name: str,
    filters: Dict[str, Any],
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    db: Session = Depends(get_db)
):
    """
    Search records with filters.
    
    Example: POST /api/v1/crud/EMPLEADO/search
    Body: {"Area": "Tecnología", "Estado": true}
    """
    Model = get_model_class(table_name)
    
    try:
        query = db.query(Model)
        
        # Apply filters
        for key, value in filters.items():
            if hasattr(Model, key):
                query = query.filter(getattr(Model, key) == value)
        
        total = query.count()
        items = query.offset(skip).limit(limit).all()
        
        return {
            "total": total,
            "skip": skip,
            "limit": limit,
            "filters": filters,
            "items": [model_to_dict(item) for item in items]
        }
    except Exception as e:
        logger.error(f"Error searching {table_name}: {e}")
        raise HTTPException(status_code=500, detail=str(e))
