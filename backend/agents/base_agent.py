"""
Base Agent Module for SG-SST Agentic System

This module provides the abstract base class for all specialized agents.
"""

from abc import ABC, abstractmethod
from typing import Any, Dict, List, Optional
from datetime import datetime
import logging
from enum import Enum

logger = logging.getLogger(__name__)


class AgentStatus(Enum):
    """Agent execution status"""
    IDLE = "idle"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"
    CANCELLED = "cancelled"


class AgentMessage:
    """Represents a message in the agent's conversation history"""
    
    def __init__(self, role: str, content: str, timestamp: Optional[datetime] = None):
        self.role = role  # 'system', 'user', 'assistant'
        self.content = content
        self.timestamp = timestamp or datetime.now()
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "role": self.role,
            "content": self.content,
            "timestamp": self.timestamp.isoformat()
        }


class AgentContext:
    """Context and memory for agent execution"""
    
    def __init__(self, user_id: Optional[int] = None, session_id: Optional[str] = None):
        self.user_id = user_id
        self.session_id = session_id
        self.messages: List[AgentMessage] = []
        self.metadata: Dict[str, Any] = {}
        self.created_at = datetime.now()
    
    def add_message(self, role: str, content: str):
        """Add a message to the conversation history"""
        self.messages.append(AgentMessage(role, content))
    
    def get_messages(self) -> List[Dict[str, Any]]:
        """Get all messages as dictionaries"""
        return [msg.to_dict() for msg in self.messages]
    
    def clear_messages(self):
        """Clear conversation history"""
        self.messages = []


class BaseAgent(ABC):
    """
    Abstract base class for all agents in the system.
    
    Each agent should:
    - Have a specific role and capabilities
    - Maintain conversation context
    - Use tools (database, email, vectorstore, etc.)
    - Log all actions for traceability
    - Handle errors gracefully
    """
    
    def __init__(
        self,
        name: str,
        description: str,
        model: str = "gpt-4",
        temperature: float = 0.7,
        max_iterations: int = 10
    ):
        self.name = name
        self.description = description
        self.model = model
        self.temperature = temperature
        self.max_iterations = max_iterations
        self.status = AgentStatus.IDLE
        self.logger = logging.getLogger(f"agent.{name}")
    
    @abstractmethod
    async def execute(self, task: str, context: AgentContext) -> Dict[str, Any]:
        """
        Execute the agent's main task.
        
        Args:
            task: The task description or user query
            context: Agent context with conversation history and metadata
        
        Returns:
            Dictionary with execution results
        """
        pass
    
    @abstractmethod
    def get_system_prompt(self) -> str:
        """
        Get the system prompt that defines the agent's role and behavior.
        
        Returns:
            System prompt string
        """
        pass
    
    def get_tools(self) -> List[Dict[str, Any]]:
        """
        Get the list of tools available to this agent.
        
        Returns:
            List of tool definitions
        """
        return []
    
    async def _call_llm(
        self,
        messages: List[Dict[str, str]],
        tools: Optional[List[Dict[str, Any]]] = None
    ) -> Dict[str, Any]:
        """
        Call the LLM with the given messages and tools.
        
        Args:
            messages: List of conversation messages
            tools: Optional list of tools for function calling
        
        Returns:
            LLM response
        """
        from langchain.chat_models import ChatOpenAI
        from langchain.schema import HumanMessage, SystemMessage, AIMessage
        from api.config import get_settings
        
        settings = get_settings()
        if not settings.openai.api_key:
            # Fallback to env var if not in settings yet (during startup)
            import os
            api_key = os.getenv("OPENAI_API_KEY")
            if not api_key:
                return {
                    "content": "Error: OpenAI API key not configured. Please add OPENAI_API_KEY to your .env file.",
                    "role": "assistant"
                }
        else:
            api_key = settings.openai.api_key

        try:
            chat = ChatOpenAI(
                openai_api_key=api_key,
                model_name=self.model,
                temperature=self.temperature
            )
            
            # Convert dict messages to LangChain schema
            lc_messages = []
            for msg in messages:
                if msg["role"] == "system":
                    lc_messages.append(SystemMessage(content=msg["content"]))
                elif msg["role"] == "user":
                    lc_messages.append(HumanMessage(content=msg["content"]))
                elif msg["role"] == "assistant":
                    lc_messages.append(AIMessage(content=msg["content"]))
            
            # Call LLM
            # Note: Tools support would go here using bind_functions or similar
            response = await chat.apredict_messages(lc_messages)
            
            return {
                "content": response.content,
                "role": "assistant",
                "function_call": None # Placeholder for tool calls
            }
            
        except Exception as e:
            self.logger.error(f"LLM call failed: {str(e)}")
            return {
                "content": f"I encountered an error processing your request: {str(e)}",
                "role": "assistant"
            }
    
    def _log_execution(self, task: str, result: Dict[str, Any], duration: float):
        """Log agent execution for audit trail"""
        self.logger.info(
            f"Agent {self.name} executed task",
            extra={
                "task": task,
                "result": result,
                "duration": duration,
                "status": self.status.value
            }
        )
    
    async def validate_output(self, output: Dict[str, Any]) -> bool:
        """
        Validate the agent's output before returning.
        
        Args:
            output: The agent's output to validate
        
        Returns:
            True if valid, False otherwise
        """
        # Basic validation - can be overridden by subclasses
        return output is not None and isinstance(output, dict)
    
    def reset(self):
        """Reset agent state"""
        self.status = AgentStatus.IDLE
        self.logger.info(f"Agent {self.name} reset")
