"""
Assistant Agent

General-purpose assistant agent for user queries,
navigation help, and delegation to specialized agents.
"""

from typing import Dict, Any, List
from .base_agent import BaseAgent, AgentContext, AgentStatus
from agents.tools.assistant_tools import AssistantTools
from agents.tools.query_tools import QueryTools
import logging

logger = logging.getLogger(__name__)


class AssistantAgent(BaseAgent):
    """
    General-purpose assistant agent.
    
    Capabilities:
    - Answer general queries about SG-SST
    - Provide system navigation help
    - Offer contextual assistance
    - Delegate to specialized agents
    - Explain processes and procedures
    """
    
    def __init__(self):
        super().__init__(
            name="assistant_agent",
            description="General-purpose assistant for SG-SST system",
            model="gpt-4",
            temperature=0.7
        )
        self.tools = AssistantTools()
        self.query_tools = QueryTools()
        self.available_agents = ["risk_agent", "document_agent", "email_agent"]
    
    def get_system_prompt(self) -> str:
        return """Eres un asistente experto en sistemas de gestión de seguridad y salud en el trabajo (SG-SST) en Colombia.

Tu rol es:
1. Responder preguntas generales sobre SG-SST
2. Ayudar a los usuarios a navegar el sistema
3. Explicar procesos y procedimientos
4. Proporcionar ayuda contextual
5. Delegar a agentes especializados cuando sea necesario

Agentes especializados disponibles:
- **Risk Agent**: Para evaluación de riesgos, identificación de peligros, matrices de riesgo
- **Document Agent**: Para procesamiento de documentos, extracción de información, verificación de cumplimiento
- **Email Agent**: Para generación de correos, notificaciones, comunicaciones

Conocimiento base:
- Decreto 1072 de 2015 (Sistema de Gestión de SST)
- Resolución 0312 de 2019 (Estándares mínimos)
- GTC 45 (Guía para identificación de peligros)
- Normativa colombiana de SST

Debes:
- Ser claro y conciso en tus respuestas
- Proporcionar ejemplos cuando sea útil
- Sugerir el agente especializado apropiado si la consulta es compleja
- Ofrecer opciones y guiar al usuario
- Ser proactivo en ofrecer ayuda adicional
- Usar lenguaje profesional pero accesible

Cuando no sepas algo:
- Admítelo honestamente
- Sugiere dónde buscar la información
- Ofrece alternativas

Estructura tus respuestas:
1. Respuesta directa a la pregunta
2. Contexto o explicación adicional (si es necesario)
3. Sugerencias de próximos pasos o acciones
4. Oferta de ayuda adicional"""
    
    def get_tools(self) -> List[Dict[str, Any]]:
        """Define tools available to the assistant agent"""
        return [
            {
                "type": "function",
                "function": {
                    "name": "delegate_to_agent",
                    "description": "Delegate task to a specialized agent",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "agent_name": {
                                "type": "string",
                                "enum": ["risk_agent", "document_agent", "email_agent"],
                                "description": "Name of the specialized agent"
                            },
                            "task": {
                                "type": "string",
                                "description": "Task to delegate"
                            },
                            "context": {
                                "type": "object",
                                "description": "Additional context for the task"
                            }
                        },
                        "required": ["agent_name", "task"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "search_knowledge_base",
                    "description": "Search the SG-SST knowledge base",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "query": {
                                "type": "string",
                                "description": "Search query"
                            },
                            "category": {
                                "type": "string",
                                "enum": ["regulations", "procedures", "forms", "guides"],
                                "description": "Category to search in"
                            }
                        },
                        "required": ["query"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "get_system_status",
                    "description": "Get current system status and statistics",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "include_metrics": {
                                "type": "boolean",
                                "description": "Include performance metrics",
                                "default": False
                            }
                        }
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "get_user_tasks",
                    "description": "Get tasks assigned to current user",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "status": {
                                "type": "string",
                                "enum": ["pending", "in_progress", "completed", "all"],
                                "description": "Filter by task status"
                            },
                            "priority": {
                                "type": "string",
                                "enum": ["low", "medium", "high", "critical"],
                                "description": "Filter by priority"
                            }
                        }
                    }
                }
            }
        ]
    
    async def execute(self, task: str, context: AgentContext) -> Dict[str, Any]:
        """
        Execute assistant task.
        
        Args:
            task: User query or request
            context: Agent context with conversation history
        
        Returns:
            Assistant response
        """
        self.status = AgentStatus.RUNNING
        self.logger.info(f"Assistant processing: {task}")
        
        try:
            # Add system prompt
            context.add_message("system", self.get_system_prompt())
            
            # Add user task
            context.add_message("user", task)
            
            # Prepare messages for LLM
            messages = context.get_messages()
            
            # Call LLM with tools (will be implemented when API key is available)
            # response = await self._call_llm(messages, tools=self.get_tools())
            
            # 3. Check for specific reporting requests
            if "reporte ejecutivo" in task.lower():
                report = await self.tools.get_executive_report()
                return {"response": "Aquí está el reporte ejecutivo generado.", "data": report, "type": "report"}
                
            # 4. Try to answer using Natural Language to SQL (New Capability)
            # Heuristic: If the question looks like a data query
            if any(keyword in task.lower() for keyword in ["cuantos", "cuántos", "lista", "buscar", "dame", "muestrame", "muéstrame", "quien", "quién", "cual", "cuál"]):
                self.logger.info(f"Attempting to answer via Text-to-SQL: {task}")
                query_result = await self.query_tools.query_database(task)
                
                if query_result["success"]:
                    data = query_result["data"]
                    count = query_result["count"]
                    sql = query_result["sql"]
                    
                    if count == 0:
                        return {
                            "response": f"Realicé la consulta pero no encontré resultados. (SQL: `{sql}`)",
                            "data": [],
                            "type": "text"
                        }
                    
                    # Format a simple text response based on data
                    return {
                        "response": f"Encontré {count} registros que coinciden con tu consulta.",
                        "data": data,
                        "sql_debug": sql, # For transparency
                        "type": "data_table" # Frontend can render this as a table
                    }
                elif "Security Alert" in query_result.get("error", ""):
                     return {
                        "response": "Lo siento, no puedo ejecutar esa consulta por razones de seguridad (intento de modificación de datos detectado).",
                        "error": query_result["error"],
                        "type": "error"
                    }

            # 5. Default to LLM chat (mock for now, would use RAG here)
            return {
                "response": f"Entendido, puedo ayudarte con '{task}'. ¿Deseas que busque información específica o inicie un proceso?",
                "options": ["Buscar documentos", "Iniciar inspección", "Ver indicadores"]
            }
            
        except Exception as e:
            self.logger.error(f"Assistant task failed: {str(e)}")
            self.status = AgentStatus.FAILED
            return {
                "status": "failed",
                "error": str(e),
                "agent": self.name
            }
    
    def should_delegate(self, task: str) -> Dict[str, Any]:
        """
        Determine if task should be delegated to a specialized agent.
        
        Args:
            task: User task/query
        
        Returns:
            Delegation recommendation
        """
        # Simple keyword-based routing (will be enhanced with LLM)
        task_lower = task.lower()
        
        if any(word in task_lower for word in ["riesgo", "peligro", "matriz", "evaluación"]):
            return {
                "should_delegate": True,
                "agent": "risk_agent",
                "reason": "Task involves risk assessment"
            }
        elif any(word in task_lower for word in ["documento", "pdf", "archivo", "compliance"]):
            return {
                "should_delegate": True,
                "agent": "document_agent",
                "reason": "Task involves document processing"
            }
        elif any(word in task_lower for word in ["correo", "email", "notificación", "enviar"]):
            return {
                "should_delegate": True,
                "agent": "email_agent",
                "reason": "Task involves email communication"
            }
        else:
            return {
                "should_delegate": False,
                "reason": "General query - assistant can handle"
            }
