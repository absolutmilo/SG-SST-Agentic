# SG-SST Agentic - Development Scripts

Este directorio contiene scripts para facilitar el desarrollo.

## Scripts Disponibles

### `start-dev.ps1` - Iniciar Servidores
Inicia automáticamente el backend (FastAPI) y frontend (Vite) en terminales separadas.

**Uso:**
```powershell
.\start-dev.ps1
```

**Qué hace:**
1. Verifica si hay servidores corriendo en los puertos 8000 y 5173
2. Detiene cualquier proceso existente en esos puertos
3. Inicia el backend en una nueva terminal (puerto 8000)
4. Espera a que el backend esté listo
5. Inicia el frontend en otra terminal (puerto 5173)
6. Abre el navegador en http://localhost:5173

### `stop-dev.ps1` - Detener Servidores
Detiene todos los servidores de desarrollo.

**Uso:**
```powershell
.\stop-dev.ps1
```

**Qué hace:**
1. Encuentra procesos corriendo en puerto 8000 (backend)
2. Encuentra procesos corriendo en puerto 5173 (frontend)
3. Detiene ambos procesos de forma segura

## URLs de Acceso

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Docs (Swagger)**: http://localhost:8000/docs
- **API Redoc**: http://localhost:8000/redoc

## Requisitos

### Backend
- Python 3.13+
- Entorno virtual activado
- Dependencias instaladas: `pip install -r requirements.txt`

### Frontend
- Node.js 18+
- Dependencias instaladas: `npm install`

## Solución de Problemas

### Backend no inicia
1. Verifica que el entorno virtual esté activado
2. Verifica la conexión a la base de datos en `config.toml`
3. Revisa los logs en la terminal del backend

### Frontend no inicia
1. Ejecuta `npm install` en el directorio `frontend`
2. Verifica que el puerto 5173 no esté en uso
3. Revisa los logs en la terminal del frontend

### Puerto en uso
Si ves el error "port already in use":
1. Ejecuta `.\stop-dev.ps1` para detener servidores existentes
2. O manualmente: `Get-Process -Id (Get-NetTCPConnection -LocalPort 8000).OwningProcess | Stop-Process -Force`
