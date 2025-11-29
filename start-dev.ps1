# SG-SST Agentic - Start Development Servers
# This script starts both backend and frontend servers

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SG-SST Agentic - Starting Servers" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get the script directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$backendPath = Join-Path $scriptPath "backend"
$frontendPath = Join-Path $scriptPath "frontend"

# Function to check if a port is in use
function Test-Port {
    param([int]$Port)
    $connection = Test-NetConnection -ComputerName localhost -Port $Port -InformationLevel Quiet -WarningAction SilentlyContinue
    return $connection
}

# Function to kill process on port
function Stop-ProcessOnPort {
    param([int]$Port)
    $process = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique
    if ($process) {
        Write-Host "Stopping process on port $Port..." -ForegroundColor Yellow
        Stop-Process -Id $process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
}

# Check and stop existing servers
Write-Host "Checking for running servers..." -ForegroundColor Yellow
if (Test-Port 8000) {
    Write-Host "Backend server is running on port 8000" -ForegroundColor Yellow
    Stop-ProcessOnPort 8000
}
if (Test-Port 5173) {
    Write-Host "Frontend server is running on port 5173" -ForegroundColor Yellow
    Stop-ProcessOnPort 5173
}

Write-Host ""
Write-Host "Starting Backend Server (FastAPI)..." -ForegroundColor Green
Write-Host "Location: $backendPath" -ForegroundColor Gray
Write-Host "URL: http://localhost:8000" -ForegroundColor Gray
Write-Host ""

# Start backend in new terminal
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "cd '$backendPath'; Write-Host 'Starting FastAPI Backend...' -ForegroundColor Cyan; uvicorn api.main:app --reload --host 0.0.0.0 --port 8000"
)

# Wait for backend to start
Write-Host "Waiting for backend to initialize..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Check if backend started successfully
$backendRunning = Test-Port 8000
if ($backendRunning) {
    Write-Host "✓ Backend server started successfully!" -ForegroundColor Green
} else {
    Write-Host "✗ Backend server failed to start. Check the backend terminal for errors." -ForegroundColor Red
    Write-Host "  Make sure you have activated the virtual environment and installed dependencies." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Starting Frontend Server (Vite)..." -ForegroundColor Green
Write-Host "Location: $frontendPath" -ForegroundColor Gray
Write-Host "URL: http://localhost:5173" -ForegroundColor Gray
Write-Host ""

# Start frontend in new terminal
$frontendCommand = "Set-Location '$frontendPath'; Write-Host 'Starting Vite Frontend...' -ForegroundColor Cyan; npm run dev"
Start-Process powershell -ArgumentList "-NoExit", "-Command", $frontendCommand

# Wait for frontend to start
Write-Host "Waiting for frontend to initialize..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Check if frontend started successfully
$frontendRunning = Test-Port 5173
if ($frontendRunning) {
    Write-Host "✓ Frontend server started successfully!" -ForegroundColor Green
} else {
    Write-Host "✗ Frontend server failed to start. Check the frontend terminal for errors." -ForegroundColor Red
    Write-Host "  Make sure you have run 'npm install' in the frontend directory." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Servers Status" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Backend API:  http://localhost:8000" -ForegroundColor $(if ($backendRunning) { "Green" } else { "Red" })
Write-Host "Frontend App: http://localhost:5173" -ForegroundColor $(if ($frontendRunning) { "Green" } else { "Red" })
Write-Host "API Docs:     http://localhost:8000/docs" -ForegroundColor $(if ($backendRunning) { "Green" } else { "Red" })
Write-Host ""
Write-Host "Press any key to open the application in your browser..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Open browser
if ($frontendRunning) {
    Start-Process "http://localhost:5173"
}

Write-Host ""
Write-Host "To stop the servers, close the terminal windows or press Ctrl+C in each." -ForegroundColor Gray
Write-Host ""
