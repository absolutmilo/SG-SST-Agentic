"""
Agent Router

Intelligent routing of tasks to appropriate agents based on
intent classification and context analysis.
"""

from typing import Dict, Any, Optional, List
import logging
import re

logger = logging.getLogger(__name__)


class IntentClassifier:
    """Classifies user intent from task description"""
    
    # Intent patterns (keyword-based for now, will be enhanced with LLM)
    PATTERNS = {
        "risk_assessment": [
            r"\b(riesgo|peligro|hazard|risk)\b",
            r"\b(matriz|matrix)\b",
            r"\b(evalua(r|ción)|assess|evaluation)\b",
            r"\b(control(es)?)\b"
        ],
        "document_processing": [
            r"\b(documento|document|pdf|docx|archivo|file)\b",
            r"\b(extrae(r|cción)|extract)\b",
            r"\b(resumen|summary|sumari[zs]e)\b",
            r"\b(clasifica(r|ción)|classif(y|ication))\b",
            r"\b(compliance|cumplimiento)\b"
        ],
        "email_communication": [
            r"\b(correo|email|e-mail)\b",
            r"\b(notifica(r|ción)|notif(y|ication))\b",
            r"\b(envia(r|do)|send|sent)\b",
            r"\b(recordatorio|reminder)\b",
            r"\b(alerta|alert)\b"
        ],
        "general_query": [
            r"\b(qué|what|cómo|how|cuándo|when|dónde|where|por qué|why)\b",
            r"\b(ayuda|help|asistencia|assistance)\b",
            r"\b(explica(r|ción)|explain)\b",
            r"\b(información|information)\b"
        ]
    }
    
    @classmethod
    def classify(cls, task: str) -> Dict[str, float]:
        """
        Classify task intent with confidence scores.
        
        Args:
            task: Task description
        
        Returns:
            Dictionary of intent -> confidence score
        """
        task_lower = task.lower()
        scores = {}
        
        for intent, patterns in cls.PATTERNS.items():
            matches = sum(1 for pattern in patterns if re.search(pattern, task_lower, re.IGNORECASE))
            confidence = min(matches / len(patterns), 1.0)
            scores[intent] = confidence
        
        return scores
    
    @classmethod
    def get_primary_intent(cls, task: str) -> str:
        """Get the primary intent with highest confidence"""
        scores = cls.classify(task)
        if not scores:
            return "general_query"
        return max(scores.items(), key=lambda x: x[1])[0]


