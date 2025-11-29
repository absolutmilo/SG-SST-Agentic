"""
Risk Assessment Workflow

Complete workflow for risk evaluation process.
"""

from typing import Dict, Any
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from orchestrator.workflow_engine import Workflow, WorkflowStep, StepStatus


def create_risk_workflow(workflow_id: str, params: Dict[str, Any]) -> Workflow:
    """
    Create a risk assessment workflow.
    
    Workflow steps:
    1. Hazard identification
    2. Risk evaluation (probability × severity)
    3. Control determination
    4. Risk matrix generation
    5. Task creation for corrective actions
    6. Notification to responsible parties
    
    Args:
        workflow_id: Unique workflow ID
        params: Workflow parameters (area, process, etc.)
    
    Returns:
        Configured Workflow
    """
    
    area = params.get("area", "Unknown")
    process = params.get("process", "Unknown")
    
    steps = [
        WorkflowStep(
            step_id="identify_hazards",
            name="Identificar Peligros",
            agent_name="risk_agent",
            params={
                "task": f"Identificar peligros en {area} - {process}",
                "area": area,
                "process": process
            }
        ),
        WorkflowStep(
            step_id="evaluate_risks",
            name="Evaluar Riesgos",
            agent_name="risk_agent",
            depends_on=["identify_hazards"],
            params={
                "task": "Evaluar nivel de riesgo para cada peligro identificado",
                "method": "5x5_matrix"
            }
        ),
        WorkflowStep(
            step_id="determine_controls",
            name="Determinar Controles",
            agent_name="risk_agent",
            depends_on=["evaluate_risks"],
            params={
                "task": "Recomendar controles según jerarquía de controles",
                "hierarchy": ["elimination", "substitution", "engineering", "administrative", "ppe"]
            }
        ),
        WorkflowStep(
            step_id="generate_matrix",
            name="Generar Matriz de Riesgos",
            agent_name="risk_agent",
            depends_on=["determine_controls"],
            params={
                "task": "Generar matriz de riesgos completa",
                "format": "table"
            }
        ),
        WorkflowStep(
            step_id="create_tasks",
            name="Crear Tareas Correctivas",
            agent_name="assistant_agent",
            depends_on=["generate_matrix"],
            params={
                "task": "Crear tareas para implementar controles recomendados",
                "priority_mapping": {
                    "critical": "high",
                    "high": "high",
                    "medium": "medium",
                    "low": "low"
                }
            }
        ),
        WorkflowStep(
            step_id="notify_responsible",
            name="Notificar Responsables",
            agent_name="email_agent",
            depends_on=["create_tasks"],
            params={
                "task": "Enviar notificaciones a responsables de tareas",
                "template": "task_assignment"
            }
        )
    ]
    
    workflow = Workflow(
        workflow_id=workflow_id,
        name="Evaluación de Riesgos",
        description=f"Workflow completo de evaluación de riesgos para {area}",
        steps=steps,
        metadata={
            "area": area,
            "process": process,
            "workflow_type": "risk_assessment"
        }
    )
    
    return workflow


async def execute_risk_workflow(area: str, process: str) -> Dict[str, Any]:
    """
    Execute a complete risk assessment workflow.
    
    Args:
        area: Area or department
        process: Process being evaluated
    
    Returns:
        Workflow execution results
    """
    from orchestrator.workflow_engine import WorkflowEngine
    
    engine = WorkflowEngine()
    workflow_id = f"risk_{area}_{process}".replace(" ", "_").lower()
    
    params = {
        "area": area,
        "process": process
    }
    
    # Register the workflow template
    engine.register_template("risk_assessment", create_risk_workflow)
    
    # Start workflow
    result = await engine.start_workflow(workflow_id, "risk_assessment", params)
    
    return result
