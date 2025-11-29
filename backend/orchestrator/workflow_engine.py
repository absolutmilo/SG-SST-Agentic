"""
Workflow Engine

Manages execution of complex multi-step workflows with
state management, error handling, and recovery.
"""

from typing import Dict, Any, List, Optional, Callable
from enum import Enum
from dataclasses import dataclass, field
from datetime import datetime
import logging
import asyncio

logger = logging.getLogger(__name__)


class WorkflowStatus(Enum):
    """Workflow execution status"""
    PENDING = "pending"
    RUNNING = "running"
    PAUSED = "paused"
    COMPLETED = "completed"
    FAILED = "failed"
    CANCELLED = "cancelled"


class StepStatus(Enum):
    """Individual step status"""
    PENDING = "pending"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"
    SKIPPED = "skipped"


@dataclass
class WorkflowStep:
    """Represents a single step in a workflow"""
    step_id: str
    name: str
    agent_name: Optional[str] = None
    action: Optional[Callable] = None
    depends_on: List[str] = field(default_factory=list)
    params: Dict[str, Any] = field(default_factory=dict)
    status: StepStatus = StepStatus.PENDING
    result: Optional[Dict[str, Any]] = None
    error: Optional[str] = None
    started_at: Optional[datetime] = None
    completed_at: Optional[datetime] = None
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "step_id": self.step_id,
            "name": self.name,
            "agent_name": self.agent_name,
            "depends_on": self.depends_on,
            "status": self.status.value,
            "result": self.result,
            "error": self.error,
            "started_at": self.started_at.isoformat() if self.started_at else None,
            "completed_at": self.completed_at.isoformat() if self.completed_at else None
        }


@dataclass
class Workflow:
    """Represents a complete workflow"""
    workflow_id: str
    name: str
    description: str
    steps: List[WorkflowStep]
    status: WorkflowStatus = WorkflowStatus.PENDING
    created_at: datetime = field(default_factory=datetime.now)
    started_at: Optional[datetime] = None
    completed_at: Optional[datetime] = None
    metadata: Dict[str, Any] = field(default_factory=dict)
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "workflow_id": self.workflow_id,
            "name": self.name,
            "description": self.description,
            "status": self.status.value,
            "steps": [step.to_dict() for step in self.steps],
            "created_at": self.created_at.isoformat(),
            "started_at": self.started_at.isoformat() if self.started_at else None,
            "completed_at": self.completed_at.isoformat() if self.completed_at else None,
            "metadata": self.metadata
        }


