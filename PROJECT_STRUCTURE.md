# SG-SST Project Structure

## Directory Tree

```
SGSST-AGENTIC/
│
├── 📁 BD/                                    # Database scripts
│   ├── Claude3_SGSST_BD_Script.sql          # Main database creation script
│   ├── Claude3_SGSST_BD_Script 2.sql        # Alternative version
│   └── V1/                                   # Version 1 scripts (individual tables)
│
├── 📁 backend/                               # FastAPI Backend
│   ├── 📁 api/                              # API application
│   │   ├── __init__.py
│   │   ├── main.py                          # ✅ FastAPI app entry point
│   │   ├── config.py                        # ✅ TOML configuration loader
│   │   │
│   │   ├── 📁 database/                     # Database layer
│   │   │   ├── __init__.py                  # ✅
│   │   │   └── connection.py                # ✅ SQLAlchemy engine & session
│   │   │
│   │   ├── 📁 models/                       # SQLAlchemy ORM models
│   │   │   ├── __init__.py                  # ✅
│   │   │   ├── employee.py                  # TODO: Employee model
│   │   │   ├── risk.py                      # TODO: Risk models
│   │   │   ├── event.py                     # TODO: Event models
│   │   │   ├── training.py                  # TODO: Training models
│   │   │   ├── medical.py                   # TODO: Medical models
│   │   │   ├── ppe.py                       # TODO: PPE models
│   │   │   ├── committee.py                 # TODO: Committee models
│   │   │   ├── task.py                      # TODO: Task models
│   │   │   ├── audit.py                     # TODO: Audit models
│   │   │   ├── document.py                  # TODO: Document models
│   │   │   └── user.py                      # TODO: User/Auth models
│   │   │
│   │   ├── 📁 schemas/                      # Pydantic schemas
│   │   │   ├── __init__.py                  # ✅
│   │   │   ├── employee.py                  # TODO: Employee schemas
│   │   │   ├── risk.py                      # TODO: Risk schemas
│   │   │   ├── event.py                     # TODO: Event schemas
│   │   │   ├── training.py                  # TODO: Training schemas
│   │   │   ├── medical.py                   # TODO: Medical schemas
│   │   │   ├── ppe.py                       # TODO: PPE schemas
│   │   │   ├── committee.py                 # TODO: Committee schemas
│   │   │   ├── task.py                      # TODO: Task schemas
│   │   │   ├── audit.py                     # TODO: Audit schemas
│   │   │   ├── document.py                  # TODO: Document schemas
│   │   │   ├── form.py                      # TODO: Intelligent form schemas
│   │   │   └── auth.py                      # TODO: Authentication schemas
│   │   │
│   │   ├── 📁 routers/                      # API endpoints
│   │   │   ├── __init__.py                  # ✅
│   │   │   ├── auth.py                      # TODO: Authentication endpoints
│   │   │   ├── employees.py                 # TODO: Employee CRUD
│   │   │   ├── risks.py                     # TODO: Risk management
│   │   │   ├── events.py                    # TODO: Event/incident endpoints
│   │   │   ├── training.py                  # TODO: Training endpoints
│   │   │   ├── medical.py                   # TODO: Medical endpoints
│   │   │   ├── ppe.py                       # TODO: PPE endpoints
│   │   │   ├── committees.py                # TODO: Committee endpoints
│   │   │   ├── tasks.py                     # TODO: Task endpoints
│   │   │   ├── audits.py                    # TODO: Audit endpoints
│   │   │   ├── documents.py                 # TODO: Document endpoints
│   │   │   ├── forms.py                     # TODO: Intelligent forms
│   │   │   ├── reports.py                   # TODO: Reports
│   │   │   └── alerts.py                    # TODO: Alerts
│   │   │
│   │   ├── 📁 services/                     # Business logic
│   │   │   ├── __init__.py                  # ✅
│   │   │   ├── auth_service.py              # TODO: Authentication logic
│   │   │   ├── form_service.py              # TODO: Intelligent form logic
│   │   │   ├── alert_service.py             # TODO: Alert generation
│   │   │   └── report_service.py            # TODO: Report generation
│   │   │
│   │   ├── 📁 middleware/                   # Middleware
│   │   │   ├── __init__.py                  # ✅
│   │   │   ├── auth.py                      # TODO: JWT middleware
│   │   │   └── logging.py                   # TODO: Request logging
│   │   │
│   │   └── 📁 utils/                        # Utilities
│   │       ├── __init__.py                  # ✅
│   │       ├── security.py                  # TODO: Password hashing, JWT
│   │       ├── validators.py                # TODO: Custom validators
│   │       └── helpers.py                   # TODO: Helper functions
│   │
│   ├── 📁 tests/                            # Backend tests
│   │   ├── __init__.py                      # TODO
│   │   ├── test_auth.py                     # TODO
│   │   ├── test_employees.py                # TODO
│   │   └── test_forms.py                    # TODO
│   │
│   ├── 📁 logs/                             # Log files (created by app)
│   ├── 📁 uploads/                          # Uploaded files (created by app)
│   ├── 📁 temp/                             # Temporary files (created by app)
│   │
│   ├── requirements.txt                      # ✅ Python dependencies
│   ├── config.example.toml                   # ✅ Example configuration
│   ├── config.toml                           # ⚠️ User must create (from example)
│   └── Dockerfile                            # ✅ Backend Docker image
│
├── 📁 frontend/                              # Vue.js Frontend
│   ├── 📁 public/                           # Public assets
│   │   └── favicon.ico                      # TODO: Add favicon
│   │
│   ├── 📁 src/                              # Source code
│   │   ├── 📁 assets/                       # Static assets
│   │   │   └── main.css                     # ✅ Global styles
│   │   │
│   │   ├── 📁 components/                   # Vue components
│   │   │   ├── Navbar.vue                   # TODO: Navigation bar
│   │   │   ├── Sidebar.vue                  # TODO: Sidebar menu
│   │   │   ├── Alert.vue                    # TODO: Alert component
│   │   │   ├── Modal.vue                    # TODO: Modal component
│   │   │   ├── DataTable.vue                # TODO: Data table
│   │   │   ├── FormField.vue                # TODO: Form field
│   │   │   └── IntelligentForm.vue          # TODO: Intelligent form
│   │   │
│   │   ├── 📁 views/                        # Page views
│   │   │   ├── LoginView.vue                # TODO: Login page
│   │   │   ├── DashboardView.vue            # TODO: Dashboard
│   │   │   ├── EmployeesView.vue            # TODO: Employees page
│   │   │   ├── EventsView.vue               # TODO: Events page
│   │   │   ├── TrainingView.vue             # TODO: Training page
│   │   │   ├── MedicalView.vue              # TODO: Medical page
│   │   │   ├── ReportsView.vue              # TODO: Reports page
│   │   │   └── SettingsView.vue             # TODO: Settings page
│   │   │
│   │   ├── 📁 router/                       # Vue Router
│   │   │   └── index.js                     # TODO: Router configuration
│   │   │
│   │   ├── 📁 stores/                       # Pinia stores
│   │   │   ├── auth.js                      # TODO: Auth store
│   │   │   ├── employees.js                 # TODO: Employees store
│   │   │   ├── alerts.js                    # TODO: Alerts store
│   │   │   └── ui.js                        # TODO: UI state store
│   │   │
│   │   ├── 📁 services/                     # API services
│   │   │   ├── api.js                       # TODO: Axios instance
│   │   │   ├── authService.js               # TODO: Auth API calls
│   │   │   ├── employeeService.js           # TODO: Employee API calls
│   │   │   ├── formService.js               # TODO: Form API calls
│   │   │   └── reportService.js             # TODO: Report API calls
│   │   │
│   │   ├── App.vue                          # ✅ Root component
│   │   └── main.js                          # ✅ App entry point
│   │
│   ├── index.html                            # ✅ HTML entry point
│   ├── package.json                          # ✅ Node dependencies
│   ├── vite.config.js                        # ✅ Vite configuration
│   ├── nginx.conf                            # ✅ Nginx config for Docker
│   └── Dockerfile                            # ✅ Frontend Docker image
│
├── 📁 docs/                                  # Documentation (optional)
│   ├── api/                                  # API documentation
│   ├── user-guide/                           # User guides
│   └── developer/                            # Developer docs
│
├── .gitignore                                # ✅ Git ignore rules
├── README.md                                 # ✅ Project overview
├── QUICK_START.md                            # ✅ Quick start guide
├── LEGAL_COMPLIANCE_ANALYSIS.md              # ✅ Legal compliance mapping
├── INTELLIGENT_FORMS_SPEC.md                 # ✅ Intelligent forms spec
├── docker-compose.yml                        # ✅ Docker Compose config
└── setup.ps1                                 # ✅ Setup script
```

