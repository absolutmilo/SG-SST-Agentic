"""
Agent API Router

FastAPI endpoints for agent execution and management.
"""

from fastapi import APIRouter, HTTPException, Depends, BackgroundTasks
from pydantic import BaseModel, Field
from typing import Optional, Dict, Any, List
import logging
from datetime import datetime

# Import agents and orchestrator
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from agents.base_agent import AgentContext, AgentStatus
from agents.risk_agent import RiskAgent
from agents.document_agent import DocumentAgent
from agents.email_agent import EmailAgent
from agents.assistant_agent import AssistantAgent
from orchestrator.role_orchestrator import RoleOrchestrator

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/agent")

# Initialize agents
risk_agent = RiskAgent()
document_agent = DocumentAgent()
email_agent = EmailAgent()
assistant_agent = AssistantAgent()

# Initialize orchestrator
orchestrator = RoleOrchestrator()

# Agent registry
AGENTS = {
    "risk_agent": risk_agent,
    "document_agent": document_agent,
    "email_agent": email_agent,
    "assistant_agent": assistant_agent
}


# ============================================
# Request/Response Models
# ============================================

class AgentRunRequest(BaseModel):
    """Request to run an agent"""
    agent_name: str = Field(..., description="Name of the agent to run")
    task: str = Field(..., description="Task description for the agent")
    user_id: int = Field(..., description="ID of the user requesting the task")
    context: Optional[Dict[str, Any]] = Field(default=None, description="Additional context")
    session_id: Optional[str] = Field(default=None, description="Session ID for conversation continuity")


class AgentRunResponse(BaseModel):
    """Response from agent execution"""
    status: str
    agent_name: str
    task_id: str
    result: Optional[Dict[str, Any]] = None
    error: Optional[str] = None
    execution_time: Optional[float] = None


class AgentStatusResponse(BaseModel):
    """Agent status response"""
    task_id: str
    status: str
    agent_name: str
    progress: Optional[float] = None
    result: Optional[Dict[str, Any]] = None
    error: Optional[str] = None


class AgentListResponse(BaseModel):
    """List of available agents"""
    agents: List[Dict[str, Any]]
    total: int


# ============================================
# Endpoints
# ============================================

@router.post("/run", response_model=AgentRunResponse)
async def run_agent(
    request: AgentRunRequest,
    background_tasks: BackgroundTasks
):
    """
    Execute an agent with a given task.
    
    This endpoint:
    1. Validates user permissions
    2. Selects appropriate agent
    3. Executes the task
    4. Returns results
    """
    try:
        # Validate user permissions
        orchestration = await orchestrator.orchestrate(
            user_id=request.user_id,
            task=request.task,
            preferred_agent=request.agent_name
        )
        
        if orchestration["status"] == "error":
            raise HTTPException(
                status_code=403,
                detail=orchestration["message"]
            )
        
        # Get the agent
        agent_name = orchestration["selected_agent"]
        agent = AGENTS.get(agent_name)
        
        if not agent:
            raise HTTPException(
                status_code=404,
                detail=f"Agent {agent_name} not found"
            )
        
        # Create context
        context = AgentContext(
            user_id=request.user_id,
            session_id=request.session_id
        )
        
        if request.context:
            context.metadata.update(request.context)
        
        # Execute agent
        start_time = datetime.now()
        result = await agent.execute(request.task, context)
        execution_time = (datetime.now() - start_time).total_seconds()
        
        # Generate task ID
        task_id = f"{agent_name}_{request.user_id}_{int(start_time.timestamp())}"
        
        # Track usage
        orchestrator.track_agent_usage(
            user_id=request.user_id,
            agent_name=agent_name,
            task_id=task_id,
            status="completed"
        )
        
        return AgentRunResponse(
            status="success",
            agent_name=agent_name,
            task_id=task_id,
            result=result,
            execution_time=execution_time
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error executing agent: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error executing agent: {str(e)}"
        )


@router.get("/status/{task_id}", response_model=AgentStatusResponse)
async def get_agent_status(task_id: str):
    """
    Get the status of a running agent task.
    
    Note: This is a placeholder. In production, you would track
    task status in a database or cache (Redis).
    """
    # TODO: Implement actual task tracking
    return AgentStatusResponse(
        task_id=task_id,
        status="completed",
        agent_name="unknown",
        progress=100.0,
        result={"message": "Task tracking not yet implemented"}
    )


@router.get("/list", response_model=AgentListResponse)
async def list_agents(user_id: int):
    """
    List all agents available to a user based on their permissions.
    """
    try:
        # Get user permissions
        permissions = await orchestrator.get_user_agent_permissions(user_id)
        
        allowed_agents = permissions.get("allowed_agents", [])
        
        # Build agent list
        agents_info = []
        for agent_name in allowed_agents:
            agent = AGENTS.get(agent_name)
            if agent:
                agents_info.append({
                    "name": agent_name,
                    "description": agent.description,
                    "capabilities": getattr(agent, "capabilities", []),
                    "status": "available"
                })
        
        return AgentListResponse(
            agents=agents_info,
            total=len(agents_info)
        )
        
    except Exception as e:
        logger.error(f"Error listing agents: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error listing agents: {str(e)}"
        )


@router.post("/cancel/{task_id}")
async def cancel_agent_task(task_id: str, user_id: int):
    """
    Cancel a running agent task.
    
    Note: This is a placeholder. Actual implementation would require
    task tracking and cancellation logic.
    """
    # TODO: Implement task cancellation
    return {
        "status": "cancelled",
        "task_id": task_id,
        "message": "Task cancellation not yet implemented"
    }


@router.get("/history")
async def get_agent_history(
    user_id: int,
    limit: int = 10,
    offset: int = 0
):
    """
    Get agent execution history for a user.
    
    Note: This is a placeholder. Actual implementation would query
    from database.
    """
    # TODO: Implement history retrieval from database
    return {
        "history": [],
        "total": 0,
        "limit": limit,
        "offset": offset,
        "message": "History tracking not yet implemented"
    }


@router.get("/capabilities/{agent_name}")
async def get_agent_capabilities(agent_name: str):
    """Get detailed capabilities of a specific agent"""
    agent = AGENTS.get(agent_name)
    
    if not agent:
        raise HTTPException(
            status_code=404,
            detail=f"Agent {agent_name} not found"
        )
    
    return {
        "name": agent_name,
        "description": agent.description,
        "system_prompt": agent.get_system_prompt(),
        "tools": agent.get_tools(),
        "model": agent.model,
        "temperature": agent.temperature
    }
