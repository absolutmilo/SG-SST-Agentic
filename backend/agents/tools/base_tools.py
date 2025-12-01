"""
Base Tools for Agents

Provides common functionality for all agent tools to interact with:
- Stored Procedures via API
- CRUD operations via API
- Database direct access (optional)
"""

import httpx
from typing import Dict, Any, List, Optional
from datetime import date, datetime
import logging

logger = logging.getLogger(__name__)


class BaseTool:
    """
    Base class for all agent tools.
    
    Provides methods to interact with the backend API:
    - Stored procedures
    - CRUD operations
    - Custom endpoints
    """
    
    def __init__(
        self,
        api_base_url: str = "http://localhost:8000",
        auth_token: Optional[str] = None
    ):
        self.api_base_url = api_base_url.rstrip('/')
        self.auth_token = auth_token
        self.headers = {}
        
        if auth_token:
            self.headers["Authorization"] = f"Bearer {auth_token}"
    
    async def _make_request(
        self,
        method: str,
        endpoint: str,
        **kwargs
    ) -> Dict[str, Any]:
        """
        Make HTTP request to backend API.
        
        Args:
            method: HTTP method (GET, POST, PUT, DELETE)
            endpoint: API endpoint (will be appended to base_url)
            **kwargs: Additional arguments for httpx request
        
        Returns:
            Response JSON as dictionary
        """
        url = f"{self.api_base_url}{endpoint}"
        
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.request(
                    method=method,
                    url=url,
                    headers=self.headers,
                    **kwargs
                )
                response.raise_for_status()
                return response.json()
        except httpx.HTTPStatusError as e:
            logger.error(f"HTTP error {e.response.status_code}: {e.response.text}")
            raise Exception(f"API error: {e.response.text}")
        except Exception as e:
            logger.error(f"Request error: {e}")
            raise
    
    # ============================================
    # Stored Procedure Methods
    # ============================================
    
    async def call_sp_monitor_overdue_tasks(self) -> Dict[str, Any]:
        """Call SP_Monitorear_Tareas_Vencidas"""
        return await self._make_request(
            "POST",
            "/api/v1/procedures/monitor-overdue-tasks"
        )
    
    async def call_sp_generate_tasks_expiration(
        self,
        coordinator_id: int
    ) -> Dict[str, Any]:
        """Call SP_Generar_Tareas_Vigencia"""
        return await self._make_request(
            "POST",
            f"/api/v1/procedures/generate-tasks-expiration?id_coordinador_sst={coordinator_id}"
        )
    
    async def call_sp_accident_indicators(
        self,
        year: int,
        period: Optional[str] = None
    ) -> Dict[str, Any]:
        """Call SP_Calcular_Indicadores_Siniestralidad"""
        endpoint = f"/api/v1/procedures/accident-indicators/{year}"
        if period:
            endpoint += f"?periodo={period}"
        return await self._make_request("GET", endpoint)
    
    async def call_sp_work_plan_compliance(
        self,
        plan_id: Optional[int] = None,
        fecha_corte: Optional[date] = None
    ) -> Dict[str, Any]:
        """Call SP_Reporte_Cumplimiento_Plan"""
        params = {}
        if plan_id:
            params["id_plan"] = plan_id
        if fecha_corte:
            params["fecha_corte"] = fecha_corte.isoformat()
        
        return await self._make_request(
            "GET",
            "/api/v1/procedures/work-plan-compliance",
            params=params
        )
    
    async def call_sp_medical_exam_compliance(self) -> Dict[str, Any]:
        """Call SP_Reporte_Cumplimiento_EMO"""
        return await self._make_request(
            "GET",
            "/api/v1/procedures/medical-exam-compliance"
        )
    
    async def call_sp_executive_report(self) -> Dict[str, Any]:
        """Call SP_Reporte_Ejecutivo_CEO"""
        return await self._make_request(
            "GET",
            "/api/v1/procedures/executive-report"
        )
    
    async def call_sp_generate_automatic_alerts(self) -> Dict[str, Any]:
        """Call SP_Generar_Alertas_Automaticas"""
        return await self._make_request(
            "POST",
            "/api/v1/procedures/generate-automatic-alerts"
        )
    
    async def call_sp_get_pending_alerts(self) -> Dict[str, Any]:
        """Call SP_Obtener_Alertas_Pendientes"""
        return await self._make_request(
            "GET",
            "/api/v1/procedures/pending-alerts"
        )
    
    async def call_sp_mark_alerts_sent(
        self,
        alert_ids: List[int]
    ) -> Dict[str, Any]:
        """Call SP_Marcar_Alertas_Enviadas"""
        return await self._make_request(
            "POST",
            "/api/v1/procedures/mark-alerts-sent",
            json={"alert_ids": alert_ids}
        )
    
    async def call_sp_create_task_from_email(
        self,
        descripcion: str,
        fecha_vencimiento: date,
        id_responsable: int,
        prioridad: str = "Media",
        tipo_tarea: str = "Solicitud Agente",
        id_conversacion: Optional[int] = None
    ) -> Dict[str, Any]:
        """Call SP_Crear_Tarea_Desde_Correo"""
        params = {
            "descripcion": descripcion,
            "fecha_vencimiento": fecha_vencimiento.isoformat(),
            "id_responsable": id_responsable,
            "prioridad": prioridad,
            "tipo_tarea": tipo_tarea
        }
        if id_conversacion:
            params["id_conversacion"] = id_conversacion
        
        return await self._make_request(
            "POST",
            "/api/v1/procedures/create-task-from-email",
            params=params
        )
    
    async def call_sp_get_agent_context(
        self,
        user_email: str,
        last_n: int = 5
    ) -> Dict[str, Any]:
        """Call SP_Obtener_Contexto_Agente"""
        return await self._make_request(
            "GET",
            "/api/v1/procedures/agent-context",
            params={"correo_usuario": user_email, "ultimas_n": last_n}
        )
    
    async def call_sp_register_conversation(
        self,
        correo_origen: str,
        asunto: str,
        contenido_original: str,
        tipo_solicitud: str,
        interpretacion_agente: Optional[str] = None,
        respuesta_generada: Optional[str] = None,
        acciones_realizadas: Optional[str] = None,
        confianza_respuesta: Optional[float] = None
    ) -> Dict[str, Any]:
        """Call SP_Registrar_Conversacion_Agente"""
        data = {
            "correo_origen": correo_origen,
            "asunto": asunto,
            "contenido_original": contenido_original,
            "tipo_solicitud": tipo_solicitud,
            "interpretacion_agente": interpretacion_agente,
            "respuesta_generada": respuesta_generada,
            "acciones_realizadas": acciones_realizadas,
            "confianza_respuesta": confianza_respuesta
        }
        
        return await self._make_request(
            "POST",
            "/api/v1/procedures/register-agent-conversation",
            params=data
        )
    
    # ============================================
    # CRUD Methods
    # ============================================
    
    async def crud_get_all(
        self,
        table_name: str,
        skip: int = 0,
        limit: int = 100
    ) -> Dict[str, Any]:
        """Get all records from a table"""
        return await self._make_request(
            "GET",
            f"/api/v1/crud/{table_name}",
            params={"skip": skip, "limit": limit}
        )
    
    async def crud_get_one(
        self,
        table_name: str,
        record_id: int
    ) -> Dict[str, Any]:
        """Get a single record by ID"""
        return await self._make_request(
            "GET",
            f"/api/v1/crud/{table_name}/{record_id}"
        )
    
    async def crud_create(
        self,
        table_name: str,
        data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Create a new record"""
        return await self._make_request(
            "POST",
            f"/api/v1/crud/{table_name}",
            json=data
        )
    
    async def crud_update(
        self,
        table_name: str,
        record_id: int,
        data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Update an existing record"""
        return await self._make_request(
            "PUT",
            f"/api/v1/crud/{table_name}/{record_id}",
            json=data
        )
    
    async def crud_delete(
        self,
        table_name: str,
        record_id: int
    ) -> Dict[str, Any]:
        """Delete a record"""
        return await self._make_request(
            "DELETE",
            f"/api/v1/crud/{table_name}/{record_id}"
        )
    
    async def crud_search(
        self,
        table_name: str,
        filters: Dict[str, Any],
        skip: int = 0,
        limit: int = 100
    ) -> Dict[str, Any]:
        """Search records with filters"""
        return await self._make_request(
            "POST",
            f"/api/v1/crud/{table_name}/search",
            json=filters,
            params={"skip": skip, "limit": limit}
        )
    
    # ============================================
    # Helper Methods
    # ============================================
    
    def format_date(self, date_obj: Any) -> str:
        """Format date object to ISO string"""
        if isinstance(date_obj, (date, datetime)):
            return date_obj.isoformat()
        return str(date_obj)
    
    def parse_response(self, response: Dict[str, Any], key: str = None) -> Any:
        """Parse API response and extract specific key if provided"""
        if key and key in response:
            return response[key]
        return response
