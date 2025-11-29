# SG-SST Agentic - Stop Development Servers
# This script stops both backend and frontend servers

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SG-SST Agentic - Stopping Servers" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to kill process on port
function Stop-ProcessOnPort {
    param([int]$Port, [string]$ServerName)
    
    try {
        $connections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
        if ($connections) {
            $processes = $connections | Select-Object -ExpandProperty OwningProcess -Unique
            foreach ($processId in $processes) {
                try {
                    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
                    if ($process) {
                        Write-Host "Stopping $ServerName (PID: $processId, Name: $($process.ProcessName))..." -ForegroundColor Yellow
                        Stop-Process -Id $processId -Force
                        Write-Host "✓ $ServerName stopped" -ForegroundColor Green
                    }
                } catch {
                    Write-Host "✗ Failed to stop $ServerName (PID: $processId)" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "○ No process found on port $Port" -ForegroundColor Gray
        }
    } catch {
        Write-Host "○ $ServerName is not running on port $Port" -ForegroundColor Gray
    }
}

# Function to kill processes by name
function Stop-ProcessByName {
    param([string]$ProcessName, [string]$ServerName)
    
    $processes = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    if ($processes) {
        foreach ($process in $processes) {
            # Check if it's related to our project
            if ($process.Path -like "*SGSST AGENTIC*" -or $process.CommandLine -like "*SGSST AGENTIC*") {
                Write-Host "Stopping $ServerName (PID: $($process.Id))..." -ForegroundColor Yellow
                Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
                Write-Host "✓ $ServerName stopped" -ForegroundColor Green
            }
        }
    }
}

Write-Host "Method 1: Stopping by port..." -ForegroundColor Cyan
Write-Host ""

# Stop backend (port 8000)
Stop-ProcessOnPort -Port 8000 -ServerName "Backend Server (FastAPI)"

# Stop frontend (port 5173)
Stop-ProcessOnPort -Port 5173 -ServerName "Frontend Server (Vite)"

Write-Host ""
Write-Host "Method 2: Stopping by process name..." -ForegroundColor Cyan
Write-Host ""

# Stop Node.js processes (frontend)
$nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    foreach ($proc in $nodeProcesses) {
        try {
            $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($proc.Id)").CommandLine
            if ($cmdLine -like "*vite*" -or $cmdLine -like "*SGSST AGENTIC*frontend*") {
                Write-Host "Stopping Node.js/Vite process (PID: $($proc.Id))..." -ForegroundColor Yellow
                Stop-Process -Id $proc.Id -Force
                Write-Host "✓ Node.js process stopped" -ForegroundColor Green
            }
        } catch {
            # Skip if can't get command line
        }
    }
}

# Stop Python/uvicorn processes (backend)
$pythonProcesses = Get-Process -Name "python*" -ErrorAction SilentlyContinue
if ($pythonProcesses) {
    foreach ($proc in $pythonProcesses) {
        try {
            $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($proc.Id)").CommandLine
            if ($cmdLine -like "*uvicorn*" -or $cmdLine -like "*SGSST AGENTIC*backend*") {
                Write-Host "Stopping Python/Uvicorn process (PID: $($proc.Id))..." -ForegroundColor Yellow
                Stop-Process -Id $proc.Id -Force
                Write-Host "✓ Python process stopped" -ForegroundColor Green
            }
        } catch {
            # Skip if can't get command line
        }
    }
}

Write-Host ""
Write-Host "Verification..." -ForegroundColor Cyan
Start-Sleep -Seconds 1

# Verify ports are free
$port8000 = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
$port5173 = Get-NetTCPConnection -LocalPort 5173 -ErrorAction SilentlyContinue

if (-not $port8000 -and -not $port5173) {
    Write-Host "✓ All servers stopped successfully!" -ForegroundColor Green
} else {
    if ($port8000) {
        Write-Host "⚠ Port 8000 is still in use" -ForegroundColor Yellow
    }
    if ($port5173) {
        Write-Host "⚠ Port 5173 is still in use" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "If ports are still in use, try closing the terminal windows manually." -ForegroundColor Gray
}

Write-Host ""