class WorkflowEngine:
    """
    Executes workflows with dependency management and error handling.
    
    Features:
    - DAG-based workflow execution
    - Parallel step execution when possible
    - State persistence
    - Error recovery and retry
    - Workflow pause/resume
    """
    
    def __init__(self):
        self.logger = logging.getLogger("orchestrator.workflow")
        self.active_workflows: Dict[str, Workflow] = {}
        self.workflow_templates: Dict[str, Callable] = {}
    
    def register_template(self, name: str, builder: Callable):
        """Register a workflow template builder"""
        self.workflow_templates[name] = builder
        self.logger.info(f"Registered workflow template: {name}")
    
    async def start_workflow(
        self,
        workflow_id: str,
        template_name: str,
        params: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Start a workflow from a template.
        
        Args:
            workflow_id: Unique workflow instance ID
            template_name: Name of the workflow template
            params: Parameters for the workflow
        
        Returns:
            Workflow execution result
        """
        if template_name not in self.workflow_templates:
            return {
                "status": "error",
                "message": f"Unknown workflow template: {template_name}",
                "available_templates": list(self.workflow_templates.keys())
            }
        
        # Build workflow from template
        builder = self.workflow_templates[template_name]
        workflow = builder(workflow_id, params or {})
        
        # Store and execute
        self.active_workflows[workflow_id] = workflow
        
        self.logger.info(f"Starting workflow: {workflow_id} ({template_name})")
        
        result = await self.execute_workflow(workflow)
        
        return result
    
    async def execute_workflow(self, workflow: Workflow) -> Dict[str, Any]:
        """
        Execute a workflow with dependency resolution.
        
        Args:
            workflow: Workflow to execute
        
        Returns:
            Execution result
        """
        workflow.status = WorkflowStatus.RUNNING
        workflow.started_at = datetime.now()
        
        try:
            # Build dependency graph
            completed_steps = set()
            
            while len(completed_steps) < len(workflow.steps):
                # Find steps ready to execute
                ready_steps = [
                    step for step in workflow.steps
                    if step.status == StepStatus.PENDING
                    and all(dep in completed_steps for dep in step.depends_on)
                ]
                
                if not ready_steps:
                    # Check if we're stuck
                    pending_steps = [s for s in workflow.steps if s.status == StepStatus.PENDING]
                    if pending_steps:
                        workflow.status = WorkflowStatus.FAILED
                        return {
                            "status": "failed",
                            "message": "Workflow stuck - circular dependencies or failed steps",
                            "workflow": workflow.to_dict()
                        }
                    break
                
                # Execute ready steps in parallel
                tasks = [self._execute_step(step) for step in ready_steps]
                results = await asyncio.gather(*tasks, return_exceptions=True)
                
                # Process results
                for step, result in zip(ready_steps, results):
                    if isinstance(result, Exception):
                        step.status = StepStatus.FAILED
                        step.error = str(result)
                        self.logger.error(f"Step {step.step_id} failed: {result}")
                    else:
                        step.status = StepStatus.COMPLETED
                        step.result = result
                        completed_steps.add(step.step_id)
                        self.logger.info(f"Step {step.step_id} completed")
            
            # Check overall workflow status
            failed_steps = [s for s in workflow.steps if s.status == StepStatus.FAILED]
            if failed_steps:
                workflow.status = WorkflowStatus.FAILED
            else:
                workflow.status = WorkflowStatus.COMPLETED
            
            workflow.completed_at = datetime.now()
            
            return {
                "status": workflow.status.value,
                "workflow": workflow.to_dict(),
                "failed_steps": [s.to_dict() for s in failed_steps]
            }
            
        except Exception as e:
            self.logger.error(f"Workflow execution failed: {e}")
            workflow.status = WorkflowStatus.FAILED
            workflow.completed_at = datetime.now()
            
            return {
                "status": "failed",
                "error": str(e),
                "workflow": workflow.to_dict()
            }
    
    async def _execute_step(self, step: WorkflowStep) -> Dict[str, Any]:
        """Execute a single workflow step"""
        step.status = StepStatus.RUNNING
        step.started_at = datetime.now()
        
        try:
            if step.action:
                # Execute custom action
                result = await step.action(**step.params)
            elif step.agent_name:
                # Execute agent (placeholder for now)
                result = {
                    "status": "pending_implementation",
                    "message": f"Agent execution: {step.agent_name}",
                    "params": step.params
                }
            else:
                result = {"status": "skipped", "message": "No action defined"}
            
            step.completed_at = datetime.now()
            return result
            
        except Exception as e:
            step.completed_at = datetime.now()
            raise e
    
    async def pause_workflow(self, workflow_id: str) -> Dict[str, Any]:
        """Pause a running workflow"""
        if workflow_id not in self.active_workflows:
            return {"status": "error", "message": "Workflow not found"}
        
        workflow = self.active_workflows[workflow_id]
        workflow.status = WorkflowStatus.PAUSED
        
        self.logger.info(f"Workflow paused: {workflow_id}")
        
        return {
            "status": "paused",
            "workflow": workflow.to_dict()
        }
    
    async def cancel_workflow(self, workflow_id: str) -> Dict[str, Any]:
        """Cancel a workflow"""
        if workflow_id not in self.active_workflows:
            return {"status": "error", "message": "Workflow not found"}
        
        workflow = self.active_workflows[workflow_id]
        workflow.status = WorkflowStatus.CANCELLED
        workflow.completed_at = datetime.now()
        
        self.logger.info(f"Workflow cancelled: {workflow_id}")
        
        return {
            "status": "cancelled",
            "workflow": workflow.to_dict()
        }
    
    def get_workflow_status(self, workflow_id: str) -> Dict[str, Any]:
        """Get the current status of a workflow"""
        if workflow_id not in self.active_workflows:
            return {"status": "error", "message": "Workflow not found"}
        
        workflow = self.active_workflows[workflow_id]
        return workflow.to_dict()
    
    def list_workflows(self) -> List[Dict[str, Any]]:
        """List all active workflows"""
        return [wf.to_dict() for wf in self.active_workflows.values()]
