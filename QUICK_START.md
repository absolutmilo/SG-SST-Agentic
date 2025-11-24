# SG-SST Quick Start Guide

## Prerequisites

✅ Python 3.11 installed  
✅ Node.js 18+ installed  
✅ SQL Server installed and accessible  
✅ Docker installed (optional, for containerized deployment)

## Step 1: Database Setup

1. Open SQL Server Management Studio or Azure Data Studio
2. Connect to your SQL Server instance
3. Execute the database creation script:
   ```sql
   -- File: BD/Claude3_SGSST_BD_Script.sql
   ```
4. Verify the database `SG_SST_AgenteInteligente` was created successfully

## Step 2: Backend Configuration

1. Navigate to the backend directory:
   ```powershell
   cd backend
   ```

2. Copy the example configuration:
   ```powershell
   copy config.example.toml config.toml
   ```

3. Edit `config.toml` with your database connection details:
   ```toml
   [database]
   server = "localhost"  # or your SQL Server address
   database = "SG_SST_AgenteInteligente"
   username = "sa"  # or your SQL Server username
   password = "YourPassword"  # CHANGE THIS!
   port = 1433
   ```

4. Also update the secret key for security:
   ```toml
   [security]
   secret_key = "your-super-secret-key-min-32-characters-long"  # CHANGE THIS!
   ```

## Step 3: Run Setup Script

Run the automated setup script:

```powershell
.\setup.ps1
```

This script will:
- ✅ Check Python and Node.js installations
- ✅ Create Python virtual environment
- ✅ Install backend dependencies
- ✅ Install frontend dependencies
- ✅ Create necessary directories

## Step 4: Start Development Servers

### Option A: Manual Start (Recommended for Development)

**Terminal 1 - Backend:**
```powershell
cd backend
.\venv\Scripts\Activate.ps1
uvicorn api.main:app --reload --host 0.0.0.0 --port 8000
```

**Terminal 2 - Frontend:**
```powershell
cd frontend
npm run dev
```

### Option B: Docker (Recommended for Production)

```powershell
docker-compose up -d
```

## Step 5: Access the Application

- **Frontend**: http://localhost:5173 (dev) or http://localhost (Docker)
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **API ReDoc**: http://localhost:8000/redoc

## Step 6: Test the API

1. Open your browser to http://localhost:8000/docs
2. You should see the Swagger UI with all API endpoints
3. Try the health check endpoint:
   - Click on `GET /health`
   - Click "Try it out"
   - Click "Execute"
   - You should see a successful response

## Default Test Users

After running the database script, you'll have these test users:

| Email | Role | Access Level |
|-------|------|--------------|
| ceo@digitalbulks.com | CEO | Full access |
| maria.gomez@digitalbulks.com | Coordinador SST | Full SST access |

**Note**: Passwords need to be set on first login.

## Troubleshooting

### Backend won't start

**Error**: `config.toml not found`
- **Solution**: Copy `config.example.toml` to `config.toml` and configure it

**Error**: Database connection failed
- **Solution**: 
  1. Verify SQL Server is running
  2. Check connection details in `config.toml`
  3. Test connection with SQL Server Management Studio
  4. Ensure SQL Server is configured to accept TCP/IP connections

**Error**: `ODBC Driver 17 for SQL Server not found`
- **Solution**: Install ODBC Driver 17 for SQL Server:
  - Download from: https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server
  - Or update `config.toml` to use your installed driver version

### Frontend won't start

**Error**: `npm install` fails
- **Solution**: 
  1. Delete `node_modules` folder
  2. Delete `package-lock.json`
  3. Run `npm install` again

**Error**: Cannot connect to API
- **Solution**: 
  1. Verify backend is running on port 8000
  2. Check browser console for CORS errors
  3. Verify `vite.config.js` proxy configuration

### Docker Issues

**Error**: Docker build fails
- **Solution**: 
  1. Ensure Docker Desktop is running
  2. Check Docker has enough resources (memory, disk)
  3. Try `docker-compose build --no-cache`

**Error**: SQL Server container won't start
- **Solution**: 
  1. Ensure port 1433 is not already in use
  2. Check SA_PASSWORD meets complexity requirements
  3. Allocate more memory to Docker (SQL Server needs at least 2GB)

## Next Steps

1. **Explore the API**: Visit http://localhost:8000/docs
2. **Review the database**: Check tables and sample data
3. **Start development**: Begin implementing features from the task list
4. **Read documentation**: 
   - `LEGAL_COMPLIANCE_ANALYSIS.md` - Legal requirements
   - `INTELLIGENT_FORMS_SPEC.md` - Form system design
   - `implementation_plan.md` - Full implementation plan

## Development Workflow

1. **Backend changes**: 
   - Edit files in `backend/api/`
   - Uvicorn will auto-reload
   - Check logs in terminal

2. **Frontend changes**:
   - Edit files in `frontend/src/`
   - Vite will hot-reload
   - Check browser console

3. **Database changes**:
   - Create migration scripts
   - Test in development first
   - Document changes

## Useful Commands

```powershell
# Backend
cd backend
.\venv\Scripts\Activate.ps1
uvicorn api.main:app --reload          # Start dev server
pytest tests/ -v                        # Run tests
black api/                              # Format code
flake8 api/                             # Lint code

# Frontend
cd frontend
npm run dev                             # Start dev server
npm run build                           # Build for production
npm run preview                         # Preview production build
npm run lint                            # Lint code

# Docker
docker-compose up -d                    # Start all services
docker-compose down                     # Stop all services
docker-compose logs -f backend          # View backend logs
docker-compose logs -f frontend         # View frontend logs
docker-compose restart backend          # Restart backend
docker-compose build --no-cache         # Rebuild images
```

## Support

For issues or questions:
1. Check this guide first
2. Review the error logs
3. Check the documentation files
4. Contact the development team

---

**Happy Coding! 🚀**
