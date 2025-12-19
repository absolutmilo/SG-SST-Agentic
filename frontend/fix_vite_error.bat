@echo off
echo ===========================================
echo   LIMPIEZA PROFUNDA DE VITE (PowerShell)
echo ===========================================

:: 1. Matar procesos de Node agresivamente
taskkill /F /IM node.exe /T 2>nul

:: 2. Usar PowerShell para forzar el borrado (mucho mas potente que rmdir)
powershell -Command "Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue"
powershell -Command "Remove-Item -Recurse -Force package-lock.json -ErrorAction SilentlyContinue"

:: 3. Limpiar cache especifica de npm
call npm cache clean --force

:: 4. Reistalar ESBUILD especificamente primero (el truco clave)
echo Instalando esbuild manualmente para asegurar el binario...
call npm install esbuild@0.21.5 --save-dev --save-exact

:: 5. Instalar el resto
echo Instalando resto de dependencias...
call npm install

echo.
echo ===========================================
echo   LISTO. Intenta 'npm run dev'
echo ===========================================
pause