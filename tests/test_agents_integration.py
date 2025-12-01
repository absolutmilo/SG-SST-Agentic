
import sys
import os
import asyncio
import logging

# Add backend to path
sys.path.append(os.path.join(os.getcwd(), "backend"))

from agents.risk_agent import RiskAgent
from agents.document_agent import DocumentAgent
from agents.email_agent import EmailAgent
from agents.assistant_agent import AssistantAgent

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def test_agents_initialization():
    """Test that all agents can be initialized and have tools."""
    print("Testing Agent Integration...")
    
    try:
        # 1. Risk Agent
        print("\n1. Testing Risk Agent...")
        risk_agent = RiskAgent()
        tools = risk_agent.get_tools()
        print(f"✅ Risk Agent initialized with {len(tools)} tools")
        for tool in tools:
            print(f"   - {tool['function']['name']}")
            
        # 2. Document Agent
        print("\n2. Testing Document Agent...")
        doc_agent = DocumentAgent()
        tools = doc_agent.get_tools()
        print(f"✅ Document Agent initialized with {len(tools)} tools")
        for tool in tools:
            print(f"   - {tool['function']['name']}")
            
        # 3. Email Agent
        print("\n3. Testing Email Agent...")
        email_agent = EmailAgent()
        tools = email_agent.get_tools()
        print(f"✅ Email Agent initialized with {len(tools)} tools")
        for tool in tools:
            print(f"   - {tool['function']['name']}")
            
        # 4. Assistant Agent
        print("\n4. Testing Assistant Agent...")
        assist_agent = AssistantAgent()
        tools = assist_agent.get_tools()
        print(f"✅ Assistant Agent initialized with {len(tools)} tools")
        for tool in tools:
            print(f"   - {tool['function']['name']}")
            
        print("\n✅ All agents initialized successfully!")
        return True
        
    except Exception as e:
        print(f"\n❌ Error testing agents: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    asyncio.run(test_agents_initialization())