## File Status Legend

- ✅ **Created and ready** - File exists and is configured
- ⚠️ **User action required** - File needs to be created or configured by user
- TODO - File needs to be implemented in next phases

## Key Files to Configure

### 1. Backend Configuration
**File**: `backend/config.toml`  
**Action**: Copy from `config.example.toml` and update:
- Database connection string
- Secret key for JWT
- CORS origins
- Alert settings

### 2. Database
**File**: `BD/Claude3_SGSST_BD_Script.sql`  
**Action**: Execute in SQL Server to create database

### 3. Environment Setup
**File**: `setup.ps1`  
**Action**: Run to initialize development environment

## Next Implementation Priority

### Phase 1: Authentication & Core Models (Days 1-2)
1. User model and authentication
2. Employee model
3. Company/Site models
4. JWT authentication endpoints
5. Login page

### Phase 2: Risk Management (Days 3-4)
1. Risk models
2. Risk CRUD endpoints
3. Risk management UI
4. Risk matrix visualization

### Phase 3: Events & Incidents (Days 5-6)
1. Event models
2. Event CRUD endpoints
3. Event reporting form (intelligent)
4. Investigation workflow

### Phase 4: Medical & Training (Days 7-9)
1. Medical exam models
2. Training models
3. Medical/Training endpoints
4. Intelligent forms for medical exams
5. Training calendar

