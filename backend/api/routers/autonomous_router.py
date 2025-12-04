from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Dict, Any
from api.database import get_db
from api.routers.auth import get_current_active_user, AuthorizedUser
from agents.autonomous_agents import TaskCoordinatorAgent, PlanningAgent, AnalyticsAgent

router = APIRouter(
    responses={404: {"description": "Not found"}},
)

@router.post("/coordinate-tasks", response_model=List[Dict[str, Any]])
def coordinate_tasks(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Triggers the Task Coordinator Agent to:
    1. Monitor overdue tasks
    2. Create preventive tasks
    3. Rebalance workload
    4. Escalate critical tasks
    """
    try:
        agent = TaskCoordinatorAgent(db)
        actions = agent.analyze_and_coordinate()
        return actions
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error coordinating tasks: {str(e)}")

@router.post("/generate-plan")
def generate_annual_plan(
    year: int,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Triggers the Planning Agent to generate an annual work plan.
    """
    try:
        agent = PlanningAgent(db)
        plan = agent.generate_annual_plan(year)
        return plan
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error generating plan: {str(e)}")

@router.get("/analytics")
def get_analytics(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """
    Triggers the Analytics Agent to analyze trends and generate insights.
    """
    try:
        agent = AnalyticsAgent(db)
        insights = agent.analyze_trends()
        return insights
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error generating analytics: {str(e)}")
