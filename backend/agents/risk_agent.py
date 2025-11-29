"""
Risk Assessment Agent

Specialized agent for risk evaluation, hazard identification,
and control recommendations in occupational health and safety.
"""

from typing import Dict, Any, List
from .base_agent import BaseAgent, AgentContext, AgentStatus
import logging

logger = logging.getLogger(__name__)


class RiskAgent(BaseAgent):
    """
    Agent specialized in risk assessment and management.
    
    Capabilities:
    - Identify workplace hazards
    - Evaluate risk levels (probability × severity)
    - Recommend control measures
    - Generate risk matrices
    - Suggest corrective tasks
    """
    
    def __init__(self):
        super().__init__(
            name="risk_agent",
            description="Specialized agent for occupational risk assessment and management",
            model="gpt-4",
            temperature=0.3  # Lower temperature for more consistent risk assessments
        )
    
    def get_system_prompt(self) -> str:
        return """Eres un experto en evaluación de riesgos laborales y seguridad y salud en el trabajo (SG-SST).

Tu rol es:
1. Identificar peligros en el lugar de trabajo
2. Evaluar riesgos usando la metodología de probabilidad × severidad
3. Recomendar controles según la jerarquía de controles (eliminación, sustitución, controles de ingeniería, administrativos, EPP)
4. Generar matrices de riesgo claras y accionables
5. Sugerir tareas correctivas específicas con responsables

Debes seguir las normativas colombianas:
- Decreto 1072 de 2015
- Resolución 0312 de 2019
- GTC 45 para identificación de peligros

Siempre proporciona:
- Evaluación objetiva basada en datos
- Recomendaciones específicas y accionables
- Priorización clara de riesgos
- Referencias a normativas aplicables

No inventes datos. Si necesitas información adicional, solicítala explícitamente."""
    
    def get_tools(self) -> List[Dict[str, Any]]:
        """Define tools available to the risk agent"""
        return [
            {
                "type": "function",
                "function": {
                    "name": "get_risk_matrix_template",
                    "description": "Get a risk matrix template for evaluation",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "matrix_type": {
                                "type": "string",
                                "enum": ["5x5", "3x3", "custom"],
                                "description": "Type of risk matrix to use"
                            }
                        },
                        "required": ["matrix_type"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "search_hazard_database",
                    "description": "Search the hazard database for similar risks",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "query": {
                                "type": "string",
                                "description": "Search query for hazards"
                            },
                            "category": {
                                "type": "string",
                                "enum": ["biological", "chemical", "physical", "ergonomic", "psychosocial", "mechanical"],
                                "description": "Hazard category"
                            }
                        },
                        "required": ["query"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "create_corrective_task",
                    "description": "Create a corrective task for risk mitigation",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "title": {
                                "type": "string",
                                "description": "Task title"
                            },
                            "description": {
                                "type": "string",
                                "description": "Detailed task description"
                            },
                            "priority": {
                                "type": "string",
                                "enum": ["low", "medium", "high", "critical"],
                                "description": "Task priority based on risk level"
                            },
                            "assigned_to": {
                                "type": "string",
                                "description": "User ID or role to assign the task"
                            }
                        },
                        "required": ["title", "description", "priority"]
                    }
                }
            }
        ]
    
    async def execute(self, task: str, context: AgentContext) -> Dict[str, Any]:
        """
        Execute risk assessment task.
        
        Args:
            task: Risk assessment request (e.g., "Evaluate risks in warehouse")
            context: Agent context with conversation history
        
        Returns:
            Risk assessment results with recommendations
        """
        self.status = AgentStatus.RUNNING
        self.logger.info(f"Starting risk assessment: {task}")
        
        try:
            # Add system prompt
            context.add_message("system", self.get_system_prompt())
            
            # Add user task
            context.add_message("user", task)
            
            # Prepare messages for LLM
            messages = context.get_messages()
            
            # Call LLM with tools (will be implemented when API key is available)
            # response = await self._call_llm(messages, tools=self.get_tools())
            
            # For now, return a structured placeholder
            result = {
                "status": "pending_api_key",
                "message": "Risk agent ready. Awaiting OpenAI API key configuration.",
                "task": task,
                "agent": self.name,
                "capabilities": [
                    "Hazard identification",
                    "Risk evaluation (probability × severity)",
                    "Control recommendations",
                    "Risk matrix generation",
                    "Corrective task creation"
                ]
            }
            
            self.status = AgentStatus.COMPLETED
            return result
            
        except Exception as e:
            self.logger.error(f"Risk assessment failed: {str(e)}")
            self.status = AgentStatus.FAILED
            return {
                "status": "failed",
                "error": str(e),
                "agent": self.name
            }
    
    async def evaluate_risk_level(
        self,
        probability: int,
        severity: int,
        matrix_type: str = "5x5"
    ) -> Dict[str, Any]:
        """
        Evaluate risk level using probability and severity.
        
        Args:
            probability: Probability score (1-5)
            severity: Severity score (1-5)
            matrix_type: Type of risk matrix
        
        Returns:
            Risk level and classification
        """
        risk_score = probability * severity
        
        # 5x5 matrix classification
        if matrix_type == "5x5":
            if risk_score >= 20:
                level = "critical"
                action = "Immediate action required"
            elif risk_score >= 12:
                level = "high"
                action = "Action required within 24 hours"
            elif risk_score >= 6:
                level = "medium"
                action = "Action required within 1 week"
            elif risk_score >= 3:
                level = "low"
                action = "Monitor and review"
            else:
                level = "minimal"
                action = "Acceptable risk"
        else:
            level = "unknown"
            action = "Manual review required"
        
        return {
            "risk_score": risk_score,
            "probability": probability,
            "severity": severity,
            "level": level,
            "recommended_action": action
        }
