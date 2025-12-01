"""
Assistant Agent Tools

Specialized tools for the General Assistant Agent.
Provides access to all stored procedures and general database operations.
"""

from typing import Dict, Any, List, Optional
from datetime import date
from .base_tools import BaseTool
import logging

logger = logging.getLogger(__name__)


class AssistantTools(BaseTool):
    """
    Tools for General Assistant Agent.
    
    Capabilities:
    - Access all reports and analytics
    - Search any table
    - Get conversation context
    - Register interactions
    - General database queries
    """
    
    async def get_conversation_context(
        self,
        user_email: str,
        last_n: int = 5
    ) -> Dict[str, Any]:
        """
        Get recent conversation context for a user.
        
        Uses: SP_Obtener_Contexto_Agente
        
        Args:
            user_email: User's email address
            last_n: Number of recent conversations to retrieve
        
        Returns:
            Recent conversation history
        """
        try:
            result = await self.call_sp_get_agent_context(user_email, last_n)
            return {
                "success": True,
                "conversations": result.get("context", []),
                "total": len(result.get("context", [])),
                "user": user_email
            }
        except Exception as e:
            logger.error(f"Error getting context: {e}")
            return {"success": False, "error": str(e)}
    
    async def register_conversation(
        self,
        user_email: str,
        subject: str,
        content: str,
        request_type: str,
        interpretation: Optional[str] = None,
        response: Optional[str] = None,
        actions: Optional[str] = None,
        confidence: Optional[float] = None
    ) -> Dict[str, Any]:
        """
        Register an interaction with the agent.
        
        Uses: SP_Registrar_Conversacion_Agente
        
        Args:
            user_email: User's email
            subject: Conversation subject
            content: Original content
            request_type: Type of request
            interpretation: Agent's interpretation
            response: Generated response
            actions: Actions taken
            confidence: Confidence score (0-1)
        
        Returns:
            Registered conversation ID
        """
        try:
            result = await self.call_sp_register_conversation(
                correo_origen=user_email,
                asunto=subject,
                contenido_original=content,
                tipo_solicitud=request_type,
                interpretacion_agente=interpretation,
                respuesta_generada=response,
                acciones_realizadas=actions,
                confianza_respuesta=confidence
            )
            
            return {
                "success": True,
                "conversation_id": result.get("id_conversacion"),
                "message": result.get("mensaje", "Conversación registrada")
            }
        except Exception as e:
            logger.error(f"Error registering conversation: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_work_plan_compliance(
        self,
        plan_id: Optional[int] = None,
        fecha_corte: Optional[date] = None
    ) -> Dict[str, Any]:
        """
        Get work plan compliance report.
        
        Uses: SP_Reporte_Cumplimiento_Plan
        
        Args:
            plan_id: Specific plan ID (optional)
            fecha_corte: Cut-off date (optional)
        
        Returns:
            Compliance report with summary and breakdown
        """
        try:
            result = await self.call_sp_work_plan_compliance(plan_id, fecha_corte)
            return {
                "success": True,
                "summary": result.get("summary", {}),
                "by_type": result.get("by_type", []),
                "message": f"Cumplimiento: {result.get('summary', {}).get('porcentaje_cumplimiento', 0)}%"
            }
        except Exception as e:
            logger.error(f"Error getting work plan compliance: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_medical_exam_compliance(self) -> Dict[str, Any]:
        """
        Get medical exam compliance report.
        
        Uses: SP_Reporte_Cumplimiento_EMO
        
        Returns:
            Medical exam compliance summary
        """
        try:
            result = await self.call_sp_medical_exam_compliance()
            return {
                "success": True,
                "summary": result.get("summary", {}),
                "employees_without_emo": result.get("employees_without_valid_emo", []),
                "compliance_percentage": result.get("summary", {}).get("porcentaje_cumplimiento", 0)
            }
        except Exception as e:
            logger.error(f"Error getting medical exam compliance: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_executive_report(self) -> Dict[str, Any]:
        """
        Get executive dashboard report.
        
        Uses: SP_Reporte_Ejecutivo_CEO
        
        Returns:
            Executive summary for CEO
        """
        try:
            result = await self.call_sp_executive_report()
            return {
                "success": True,
                "report": result.get("executive_report", []),
                "message": "Reporte ejecutivo generado"
            }
        except Exception as e:
            logger.error(f"Error getting executive report: {e}")
            return {"success": False, "error": str(e)}
    
    async def search_any_table(
        self,
        table_name: str,
        filters: Optional[Dict[str, Any]] = None,
        limit: int = 50
    ) -> Dict[str, Any]:
        """
        Search any table in the database.
        
        Uses: CRUD search
        
        Args:
            table_name: Name of the table to search
            filters: Optional filters (column: value pairs)
            limit: Maximum results
        
        Returns:
            Search results
        
        Example:
            >>> results = await tools.search_any_table(
            ...     "EMPLEADO",
            ...     filters={"Area": "Producción"},
            ...     limit=20
            ... )
        """
        try:
            if filters:
                result = await self.crud_search(table_name, filters, limit=limit)
            else:
                result = await self.crud_get_all(table_name, limit=limit)
            
            return {
                "success": True,
                "table": table_name,
                "total": result.get("total", 0),
                "items": result.get("items", []),
                "filters": filters or {}
            }
        except Exception as e:
            logger.error(f"Error searching table {table_name}: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_employee_info(
        self,
        employee_id: Optional[int] = None,
        email: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Get employee information.
        
        Uses: CRUD operations on EMPLEADO table
        
        Args:
            employee_id: Employee ID (if known)
            email: Employee email (alternative lookup)
        
        Returns:
            Employee data
        """
        try:
            if employee_id:
                result = await self.crud_get_one("EMPLEADO", employee_id)
                return {
                    "success": True,
                    "employee": result
                }
            elif email:
                result = await self.crud_search(
                    "EMPLEADO",
                    filters={"Correo": email},
                    limit=1
                )
                employees = result.get("items", [])
                if employees:
                    return {
                        "success": True,
                        "employee": employees[0]
                    }
                else:
                    return {
                        "success": False,
                        "error": f"No se encontró empleado con correo {email}"
                    }
            else:
                return {
                    "success": False,
                    "error": "Debe proporcionar employee_id o email"
                }
        except Exception as e:
            logger.error(f"Error getting employee info: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_active_employees_count(
        self,
        area: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Get count of active employees.
        
        Uses: CRUD search on EMPLEADO table
        
        Args:
            area: Filter by area (optional)
        
        Returns:
            Employee count
        """
        try:
            filters = {"Estado": True}
            if area:
                filters["Area"] = area
            
            result = await self.crud_search("EMPLEADO", filters, limit=1000)
            
            return {
                "success": True,
                "total": result.get("total", 0),
                "area": area or "Todas las áreas"
            }
        except Exception as e:
            logger.error(f"Error counting employees: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_recent_incidents(
        self,
        limit: int = 10
    ) -> Dict[str, Any]:
        """
        Get recent incidents.
        
        Uses: CRUD get all on INCIDENTE table
        
        Args:
            limit: Number of recent incidents
        
        Returns:
            List of recent incidents
        """
        try:
            result = await self.crud_get_all("INCIDENTE", limit=limit)
            return {
                "success": True,
                "total": result.get("total", 0),
                "incidents": result.get("items", [])
            }
        except Exception as e:
            logger.error(f"Error getting incidents: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_pending_tasks_count(
        self,
        responsible_id: Optional[int] = None
    ) -> Dict[str, Any]:
        """
        Get count of pending tasks.
        
        Uses: CRUD search on TAREA table
        
        Args:
            responsible_id: Filter by responsible employee (optional)
        
        Returns:
            Task count
        """
        try:
            filters = {"Estado": "Pendiente"}
            if responsible_id:
                filters["IdResponsable"] = responsible_id
            
            result = await self.crud_search("TAREA", filters, limit=1000)
            
            return {
                "success": True,
                "total": result.get("total", 0),
                "responsible_id": responsible_id
            }
        except Exception as e:
            logger.error(f"Error counting tasks: {e}")
            return {"success": False, "error": str(e)}
    
    def get_tool_descriptions(self) -> List[Dict[str, str]]:
        """Get descriptions of all available tools for LLM."""
        return [
            {
                "name": "get_conversation_context",
                "description": "Obtiene el contexto de conversaciones recientes de un usuario",
                "parameters": "user_email (str), last_n (int)"
            },
            {
                "name": "register_conversation",
                "description": "Registra una interacción con el agente",
                "parameters": "user_email, subject, content, request_type, interpretation, response, actions, confidence"
            },
            {
                "name": "get_work_plan_compliance",
                "description": "Obtiene reporte de cumplimiento del plan de trabajo",
                "parameters": "plan_id (int, opcional), fecha_corte (date, opcional)"
            },
            {
                "name": "get_medical_exam_compliance",
                "description": "Obtiene reporte de cumplimiento de exámenes médicos",
                "parameters": "ninguno"
            },
            {
                "name": "get_executive_report",
                "description": "Obtiene reporte ejecutivo para CEO",
                "parameters": "ninguno"
            },
            {
                "name": "search_any_table",
                "description": "Busca en cualquier tabla de la base de datos",
                "parameters": "table_name (str), filters (dict), limit (int)"
            },
            {
                "name": "get_employee_info",
                "description": "Obtiene información de un empleado por ID o correo",
                "parameters": "employee_id (int) o email (str)"
            },
            {
                "name": "get_active_employees_count",
                "description": "Obtiene el conteo de empleados activos",
                "parameters": "area (str, opcional)"
            },
            {
                "name": "get_recent_incidents",
                "description": "Obtiene los incidentes más recientes",
                "parameters": "limit (int)"
            },
            {
                "name": "get_pending_tasks_count",
                "description": "Obtiene el conteo de tareas pendientes",
                "parameters": "responsible_id (int, opcional)"
            }
        ]
