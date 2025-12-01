# SG-SST Agentic Compliance System

Sistema de Gestión de Seguridad y Salud en el Trabajo (SG-SST) con **Inteligencia Artificial Agentic** compliant with Colombian regulations.

## 🌟 What's New - Agentic AI

This system now features a **complete agentic AI architecture** that enables:

- 🤖 **Intelligent Agents** - Specialized AI agents for risk assessment, document processing, email generation, and general assistance
- 💬 **Natural Language to SQL** - Query your database using plain language questions
- 🔄 **Automated Workflows** - Multi-step processes orchestrated by AI agents
- 📚 **RAG (Retrieval-Augmented Generation)** - Context-aware responses using your documents
- 🎯 **Role-Based Agent Access** - Agents adapt to user roles and permissions

## Features

### Core Compliance Features
- ✅ **100% Colombian Law Compliant** - Decreto 1072/2015, Resolución 0312/2019, GTC 45
- 🤖 **Intelligent Forms** - Eliminates redundant data entry
- 🔐 **Role-Based Access Control** - CEO, Coordinador SST, Gerente RRHH, Auditor, Consulta
- 📊 **Real-Time Indicators** - Automated calculation of safety metrics
- 🔔 **Smart Alerts** - Automatic notifications for deadlines and compliance
- 📱 **Responsive Design** - Works on desktop, tablet, and mobile

### Agentic AI Features
- 🧠 **AssistantAgent** - General-purpose assistant for SG-SST queries and navigation
- ⚠️ **RiskAgent** - Specialized in hazard identification and risk assessment
- 📄 **DocumentAgent** - Processes and analyzes documents for compliance
- 📧 **EmailAgent** - Generates professional communications and notifications
- 🔍 **Text-to-SQL Engine** - Query database using natural language
- 🔄 **Workflow Orchestration** - Automated multi-step processes
- 📚 **RAG System** - Semantic search across regulatory documents

## Tech Stack

### Backend
- **Python 3.11+**
- **FastAPI** - Modern, fast web framework
- **SQLAlchemy** - ORM for SQL Server
- **LangChain** - AI agent framework
- **OpenAI GPT-4** - Large Language Model
- **Pydantic** - Data validation
- **PyODBC** - SQL Server driver

### Frontend
- **Vue.js 3** - Progressive JavaScript framework
- **Vite** - Fast build tool
- **Pinia** - State management
- **Axios** - HTTP client

### Database
- **Microsoft SQL Server** - Enterprise database with stored procedures

### AI/ML
- **OpenAI API** - GPT-4 for natural language processing
- **FAISS** - Vector store for semantic search
- **Sentence Transformers** - Document embeddings

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration

## Project Structure

```
SGSST-AGENTIC/
├── backend/                    # FastAPI backend
│   ├── agents/                # AI Agents
│   │   ├── base_agent.py     # Base agent class
│   │   ├── assistant_agent.py # General assistant
│   │   ├── risk_agent.py     # Risk assessment agent
│   │   ├── document_agent.py # Document processing agent
│   │   ├── email_agent.py    # Email generation agent
│   │   └── tools/            # Agent tools
│   │       └── query_tools.py # Text-to-SQL engine
│   ├── orchestrator/          # Agent orchestration
│   │   ├── role_orchestrator.py # Role-based routing
│   │   └── workflow_engine.py   # Workflow execution
│   ├── workflows/             # Predefined workflows
│   │   ├── risk_workflow.py
│   │   ├── document_workflow.py
│   │   └── onboarding_flow.py
│   ├── rag/                   # RAG system
│   │   ├── rag_pipeline.py   # RAG orchestration
│   │   ├── vectorstore.py    # Vector database
│   │   ├── embeddings.py     # Embedding generation
│   │   └── loaders/          # Document loaders
│   ├── prompts/               # LLM prompts
│   │   ├── assistant_prompts.py
│   │   ├── risk_prompts.py
│   │   ├── doc_prompts.py
│   │   ├── email_prompts.py
│   │   └── sql_prompts.py
│   ├── data/                  # Data schemas
│   │   └── schema_context.py # Database schema for LLM
│   ├── api/                   # API application
│   │   ├── main.py           # FastAPI app entry point
│   │   ├── config.py         # Configuration (TOML-based)
│   │   ├── database/         # Database connection
│   │   ├── models/           # SQLAlchemy models
│   │   ├── routers/          # API endpoints
│   │   │   ├── agent_router.py    # Agent execution
│   │   │   ├── workflow_router.py # Workflow management
│   │   │   └── rag_router.py      # RAG queries
│   │   ├── services/         # Business logic
│   │   └── utils/            # Utilities
│   ├── tests/                # Backend tests
│   ├── requirements.txt      # Python dependencies
│   ├── config.example.toml   # Example configuration
│   └── Dockerfile            # Backend Docker image
├── frontend/                  # Vue.js frontend
│   ├── src/
│   │   ├── views/
│   │   │   └── AgenticConsole.vue # AI Agent interface
│   │   ├── components/
│   │   │   └── AgentTools.vue     # Agent tools panel
│   │   ├── router/           # Vue Router
│   │   ├── stores/           # Pinia stores
│   │   └── services/         # API services
│   ├── package.json          # Node dependencies
│   └── Dockerfile            # Frontend Docker image
├── BD/                        # Database scripts
│   └── Claude3_SGSST_BD_Script.sql
├── docs/                      # Documentation
│   ├── AGENTIC_README.md     # Agentic architecture guide
│   ├── ROADMAP.md            # Development roadmap
│   ├── ROLES_ARCHITECTURE.md # Role system documentation
│   └── DB_INTEGRATION_SUMMARY.md # Database integration
├── docker-compose.yml         # Docker Compose configuration
└── README.md                  # This file
```

