"""
Email Communication Agent

Specialized agent for generating and managing
email communications in the SG-SST system.
"""

from typing import Dict, Any, List
from .base_agent import BaseAgent, AgentContext, AgentStatus
from agents.tools.email_tools import EmailTools
from agents.tools.query_tools import QueryTools
import logging

logger = logging.getLogger(__name__)


class EmailAgent(BaseAgent):
    """
    Agent specialized in email communication.
    
    Capabilities:
    - Generate contextual emails
    - Send automated notifications
    - Create task reminders
    - Generate compliance alerts
    - Format professional communications
    """
    
    def __init__(self):
        super().__init__(
            name="email_agent",
            description="Specialized agent for email communication and notifications",
            model="gpt-4",
            temperature=0.6  # Slightly higher for more natural language
        )
        self.tools = EmailTools()
        self.query_tools = QueryTools()
    
    def get_system_prompt(self) -> str:
        return """Eres un experto en comunicación profesional para sistemas de gestión de seguridad y salud en el trabajo (SG-SST).

Tu rol es:
1. Generar correos electrónicos claros, profesionales y contextuales
2. Crear notificaciones automáticas para tareas y vencimientos
3. Redactar alertas de cumplimiento y recordatorios
4. Formatear invitaciones a capacitaciones y eventos
5. Generar reportes periódicos por correo

Tipos de correos que generas:
- Notificaciones de tareas asignadas
- Recordatorios de vencimientos
- Alertas de incumplimiento
- Invitaciones a capacitaciones
- Reportes de indicadores
- Comunicados de accidentes/incidentes
- Solicitudes de información

Debes:
- Usar tono profesional pero cercano
- Ser claro y conciso
- Incluir toda la información relevante
- Usar formato HTML cuando sea apropiado
- Incluir llamados a la acción claros
- Personalizar con el nombre del destinatario
- Incluir referencias y enlaces cuando sea necesario

Estructura recomendada:
1. Saludo personalizado
2. Contexto/motivo del correo
3. Información principal
4. Acción requerida (si aplica)
5. Cierre profesional

No uses lenguaje técnico excesivo. Sé directo y accionable."""
    
    def get_tools(self) -> List[Dict[str, Any]]:
        """Define tools available to the email agent"""
        return [
            {
                "type": "function",
                "function": {
                    "name": "send_email",
                    "description": "Send an email to one or more recipients",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "to": {
                                "type": "array",
                                "items": {"type": "string"},
                                "description": "List of recipient email addresses"
                            },
                            "subject": {
                                "type": "string",
                                "description": "Email subject line"
                            },
                            "body": {
                                "type": "string",
                                "description": "Email body content (HTML or plain text)"
                            },
                            "cc": {
                                "type": "array",
                                "items": {"type": "string"},
                                "description": "CC recipients"
                            },
                            "attachments": {
                                "type": "array",
                                "items": {"type": "string"},
                                "description": "File paths of attachments"
                            }
                        },
                        "required": ["to", "subject", "body"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "get_email_template",
                    "description": "Get a predefined email template",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "template_type": {
                                "type": "string",
                                "enum": [
                                    "task_assignment",
                                    "deadline_reminder",
                                    "compliance_alert",
                                    "training_invitation",
                                    "incident_report",
                                    "periodic_report"
                                ],
                                "description": "Type of email template"
                            },
                            "variables": {
                                "type": "object",
                                "description": "Variables to fill in the template"
                            }
                        },
                        "required": ["template_type"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "schedule_email",
                    "description": "Schedule an email to be sent at a specific time",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "email_data": {
                                "type": "object",
                                "description": "Email data (to, subject, body, etc.)"
                            },
                            "send_at": {
                                "type": "string",
                                "description": "ISO timestamp for when to send"
                            }
                        },
                        "required": ["email_data", "send_at"]
                    }
                }
            }
        ]
    
    async def execute(self, task: str, context: AgentContext) -> Dict[str, Any]:
        """
        Execute email generation/sending task.
        
        Args:
            task: Email task request
            context: Agent context with conversation history
        
        Returns:
            Email generation results
        """
        self.status = AgentStatus.RUNNING
        self.logger.info(f"Starting email task: {task}")
        
        try:
            # Add system prompt
            context.add_message("system", self.get_system_prompt())
            
            # Add user task
            context.add_message("user", task)
            
            # Prepare messages for LLM
            messages = context.get_messages()
            
            # Call LLM with tools (will be implemented when API key is available)
            # response = await self._call_llm(messages, tools=self.get_tools())
            
            # 3. Check if it's a question that needs data (New Capability)
            if "?" in task and any(keyword in task.lower() for keyword in ["cuantos", "cuántos", "lista", "buscar", "dame", "muestrame", "muéstrame", "quien", "quién", "cual", "cuál"]):
                self.logger.info(f"Email contains a data question. Attempting Text-to-SQL: {task}")
                query_result = await self.query_tools.query_database(task)
                
                if query_result["success"]:
                    data = query_result["data"]
                    count = query_result["count"]
                    
                    # Generate a natural language response summarizing the data
                    response_body = f"En respuesta a su consulta: '{task}'\n\n"
                    response_body += f"Hemos encontrado {count} registros:\n\n"
                    
                    # Simple text formatting of the first few results
                    for i, item in enumerate(data[:5]):
                        response_body += f"- {str(item)}\n"
                    
                    if count > 5:
                        response_body += f"\n... y {count - 5} más."
                        
                    return {
                        "subject": f"Re: {task[:30]}...",
                        "body": response_body,
                        "type": "email_draft"
                    }

            # 4. Default: Generate a generic task notification
            return await self.generate_task_notification(task, "Alta")
            
        except Exception as e:
            self.logger.error(f"Email task failed: {str(e)}")
            self.status = AgentStatus.FAILED
            return {
                "status": "failed",
                "error": str(e),
                "agent": self.name
            }
    
    async def generate_task_notification(
        self,
        task_title: str,
        assigned_to: str,
        due_date: str,
        priority: str
    ) -> Dict[str, str]:
        """
        Generate a task assignment notification email.
        
        Args:
            task_title: Title of the task
            assigned_to: Name of person assigned
            due_date: Task due date
            priority: Task priority level
        
        Returns:
            Email subject and body
        """
        # This will use LLM when API key is configured
        subject = f"Nueva tarea asignada: {task_title}"
        body = f"""
        <p>Hola {assigned_to},</p>
        <p>Se te ha asignado una nueva tarea:</p>
        <ul>
            <li><strong>Tarea:</strong> {task_title}</li>
            <li><strong>Prioridad:</strong> {priority}</li>
            <li><strong>Fecha límite:</strong> {due_date}</li>
        </ul>
        <p>Por favor, revisa los detalles en el sistema.</p>
        """
        
        return {"subject": subject, "body": body}
