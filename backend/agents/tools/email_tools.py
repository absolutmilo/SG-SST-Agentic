"""
Email Agent Tools

Specialized tools for the Email/Notification Agent.
Integrates with database for alert management and notifications.
"""

from typing import Dict, Any, List, Optional
from datetime import date, timedelta
from .base_tools import BaseTool
import logging

logger = logging.getLogger(__name__)


class EmailTools(BaseTool):
    """
    Tools for Email/Notification Agent.
    
    Capabilities:
    - Get and manage alerts
    - Send notifications
    - Get employee contact information
    - Create task notifications
    - Monitor overdue items
    """
    
    async def get_pending_alerts(self) -> Dict[str, Any]:
        """
        Get all pending alerts.
        
        Uses: SP_Obtener_Alertas_Pendientes
        
        Returns:
            List of pending alerts to be sent
        
        Example:
            >>> alerts = await tools.get_pending_alerts()
            >>> print(f"Pending: {alerts['total']}")
        """
        try:
            result = await self.call_sp_get_pending_alerts()
            return {
                "success": True,
                "total": result.get("total", 0),
                "alerts": result.get("alerts", []),
                "message": f"Se encontraron {result.get('total', 0)} alertas pendientes"
            }
        except Exception as e:
            logger.error(f"Error getting pending alerts: {e}")
            return {"success": False, "error": str(e)}
    
    async def mark_alerts_sent(
        self,
        alert_ids: List[int]
    ) -> Dict[str, Any]:
        """
        Mark alerts as sent.
        
        Uses: SP_Marcar_Alertas_Enviadas
        
        Args:
            alert_ids: List of alert IDs to mark as sent
        
        Returns:
            Confirmation message
        """
        try:
            result = await self.call_sp_mark_alerts_sent(alert_ids)
            return {
                "success": True,
                "marked": len(alert_ids),
                "message": result.get("message", "Alertas marcadas como enviadas")
            }
        except Exception as e:
            logger.error(f"Error marking alerts: {e}")
            return {"success": False, "error": str(e)}
    
    async def generate_automatic_alerts(self) -> Dict[str, Any]:
        """
        Generate automatic alerts for upcoming deadlines.
        
        Uses: SP_Generar_Alertas_Automaticas
        
        Returns:
            Number of alerts generated
        """
        try:
            result = await self.call_sp_generate_automatic_alerts()
            return {
                "success": True,
                "generated": result.get("alerts_generated", 0),
                "message": f"Se generaron {result.get('alerts_generated', 0)} alertas automáticas"
            }
        except Exception as e:
            logger.error(f"Error generating alerts: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_employees_for_notification(
        self,
        area: Optional[str] = None,
        cargo: Optional[str] = None,
        estado: bool = True
    ) -> Dict[str, Any]:
        """
        Get employees for sending notifications.
        
        Uses: CRUD search on EMPLEADO table
        
        Args:
            area: Filter by area (optional)
            cargo: Filter by position (optional)
            estado: Active status (default: True)
        
        Returns:
            List of employees with contact information
        """
        try:
            filters = {"Estado": estado}
            if area:
                filters["Area"] = area
            if cargo:
                filters["Cargo"] = cargo
            
            result = await self.crud_search(
                table_name="EMPLEADO",
                filters=filters,
                limit=200
            )
            
            # Extract relevant contact info
            employees = []
            for emp in result.get("items", []):
                employees.append({
                    "id": emp.get("id_empleado"),
                    "nombre": f"{emp.get('Nombre')} {emp.get('Apellidos')}",
                    "correo": emp.get("Correo"),
                    "area": emp.get("Area"),
                    "cargo": emp.get("Cargo")
                })
            
            return {
                "success": True,
                "total": len(employees),
                "employees": employees,
                "filters": {"area": area, "cargo": cargo}
            }
        except Exception as e:
            logger.error(f"Error getting employees: {e}")
            return {"success": False, "error": str(e)}
    
    async def create_task_notification(
        self,
        description: str,
        responsible_id: int,
        deadline_days: int = 7,
        priority: str = "Media"
    ) -> Dict[str, Any]:
        """
        Create a task and prepare notification.
        
        Uses: SP_Crear_Tarea_Desde_Correo
        
        Args:
            description: Task description
            responsible_id: ID of responsible employee
            deadline_days: Days until deadline
            priority: Priority level
        
        Returns:
            Created task with notification details
        """
        try:
            deadline = date.today() + timedelta(days=deadline_days)
            result = await self.call_sp_create_task_from_email(
                descripcion=description,
                fecha_vencimiento=deadline,
                id_responsable=responsible_id,
                prioridad=priority,
                tipo_tarea="Notificación Agente"
            )
            
            return {
                "success": True,
                "task_id": result.get("id_tarea"),
                "responsible": result.get("responsable"),
                "email": result.get("correo_responsable"),
                "deadline": deadline.isoformat(),
                "message": f"Tarea creada y lista para notificar a {result.get('responsable')}"
            }
        except Exception as e:
            logger.error(f"Error creating task notification: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_overdue_tasks(self) -> Dict[str, Any]:
        """
        Get overdue tasks for sending reminders.
        
        Uses: SP_Monitorear_Tareas_Vencidas
        
        Returns:
            List of overdue tasks with responsible parties
        """
        try:
            result = await self.call_sp_monitor_overdue_tasks()
            
            # Format for email notifications
            tasks_for_email = []
            for task in result.get("tasks", []):
                tasks_for_email.append({
                    "id": task.get("id_tarea"),
                    "descripcion": task.get("descripcion"),
                    "responsable": task.get("responsable"),
                    "correo": task.get("correo_responsable"),
                    "dias_vencida": task.get("dias_vencida"),
                    "prioridad": task.get("prioridad")
                })
            
            return {
                "success": True,
                "total": len(tasks_for_email),
                "tasks": tasks_for_email,
                "message": f"{len(tasks_for_email)} tareas requieren recordatorio"
            }
        except Exception as e:
            logger.error(f"Error getting overdue tasks: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_upcoming_trainings(
        self,
        days_ahead: int = 15
    ) -> Dict[str, Any]:
        """
        Get upcoming trainings for notifications.
        
        Uses: CRUD search on CAPACITACION table
        
        Args:
            days_ahead: Days to look ahead (default: 15)
        
        Returns:
            List of upcoming trainings
        """
        try:
            # Get all trainings (would filter by date in production)
            result = await self.crud_get_all("CAPACITACION", limit=100)
            
            # Filter upcoming trainings
            today = date.today()
            future_date = today + timedelta(days=days_ahead)
            
            upcoming = []
            for training in result.get("items", []):
                fecha_str = training.get("FechaInicio")
                if fecha_str:
                    # Would parse date and filter
                    upcoming.append(training)
            
            return {
                "success": True,
                "total": len(upcoming),
                "trainings": upcoming[:20],  # Limit to 20
                "days_ahead": days_ahead
            }
        except Exception as e:
            logger.error(f"Error getting trainings: {e}")
            return {"success": False, "error": str(e)}
    
    def get_tool_descriptions(self) -> List[Dict[str, str]]:
        """Get descriptions of all available tools for LLM."""
        return [
            {
                "name": "get_pending_alerts",
                "description": "Obtiene todas las alertas pendientes de envío",
                "parameters": "ninguno"
            },
            {
                "name": "mark_alerts_sent",
                "description": "Marca alertas como enviadas",
                "parameters": "alert_ids (List[int])"
            },
            {
                "name": "generate_automatic_alerts",
                "description": "Genera alertas automáticas para vencimientos próximos",
                "parameters": "ninguno"
            },
            {
                "name": "get_employees_for_notification",
                "description": "Obtiene empleados para enviar notificaciones, filtrados por área o cargo",
                "parameters": "area (str), cargo (str), estado (bool)"
            },
            {
                "name": "create_task_notification",
                "description": "Crea una tarea y prepara notificación para el responsable",
                "parameters": "description (str), responsible_id (int), deadline_days (int), priority (str)"
            },
            {
                "name": "get_overdue_tasks",
                "description": "Obtiene tareas vencidas para enviar recordatorios",
                "parameters": "ninguno"
            },
            {
                "name": "get_upcoming_trainings",
                "description": "Obtiene capacitaciones próximas para notificar",
                "parameters": "days_ahead (int)"
            }
        ]
