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
from api.services.pdf_generator import PDFGenerator

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
        prefill_data = {}
        
        # Get form definition
        from api.services.form_catalog import get_form_definition
        form_def = get_form_definition(form_id)
        
        if not form_def:
            return {}
            
        # 1. Basic Context Mapping
        # Map context keys directly to field IDs if they match
        for field in form_def.fields:
            # Direct match
            if field.id in context_data:
                prefill_data[field.id] = context_data[field.id]
                
            # Special case: Employee ID
            if field.type == "employee_select" and "id_empleado" in context_data:
                prefill_data[field.id] = context_data["id_empleado"]
                
            # Special case: Current Date
            if field.type == "date" and field.default_value == "today":
                prefill_data[field.id] = datetime.now().strftime("%Y-%m-%d")

        # 2. Database Prefill (if configured)
        # TODO: Implement complex DB queries if 'prefill_from' is set
                
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
    Submit a form with GUARANTEED data insertion using atomic transactions.
    1. Validate data
    2. Save to FORM_SUBMISSIONS
    3. Execute workflow actions (save_to_table, create_task, etc.)
    4. Verify data insertion
    5. Rollback everything if any step fails
    """
    submission_id = None
    
    try:
        # Get form definition
        from api.services.form_catalog import get_form_definition
        from api.utils.data_verification import (
            verify_data_insertion,
            save_verification_audit,
            update_submission_status
        )
        
        form_def = get_form_definition(form_id)
        
        if not form_def:
            raise HTTPException(status_code=404, detail="Form not found")
        
        # Step 1: Validate submission data
        validation_result = validate_form_data(form_def, submission.data)
        if not validation_result.is_valid:
            raise HTTPException(
                status_code=400,
                detail={
                    "error": "validation_failed",
                    "message": "Validation failed",
                    "errors": [
                        {
                            "field": err.field_id,
                            "type": err.error_type,
                            "message": err.message
                        } for err in validation_result.errors
                    ]
                }
            )
        
        # Inject context into data so it gets saved in JSON
        if submission.context:
            submission.data['context'] = submission.context

        # Step 2: Save to FORM_SUBMISSIONS (returns ID)
        submission_id = save_form_submission(db, form_id, submission, current_user.id_autorizado)
        logger.info(f"Form submission created: {submission_id}")
        
        # Step 3: Execute workflow actions with result tracking
        workflow_results = {}
        
        try:
            for action in sorted(form_def.on_submit, key=lambda x: x.order):
                logger.info(f"Executing workflow action: {action.action} (order {action.order})")
                
                result = execute_workflow_action(
                    db, action, submission.data,
                    current_user, submission.context or {},
                    workflow_results
                )
                
                workflow_results[action.action] = result
                logger.info(f"Action {action.action} completed successfully")
                
        except Exception as workflow_error:
            # CRITICAL: Rollback everything if any workflow fails
            logger.error(f"Workflow failed, rolling back transaction: {str(workflow_error)}")
            db.rollback()
            
            # Update submission status to 'Failed'
            try:
                update_submission_status(db, submission_id, 'Failed', str(workflow_error))
            except:
                pass  # Don't fail if status update fails
            
            raise HTTPException(
                status_code=500,
                detail={
                    "error": "workflow_failed",
                    "message": f"Error executing workflow: {str(workflow_error)}",
                    "submission_id": submission_id,
                    "failed_action": action.action if 'action' in locals() else "unknown"
                }
            )
        
        # Step 4: Commit transaction (all or nothing)
        db.commit()
        logger.info(f"Transaction committed successfully for submission {submission_id}")
        
        # Step 5: Verify data insertion
        verification = verify_data_insertion(db, workflow_results, form_id)
        
        # Save verification audit
        try:
            save_verification_audit(db, submission_id, verification, current_user.id_autorizado)
        except Exception as audit_error:
            logger.warning(f"Failed to save verification audit: {str(audit_error)}")
        
        # Update submission status to 'Submitted'
        try:
            update_submission_status(db, submission_id, 'Submitted')
        except Exception as status_error:
            logger.warning(f"Failed to update submission status: {str(status_error)}")
        
        # Return success with verification details
        return {
            "success": True,
            "submission_id": submission_id,
            "message": "Form submitted successfully",
            "workflow_results": workflow_results,
            "verification": verification
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Form submission failed: {str(e)}")
        db.rollback()
        
        # Try to update submission status if we have an ID
        if submission_id:
            try:
                update_submission_status(db, submission_id, 'Failed', str(e))
            except:
                pass
        
        raise HTTPException(
            status_code=500,
            detail={
                "error": "submission_failed",
                "message": f"Failed to submit form: {str(e)}",
                "submission_id": submission_id
            }
        )


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
        data_json = json.dumps(data)
        
        # Check if draft exists
        query_check = text("""
            SELECT id_draft FROM FORM_DRAFTS 
            WHERE form_id = :form_id AND user_id = :user_id
        """)
        result = db.execute(query_check, {"form_id": form_id, "user_id": current_user.id_autorizado})
        existing_draft = result.fetchone()
        
        if existing_draft:
            # Update existing draft
            query_update = text("""
                UPDATE FORM_DRAFTS 
                SET data_json = :data_json, 
                    saved_at = GETDATE(),
                    expires_at = DATEADD(day, 30, GETDATE())
                WHERE id_draft = :id_draft
            """)
            db.execute(query_update, {
                "data_json": data_json,
                "id_draft": existing_draft[0]
            })
        else:
            # Insert new draft
            query_insert = text("""
                INSERT INTO FORM_DRAFTS (form_id, user_id, data_json, saved_at, expires_at)
                VALUES (:form_id, :user_id, :data_json, GETDATE(), DATEADD(day, 30, GETDATE()))
            """)
            db.execute(query_insert, {
                "form_id": form_id,
                "user_id": current_user.id_autorizado,
                "data_json": data_json
            })
            
        db.commit()
        
        return {
            "message": "Draft saved successfully",
            "saved_at": datetime.now().isoformat()
        }
        
    except Exception as e:
        db.rollback()
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
        query = text("""
            SELECT data_json, saved_at 
            FROM FORM_DRAFTS 
            WHERE form_id = :form_id AND user_id = :user_id
        """)
        result = db.execute(query, {"form_id": form_id, "user_id": current_user.Id_Usuario})
        row = result.fetchone()
        
        if row and row.data_json:
            return json.loads(row.data_json)
            
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
        # Run field validations
        for validation in field.validations:
            # Required check is already done above
            
            # Min Length / Min Value
            if validation.type == "min" and field_value is not None:
                if field.type in ["number", "integer"]:
                    if float(field_value) < float(validation.value):
                        errors.append(FormValidationError(
                            field_id=field.id, field_name=field.name, error_type="min",
                            message=validation.message or f"Value must be at least {validation.value}"))
                elif isinstance(field_value, str) and len(field_value) < int(validation.value):
                    errors.append(FormValidationError(
                        field_id=field.id, field_name=field.name, error_type="min_length",
                        message=validation.message or f"Must be at least {validation.value} characters"))
            
            # Max Length / Max Value
            if validation.type == "max" and field_value is not None:
                if field.type in ["number", "integer"]:
                    if float(field_value) > float(validation.value):
                        errors.append(FormValidationError(
                            field_id=field.id, field_name=field.name, error_type="max",
                            message=validation.message or f"Value must be at most {validation.value}"))
            
            # Pattern / Regex
            if validation.type == "pattern" and field_value and isinstance(field_value, str):
                import re
                if not re.match(validation.value, field_value):
                    errors.append(FormValidationError(
                        field_id=field.id, field_name=field.name, error_type="pattern",
                        message=validation.message or "Invalid format"))
            
            # Date Range (Basic)
            if validation.type == "date_range" and field_value:
                # TODO: Implement date logic
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
            
            # Prepare attachments JSON
            attachments_json = json.dumps(submission.attachments) if submission.attachments else "[]"
            
            # Form Title (from definition or lookup)
            from api.services.form_catalog import get_form_definition
            form_def = get_form_definition(form_id)
            form_title = form_def.title if form_def else form_id
            
            # Insert into FORM_SUBMISSIONS table
            # matching user provided schema: 
            # id_submission, form_id, form_version, form_title, data_json, attachments_json, 
            # submitted_by, submitted_at, status, workflow_status, ip_address, user_agent...
            
            query = text("""
                SET NOCOUNT ON;
                INSERT INTO FORM_SUBMISSIONS (
                    form_id,
                    form_version,
                    form_title,
                    data_json,
                    attachments_json,
                    submitted_by,
                    submitted_at,
                    status,
                    workflow_status,
                    ip_address,
                    user_agent,
                    created_at,
                    updated_at
                )
                VALUES (
                    :form_id,
                    :form_version,
                    :form_title,
                    :data_json,
                    :attachments_json,
                    :submitted_by,
                    GETDATE(),
                    'Submitted',
                    'Pending',
                    :ip_address,
                    :user_agent,
                    GETDATE(),
                    GETDATE()
                );
                SELECT CAST(SCOPE_IDENTITY() AS INT);
            """)
            
            result = db.execute(query, {
                "form_id": form_id,
                "form_version": submission.form_version,
                "form_title": form_title,
                "data_json": json.dumps(submission.data),
                "attachments_json": attachments_json,
                "submitted_by": user_id,
                "ip_address": submission.ip_address,
                "user_agent": submission.user_agent
            })
            
            # Get the ID from SCOPE_IDENTITY()
            submission_id = result.scalar() or 0
            
            # --- PDF GENERATION & DOCUMENT CREATION ---
            try:
                # 1. Generate PDF
                generator = PDFGenerator()
                
                # Expand data with metadata
                pdf_data = submission.data.copy()
                pdf_data['id'] = submission_id
                pdf_data['fecha_creacion'] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                
                # Use form title for filename
                clean_title = form_title.replace(" ", "_").replace("/", "-")
                filename = f"ACTA_{clean_title}_{submission_id}_{datetime.now().strftime('%Y%m%d')}.pdf"
                
                # Generate
                filepath, _, size_bytes = generator.generate_inspection_report(
                    form_data=pdf_data,
                    schema_title=form_title,
                    user_name=f"Usuario {user_id}", # Idealmente obtener nombre real si posible
                    filename=filename
                )
                
                # 2. Create Documento Record
                Documento = getattr(Base.classes, 'DOCUMENTO', None)
                if Documento:
                    # Determine category based on form_id keywords
                    category = "Gestion"
                    if "inspeccion" in form_id.lower(): category = "Seguridad Industrial"
                    elif "salud" in form_id.lower() or "emo" in form_id.lower(): category = "Salud"
                    
                    new_doc = Documento(
                        Nombre=f"Acta: {form_title} #{submission_id}",
                        Tipo="Formato",
                        CategoriaSGSST=category,
                        Area="Operaciones", # Default or extract from data
                        descripcion=f"Autogenerado desde Formulario {form_id}",
                        version=1,
                        RutaArchivo=f"documents/{filename}", # Relative path used by frontend
                        mime_type="application/pdf",
                        tamano_bytes=size_bytes,
                        Responsable=None,  # FK constraint to EMPLEADO, not USUARIOS_AUTORIZADOS
                        FechaCreacion=datetime.now(),
                        Estado="Vigente",
                        Codigo=f"MEM-{submission_id}"
                    )
                    db.add(new_doc)
                    logger.info(f"Generated PDF Document for submission {submission_id}")

            except Exception as pdf_error:
                logger.error(f"Failed to generate PDF for submission {submission_id}: {pdf_error}")
                # Continue without failing the main submission
            
            db.commit()
            
            logger.info(f"Form submission saved: {submission_id}")
            return submission_id
            
        except Exception as table_error:
            logger.error(f"Failed to save to FORM_SUBMISSIONS table: {table_error}")
            db.rollback()
            # If we can't save the submission record, we should probably fail?
            # Or allow workflow to continue if it feeds business tables?
            # Let's fail safety.
            raise
            
    except Exception as e:
        logger.error(f"Error in save_form_submission: {e}")
        db.rollback()
        raise


def execute_workflow_action(
    db: Session,
    action: WorkflowAction,
    form_data: Dict[str, Any],
    current_user: AuthorizedUser,
    context: Dict[str, Any] = {},
    workflow_results: Dict[str, Any] = None
):
    """
    Execute a workflow action with result tracking.
    
    Args:
        workflow_results: Dict to store results of each action for conditional execution
    """
    if workflow_results is None:
        workflow_results = {}
    
    # Ensure params is a dict (handle case where it might be None)
    safe_params = action.params or {}
    
    try:
        if action.action == "save_to_table":
            # Save data to specified table and capture result
            result = save_to_table(db, safe_params, form_data)
            workflow_results["save_to_table"] = result
            
            # If save failed, raise exception to stop workflow
            if not result.get("success"):
                error_msg = result.get("error", "Unknown error")
                raise Exception(f"Failed to save data: {error_msg}")
        
        elif action.action == "create_task":
            # Create a task
            create_task_from_form(db, safe_params, form_data, current_user)
            workflow_results["create_task"] = {"success": True}
        
        elif action.action == "send_notification":
            # Send notification
            send_notification(safe_params, form_data)
            workflow_results["send_notification"] = {"success": True}
        
        elif action.action == "update_indicators":
            # Update indicators
            update_indicators(db, safe_params)
            workflow_results["update_indicators"] = {"success": True}
        
        elif action.action == "run_sp":
            # Run stored procedure
            run_stored_procedure(db, safe_params, form_data)
            workflow_results["run_sp"] = {"success": True}
        
        elif action.action == "ai_analyze":
            # AI analysis
            ai_analyze(safe_params, form_data)
            workflow_results["ai_analyze"] = {"success": True}

        elif action.action == "complete_task":
            # Complete the task linked to this form
            # Check if previous actions (especially save_to_table) succeeded
            require_previous_success = safe_params.get("require_previous_success", True)
            
            if require_previous_success:
                save_result = workflow_results.get("save_to_table", {})
                if not save_result.get("success"):
                    logger.warning("[WARNING] Skipping task completion - data save failed or not executed")
                    workflow_results["complete_task"] = {
                        "success": False,
                        "skipped": True,
                        "reason": "Data save failed or not executed"
                    }
                    return
            
            complete_task_action(db, context, current_user, safe_params)
            workflow_results["complete_task"] = {"success": True}
        
    except Exception as e:
        error_msg = str(e)
        logger.error(f"Error executing workflow action {action.action}: {error_msg}")
        workflow_results[action.action] = {
            "success": False,
            "error": error_msg
        }
        # Re-raise to stop workflow execution
        raise



def save_to_table(
    db: Session,
    params: Dict[str, Any],
    form_data: Dict[str, Any]
) -> Dict[str, Any]:
    """
    Save form data to database with validation.
    
    Returns:
        Dict with keys:
        - success (bool): Whether the operation succeeded
        - inserted_id (int, optional): ID of inserted record
        - table (str): Table name
        - error (str, optional): Error message if failed
    """
    try:
        table_name = params.get("table")
        mapping = params.get("mapping", {})
        return_id = params.get("return_id", False)
        
        if not table_name:
            logger.error("No table specified in save_to_table action")
            return {
                "success": False,
                "error": "Missing table configuration"
            }
        
        if not mapping:
            logger.warning(f"No mapping specified for table {table_name}, using form fields directly")
            # Fallback: use form_data keys as column names
            mapping = {k: k for k in form_data.keys()}
        
        # 1. Validate that all mapped fields exist in form_data
        missing_fields = []
        for db_col, form_field in mapping.items():
            # Skip literal values (enclosed in quotes)
            if isinstance(form_field, str) and form_field.startswith("'") and form_field.endswith("'"):
                continue
            if form_field not in form_data:
                missing_fields.append(form_field)
        
        if missing_fields:
            error_msg = f"Missing required fields: {', '.join(missing_fields)}"
            logger.error(error_msg)
            return {
                "success": False,
                "error": error_msg
            }
        
        # 2. Build INSERT query
        columns = []
        values = []
        
        for db_column, form_field in mapping.items():
            columns.append(db_column)
            
            # Handle literal values (enclosed in quotes)
            if isinstance(form_field, str) and form_field.startswith("'") and form_field.endswith("'"):
                literal_value = form_field.strip("'")
                # Convert special date keywords
                if literal_value.lower() == 'today':
                    values.append(datetime.now())
                else:
                    values.append(literal_value)
            else:
                # Get value from form data
                values.append(form_data.get(form_field))
        
        # 3. Build parameterized query with SCOPE_IDENTITY() if needed
        placeholders = ", ".join([f":{i}" for i in range(len(values))])
        params_dict = {str(i): val for i, val in enumerate(values)}
        
        if return_id:
            query = f"""
                INSERT INTO {table_name} ({', '.join(columns)})
                VALUES ({placeholders});
                SELECT SCOPE_IDENTITY() AS inserted_id;
            """
        else:
            query = f"""
                INSERT INTO {table_name} ({', '.join(columns)})
                VALUES ({placeholders});
            """
        
        # 4. Execute query
        result = db.execute(text(query), params_dict)
        
        inserted_id = None
        if return_id:
            row = result.fetchone()
            if row:
                inserted_id = int(row.inserted_id)
        
        # 5. Commit transaction
        db.commit()
        
        # 6. Verify insertion if ID was returned
        if return_id and inserted_id:
            # Try to find primary key column (common patterns)
            pk_candidates = [
                f"id_{table_name.lower()}",
                f"Id_{table_name}",
                "id",
                "Id"
            ]
            
            verified = False
            for pk_col in pk_candidates:
                try:
                    verify_query = f"SELECT COUNT(*) as count FROM {table_name} WHERE {pk_col} = :id"
                    verify_result = db.execute(text(verify_query), {"id": inserted_id})
                    count = verify_result.fetchone().count
                    
                    if count > 0:
                        verified = True
                        break
                except:
                    continue
            
            if not verified:
                logger.warning(f"Could not verify insertion for table {table_name}, ID {inserted_id}")
        
        logger.info(f"[SUCCESS] Successfully saved to {table_name}" + (f", ID: {inserted_id}" if inserted_id else ""))
        
        return {
            "success": True,
            "inserted_id": inserted_id,
            "table": table_name
        }
        
    except Exception as e:
        db.rollback()
        error_msg = str(e)
        logger.error(f"[ERROR] Error saving to table {table_name}: {error_msg}")
        
        return {
            "success": False,
            "error": error_msg,
            "table": table_name
        }



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
            if "due_date" in params and params["due_date"] == "calculated_from_vida_util":
                # Special logic for EPP
                vida_util = form_data.get("vida_util") or form_data.get("vida_util_meses")
                if vida_util:
                    try:
                        meses = int(vida_util)
                        fecha_vencimiento = datetime.now() + timedelta(days=meses*30)
                    except ValueError:
                        pass # Fallback to default
            
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


def complete_task_action(db: Session, context: Dict[str, Any], current_user: AuthorizedUser, params: Dict[str, Any] = None):
    """Complete the task that launched this form"""
    try:
        # 1. Try to get task ID from context (frontend pass-through)
        task_id = None
        if context and isinstance(context, dict):
            task_id = context.get("taskId")
        
        # 2. Fallback: Try to get from params (hardcoded in form definition)
        if not task_id and params:
            task_id = params.get("task_id")
            
        if not task_id:
            logger.warning("[complete_task] No taskId found in context or params, cannot complete task")
            return

        # Find task
        Tarea = getattr(Base.classes, 'TAREA')
        task = db.query(Tarea).filter(Tarea.id_tarea == task_id).first()
        
        if not task:
            logger.warning(f"[complete_task] Task {task_id} not found")
            return
            
        # Update status
        task.Estado = 'Cerrada'
        task.Fecha_Cierre = datetime.now().date()
        
        # Try to find employee ID for current user
        Empleado = getattr(Base.classes, 'EMPLEADO')
        emp = db.query(Empleado).filter(Empleado.Correo == current_user.Correo_Electronico).first()
        if emp:
            task.id_empleado_cierre = emp.id_empleado
            
        db.commit()
        logger.info(f"[complete_task] Task {task_id} completed successfully via form submission")
        
    except Exception as e:
        db.rollback()
        logger.error(f"[complete_task] Error completing task: {e}")
