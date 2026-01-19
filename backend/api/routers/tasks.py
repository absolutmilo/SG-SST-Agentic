from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, aliased
from sqlalchemy import text, and_, or_
from typing import List, Optional
from datetime import date
import logging

from api.models import get_db, Base, AuthorizedUser
from api.dependencies import get_current_active_user

logger = logging.getLogger(__name__)

router = APIRouter()


def get_tarea_model():
    """Get TAREA model class."""
    try:
        return getattr(Base.classes, 'TAREA')
    except AttributeError:
        raise HTTPException(status_code=500, detail="TAREA table not found in database")

def get_empleado_model():
    """Get EMPLEADO model class."""
    try:
        return getattr(Base.classes, 'EMPLEADO')
    except AttributeError:
        raise HTTPException(status_code=500, detail="EMPLEADO table not found in database")


@router.get("/my-tasks")
def get_my_tasks(
    status: Optional[str] = None,
    priority: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Get tasks for the current user.
    Filters by user's email to find assigned tasks.
    Includes form status (required/submitted).
    """
    try:
        Tarea = get_tarea_model()
        Empleado = get_empleado_model()
        
        # Build query - join with Empleado to filter by email
        query = db.query(Tarea, Empleado).join(
            Empleado, Tarea.id_empleado_responsable == Empleado.id_empleado
        ).filter(
            Empleado.Correo == current_user.Correo_Electronico
        )
        
        # Apply optional filters
        if status:
            query = query.filter(Tarea.Estado == status)
        
        if priority:
            query = query.filter(Tarea.Prioridad == priority)
        
        # Order by priority and due date
        tasks_data = query.order_by(
            Tarea.Fecha_Vencimiento.asc()
        ).all()
        
        # Convert to dict and check form status
        result = []
        for task, emp in tasks_data:
            # Check form submission if task requires form
            form_submitted = False
            requires_form = False
            
            # Check if column exists (safe handling)
            if hasattr(task, 'requiere_formulario'):
                requires_form = bool(task.requiere_formulario)
            elif hasattr(task, 'id_formulario') and task.id_formulario:
                # Fallback: if id_formulario is present, assume required
                requires_form = True
                
            if requires_form and hasattr(task, 'id_formulario') and task.id_formulario:
                # Check if submission exists
                # We use raw sql or model if available. Using raw SQL for safety against circular imports
                # NOTE: task_id is stored inside data_json context
                try:
                    check_sql = text("""
                        SELECT COUNT(*) FROM FORM_SUBMISSIONS 
                        WHERE form_id = :form_id
                        AND JSON_VALUE(data_json, '$.context.taskId') = CAST(:task_id AS NVARCHAR(50))
                        AND status = 'Submitted'
                    """)
                    count = db.execute(check_sql, {
                        "form_id": task.id_formulario,
                        "task_id": task.id_tarea
                    }).scalar()
                    form_submitted = count > 0
                except Exception as e:
                    logger.warning(f"Failed to check form submission for task {task.id_tarea}: {e}")
                    form_submitted = False

            result.append({
                "id_tarea": task.id_tarea,
                "descripcion": task.Descripcion,
                "tipo_tarea": task.Tipo_Tarea,
                "estado": task.Estado,
                "prioridad": task.Prioridad,
                "fecha_creacion": task.Fecha_Creacion.isoformat() if task.Fecha_Creacion else None,
                "fecha_vencimiento": task.Fecha_Vencimiento.isoformat() if task.Fecha_Vencimiento else None,
                "fecha_cierre": task.Fecha_Cierre.isoformat() if task.Fecha_Cierre else None,
                "responsable": f"{emp.Nombre} {emp.Apellidos}",
                "correo_responsable": emp.Correo,
                "area": emp.Area,
                "origen_tarea": task.Origen_Tarea,
                "observaciones": task.Observaciones_Cierre if hasattr(task, 'Observaciones_Cierre') else None,
                "id_formulario": task.id_formulario if hasattr(task, 'id_formulario') else None,
                "requiere_formulario": requires_form,
                "formulario_diligenciado": form_submitted
            })
        
        return {
            "total": len(result),
            "tasks": result
        }
        
    except Exception as e:
        logger.error(f"Error fetching user tasks: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/stats")
def get_task_stats(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Get task statistics for the current user.
    """
    try:
        Tarea = get_tarea_model()
        Empleado = get_empleado_model()
        
        # Base filter for user's tasks
        base_query = db.query(Tarea).join(
            Empleado, Tarea.id_empleado_responsable == Empleado.id_empleado
        ).filter(
            Empleado.Correo == current_user.Correo_Electronico
        )
        
        # Count by status
        pending = base_query.filter(Tarea.Estado == 'Pendiente').count()
        in_progress = base_query.filter(Tarea.Estado == 'En Curso').count()
        completed = base_query.filter(Tarea.Estado == 'Cerrada').count()
        overdue = base_query.filter(
            and_(
                Tarea.Estado != 'Cerrada',
                Tarea.Fecha_Vencimiento < date.today()
            )
        ).count()
        
        return {
            "pending": pending,
            "in_progress": in_progress,
            "completed": completed,
            "overdue": overdue,
            "total": pending + in_progress + completed
        }
        
    except Exception as e:
        logger.error(f"Error fetching task stats: {e}")
        raise HTTPException(status_code=500, detail=str(e))



@router.get("/{task_id}/form-status")
def get_task_form_status(
    task_id: int,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """Check if task's required form has been submitted"""
    from sqlalchemy import text
    
    task_query = text("""
        SELECT id_formulario, requiere_formulario, Fecha_Creacion
        FROM TAREA WHERE id_tarea = :task_id
    """)
    
    task_result = db.execute(task_query, {"task_id": task_id}).fetchone()
    if not task_result:
        raise HTTPException(status_code=404, detail="Task not found")
    
    form_id, requires_form, task_created = task_result
    
    if not requires_form:
        return {"requires_form": False, "form_submitted": False, "form_id": None}
    
    submission_query = text("""
        SELECT COUNT(*) FROM FORM_SUBMISSIONS
        WHERE form_id = :form_id
        AND submitted_by IN (
            SELECT id_autorizado FROM USUARIOS_AUTORIZADOS
            WHERE Correo_Electronico = :user_email
        )
        AND status = 'Submitted'
        AND submitted_at >= :task_created
    """)
    
    submission_count = db.execute(submission_query, {
        "form_id": form_id,
        "user_email": current_user.Correo_Electronico,
        "task_created": task_created
    }).scalar()
    
    return {
        "requires_form": True,
        "form_submitted": submission_count > 0,
        "form_id": form_id,
        "task_id": task_id
    }


@router.put("/{task_id}/status")
def update_task_status(
    task_id: int,
    new_status: str,
    observaciones: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Update task status.
    Valid statuses: Pendiente, En Curso, Cerrada
    """
    try:
        Tarea = get_tarea_model()
        Empleado = get_empleado_model()
        
        # Get task with assignee info
        result = db.query(Tarea, Empleado).join(
            Empleado, Tarea.id_empleado_responsable == Empleado.id_empleado
        ).filter(Tarea.id_tarea == task_id).first()
        
        if not result:
            raise HTTPException(status_code=404, detail="Task not found")
            
        task, emp = result
        
        # Verify user has permission (is assigned to task or is admin)
        # Verify user has permission (is assigned to task or is admin)
        is_assigned = (emp.Correo == current_user.Correo_Electronico)
        
        # Check Admin Role from DB
        is_admin = False
        if current_user.id_rol:
            from api.models import Role # lazy import
            user_role = db.query(Role).filter(Role.id_rol == current_user.id_rol).first()
            if user_role:
                 # Check against allowed admin role names
                 # Admin roles: CEO, Coordinador SST, Gerente General
                 is_admin = user_role.NombreRol in ['CEO', 'Coordinador SST', 'Gerente General']
        
        # Fallback to legacy
        if not is_admin and not current_user.id_rol:
             is_admin = current_user.Nivel_Acceso in ['CEO', 'Coordinador SST']
        
        if not (is_assigned or is_admin):
            raise HTTPException(status_code=403, detail="Not authorized to update this task")
        
        # Update status
        task.Estado = new_status
        
        # If closing task, set close date and observations
        if new_status == 'Cerrada':
            # CRITICAL: Validate form submission if required
            if hasattr(task, 'requiere_formulario') and task.requiere_formulario:
                # Check if form was submitted
                if hasattr(task, 'id_formulario') and task.id_formulario:
                    # Query FORM_SUBMISSIONS to verify submission exists
                    from sqlalchemy import text
                    
                    # Get employee ID from current user
                    check_submission = text("""
                        SELECT COUNT(*) FROM FORM_SUBMISSIONS 
                        WHERE form_id = :form_id 
                        AND submitted_by IN (
                            SELECT id_autorizado FROM USUARIOS_AUTORIZADOS 
                            WHERE Correo_Electronico = :user_email
                        )
                        AND status = 'Submitted'
                        AND submitted_at >= :task_created
                    """)
                    
                    submission_count = db.execute(check_submission, {
                        "form_id": task.id_formulario,
                        "user_email": current_user.Correo_Electronico,
                        "task_created": task.Fecha_Creacion
                    }).scalar()
                    
                    if submission_count == 0:
                        raise HTTPException(
                            status_code=400, 
                            detail={
                                "error": "form_required",
                                "message": f"No se puede cerrar la tarea. Debe completar el formulario antes de cerrar esta tarea.",
                                "form_id": task.id_formulario,
                                "task_id": task.id_tarea
                            }
                        )
            
            task.Fecha_Cierre = date.today()
            task.id_empleado_cierre = emp.id_empleado
            if observaciones:
                task.Observaciones_Cierre = observaciones
        
        db.commit()
        db.refresh(task)
        
        return {
            "message": "Task status updated successfully",
            "task_id": task_id,
            "new_status": new_status
        }
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error updating task status: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.put("/{task_id}/assign")
def assign_task(
    task_id: int,
    user_id: int,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Assign task to a different user.
    Only admins can reassign tasks.
    """
    try:
        # Verify admin permission
        # Verify admin permission
        is_admin = False
        if current_user.id_rol:
             # Lazy check for now, can be optimized with a helper
             from api.models import Role
             name = db.query(Role.NombreRol).filter(Role.id_rol == current_user.id_rol).scalar()
             is_admin = name in ['CEO', 'Coordinador SST']
        else:
             is_admin = current_user.Nivel_Acceso in ['CEO', 'Coordinador SST']

        if not is_admin:
            raise HTTPException(status_code=403, detail="Only admins can assign tasks")
        
        Tarea = get_tarea_model()
        Usuario = getattr(Base.classes, 'USUARIOS_AUTORIZADOS')
        Empleado = get_empleado_model()
        
        # Get task
        task = db.query(Tarea).filter(Tarea.id_tarea == task_id).first()
        if not task:
            raise HTTPException(status_code=404, detail="Task not found")
        
        # Get new assignee (User from USUARIOS_AUTORIZADOS)
        # We need to map User ID to Empleado ID. 
        # Assuming USUARIOS_AUTORIZADOS shares Correo with EMPLEADO.
        new_user = db.query(Usuario).filter(Usuario.id_autorizado == user_id).first() # Note: id_usuario in code was likely id_autorizado
        if not new_user:
             # Fallback: maybe user_id passed IS the employee ID?
             # Let's check if we can find an employee with this ID
             emp = db.query(Empleado).filter(Empleado.id_empleado == user_id).first()
             if emp:
                 task.id_empleado_responsable = emp.id_empleado
                 db.commit()
                 return {
                    "message": "Task assigned successfully",
                    "task_id": task_id,
                    "assigned_to": f"{emp.Nombre} {emp.Apellidos}"
                }
             else:
                raise HTTPException(status_code=404, detail="User/Employee not found")

        # Find employee by email
        emp = db.query(Empleado).filter(Empleado.Correo == new_user.Correo_Electronico).first()
        if not emp:
            raise HTTPException(status_code=404, detail=f"No employee profile found for user {new_user.Correo_Electronico}")
        
        # Update assignment
        task.id_empleado_responsable = emp.id_empleado
        
        db.commit()
        
        return {
            "message": "Task assigned successfully",
            "task_id": task_id,
            "assigned_to": f"{emp.Nombre} {emp.Apellidos}"
        }
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error assigning task: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/all")
def get_all_tasks(
    status: Optional[str] = None,
    priority: Optional[str] = None,
    area: Optional[str] = None,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=500),
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Get all tasks (admin only).
    For coordinators and CEOs to see all tasks in the system.
    """
    try:
        # Verify admin permission
        # Verify admin permission
        is_admin = False
        if current_user.id_rol:
             from api.models import Role
             name = db.query(Role.NombreRol).filter(Role.id_rol == current_user.id_rol).scalar()
             is_admin = name in ['CEO', 'Coordinador SST']
        else:
             is_admin = current_user.Nivel_Acceso in ['CEO', 'Coordinador SST']

        if not is_admin:
            raise HTTPException(status_code=403, detail="Only admins can view all tasks")
        
        Tarea = get_tarea_model()
        Empleado = get_empleado_model()
        
        query = db.query(Tarea, Empleado).join(
            Empleado, Tarea.id_empleado_responsable == Empleado.id_empleado
        )
        
        # Apply filters
        if status:
            query = query.filter(Tarea.Estado == status)
        if priority:
            query = query.filter(Tarea.Prioridad == priority)
        if area:
            query = query.filter(Empleado.Area == area)
        
        total = query.count()
        tasks_data = query.order_by(Tarea.Fecha_Vencimiento.asc()).offset(skip).limit(limit).all()
        
        result = []
        for task, emp in tasks_data:
            result.append({
                "id_tarea": task.id_tarea,
                "descripcion": task.Descripcion,
                "tipo_tarea": task.Tipo_Tarea,
                "estado": task.Estado,
                "prioridad": task.Prioridad,
                "fecha_creacion": task.Fecha_Creacion.isoformat() if task.Fecha_Creacion else None,
                "fecha_vencimiento": task.Fecha_Vencimiento.isoformat() if task.Fecha_Vencimiento else None,
                "responsable": f"{emp.Nombre} {emp.Apellidos}",
                "area": emp.Area,
                "id_formulario": task.id_formulario if hasattr(task, 'id_formulario') else None
            })
        
        return {
            "total": total,
            "skip": skip,
            "limit": limit,
            "tasks": result
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching all tasks: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/users")
def get_assignable_users(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Get list of users that can be assigned tasks.
    Only admins can access this endpoint.
    """
    try:
        # Verify admin permission
        # Verify admin permission
        is_admin = False
        if current_user.id_rol:
             from api.models import Role
             name = db.query(Role.NombreRol).filter(Role.id_rol == current_user.id_rol).scalar()
             is_admin = name in ['CEO', 'Coordinador SST']
        else:
             is_admin = current_user.Nivel_Acceso in ['CEO', 'Coordinador SST']

        if not is_admin:
            raise HTTPException(status_code=403, detail="Only admins can view users")
        
        Empleado = get_empleado_model()
        
        # Get active employees
        users = db.query(Empleado).filter(Empleado.Estado == True).all()
        
        result = []
        for user in users:
            result.append({
                "id_usuario": user.id_empleado, # Using employee ID as the ID for assignment
                "nombre_completo": f"{user.Nombre} {user.Apellidos}",
                "correo_electronico": user.Correo,
                "nivel_acceso": "Empleado", # Default
                "area": user.Area
            })
        
        return {
            "total": len(result),
            "users": result
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching users: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/create")
def create_task(
    descripcion: str,
    tipo_tarea: str,
    prioridad: str,
    fecha_vencimiento: str,
    id_responsable: int,
    observaciones: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Create a new task and assign it to a user.
    Only admins can create tasks.
    """
    try:
        # Verify admin permission
        # Verify admin permission
        is_admin = False
        if current_user.id_rol:
             from api.models import Role
             name = db.query(Role.NombreRol).filter(Role.id_rol == current_user.id_rol).scalar()
             is_admin = name in ['CEO', 'Coordinador SST']
        else:
             is_admin = current_user.Nivel_Acceso in ['CEO', 'Coordinador SST']

        if not is_admin:
            raise HTTPException(status_code=403, detail="Only admins can create tasks")
        
        Tarea = get_tarea_model()
        Empleado = get_empleado_model()
        
        # Get assignee (Employee)
        assignee = db.query(Empleado).filter(Empleado.id_empleado == id_responsable).first()
        if not assignee:
            raise HTTPException(status_code=404, detail="Employee not found")
        
        # Parse date
        from datetime import datetime
        try:
            fecha_venc = datetime.fromisoformat(fecha_vencimiento.replace('Z', '+00:00')).date()
        except:
            raise HTTPException(status_code=400, detail="Invalid date format")
        
        # Create new task
        new_task = Tarea(
            Descripcion=descripcion,
            Tipo_Tarea=tipo_tarea,
            Estado='Pendiente',
            Prioridad=prioridad,
            Fecha_Creacion=date.today(),
            Fecha_Vencimiento=fecha_venc,
            id_empleado_responsable=assignee.id_empleado,
            Origen_Tarea='Manual',
            # Observaciones=observaciones # Removed as column doesn't exist
        )
        
        db.add(new_task)
        db.commit()
        db.refresh(new_task)
        
        return {
            "message": "Task created successfully",
            "task_id": new_task.id_tarea,
            "assigned_to": f"{assignee.Nombre} {assignee.Apellidos}"
        }
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error creating task: {e}")
        raise HTTPException(status_code=500, detail=str(e))

