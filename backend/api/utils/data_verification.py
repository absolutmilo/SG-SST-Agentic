"""
Data Verification Utilities for Form Submissions
Ensures data integrity and provides audit trail
"""

from sqlalchemy import text
from sqlalchemy.orm import Session
from typing import Dict, Any, List
import logging

logger = logging.getLogger(__name__)


def verify_data_insertion(
    db: Session, 
    workflow_results: Dict[str, Any],
    form_id: str
) -> Dict[str, Any]:
    """
    Verify that data was successfully inserted into target tables
    Returns verification report with status and details
    """
    verification = {
        "success": True,
        "tables_verified": [],
        "errors": [],
        "form_id": form_id
    }
    
    # Check save_to_table results
    if "save_to_table" in workflow_results:
        save_result = workflow_results["save_to_table"]
        
        if save_result.get("success"):
            table_name = save_result.get("table")
            inserted_id = save_result.get("inserted_id")
            
            if table_name and inserted_id:
                # Verify record exists
                try:
                    # Determine primary key column name (common patterns)
                    pk_column = f"id_{table_name.lower()}"
                    
                    verify_query = text(f"""
                        SELECT COUNT(*) FROM {table_name} 
                        WHERE {pk_column} = :id
                    """)
                    count = db.execute(verify_query, {"id": inserted_id}).scalar()
                    
                    if count > 0:
                        verification["tables_verified"].append({
                            "table": table_name,
                            "id": inserted_id,
                            "pk_column": pk_column,
                            "status": "verified"
                        })
                        logger.info(f"Verified insertion: {table_name} ID {inserted_id}")
                    else:
                        verification["success"] = False
                        verification["errors"].append({
                            "table": table_name,
                            "error": "Record not found after insertion",
                            "expected_id": inserted_id
                        })
                        logger.error(f"Verification failed: {table_name} ID {inserted_id} not found")
                        
                except Exception as e:
                    verification["success"] = False
                    verification["errors"].append({
                        "table": table_name,
                        "error": f"Verification query failed: {str(e)}"
                    })
                    logger.error(f"Verification error for {table_name}: {str(e)}")
    
    return verification


def save_verification_audit(
    db: Session,
    submission_id: int,
    verification_results: Dict[str, Any],
    user_id: int
) -> None:
    """
    Save verification results to audit table
    Creates audit trail for compliance
    """
    try:
        for table_info in verification_results.get("tables_verified", []):
            audit_sql = text("""
                INSERT INTO FORM_SUBMISSION_AUDIT (
                    id_submission,
                    action,
                    field_changed,
                    new_value,
                    changed_by,
                    changed_at
                ) VALUES (
                    :submission_id,
                    'data_verification',
                    'verification_status',
                    :details,
                    :user_id,
                    GETDATE()
                )
            """)
            
            details = f"Verified: {table_info['table']} ID {table_info['id']}"
            db.execute(audit_sql, {
                "submission_id": submission_id,
                "details": details,
                "user_id": user_id
            })
        
        # Log errors if any
        for error in verification_results.get("errors", []):
            audit_sql = text("""
                INSERT INTO FORM_SUBMISSION_AUDIT (
                    id_submission,
                    action,
                    field_changed,
                    new_value,
                    changed_by,
                    changed_at
                ) VALUES (
                    :submission_id,
                    'verification_error',
                    'error_details',
                    :details,
                    :user_id,
                    GETDATE()
                )
            """)
            
            details = f"Error: {error.get('table', 'unknown')} - {error.get('error', 'unknown error')}"
            db.execute(audit_sql, {
                "submission_id": submission_id,
                "details": details,
                "user_id": user_id
            })
        
        db.commit()
        
    except Exception as e:
        logger.error(f"Failed to save verification audit: {str(e)}")
        # Don't raise - audit failure shouldn't block submission


def update_submission_status(
    db: Session,
    submission_id: int,
    status: str,
    error_message: str = None
) -> None:
    """
    Update submission status in FORM_SUBMISSIONS table
    """
    try:
        update_sql = text("""
            UPDATE FORM_SUBMISSIONS
            SET status = :status,
                error_message = :error_msg,
                updated_at = GETDATE()
            WHERE id_submission = :submission_id
        """)
        
        db.execute(update_sql, {
            "submission_id": submission_id,
            "status": status,
            "error_msg": error_message
        })
        db.commit()
        
    except Exception as e:
        logger.error(f"Failed to update submission status: {str(e)}")
