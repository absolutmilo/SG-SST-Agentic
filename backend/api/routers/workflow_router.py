"""
Workflow API Router

FastAPI endpoints for workflow execution and management.
"""

from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, Field
from typing import Optional, Dict, Any, List
import logging
from datetime import datetime

# Import workflow engine and workflows
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from orchestrator.workflow_engine import WorkflowEngine, WorkflowStatus
from workflows.risk_workflow import create_risk_workflow
from workflows.document_workflow import create_document_workflow
from workflows.onboarding_flow import create_onboarding_workflow

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/workflow")

# Initialize workflow engine
workflow_engine = WorkflowEngine()

# Register workflow templates
workflow_engine.register_template("risk_assessment", create_risk_workflow)
workflow_engine.register_template("document_processing", create_document_workflow)
workflow_engine.register_template("employee_onboarding", create_onboarding_workflow)


# ============================================
# Request/Response Models
# ============================================

class WorkflowStartRequest(BaseModel):
    """Request to start a workflow"""
    template_name: str = Field(..., description="Name of the workflow template")
    params: Dict[str, Any] = Field(..., description="Parameters for the workflow")
    user_id: int = Field(..., description="ID of the user starting the workflow")


class WorkflowStartResponse(BaseModel):
    """Response from workflow start"""
    status: str
    workflow_id: str
    workflow_name: str
    total_steps: int
    message: Optional[str] = None


class WorkflowStatusResponse(BaseModel):
    """Workflow status response"""
    workflow_id: str
    name: str
    status: str
    progress: float
    completed_steps: int
    total_steps: int
    current_step: Optional[str] = None
    started_at: Optional[str] = None
    completed_at: Optional[str] = None


class WorkflowListResponse(BaseModel):
    """List of available workflow templates"""
    templates: List[Dict[str, Any]]
    total: int


# ============================================
# Endpoints
# ============================================

@router.post("/start", response_model=WorkflowStartResponse)
async def start_workflow(request: WorkflowStartRequest):
    """
    Start a new workflow execution.
    
    Available templates:
    - risk_assessment: Complete risk evaluation workflow
    - document_processing: Document ingestion and processing
    - employee_onboarding: New employee onboarding process
    """
    try:
        # Generate workflow ID
        workflow_id = f"{request.template_name}_{request.user_id}_{int(datetime.now().timestamp())}"
        
        # Start workflow
        result = await workflow_engine.start_workflow(
            workflow_id=workflow_id,
            template_name=request.template_name,
            params=request.params
        )
        
        if result["status"] == "error":
            raise HTTPException(
                status_code=400,
                detail=result.get("message", "Failed to start workflow")
            )
        
        workflow = result.get("workflow", {})
        
        return WorkflowStartResponse(
            status="started",
            workflow_id=workflow_id,
            workflow_name=workflow.get("name", request.template_name),
            total_steps=len(workflow.get("steps", [])),
            message="Workflow started successfully"
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error starting workflow: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error starting workflow: {str(e)}"
        )


@router.get("/status/{workflow_id}", response_model=WorkflowStatusResponse)
async def get_workflow_status(workflow_id: str):
    """Get the current status of a workflow"""
    try:
        status = workflow_engine.get_workflow_status(workflow_id)
        
        if status.get("status") == "error":
            raise HTTPException(
                status_code=404,
                detail="Workflow not found"
            )
        
        # Calculate progress
        steps = status.get("steps", [])
        completed = sum(1 for s in steps if s.get("status") == "completed")
        total = len(steps)
        progress = (completed / total * 100) if total > 0 else 0
        
        # Get current step
        current_step = None
        for step in steps:
            if step.get("status") == "running":
                current_step = step.get("name")
                break
        
        return WorkflowStatusResponse(
            workflow_id=workflow_id,
            name=status.get("name", "Unknown"),
            status=status.get("status", "unknown"),
            progress=progress,
            completed_steps=completed,
            total_steps=total,
            current_step=current_step,
            started_at=status.get("started_at"),
            completed_at=status.get("completed_at")
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting workflow status: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error getting workflow status: {str(e)}"
        )


@router.post("/pause/{workflow_id}")
async def pause_workflow(workflow_id: str):
    """Pause a running workflow"""
    try:
        result = await workflow_engine.pause_workflow(workflow_id)
        
        if result.get("status") == "error":
            raise HTTPException(
                status_code=404,
                detail=result.get("message", "Workflow not found")
            )
        
        return {
            "status": "paused",
            "workflow_id": workflow_id,
            "message": "Workflow paused successfully"
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error pausing workflow: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error pausing workflow: {str(e)}"
        )


@router.post("/cancel/{workflow_id}")
async def cancel_workflow(workflow_id: str):
    """Cancel a workflow"""
    try:
        result = await workflow_engine.cancel_workflow(workflow_id)
        
        if result.get("status") == "error":
            raise HTTPException(
                status_code=404,
                detail=result.get("message", "Workflow not found")
            )
        
        return {
            "status": "cancelled",
            "workflow_id": workflow_id,
            "message": "Workflow cancelled successfully"
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error cancelling workflow: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error cancelling workflow: {str(e)}"
        )


@router.get("/list", response_model=WorkflowListResponse)
async def list_workflow_templates():
    """List all available workflow templates"""
    templates = [
        {
            "name": "risk_assessment",
            "description": "Complete risk evaluation workflow",
            "steps": [
                "Identify hazards",
                "Evaluate risks",
                "Determine controls",
                "Generate risk matrix",
                "Create corrective tasks",
                "Notify responsible parties"
            ],
            "required_params": ["area", "process"]
        },
        {
            "name": "document_processing",
            "description": "Document ingestion and processing workflow",
            "steps": [
                "Extract content",
                "Classify document",
                "Index in vectorstore",
                "Verify compliance",
                "Generate summary",
                "Catalog document"
            ],
            "required_params": ["file_path", "doc_type"]
        },
        {
            "name": "employee_onboarding",
            "description": "New employee onboarding process",
            "steps": [
                "Create profile",
                "Assign trainings",
                "Generate checklist",
                "Schedule medical exams",
                "Assign PPE",
                "Send welcome email",
                "Track completion"
            ],
            "required_params": ["employee_name", "position", "department"]
        }
    ]
    
    return WorkflowListResponse(
        templates=templates,
        total=len(templates)
    )


@router.get("/active")
async def list_active_workflows(user_id: Optional[int] = None):
    """List all active workflows, optionally filtered by user"""
    try:
        workflows = workflow_engine.list_workflows()
        
        # Filter by user if specified
        if user_id:
            workflows = [
                wf for wf in workflows
                if wf.get("metadata", {}).get("user_id") == user_id
            ]
        
        # Filter only active workflows
        active_workflows = [
            wf for wf in workflows
            if wf.get("status") in ["pending", "running", "paused"]
        ]
        
        return {
            "workflows": active_workflows,
            "total": len(active_workflows)
        }
        
    except Exception as e:
        logger.error(f"Error listing workflows: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error listing workflows: {str(e)}"
        )
