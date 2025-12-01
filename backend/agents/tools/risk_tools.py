"""
Risk Agent Tools

Specialized tools for the Risk Assessment Agent.
Integrates with database stored procedures and CRUD operations.
"""

from typing import Dict, Any, List, Optional
from datetime import date, datetime, timedelta
from .base_tools import BaseTool
import logging

logger = logging.getLogger(__name__)


class RiskTools(BaseTool):
    """
    Tools for Risk Assessment Agent.
    
    Capabilities:
    - Get accident indicators and statistics
    - Create corrective tasks
    - Search hazards and risks
    - Get incident history
    - Monitor risk levels
    """
    
    async def get_accident_indicators(
        self,
        year: int,
        period: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Get accident indicators for a specific year/period.
        
        Uses: SP_Calcular_Indicadores_Siniestralidad
        
        Args:
            year: Year (e.g., 2024)
            period: Optional period (Q1, Q2, Q3, Q4, or specific month)
        
        Returns:
            Dictionary with frequency index, severity index, etc.
        
        Example:
            >>> indicators = await tools.get_accident_indicators(2024, "Q3")
            >>> print(f"Frequency index: {indicators['indice_frecuencia']}")
        """
        try:
            result = await self.call_sp_accident_indicators(year, period)
            return {
                "success": True,
                "data": result,
                "summary": f"Indicadores de {year}" + (f" - {period}" if period else "")
            }
        except Exception as e:
            logger.error(f"Error getting accident indicators: {e}")
            return {"success": False, "error": str(e)}
    
    async def create_corrective_task(
        self,
        description: str,
        responsible_id: int,
        deadline_days: int = 30,
        priority: str = "Alta"
    ) -> Dict[str, Any]:
        """
        Create a corrective task for a risk.
        
        Uses: SP_Crear_Tarea_Desde_Correo
        
        Args:
            description: Task description
            responsible_id: ID of responsible employee
            deadline_days: Days until deadline (default: 30)
            priority: Priority level (Alta, Media, Baja)
        
        Returns:
            Created task information
        
        Example:
            >>> task = await tools.create_corrective_task(
            ...     "Instalar barandas en escaleras",
            ...     responsible_id=102,
            ...     deadline_days=15,
            ...     priority="Alta"
            ... )
        """
        try:
            deadline = date.today() + timedelta(days=deadline_days)
            result = await self.call_sp_create_task_from_email(
                descripcion=description,
                fecha_vencimiento=deadline,
                id_responsable=responsible_id,
                prioridad=priority,
                tipo_tarea="Acción Correctiva"
            )
            return {
                "success": True,
                "task_id": result.get("id_tarea"),
                "data": result,
                "message": f"Tarea creada con vencimiento en {deadline_days} días"
            }
        except Exception as e:
            logger.error(f"Error creating corrective task: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_hazards_by_area(
        self,
        area: Optional[str] = None,
        limit: int = 50
    ) -> Dict[str, Any]:
        """
        Get hazards filtered by area.
        
        Uses: CRUD search on PELIGRO table
        
        Args:
            area: Area name (optional, returns all if not specified)
            limit: Maximum number of results
        
        Returns:
            List of hazards
        """
        try:
            filters = {}
            if area:
                filters["Area"] = area
            
            result = await self.crud_search(
                table_name="PELIGRO",
                filters=filters,
                limit=limit
            )
            
            return {
                "success": True,
                "total": result.get("total", 0),
                "hazards": result.get("items", []),
                "area": area or "Todas las áreas"
            }
        except Exception as e:
            logger.error(f"Error getting hazards: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_incidents_history(
        self,
        start_date: Optional[date] = None,
        end_date: Optional[date] = None,
        incident_type: Optional[str] = None,
        limit: int = 100
    ) -> Dict[str, Any]:
        """
        Get incident history with optional filters.
        
        Uses: CRUD search on INCIDENTE table
        
        Args:
            start_date: Start date for filter
            end_date: End date for filter
            incident_type: Type of incident (Accidente, Incidente, Casi-accidente)
            limit: Maximum number of results
        
        Returns:
            List of incidents
        """
        try:
            filters = {}
            if incident_type:
                filters["TipoIncidente"] = incident_type
            
            # Note: Date filtering would need custom logic or SP
            # For now, we get all and filter in memory if needed
            result = await self.crud_search(
                table_name="INCIDENTE",
                filters=filters,
                limit=limit
            )
            
            incidents = result.get("items", [])
            
            # Filter by date if provided
            if start_date or end_date:
                filtered = []
                for inc in incidents:
                    inc_date = inc.get("FechaIncidente")
                    if inc_date:
                        # Convert string to date if needed
                        if isinstance(inc_date, str):
                            inc_date = datetime.fromisoformat(inc_date).date()
                        
                        if start_date and inc_date < start_date:
                            continue
                        if end_date and inc_date > end_date:
                            continue
                        filtered.append(inc)
                incidents = filtered
            
            return {
                "success": True,
                "total": len(incidents),
                "incidents": incidents,
                "filters": {
                    "start_date": start_date.isoformat() if start_date else None,
                    "end_date": end_date.isoformat() if end_date else None,
                    "type": incident_type
                }
            }
        except Exception as e:
            logger.error(f"Error getting incidents: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_risk_matrix(
        self,
        area: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Get risk matrix entries.
        
        Uses: CRUD search on MATRIZ_RIESGO table
        
        Args:
            area: Filter by area (optional)
        
        Returns:
            Risk matrix data
        """
        try:
            filters = {}
            if area:
                filters["Area"] = area
            
            result = await self.crud_search(
                table_name="MATRIZ_RIESGO",
                filters=filters,
                limit=200
            )
            
            return {
                "success": True,
                "total": result.get("total", 0),
                "risks": result.get("items", []),
                "area": area or "Todas las áreas"
            }
        except Exception as e:
            logger.error(f"Error getting risk matrix: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_overdue_tasks(self) -> Dict[str, Any]:
        """
        Get list of overdue tasks.
        
        Uses: SP_Monitorear_Tareas_Vencidas
        
        Returns:
            List of overdue tasks
        """
        try:
            result = await self.call_sp_monitor_overdue_tasks()
            return {
                "success": True,
                "total": result.get("total", 0),
                "tasks": result.get("tasks", []),
                "message": f"Se encontraron {result.get('total', 0)} tareas vencidas"
            }
        except Exception as e:
            logger.error(f"Error getting overdue tasks: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_employee_info(
        self,
        employee_id: int
    ) -> Dict[str, Any]:
        """
        Get employee information.
        
        Uses: CRUD get on EMPLEADO table
        
        Args:
            employee_id: Employee ID
        
        Returns:
            Employee data
        """
        try:
            result = await self.crud_get_one("EMPLEADO", employee_id)
            return {
                "success": True,
                "employee": result
            }
        except Exception as e:
            logger.error(f"Error getting employee info: {e}")
            return {"success": False, "error": str(e)}
    
    def get_tool_descriptions(self) -> List[Dict[str, str]]:
        """
        Get descriptions of all available tools for LLM.
        
        Returns:
            List of tool descriptions
        """
        return [
            {
                "name": "get_accident_indicators",
                "description": "Obtiene indicadores de accidentalidad (frecuencia, severidad, ILI) para un año y periodo específico",
                "parameters": "year (int), period (str, opcional: Q1, Q2, Q3, Q4)"
            },
            {
                "name": "create_corrective_task",
                "description": "Crea una tarea correctiva para un riesgo identificado",
                "parameters": "description (str), responsible_id (int), deadline_days (int), priority (str)"
            },
            {
                "name": "get_hazards_by_area",
                "description": "Obtiene lista de peligros filtrados por área",
                "parameters": "area (str, opcional), limit (int)"
            },
            {
                "name": "get_incidents_history",
                "description": "Obtiene historial de incidentes con filtros opcionales",
                "parameters": "start_date (date), end_date (date), incident_type (str), limit (int)"
            },
            {
                "name": "get_risk_matrix",
                "description": "Obtiene la matriz de riesgos, opcionalmente filtrada por área",
                "parameters": "area (str, opcional)"
            },
            {
                "name": "get_overdue_tasks",
                "description": "Obtiene lista de tareas vencidas",
                "parameters": "ninguno"
            },
            {
                "name": "get_employee_info",
                "description": "Obtiene información de un empleado por ID",
                "parameters": "employee_id (int)"
            }
        ]
