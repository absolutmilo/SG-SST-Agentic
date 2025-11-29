"""
Employees Router - API endpoints for employee management
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import List, Dict, Any, Optional
import logging

from api.models import get_db, Base, AuthorizedUser
from api.dependencies import get_current_active_user

logger = logging.getLogger(__name__)
router = APIRouter()


@router.get("/employees")
async def get_employees(
    search: Optional[str] = Query(None),
    limit: int = Query(100, le=500),
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Get list of employees from EMPLEADO table (or USUARIOS_AUTORIZADOS as fallback)
    Supports search by name
    """
    try:
        # Try EMPLEADO table first, fallback to USUARIOS_AUTORIZADOS
        try:
            query = """
                SELECT 
                    Id_Empleado as id,
                    NombreCompleto as nombre,
                    Cargo as cargo,
                    Area as area,
                    Estado as estado
                FROM EMPLEADO
                WHERE Estado = 'Activo'
            """
            
            params = {}
            
            if search:
                query += " AND NombreCompleto LIKE :search"
                params['search'] = f"%{search}%"
            
            query += " ORDER BY NombreCompleto"
            query += f" OFFSET 0 ROWS FETCH NEXT {limit} ROWS ONLY"
            
            result = db.execute(text(query), params)
            
        except Exception as e:
            # Fallback to USUARIOS_AUTORIZADOS
            logger.info(f"EMPLEADO table not found, using USUARIOS_AUTORIZADOS: {e}")
            query = """
                SELECT 
                    Id_Usuario as id,
                    NombreCompleto as nombre,
                    Nivel_Acceso as cargo,
                    'N/A' as area,
                    Estado as estado
                FROM USUARIOS_AUTORIZADOS
                WHERE Estado = 'Activo'
            """
            
            params = {}
            
            if search:
                query += " AND NombreCompleto LIKE :search"
                params['search'] = f"%{search}%"
            
            query += " ORDER BY NombreCompleto"
            query += f" OFFSET 0 ROWS FETCH NEXT {limit} ROWS ONLY"
            
            result = db.execute(text(query), params)
        
        employees = []
        for row in result:
            employees.append({
                "id_empleado": row.id,
                "nombre_completo": row.nombre,
                "cargo": row.cargo,
                "area": row.area if hasattr(row, 'area') else 'N/A',
                "estado": row.estado
            })
        
        return {
            "employees": employees,
            "total": len(employees)
        }
        
    except Exception as e:
        logger.error(f"Error fetching employees: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/employees/{employee_id}")
async def get_employee(
    employee_id: int,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """Get single employee details"""
    try:
        query = """
            SELECT 
                Id_Empleado,
                NombreCompleto,
                Cargo,
                Area,
                FechaIngreso,
                Estado
            FROM EMPLEADO
            WHERE Id_Empleado = :employee_id
        """
        
        result = db.execute(text(query), {"employee_id": employee_id})
        row = result.fetchone()
        
        if not row:
            raise HTTPException(status_code=404, detail="Employee not found")
        
        return {
            "id_empleado": row.Id_Empleado,
            "nombre_completo": row.NombreCompleto,
            "cargo": row.Cargo,
            "area": row.Area,
            "fecha_ingreso": row.FechaIngreso.isoformat() if row.FechaIngreso else None,
            "estado": row.Estado
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching employee {employee_id}: {e}")
        raise HTTPException(status_code=500, detail=str(e))