class Router:
    """
    Routes tasks to appropriate agents based on intent and context.
    
    Features:
    - Intent classification
    - Context-aware routing
    - Fallback handling
    - Multi-agent routing for complex tasks
    - Routing analytics
    """
    
    # Intent to agent mapping
    INTENT_AGENT_MAP = {
        "risk_assessment": "risk_agent",
        "document_processing": "document_agent",
        "email_communication": "email_agent",
        "general_query": "assistant_agent"
    }
    
    def __init__(self):
        self.logger = logging.getLogger("orchestrator.router")
        self.routing_history: List[Dict[str, Any]] = []
    
    async def route(
        self,
        task: str,
        context: Optional[Dict[str, Any]] = None,
        available_agents: Optional[List[str]] = None
    ) -> Dict[str, Any]:
        """
        Route a task to the appropriate agent.
        
        Args:
            task: Task description
            context: Optional context (user info, previous interactions, etc.)
            available_agents: Optional list of available agents (for permission filtering)
        
        Returns:
            Routing decision with selected agent and confidence
        """
        # Classify intent
        intent_scores = IntentClassifier.classify(task)
        primary_intent = max(intent_scores.items(), key=lambda x: x[1])[0] if intent_scores else "general_query"
        
        # Map intent to agent
        selected_agent = self.INTENT_AGENT_MAP.get(primary_intent, "assistant_agent")
        
        # Check if agent is available (permission filtering)
        if available_agents and selected_agent not in available_agents:
            # Fallback to assistant if primary agent not available
            if "assistant_agent" in available_agents:
                selected_agent = "assistant_agent"
                self.logger.warning(
                    f"Primary agent {selected_agent} not available, falling back to assistant"
                )
            else:
                # Use first available agent
                selected_agent = available_agents[0] if available_agents else "assistant_agent"
                self.logger.warning(
                    f"No suitable agent available, using {selected_agent}"
                )
        
        # Build routing decision
        decision = {
            "selected_agent": selected_agent,
            "primary_intent": primary_intent,
            "intent_scores": intent_scores,
            "confidence": intent_scores.get(primary_intent, 0.0),
            "task": task,
            "context": context or {},
            "available_agents": available_agents
        }
        
        # Log routing decision
        self._log_routing(decision)
        
        return decision
    
    async def route_multi_agent(
        self,
        task: str,
        context: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Route a complex task that may require multiple agents.
        
        Args:
            task: Complex task description
            context: Optional context
        
        Returns:
            Multi-agent routing plan
        """
        intent_scores = IntentClassifier.classify(task)
        
        # Select all agents with confidence > 0.3
        threshold = 0.3
        selected_agents = [
            self.INTENT_AGENT_MAP[intent]
            for intent, score in intent_scores.items()
            if score > threshold
        ]
        
        # If no agents meet threshold, use primary intent
        if not selected_agents:
            primary_intent = IntentClassifier.get_primary_intent(task)
            selected_agents = [self.INTENT_AGENT_MAP.get(primary_intent, "assistant_agent")]
        
        # Remove duplicates while preserving order
        selected_agents = list(dict.fromkeys(selected_agents))
        
        return {
            "agents": selected_agents,
            "intent_scores": intent_scores,
            "task": task,
            "execution_mode": "sequential" if len(selected_agents) > 1 else "single",
            "context": context or {}
        }
    
    def suggest_agent(
        self,
        task: str,
        available_agents: List[str]
    ) -> Dict[str, Any]:
        """
        Suggest the best agent for a task from available options.
        
        Args:
            task: Task description
            available_agents: List of available agent names
        
        Returns:
            Suggestion with reasoning
        """
        intent_scores = IntentClassifier.classify(task)
        primary_intent = max(intent_scores.items(), key=lambda x: x[1])[0] if intent_scores else "general_query"
        
        # Get ideal agent
        ideal_agent = self.INTENT_AGENT_MAP.get(primary_intent, "assistant_agent")
        
        # Check if ideal agent is available
        if ideal_agent in available_agents:
            return {
                "suggested_agent": ideal_agent,
                "confidence": intent_scores.get(primary_intent, 0.0),
                "reasoning": f"Best match for {primary_intent} intent",
                "alternatives": [a for a in available_agents if a != ideal_agent]
            }
        else:
            # Find best alternative
            for intent, score in sorted(intent_scores.items(), key=lambda x: x[1], reverse=True):
                agent = self.INTENT_AGENT_MAP.get(intent)
                if agent and agent in available_agents:
                    return {
                        "suggested_agent": agent,
                        "confidence": score,
                        "reasoning": f"Alternative match for {intent} intent (ideal agent {ideal_agent} not available)",
                        "alternatives": [a for a in available_agents if a != agent]
                    }
            
            # Fallback to first available
            return {
                "suggested_agent": available_agents[0] if available_agents else "assistant_agent",
                "confidence": 0.0,
                "reasoning": "No good match found, using fallback",
                "alternatives": available_agents[1:] if len(available_agents) > 1 else []
            }
    
    def _log_routing(self, decision: Dict[str, Any]):
        """Log routing decision for analytics"""
        self.routing_history.append({
            "timestamp": None,  # Would use datetime.now()
            "agent": decision["selected_agent"],
            "intent": decision["primary_intent"],
            "confidence": decision["confidence"]
        })
        
        self.logger.info(
            f"Routed to {decision['selected_agent']}",
            extra={
                "intent": decision["primary_intent"],
                "confidence": decision["confidence"]
            }
        )
    
    def get_routing_stats(self) -> Dict[str, Any]:
        """Get routing statistics"""
        if not self.routing_history:
            return {"total_routes": 0}
        
        total = len(self.routing_history)
        agent_counts = {}
        intent_counts = {}
        
        for entry in self.routing_history:
            agent = entry["agent"]
            intent = entry["intent"]
            
            agent_counts[agent] = agent_counts.get(agent, 0) + 1
            intent_counts[intent] = intent_counts.get(intent, 0) + 1
        
        return {
            "total_routes": total,
            "agent_distribution": agent_counts,
            "intent_distribution": intent_counts,
            "average_confidence": sum(e["confidence"] for e in self.routing_history) / total
        }
