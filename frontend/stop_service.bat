@echo off
echo Deteniendo servicios de Node y Esbuild...
taskkill /F /IM node.exe /T
taskkill /F /IM esbuild.exe /T
echo Servicios detenidos.
pause
