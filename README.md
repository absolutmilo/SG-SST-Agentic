# SG-SST Compliance System

Sistema de Gestión de Seguridad y Salud en el Trabajo (SG-SST) compliant with Colombian regulations.

## Features

- ✅ **100% Colombian Law Compliant** - Decreto 1072/2015, Resolución 0312/2019, GTC 45
- 🤖 **Intelligent Forms** - Eliminates redundant data entry
- 🔐 **Role-Based Access Control** - CEO, Coordinador SST, Gerente RRHH, Auditor, Consulta
- 📊 **Real-Time Indicators** - Automated calculation of safety metrics
- 🔔 **Smart Alerts** - Automatic notifications for deadlines and compliance
- 📱 **Responsive Design** - Works on desktop, tablet, and mobile

## Tech Stack

### Backend
- **Python 3.11+**
- **FastAPI** - Modern, fast web framework
- **SQLAlchemy** - ORM for SQL Server
- **Pydantic** - Data validation
- **PyODBC** - SQL Server driver

### Frontend
- **Vue.js 3** - Progressive JavaScript framework
- **Vite** - Fast build tool
- **Pinia** - State management
- **Axios** - HTTP client

### Database
- **Microsoft SQL Server** - Enterprise database

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration

## Project Structure

```
SGSST-AGENTIC/
├── backend/                 # FastAPI backend
│   ├── api/                # API application
│   │   ├── main.py        # FastAPI app entry point
│   │   ├── config.py      # Configuration (TOML-based)
│   │   ├── database/      # Database connection
│   │   ├── models/        # SQLAlchemy models
│   │   ├── schemas/       # Pydantic schemas
│   │   ├── routers/       # API endpoints
│   │   ├── services/      # Business logic
│   │   ├── middleware/    # Middleware
│   │   └── utils/         # Utilities
│   ├── tests/             # Backend tests
│   ├── requirements.txt   # Python dependencies
│   ├── config.example.toml # Example configuration
│   └── Dockerfile         # Backend Docker image
├── frontend/              # Vue.js frontend
│   ├── src/              # Source code
│   │   ├── assets/       # Static assets
│   │   ├── components/   # Vue components
│   │   ├── views/        # Page views
│   │   ├── router/       # Vue Router
│   │   ├── stores/       # Pinia stores
│   │   ├── services/     # API services
│   │   └── App.vue       # Root component
│   ├── public/           # Public assets
│   ├── package.json      # Node dependencies
│   ├── vite.config.js    # Vite configuration
│   └── Dockerfile        # Frontend Docker image
├── BD/                   # Database scripts
│   └── Claude3_SGSST_BD_Script.sql
├── docker-compose.yml    # Docker Compose configuration
└── README.md            # This file
```

## Quick Start

### Prerequisites

- Python 3.11+
- Node.js 18+
- SQL Server (local or remote)
- Docker & Docker Compose (for containerized deployment)

### 1. Database Setup

```bash
# Run the database creation script in SQL Server
# Use SQL Server Management Studio or Azure Data Studio
# Execute: BD/Claude3_SGSST_BD_Script.sql
```

### 2. Backend Setup (Development)

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

### 3. Frontend Setup (Development)

```bash
cd frontend

# Install dependencies
npm install

# Run development server
npm run dev
```

Frontend will be available at: http://localhost:5173

### 4. Docker Deployment (Production)

```bash
# Copy and configure environment
copy backend/config.example.toml backend/config.toml
# Edit backend/config.toml with your settings

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

## Configuration

Configuration is managed via TOML files (not JSON) for better readability and type safety.

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

[alerts]
dias_alerta_emo = 45
dias_alerta_comite = 60
dias_alerta_equipos = 30
frecuencia_revision_horas = 6
```

## API Documentation

Once the backend is running, visit:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Default Users

After running the database script, you'll have these test users:

| Email | Password | Role | Access Level |
|-------|----------|------|--------------|
| ceo@digitalbulks.com | (set on first login) | CEO | Full access |
| maria.gomez@digitalbulks.com | (set on first login) | Coordinador SST | Full SST access |

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

## Legal Compliance

This system is designed to comply with:

- ✅ **Decreto 1072 de 2015** - Unified Labor Decree
- ✅ **Resolución 0312 de 2019** - Minimum SG-SST Standards
- ✅ **Resolución 1401 de 2007** - Accident Investigation
- ✅ **GTC 45** - Risk Identification and Assessment
- ✅ **Ley 1562 de 2012** - Occupational Health Services

See `LEGAL_COMPLIANCE_ANALYSIS.md` for detailed compliance mapping.

## Support

For issues, questions, or contributions, please contact the development team.

## License

Proprietary - All rights reserved

---

**Version**: 1.0.0  
**Last Updated**: November 22, 2025
