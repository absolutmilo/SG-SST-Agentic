# Quick install script for backend dependencies
Write-Host "Installing backend dependencies..." -ForegroundColor Cyan

# Activate virtual environment
& .\venv\Scripts\Activate.ps1

# Install/upgrade pip
python -m pip install --upgrade pip

# Install all requirements
pip install -r requirements.txt

Write-Host ""
Write-Host "✓ All dependencies installed!" -ForegroundColor Green
Write-Host ""
Write-Host "Now you can start the server with:" -ForegroundColor Yellow
Write-Host "uvicorn api.main:app --reload --host 0.0.0.0 --port 8000" -ForegroundColor White