### Phase 5: Reports & Analytics (Days 10-12)
1. Indicator calculations
2. Report generation
3. Dashboard with charts
4. Export functionality

### Phase 6: Testing & Polish (Days 13-15)
1. Unit tests
2. Integration tests
3. UI/UX improvements
4. Documentation
5. Deployment preparation

## Docker Services

When running `docker-compose up`:

1. **backend** (port 8000)
   - FastAPI application
   - Connects to SQL Server
   - Serves API endpoints

2. **frontend** (port 80)
   - Vue.js application (built)
   - Nginx web server
   - Proxies /api to backend

3. **sqlserver** (port 1433) - Optional
   - SQL Server 2022
   - Only if you don't have external SQL Server

## Development vs Production

### Development
- Backend: Uvicorn with `--reload`
- Frontend: Vite dev server with HMR
- Database: External SQL Server
- Logs: Console output

### Production (Docker)
- Backend: Uvicorn in container
- Frontend: Nginx serving built files
- Database: External SQL Server (recommended) or containerized
- Logs: Docker logs + file logs

## Technology Stack Summary

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Backend** | Python 3.11 | Programming language |
| | FastAPI | Web framework |
| | SQLAlchemy | ORM |
| | Pydantic | Data validation |
| | PyODBC | SQL Server driver |
| | TOML | Configuration format |
| **Frontend** | Vue.js 3 | UI framework |
| | Vite | Build tool |
| | Pinia | State management |
| | Vue Router | Routing |
| | Axios | HTTP client |
| **Database** | SQL Server | Database |
| **DevOps** | Docker | Containerization |
| | Docker Compose | Orchestration |
| | Nginx | Web server (production) |

---

**Status**: Project structure created ✅  
**Next**: Run `setup.ps1` and start development 🚀
