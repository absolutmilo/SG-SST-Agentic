$ErrorActionPreference = "SilentlyContinue"

Write-Host "Iniciando Limpieza Profunda RAPIDA..." -ForegroundColor Cyan

# 1. Kill Process on Port 5173
$port = 5173
$tcpConnections = Get-NetTCPConnection -LocalPort $port -State Listen
if ($tcpConnections) {
    foreach ($connection in $tcpConnections) {
        $processId = $connection.OwningProcess
        Write-Host "Matando proceso $processId en el puerto $port" -ForegroundColor Yellow
        Stop-Process -Id $processId -Force
    }
}

# 2. Kill any stuck esbuild.exe
Get-Process -Name "esbuild" | Stop-Process -Force

# 3. Borrar Cache de Vite (Causa comun de "Service Stopped")
$viteCache = "./node_modules/.vite"
if (Test-Path $viteCache) {
    Write-Host "Borrando cache de Vite ($viteCache)..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $viteCache
}

# 4. Reconstruir binario de esbuild (Mas rapido que npm install completo)
Write-Host "Reconstruyendo esbuild..." -ForegroundColor Cyan
npm rebuild esbuild

Write-Host "LISTO. Iniciando Vite..." -ForegroundColor Green
npm run dev
