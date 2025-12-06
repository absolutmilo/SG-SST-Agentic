"""
Employees Router - API endpoints for employee management
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import List, Optional
import logging

from api.models import get_db, AuthorizedUser
from api.dependencies import get_current_active_user
from api.schemas.employee import EmployeeResponse

logger = logging.getLogger(__name__)
router = APIRouter()


@router.get("/employees", response_model=List[EmployeeResponse])
async def get_employees(
    search: Optional[str] = Query(None),
    limit: int = Query(100, le=500),
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Get list of employees from VW_Empleados_Activos view.
    This view includes joined data (Sede, Supervisor) and calculated fields.
    """
    try:
        query_str = "SELECT * FROM VW_Empleados_Activos"
        params = {}
        
        if search:
            query_str += " WHERE NombreCompleto LIKE :search OR NumeroDocumento LIKE :search"
            params['search'] = f"%{search}%"
            
        query_str += f" ORDER BY NombreCompleto OFFSET 0 ROWS FETCH NEXT {limit} ROWS ONLY"
        
        result = db.execute(text(query_str), params)
        
        # Convert rows to dicts for Pydantic validation
        employees = []
        for row in result:
            # Row mapping to dict
            row_dict = row._mapping
            employees.append(row_dict)
            
        return employees
        
    except Exception as e:
        logger.error(f"Error fetching employees from view: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/employees/{employee_id}", response_model=EmployeeResponse)
async def get_employee(
    employee_id: int,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """Get single employee details from view"""
    try:
        query = text("SELECT * FROM VW_Empleados_Activos WHERE id_empleado = :id")
        result = db.execute(query, {"id": employee_id}).fetchone()
        
        if not result:
            raise HTTPException(status_code=404, detail="Employee not found")
        
        return result._mapping
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching employee {employee_id}: {e}")
        raise HTTPException(status_code=500, detail=str(e))
