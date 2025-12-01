# Agentic Architecture for SG-SST

This directory contains the agentic AI architecture for the SG-SST system, now fully integrated with the SQL Server database and a unified frontend interface.

## 🌟 Current Features (v2.0)

### 🖥️ Unified Interface
- **Global Navigation**: Unified Navbar with tabs for Dashboard, Tasks, Forms, Reports, Employees, and Agentic Console.
- **Agentic Console**: Centralized hub for interacting with all AI agents.
- **Notification Center**: Real-time alerts and task notifications.
- **Offline Fallback**: Robust error handling that provides mock data when backend services are unavailable.

### 🤖 Intelligent Agents
The system implements 4 specialized agents, now powered by real database tools:

1. **Risk Agent (`risk_agent.py`)**
   - **Capabilities**: Hazard identification, risk evaluation, control recommendations.
   - **DB Integration**: Can query accident indicators, create corrective tasks, and access risk matrices.
   - **Tools**: `get_accident_indicators`, `create_corrective_task`, `get_hazards_by_area`.

2. **Document Agent (`document_agent.py`)**
   - **Capabilities**: Document processing, compliance verification, semantic search.
   - **DB Integration**: Access to document repository, legal requirements, and templates.
   - **Tools**: `get_documents_by_type`, `verify_document_compliance`, `search_documents_by_keyword`.

3. **Email Agent (`email_agent.py`)**
   - **Capabilities**: Communication management, alert generation, task notifications.
   - **DB Integration**: Access to pending alerts, employee directories, and task deadlines.
   - **Tools**: `get_pending_alerts`, `generate_automatic_alerts`, `create_task_notification`.

4. **Assistant Agent (`assistant_agent.py`)**
   - **Capabilities**: General system navigation, executive reporting, data analysis.
   - **DB Integration**: Full read access to system tables for reporting and queries.
   - **Tools**: `get_executive_report`, `search_any_table`, `get_work_plan_compliance`.

## 🏗️ Architecture Overview

```
Frontend (Vue.js)
    │
    ▼
Backend (FastAPI) ───▶ Auth & Roles (JWT + RBAC)
    │
    ├──▶ API Routers (Standard CRUD)
    │
    └──▶ Agent Orchestrator
           │
           ├──▶ Risk Agent ──────┐
           ├──▶ Doc Agent  ──────┤
           ├──▶ Email Agent ─────┼──▶ Base Tools ──▶ SQL Server (Stored Procedures)
           └──▶ Assistant Agent ─┘
```

## 🔌 Database Integration

The system is tightly integrated with SQL Server through a dedicated tools layer:

- **Stored Procedures**: 12+ SPs integrated for complex logic (Indicators, Reports, Alerts).
- **CRUD Operations**: Generic CRUD wrappers for all system tables.
- **Authentication**: All agent actions are performed under the authenticated user's context.

## 🚀 Getting Started

### 1. Prerequisites
- SQL Server with SG-SST database
- Python 3.10+
- Node.js 16+
- OpenAI API Key

### 2. Backend Setup
```bash
cd backend
pip install -r requirements.txt
# Configure .env with DB credentials and OpenAI Key
python api/main.py
```

### 3. Frontend Setup
```bash
cd frontend
npm install
npm run dev
```

### 4. Database Setup
Run the setup scripts in `BD/` to create necessary tables and stored procedures:
- `setup_agentic_roles.sql`: Configures agent permissions.
- `SP_*.sql`: Creates all required stored procedures.

## 📚 Documentation Resources

- **[ROADMAP.md](../ROADMAP.md)**: Future plans for RAG, Vector DB, and autonomous agents.
- **[QUICK_START.md](../QUICK_START.md)**: Detailed installation guide.
- **[ROLES_ARCHITECTURE.md](../ROLES_ARCHITECTURE.md)**: Explanation of the permission system.
- **[DB_INTEGRATION_SUMMARY.md](../DB_INTEGRATION_SUMMARY.md)**: Technical details of DB tools.

## ⚠️ Important Notes

- **Authentication**: The system uses JWT. Agents inherit the user's permissions.
- **Fallback Mode**: If the DB is unreachable, the frontend will show mock data to prevent crashes.
- **Vector Store**: Currently in transition to a persistent solution (see Roadmap).