## Quick Start

### Prerequisites

- Python 3.11+
- Node.js 18+
- SQL Server (local or remote)
- **OpenAI API Key** (for AI features)
- Docker & Docker Compose (for containerized deployment)

### 1. Database Setup

```bash
# Run the database creation script in SQL Server
# Use SQL Server Management Studio or Azure Data Studio
# Execute: BD/Claude3_SGSST_BD_Script.sql
```

### 2. Environment Configuration

```bash
# Create .env file in backend directory
cd backend
echo "OPENAI_API_KEY=sk-your-key-here" > .env
```

### 3. Backend Setup (Development)

```bash
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Copy and configure settings
copy config.example.toml config.toml
# Edit config.toml with your database connection string

# Run development server
uvicorn api.main:app --reload --host 0.0.0.0 --port 8000
```

Backend will be available at: http://localhost:8000  
API documentation: http://localhost:8000/docs

### 4. Frontend Setup (Development)

```bash
cd frontend

# Install dependencies
npm install

# Run development server
npm run dev
```

Frontend will be available at: http://localhost:5173

### 5. Setup Vector Store (for RAG)

```bash
cd backend
# Run the vectorstore setup script
.\setup_vectorstore.ps1
```

### 6. Docker Deployment (Production)

```bash
# Copy and configure environment
copy backend/config.example.toml backend/config.toml
# Edit backend/config.toml with your settings
# Add OPENAI_API_KEY to backend/.env

# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

Services:
- Frontend: http://localhost:80
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

## Using the Agentic AI Features

### Accessing the Agentic Console

1. Navigate to `http://localhost:5173/agentic`
2. Select an agent from the sidebar:
   - **Asistente General** - General queries and navigation
   - **Agente de Riesgos** - Risk assessment
   - **Agente de Documentos** - Document processing
   - **Agente de Correos** - Email generation

### Text-to-SQL Queries

Ask questions in natural language:

```
¿Cuántos empleados tenemos activos?
Dame la lista de incidentes del último mes
¿Qué capacitaciones están programadas para diciembre?
Muéstrame los peligros identificados en el área de producción
```

The system will:
1. Convert your question to SQL
2. Validate it's read-only (security)
3. Execute the query
4. Return results in a table format

### Running Workflows

Click on a workflow in the sidebar:
- **Evaluación de Riesgos** - Complete risk assessment process
- **Procesamiento de Documentos** - Document ingestion and analysis
- **Incorporación de Empleado** - New employee onboarding

### RAG Queries

Toggle "Búsqueda RAG" to search across your regulatory documents and get context-aware answers.

## Configuration

Configuration is managed via TOML files and environment variables.

### Backend Configuration (`backend/config.toml`)

