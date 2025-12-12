@echo off
title Reparador de Entorno Frontend (SGSST)
color 0e

echo ===================================================
echo   HERRAMIENTA DE REPARACION AUTOMATICA - FRONTEND
echo ===================================================
echo.
echo 1. Deteniendo procesos de Node.js que puedan bloquear archivos...
taskkill /F /IM node.exe /T 2>nul
echo.

echo 2. Eliminando carpeta node_modules (esto puede tardar)...
if exist node_modules (
    rmdir /s /q node_modules
    echo    - node_modules eliminado.
) else (
    echo    - node_modules no existia.
)

echo 3. Eliminando package-lock.json...
if exist package-lock.json (
    del /f /q package-lock.json
    echo    - package-lock.json eliminado.
)

echo 4. Limpiando cache de npm...
call npm cache clean --force >nul 2>&1

echo.
echo 5. Reinstalando dependencias limpias...
echo    (Por favor espera, esto descarga los archivos necesarios)
call npm install

echo.
echo ===================================================
echo   REPARACION COMPLETADA
echo ===================================================
echo.
echo Ya puedes ejecutar 'npm run dev' nuevamente.
echo.
pause
