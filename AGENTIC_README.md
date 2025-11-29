# Agentic Architecture for SG-SST

This directory contains the agentic AI architecture for the SG-SST system.

## 📁 Structure

```
backend/
├── agents/              # Specialized AI agents
│   ├── base_agent.py    # Abstract base agent
│   ├── risk_agent.py    # Risk assessment
│   ├── document_agent.py # Document processing
│   ├── email_agent.py   # Email generation
│   └── assistant_agent.py # General assistant
│
├── orchestrator/        # Agent orchestration
│   ├── role_orchestrator.py  # Role-based routing
│   ├── workflow_engine.py    # Workflow execution
│   └── router.py             # Intent-based routing
│
├── rag/                 # Retrieval-Augmented Generation
│   ├── loaders.py       # Document loaders
│   ├── embeddings.py    # Embedding generation
│   ├── vectorstore.py   # FAISS vectorstore
│   ├── rag_pipeline.py  # Complete RAG pipeline
│   └── legal_prompt.py  # Legal compliance prompts
│
├── review/              # Automated review
│   ├── validator.py     # Output validation
│   ├── compliance_checker.py # Compliance verification
│   └── hallucination_guard.py # Hallucination detection
│
├── workflows/           # Predefined workflows
│   ├── risk_workflow.py      # Risk assessment flow
│   ├── document_workflow.py  # Document processing flow
│   └── onboarding_flow.py    # Employee onboarding flow
│
└── prompts/             # Prompt templates
    ├── risk_prompts.py
    ├── email_prompts.py
    ├── doc_prompts.py
    └── assistant_prompts.py

vector/                  # Vectorstore & ingestion
├── config.yaml          # Configuration
├── ingest.py            # Document ingestion script
└── query_example.py     # Query examples
```

## 🚀 Getting Started

### 1. Install Dependencies

```bash
cd backend
pip install -r requirements.txt
```

### 2. Configure Environment

Create a `.env` file in the project root:

```env
# OpenAI Configuration
OPENAI_API_KEY=your_api_key_here
LLM_MODEL=gpt-4
LLM_TEMPERATURE=0.7

# Vectorstore Configuration
VECTOR_STORE_PATH=./vector/index
EMBEDDING_MODEL=sentence-transformers/all-MiniLM-L6-v2

# Agent Configuration
AGENT_MAX_ITERATIONS=10
AGENT_TIMEOUT=300
```

### 3. Ingest Documents (Optional)

```bash
# Ingest from a directory
python vector/ingest.py --directory ./documents/policies --type policy

# Or ingest from config file
python vector/ingest.py --config
```

### 4. Test RAG Queries

```bash
# Run query examples
python vector/query_example.py

# Run specific example
python vector/query_example.py --example 3
```

## 🤖 Available Agents

### Risk Agent
- Hazard identification
- Risk evaluation (probability × severity)
- Control recommendations
- Risk matrix generation

### Document Agent
- PDF/DOCX extraction
- Document classification
- Compliance verification
- Semantic search

### Email Agent
- Task notifications
- Deadline reminders
- Compliance alerts
- Training invitations

### Assistant Agent
- General SG-SST queries
- System navigation help
- Process explanations
- Agent delegation

## 🔄 Workflows

### Risk Assessment Workflow
1. Identify hazards
2. Evaluate risks
3. Determine controls
4. Generate risk matrix
5. Create corrective tasks
6. Notify responsible parties

### Document Processing Workflow
1. Extract content
2. Classify document
3. Index in vectorstore
4. Verify compliance
5. Generate summary
6. Catalog document

### Employee Onboarding Workflow
1. Create profile
2. Assign trainings
3. Generate checklist
4. Schedule medical exams
5. Assign PPE
6. Track completion

## 📊 Architecture Features

- **Role-Based Access**: Different agents available based on user role
- **Workflow Engine**: DAG-based execution with dependency management
- **RAG Pipeline**: Document retrieval with answer generation
- **Compliance Checking**: Automatic verification against SG-SST regulations
- **Hallucination Guard**: Fact verification and contradiction detection
- **Legal Prompts**: Built-in disclaimers and safety guidelines

## 🔐 Security & Compliance

- All outputs include legal disclaimers
- Compliance checking against Decreto 1072, Resolución 0312, GTC 45
- Hallucination detection and fact verification
- Content filtering for restricted topics
- Audit trail for all agent executions

## 📝 Next Steps

1. **Configure OpenAI API Key**: Add your API key to `.env`
2. **Ingest Documents**: Add your SG-SST documentation to the vectorstore
3. **Test Agents**: Try the different agents with sample queries
4. **Create API Endpoints**: Integrate with FastAPI backend
5. **Build Frontend**: Create UI components for agent interaction

## 🛠️ Development

### Running Tests
```bash
pytest backend/tests/
```

### Code Formatting
```bash
black backend/
flake8 backend/
```

## 📚 Documentation

- [Implementation Plan](../.gemini/antigravity/brain/37362b85-5d84-4f55-a0b8-e7bab80d22f2/implementation_plan.md)
- [Task Checklist](../.gemini/antigravity/brain/37362b85-5d84-4f55-a0b8-e7bab80d22f2/task.md)

## ⚠️ Important Notes

- **API Key Required**: Most functionality requires an OpenAI API key
- **FAISS Installation**: May require additional system dependencies
- **Memory Usage**: Embedding generation can be memory-intensive
- **Legal Disclaimer**: AI outputs are informational only, not legal advice
