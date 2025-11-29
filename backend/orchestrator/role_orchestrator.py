"""
Role Orchestrator - Updated for Database Integration

Coordinates agent selection and execution based on user roles
from the database AGENTE_ROL table.
"""

from typing import Dict, Any, List, Optional
from enum import Enum
import logging
import json

logger = logging.getLogger(__name__)


class RoleOrchestrator:
    """
    Orchestrates agent execution based on user roles from database.
    
    Responsibilities:
    - Fetch user permissions from EMPLEADO_AGENTE_ROL table
    - Validate user permissions for agent access
    - Select appropriate agent for task
    - Prioritize tasks based on role
    - Track agent usage and performance
    """
    
    def __init__(self, db_connection=None):
        self.logger = logging.getLogger("orchestrator.role")
        self.active_tasks: Dict[str, Dict[str, Any]] = {}
        self.db = db_connection  # Database connection for querying roles
    
    async def get_user_agent_permissions(self, user_id: int) -> Dict[str, Any]:
        """
        Get user's agent permissions from database.
        
        Args:
            user_id: ID of the user (id_empleado)
        
        Returns:
            Dictionary with user's agent permissions
        """
        if not self.db:
            self.logger.warning("No database connection, using default permissions")
            return {
                "user_id": user_id,
                "role_name": "employee",
                "allowed_agents": ["assistant_agent"],
                "access_level": 1
            }
        
        try:
            # Query to get user's agent role
            query = """
            SELECT 
                e.id_empleado,
                e.Nombre + ' ' + e.Apellidos AS nombre_completo,
                e.Cargo,
                ar.nombre_rol,
                ar.agentes_permitidos,
                ar.nivel_acceso,
                ar.descripcion
            FROM [dbo].[EMPLEADO] e
            INNER JOIN [dbo].[EMPLEADO_AGENTE_ROL] ear 
                ON e.id_empleado = ear.id_empleado
            INNER JOIN [dbo].[AGENTE_ROL] ar 
                ON ear.id_agente_rol = ar.id_agente_rol
            WHERE e.id_empleado = ?
              AND ear.FechaFinalizacion IS NULL
              AND ar.activo = 1
            """
            
            # Execute query (implementation depends on your DB connection)
            # result = await self.db.execute(query, user_id)
            
            # For now, return placeholder
            # In production, parse the JSON agentes_permitidos field
            return {
                "user_id": user_id,
                "role_name": "employee",
                "allowed_agents": ["assistant_agent"],
                "access_level": 1
            }
            
        except Exception as e:
            self.logger.error(f"Error fetching user permissions: {e}")
            # Fallback to minimal permissions
            return {
                "user_id": user_id,
                "role_name": "employee",
                "allowed_agents": ["assistant_agent"],
                "access_level": 1
            }
    
    async def orchestrate(
        self,
        user_id: int,
        task: str,
        preferred_agent: Optional[str] = None,
        context: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Orchestrate task execution based on user role from database.
        
        Args:
            user_id: ID of the user requesting the task
            task: Task description
            preferred_agent: Optional preferred agent name
            context: Optional additional context
        
        Returns:
            Orchestration result with agent selection and execution plan
        """
        # Get user permissions from database
        permissions = await self.get_user_agent_permissions(user_id)
        
        user_role = permissions.get("role_name", "employee")
        allowed_agents = permissions.get("allowed_agents", ["assistant_agent"])
        access_level = permissions.get("access_level", 1)
        
        if not allowed_agents:
            return {
                "status": "error",
                "message": f"No agents available for user {user_id}",
                "user_role": user_role
            }
        
        # Validate preferred agent if specified
        if preferred_agent:
            if preferred_agent not in allowed_agents:
                return {
                    "status": "error",
                    "message": f"User {user_id} (role: {user_role}) cannot use agent {preferred_agent}",
                    "allowed_agents": allowed_agents,
                    "access_level": access_level
                }
            selected_agent = preferred_agent
        else:
            # Auto-select agent based on task
            selected_agent = self._select_agent(task, allowed_agents)
        
        self.logger.info(
            f"Orchestrating task for user {user_id} (role: {user_role})",
            extra={
                "task": task,
                "selected_agent": selected_agent,
                "allowed_agents": allowed_agents,
                "access_level": access_level
            }
        )
        
        return {
            "status": "ready",
            "user_id": user_id,
            "user_role": user_role,
            "selected_agent": selected_agent,
            "allowed_agents": allowed_agents,
            "access_level": access_level,
            "task": task,
            "context": context or {}
        }
    
    def _select_agent(self, task: str, available_agents: List[str]) -> str:
        """
        Automatically select the most appropriate agent for a task.
        
        Args:
            task: Task description
            available_agents: List of agents available to the user
        
        Returns:
            Selected agent name
        """
        task_lower = task.lower()
        
        # Priority-based selection
        if "risk_agent" in available_agents:
            if any(word in task_lower for word in ["riesgo", "peligro", "matriz", "evaluación", "hazard"]):
                return "risk_agent"
        
        if "document_agent" in available_agents:
            if any(word in task_lower for word in ["documento", "pdf", "archivo", "compliance", "verificar"]):
                return "document_agent"
        
        if "email_agent" in available_agents:
            if any(word in task_lower for word in ["correo", "email", "notificación", "enviar", "notificar"]):
                return "email_agent"
        
        # Default to assistant if available
        if "assistant_agent" in available_agents:
            return "assistant_agent"
        
        # Fallback to first available agent
        return available_agents[0]
    
    async def prioritize_tasks(
        self,
        tasks: List[Dict[str, Any]],
        user_id: int
    ) -> List[Dict[str, Any]]:
        """
        Prioritize tasks based on user's access level and task urgency.
        
        Args:
            tasks: List of tasks to prioritize
            user_id: User's ID
        
        Returns:
            Prioritized list of tasks
        """
        # Get user permissions
        permissions = await self.get_user_agent_permissions(user_id)
        access_level = permissions.get("access_level", 1)
        
        # Priority weights by access level
        level_weights = {
            4: 1.5,  # Admin/SST Coordinator
            3: 1.3,  # Auditor/COPASST
            2: 1.1,  # Supervisor/Brigadista
            1: 1.0   # Employee/Contractor
        }
        
        weight = level_weights.get(access_level, 1.0)
        
        # Sort tasks by priority and access level weight
        def task_score(task: Dict[str, Any]) -> float:
            priority_scores = {
                "critical": 4.0,
                "high": 3.0,
                "medium": 2.0,
                "low": 1.0
            }
            priority = task.get("priority", "medium")
            return priority_scores.get(priority, 2.0) * weight
        
        return sorted(tasks, key=task_score, reverse=True)
    
    def track_agent_usage(
        self,
        user_id: int,
        agent_name: str,
        task_id: str,
        status: str
    ):
        """Track agent usage for analytics and monitoring"""
        self.active_tasks[task_id] = {
            "user_id": user_id,
            "agent_name": agent_name,
            "status": status,
            "timestamp": None  # Would use datetime.now()
        }
        
        self.logger.info(
            f"Agent usage tracked",
            extra={
                "task_id": task_id,
                "user_id": user_id,
                "agent": agent_name,
                "status": status
            }
        )