```toml
[app]
name = "SG-SST API"
version = "1.0.0"
debug = false

[database]
driver = "ODBC Driver 17 for SQL Server"
server = "localhost"
database = "SG_SST_AgenteInteligente"
username = "sa"
password = "YourPassword"
port = 1433
trusted_connection = false

[security]
secret_key = "your-secret-key-here-change-in-production"
algorithm = "HS256"
access_token_expire_minutes = 30

[cors]
origins = ["http://localhost:5173", "http://localhost:80"]

[openai]
# API key is read from .env file
model = "gpt-4"
temperature = 0.7

[alerts]
dias_alerta_emo = 45
dias_alerta_comite = 60
dias_alerta_equipos = 30
frecuencia_revision_horas = 6
```

### Environment Variables (`backend/.env`)

```bash
OPENAI_API_KEY=sk-your-openai-api-key-here
```

## API Documentation

Once the backend is running, visit:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### Agentic AI Endpoints

- `POST /api/agent/run` - Execute an agent task
- `GET /api/agent/list` - List available agents
- `GET /api/agent/capabilities/{agent_name}` - Get agent capabilities
- `POST /api/workflow/start` - Start a workflow
- `GET /api/workflow/status/{workflow_id}` - Get workflow status
- `POST /api/rag/query` - Query the RAG system
- `POST /api/rag/ingest` - Ingest documents into vectorstore

## Default Users

After running the database script, you'll have these test users:

| Email | Password | Role | Access Level |
|-------|----------|------|--------------|
| ceo@digitalbulks.com | (set on first login) | CEO | Full access + All agents |
| maria.gomez@digitalbulks.com | (set on first login) | Coordinador SST | Full SST access + Risk/Doc agents |

## Development

### Running Tests

```bash
# Backend tests
cd backend
pytest tests/ -v --cov=api

# Frontend tests
cd frontend
npm run test
```

### Code Quality

```bash
# Backend linting
cd backend
flake8 api/
black api/

# Frontend linting
cd frontend
npm run lint
```

## Deployment

### Docker Production Deployment

1. **Configure environment**:
   ```bash
   # Edit backend/config.toml with production settings
   # Set debug = false
   # Use strong secret_key
   # Configure production database
   # Add OPENAI_API_KEY to backend/.env
   ```

2. **Build and deploy**:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

3. **Setup reverse proxy** (Nginx/Traefik):
   - Configure SSL/TLS certificates
   - Setup domain routing
   - Enable rate limiting

### Manual Deployment

See `docs/DEPLOYMENT.md` for detailed deployment instructions.

## Security

### AI Security Features

- ✅ **SQL Injection Prevention** - Text-to-SQL validates all queries
- ✅ **Read-Only Queries** - Only SELECT statements allowed
- ✅ **Role-Based Agent Access** - Agents respect user permissions
- ✅ **Prompt Injection Protection** - Sanitized inputs to LLM
- ✅ **API Key Security** - Keys stored in environment variables

## Legal Compliance

This system is designed to comply with:

- ✅ **Decreto 1072 de 2015** - Unified Labor Decree
- ✅ **Resolución 0312 de 2019** - Minimum SG-SST Standards
- ✅ **Resolución 1401 de 2007** - Accident Investigation
- ✅ **GTC 45** - Risk Identification and Assessment
- ✅ **Ley 1562 de 2012** - Occupational Health Services

See `LEGAL_COMPLIANCE_ANALYSIS.md` for detailed compliance mapping.

## Architecture Documentation

For detailed information about the agentic architecture:

- **[AGENTIC_README.md](./AGENTIC_README.md)** - Complete agentic architecture guide
- **[ROADMAP.md](./ROADMAP.md)** - Development roadmap to full autonomy
- **[ROLES_ARCHITECTURE.md](./ROLES_ARCHITECTURE.md)** - Role-based access system
- **[DB_INTEGRATION_SUMMARY.md](./DB_INTEGRATION_SUMMARY.md)** - Database integration details

## Support

For issues, questions, or contributions, please contact the development team or open an issue on GitHub.

## License

Proprietary - All rights reserved

---

**Version**: 2.0.0 (Agentic)  
**Last Updated**: December 1, 2024  
**AI Powered**: OpenAI GPT-4
