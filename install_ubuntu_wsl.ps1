# Script para instalar Ubuntu en WSL manualmente
# Descarga el paquete .appx directamente

$ErrorActionPreference = "Stop"

Write-Host "Descargando Ubuntu 20.04 para WSL..." -ForegroundColor Cyan

# URL directa del paquete Ubuntu 20.04
$ubuntuUrl = "https://aka.ms/wslubuntu2004"
$downloadPath = "$env:TEMP\Ubuntu2004.appx"

# Descargar
Write-Host "Descargando desde: $ubuntuUrl" -ForegroundColor Yellow
Invoke-WebRequest -Uri $ubuntuUrl -OutFile $downloadPath -UseBasicParsing

Write-Host "Descarga completada. Instalando..." -ForegroundColor Green

# Instalar el paquete
Add-AppxPackage -Path $downloadPath

Write-Host "Ubuntu instalado correctamente!" -ForegroundColor Green
Write-Host "Ahora ejecuta 'ubuntu2004' desde PowerShell para configurarlo." -ForegroundColor Cyan

# Limpiar
Remove-Item $downloadPath -ErrorAction SilentlyContinue
