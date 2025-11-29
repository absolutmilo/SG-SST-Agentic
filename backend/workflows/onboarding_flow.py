"""
Employee Onboarding Workflow

Workflow for new employee onboarding in SG-SST system.
"""

from typing import Dict, Any
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from orchestrator.workflow_engine import Workflow, WorkflowStep


def create_onboarding_workflow(workflow_id: str, params: Dict[str, Any]) -> Workflow:
    """
    Create employee onboarding workflow.
    
    Workflow steps:
    1. Create employee profile
    2. Assign mandatory trainings
    3. Generate induction checklist
    4. Schedule medical exams
    5. Assign PPE
    6. Track completion
    
    Args:
        workflow_id: Unique workflow ID
        params: Workflow parameters (employee_name, position, etc.)
    
    Returns:
        Configured Workflow
    """
    
    employee_name = params.get("employee_name", "")
    position = params.get("position", "")
    department = params.get("department", "")
    
    steps = [
        WorkflowStep(
            step_id="create_profile",
            name="Crear Perfil de Empleado",
            params={
                "task": f"Crear perfil para {employee_name}",
                "employee_name": employee_name,
                "position": position,
                "department": department
            }
        ),
        WorkflowStep(
            step_id="assign_trainings",
            name="Asignar Capacitaciones Obligatorias",
            depends_on=["create_profile"],
            params={
                "task": "Asignar capacitaciones según puesto y riesgos",
                "trainings": [
                    "Inducción SST",
                    "Riesgos específicos del puesto",
                    "Plan de emergencias",
                    "Uso de EPP"
                ]
            }
        ),
        WorkflowStep(
            step_id="generate_checklist",
            name="Generar Checklist de Inducción",
            agent_name="assistant_agent",
            depends_on=["create_profile"],
            params={
                "task": f"Generar checklist de inducción para {position}",
                "include_items": [
                    "Entrega de EPP",
                    "Capacitaciones completadas",
                    "Examen médico",
                    "Firma de documentos"
                ]
            }
        ),
        WorkflowStep(
            step_id="schedule_medical",
            name="Programar Exámenes Médicos",
            depends_on=["create_profile"],
            params={
                "task": "Programar examen médico ocupacional de ingreso",
                "exam_type": "ingreso",
                "priority": "high"
            }
        ),
        WorkflowStep(
            step_id="assign_ppe",
            name="Asignar EPP",
            agent_name="assistant_agent",
            depends_on=["create_profile"],
            params={
                "task": f"Determinar y asignar EPP para {position}",
                "based_on": "risk_assessment"
            }
        ),
        WorkflowStep(
            step_id="send_welcome_email",
            name="Enviar Email de Bienvenida",
            agent_name="email_agent",
            depends_on=["create_profile"],
            params={
                "task": f"Enviar email de bienvenida a {employee_name}",
                "template": "onboarding_welcome",
                "include_checklist": True
            }
        ),
        WorkflowStep(
            step_id="track_completion",
            name="Seguimiento de Completitud",
            depends_on=["assign_trainings", "schedule_medical", "assign_ppe"],
            params={
                "task": "Crear dashboard de seguimiento de onboarding",
                "send_reminders": True
            }
        )
    ]
    
    workflow = Workflow(
        workflow_id=workflow_id,
        name="Incorporación de Empleado",
        description=f"Workflow de onboarding para {employee_name} - {position}",
        steps=steps,
        metadata={
            "employee_name": employee_name,
            "position": position,
            "department": department,
            "workflow_type": "onboarding"
        }
    )
    
    return workflow


async def execute_onboarding_workflow(
    employee_name: str,
    position: str,
    department: str
) -> Dict[str, Any]:
    """
    Execute employee onboarding workflow.
    
    Args:
        employee_name: Name of new employee
        position: Job position
        department: Department
    
    Returns:
        Workflow execution results
    """
    from orchestrator.workflow_engine import WorkflowEngine
    
    engine = WorkflowEngine()
    workflow_id = f"onboard_{employee_name.replace(' ', '_').lower()}"
    
    params = {
        "employee_name": employee_name,
        "position": position,
        "department": department
    }
    
    # Register the workflow template
    engine.register_template("employee_onboarding", create_onboarding_workflow)
    
    # Start workflow
    result = await engine.start_workflow(workflow_id, "employee_onboarding", params)
    
    return result
