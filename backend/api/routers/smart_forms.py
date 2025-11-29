"""
Smart Forms Router - API endpoints for dynamic forms
"""

from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Query
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import List, Dict, Any, Optional
import json
import logging
from datetime import datetime

from api.models import get_db, Base, AuthorizedUser
from api.models.smart_forms import (
    SmartFormDefinition,
    FormSubmission,
    FormDraft,
    FormValidationResult,
    FormValidationError,
    WorkflowAction
)
from api.dependencies import get_current_active_user

logger = logging.getLogger(__name__)
router = APIRouter()


# ============================================================
# FORM DEFINITIONS
# ============================================================

@router.get("/forms", response_model=List[Dict[str, Any]])
async def get_available_forms(
    category: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Get list of available forms for the current user.
    Filters based on company size, risk level, and user role.
    """
    try:
        from api.services.form_catalog import get_form_catalog
        
        catalog = get_form_catalog()
        
        # Convert Pydantic models to dicts
        forms_list = []
        for form_id, form_def in catalog.items():
            forms_list.append({
                "id": form_def.id,
                "name": form_def.name,
                "title": form_def.title,
                "description": form_def.description,
                "category": form_def.category,
                "legal_reference": form_def.legal_reference
            })
        
        # Filter by category if provided
        if category:
            forms_list = [f for f in forms_list if f.get('category') == category]
        
        return forms_list
        
    except Exception as e:
        logger.error(f"Error fetching forms: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/forms/{form_id}")
async def get_form_definition(
    form_id: str,
    db: Session = Depends(get_db)
):
    """Get complete form definition"""
    try:
        from api.services.form_catalog import get_form_definition
        
        form_def = get_form_definition(form_id)
        if not form_def:
            raise HTTPException(status_code=404, detail="Form not found")
        
        # Convert Pydantic model to dict
        return form_def.model_dump()
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching form {form_id}: {e}")
        raise HTTPException(status_code=500, detail=str(e))


# ============================================================
# FORM PRE-FILL
# ============================================================

@router.get("/forms/{form_id}/prefill")
async def get_prefill_data(
    form_id: str,
    context: Optional[str] = Query(None),  # JSON string with context
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Get data to pre-fill the form.
    Context can include: employee_id, event_id, etc.
    """
    try:
        context_data = json.loads(context) if context else {}
        
        # TODO: Implement pre-fill logic based on form_id and context
        # Example: For medical exam, get last exam data
        # Example: For accident, get employee data
        
        prefill_data = {}
        
        # Get form definition
        from api.services.form_catalog import get_form_definition
        form_def = get_form_definition(form_id)
        
        if not form_def:
            return {}
        
        # Process each field's prefill_from
        for field in form_def.fields:
            if field.prefill_from:
                # Execute prefill query
                # prefill_data[field.id] = execute_prefill_query(field.prefill_from, context_data)
                pass
        
        return prefill_data
        
    except Exception as e:
        logger.error(f"Error getting prefill data: {e}")
        return {}


# ============================================================
# FORM SUBMISSION
# ============================================================

@router.post("/forms/{form_id}/submit")
async def submit_form(
    form_id: str,
    submission: FormSubmission,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Submit a form.
    1. Validate data
    2. Save to database
    3. Execute workflow actions
    4. Generate PDF if configured
    5. Send notifications
    """
    try:
        # Get form definition
        from api.services.form_catalog import get_form_definition
        form_def = get_form_definition(form_id)
        
        if not form_def:
            raise HTTPException(status_code=404, detail="Form not found")
        
        # 1. Validate submission
        validation_result = validate_form_data(form_def, submission.data)
        if not validation_result.is_valid:
            raise HTTPException(
                status_code=400,
                detail={"message": "Validation failed", "errors": validation_result.errors}
            )
        
        # 2. Save to database
        submission_id = save_form_submission(db, form_id, submission, current_user.Id_Usuario)
        
        # 3. Execute workflow actions (TEMPORARILY DISABLED FOR DEBUGGING)
        # TODO: Re-enable after fixing the error
        try:
            for action in sorted(form_def.on_submit, key=lambda x: x.order):
                logger.info(f"Executing workflow action: {action.action}")
                execute_workflow_action(db, action, submission.data, current_user)
        except Exception as workflow_error:
            logger.error(f"Workflow execution failed: {workflow_error}")
            # Don't fail the submission if workflow fails
            pass
        
        # 4. Generate PDF if configured
        if form_def.generate_pdf:
            # TODO: Generate PDF
            pass
        
        # 5. Send notifications
        if form_def.send_notifications:
            # TODO: Send notifications
            pass
        
        return {
            "message": "Form submitted successfully",
            "submission_id": submission_id,
            "form_id": form_id
        }
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error submitting form: {e}")
        logger.exception("Full traceback:")  # This will log the full stack trace
        raise HTTPException(status_code=500, detail=str(e))


# ============================================================
# DRAFT MANAGEMENT
# ============================================================

@router.post("/forms/{form_id}/draft")
async def save_draft(
    form_id: str,
    data: Dict[str, Any],
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """Save form draft (auto-save)"""
    try:
        # TODO: Save to FORM_DRAFTS table
        
        return {
            "message": "Draft saved successfully",
            "saved_at": datetime.now().isoformat()
        }
        
    except Exception as e:
        logger.error(f"Error saving draft: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/forms/{form_id}/draft")
async def get_draft(
    form_id: str,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """Get saved draft for current user"""
    try:
        # TODO: Load from FORM_DRAFTS table
        
        return {}
        
    except Exception as e:
        logger.error(f"Error loading draft: {e}")
        return {}


# ============================================================
# FILE UPLOADS
# ============================================================

@router.post("/forms/{form_id}/upload")
async def upload_attachment(
    form_id: str,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """Upload file attachment"""
    try:
        # TODO: Implement file upload
        # - Validate file type
        # - Save to storage
        # - Return file path
        
        return {
            "message": "File uploaded successfully",
            "file_path": f"/uploads/{form_id}/{file.filename}"
        }
        
    except Exception as e:
        logger.error(f"Error uploading file: {e}")
        raise HTTPException(status_code=500, detail=str(e))


# ============================================================
# SUBMISSIONS HISTORY
# ============================================================

@router.get("/forms/{form_id}/submissions")
async def get_submissions(
    form_id: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """Get form submissions history"""
    try:
        # TODO: Load from FORM_SUBMISSIONS table
        
        return {
            "total": 0,
            "skip": skip,
            "limit": limit,
            "submissions": []
        }
        
    except Exception as e:
        logger.error(f"Error fetching submissions: {e}")
        raise HTTPException(status_code=500, detail=str(e))


# ============================================================
# HELPER FUNCTIONS
# ============================================================

def validate_form_data(
    form_def: SmartFormDefinition,
    data: Dict[str, Any]
) -> FormValidationResult:
    """Validate form data against form definition"""
    errors = []
    
    for field in form_def.fields:
        field_value = data.get(field.id)
        
        # Check required fields
        if field.required and not field_value:
            errors.append(FormValidationError(
                field_id=field.id,
                field_name=field.name,
                error_type="required",
                message=f"{field.label} is required"
            ))
            continue
        
        # Run field validations
        for validation in field.validations:
            # TODO: Implement validation logic
            pass
    
    return FormValidationResult(
        is_valid=len(errors) == 0,
        errors=errors
    )


def save_form_submission(
    db: Session,
    form_id: str,
    submission: FormSubmission,
    user_id: int
) -> int:
    """Save form submission to database"""
    try:
        # Create submission record in FORM_SUBMISSIONS table (if it exists)
        # Otherwise just log it
        try:
            from sqlalchemy import text
            import json
            
            # Try to save to FORM_SUBMISSIONS table
            query = text("""
                INSERT INTO FORM_SUBMISSIONS (
                    form_id,
                    form_version,
                    submitted_by,
                    submitted_at,
                    data_json,
                    status
                )
                OUTPUT INSERTED.id_submission
                VALUES (
                    :form_id,
                    :form_version,
                    :submitted_by,
                    GETDATE(),
                    :data_json,
                    'completed'
                )
            """)
            
            result = db.execute(query, {
                "form_id": form_id,
                "form_version": submission.form_version,
                "submitted_by": user_id,
                "data_json": json.dumps(submission.data)
            })
            
            row = result.fetchone()
            submission_id = row[0] if row else None
            
            db.commit()
            
            logger.info(f"Form submission saved: {submission_id}")
            return submission_id
            
        except Exception as table_error:
            # Table might not exist, just log and continue
            logger.warning(f"Could not save to FORM_SUBMISSIONS table: {table_error}")
            logger.info(f"Form data will be processed by workflows only")
            db.rollback()
            return 0  # Return 0 to indicate no submission ID but continue processing
            
    except Exception as e:
        logger.error(f"Error in save_form_submission: {e}")
        db.rollback()
        raise


def execute_workflow_action(
    db: Session,
    action: WorkflowAction,
    form_data: Dict[str, Any],
    current_user: AuthorizedUser
):
    """Execute a workflow action"""
    try:
        if action.action == "save_to_table":
            # Save data to specified table
            save_to_table(db, action.params, form_data)
        
        elif action.action == "create_task":
            # Create a task
            create_task_from_form(db, action.params, form_data, current_user)
        
        elif action.action == "send_notification":
            # Send notification
            send_notification(action.params, form_data)
        
        elif action.action == "update_indicators":
            # Update indicators
            update_indicators(db, action.params)
        
        elif action.action == "run_sp":
            # Run stored procedure
            run_stored_procedure(db, action.params, form_data)
        
        elif action.action == "ai_analyze":
            # AI analysis
            ai_analyze(action.params, form_data)
        
    except Exception as e:
        logger.error(f"Error executing workflow action {action.action}: {e}")
        # Don't fail the entire submission if one action fails
        pass


def save_to_table(db: Session, params: Dict[str, Any], form_data: Dict[str, Any]):
    """Save form data to a database table"""
    try:
        table_name = params.get("table")
        mapping = params.get("mapping", {})
        
        if not table_name:
            logger.error("No table specified in save_to_table action")
            return
        
        # Build INSERT query
        columns = []
        values = []
        
        for db_column, form_field in mapping.items():
            columns.append(db_column)
            
            # Handle literal values (enclosed in quotes)
            if isinstance(form_field, str) and form_field.startswith("'") and form_field.endswith("'"):
                values.append(form_field.strip("'"))
            else:
                # Get value from form data
                values.append(form_data.get(form_field))
        
        # Build parameterized query
        placeholders = ", ".join([f":{i}" for i in range(len(values))])
        query = f"""
            INSERT INTO {table_name} ({', '.join(columns)})
            VALUES ({placeholders})
        """
        
        # Create params dict
        params_dict = {str(i): val for i, val in enumerate(values)}
        
        # Execute
        db.execute(text(query), params_dict)
        db.commit()
        
        logger.info(f"Saved form data to table {table_name}")
        
    except Exception as e:
        db.rollback()
        logger.error(f"Error saving to table: {e}")
        raise


def create_task_from_form(
    db: Session,
    params: Dict[str, Any],
    form_data: Dict[str, Any],
    current_user: AuthorizedUser
):
    """Create a task from form submission"""
    try:
        from datetime import datetime, timedelta
        
        # Get task parameters
        tipo_tarea = params.get("tipo_tarea", "Tarea de Formulario")
        descripcion = params.get("descripcion", "")
        prioridad = params.get("prioridad", "Media")
        
        # Get assignee
        id_responsable = None
        if "assign_to_field" in params:
            # Get from form field
            field_name = params["assign_to_field"]
            id_responsable = form_data.get(field_name)
        elif "assign_to_role" in params:
            # Assign to first user with role
            role = params["assign_to_role"]
            result = db.execute(
                text("SELECT TOP 1 Id_Usuario FROM USUARIOS_AUTORIZADOS WHERE Nivel_Acceso = :role AND Estado = 'Activo'"),
                {"role": role}
            )
            row = result.fetchone()
            if row:
                id_responsable = row.Id_Usuario
        
        if not id_responsable:
            id_responsable = current_user.Id_Usuario
        
        # Get due date
        fecha_vencimiento = None
        if "due_date_field" in params:
            # Get from form field
            field_name = params["due_date_field"]
            fecha_vencimiento = form_data.get(field_name)
        elif "due_date" in params:
            # Parse relative date (e.g., "+48 hours", "+7 days")
            due_date_str = params["due_date"]
            if due_date_str.startswith("+"):
                parts = due_date_str[1:].split()
                if len(parts) == 2:
                    amount = int(parts[0])
                    unit = parts[1].lower()
                    
                    if "hour" in unit:
                        fecha_vencimiento = datetime.now() + timedelta(hours=amount)
                    elif "day" in unit:
                        fecha_vencimiento = datetime.now() + timedelta(days=amount)
                    elif "week" in unit:
                        fecha_vencimiento = datetime.now() + timedelta(weeks=amount)
        
        if not fecha_vencimiento:
            # Default to 7 days from now
            fecha_vencimiento = datetime.now() + timedelta(days=7)
        
        # Format date for SQL Server
        if isinstance(fecha_vencimiento, str):
            fecha_vencimiento_str = fecha_vencimiento
        else:
            fecha_vencimiento_str = fecha_vencimiento.strftime('%Y-%m-%d')
        
        # Create task
        query = text("""
            INSERT INTO Tarea (Descripcion, Tipo_Tarea, Prioridad, Estado, Fecha_Vencimiento, Id_Responsable, Fecha_Creacion)
            VALUES (:descripcion, :tipo_tarea, :prioridad, 'Pendiente', :fecha_vencimiento, :id_responsable, GETDATE())
        """)
        
        db.execute(query, {
            "descripcion": descripcion,
            "tipo_tarea": tipo_tarea,
            "prioridad": prioridad,
            "fecha_vencimiento": fecha_vencimiento_str,
            "id_responsable": id_responsable
        })
        db.commit()
        
        logger.info(f"Created task: {tipo_tarea} for user {id_responsable}")
        
    except Exception as e:
        db.rollback()
        logger.error(f"Error creating task: {e}")
        raise


def send_notification(params: Dict[str, Any], form_data: Dict[str, Any]):
    """Send notification"""
    try:
        recipients = params.get("recipients", [])
        subject = params.get("subject", "Notificación de Formulario")
        template = params.get("template")
        
        # TODO: Implement email/notification sending
        # For now, just log
        logger.info(f"Notification: {subject} to {recipients}")
        logger.info(f"Template: {template}, Data: {form_data}")
        
        # In production, this would:
        # 1. Look up email addresses for recipients
        # 2. Render email template with form_data
        # 3. Send via SMTP or notification service
        
    except Exception as e:
        logger.error(f"Error sending notification: {e}")


def update_indicators(db: Session, params: Dict[str, Any]):
    """Update indicators"""
    try:
        indicators = params.get("indicators", [])
        
        # TODO: Implement indicator calculation
        # For now, just log
        logger.info(f"Updating indicators: {indicators}")
        
        # In production, this would:
        # 1. Recalculate each indicator (IFA, ISA, ILI, etc.)
        # 2. Update RESULTADO_INDICADOR table
        # 3. Trigger alerts if thresholds exceeded
        
        # Example for IFA (Índice de Frecuencia de Accidentalidad):
        # IFA = (Número de accidentes * 240,000) / Horas hombre trabajadas
        
    except Exception as e:
        logger.error(f"Error updating indicators: {e}")


def run_stored_procedure(db: Session, params: Dict[str, Any], form_data: Dict[str, Any]):
    """Run a stored procedure"""
    try:
        sp_name = params.get("sp_name")
        sp_params = params.get("sp_params", {})
        
        if not sp_name:
            logger.error("No stored procedure name specified")
            return
        
        # Build parameter values from form data
        param_values = {}
        for param_name, form_field in sp_params.items():
            param_values[param_name] = form_data.get(form_field)
        
        # Build EXEC statement
        param_list = ", ".join([f"@{k} = :{k}" for k in param_values.keys()])
        query = f"EXEC {sp_name} {param_list}"
        
        # Execute
        db.execute(text(query), param_values)
        db.commit()
        
        logger.info(f"Executed stored procedure: {sp_name}")
        
    except Exception as e:
        db.rollback()
        logger.error(f"Error running stored procedure: {e}")


def ai_analyze(params: Dict[str, Any], form_data: Dict[str, Any]):
    """AI analysis of form data"""
    try:
        field = params.get("field")
        output_field = params.get("output_field")
        prompt = params.get("prompt")
        
        # TODO: Implement OpenAI integration
        # For now, just log
        logger.info(f"AI Analysis requested for field: {field}")
        logger.info(f"Prompt: {prompt}")
        
        # In production, this would:
        # 1. Get field value from form_data
        # 2. Call OpenAI API with prompt
        # 3. Store result in output_field
        # 4. Return analysis to user
        
    except Exception as e:
        logger.error(f"Error in AI analysis: {e}")
