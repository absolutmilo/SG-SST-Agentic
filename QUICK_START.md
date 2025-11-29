# Instalación y Configuración - Guía Rápida

## 🚀 Pasos de Instalación

### 1. Configurar Vectorstore (PRIMERO)

```powershell
# Ejecutar script de setup
.\setup_vectorstore.ps1
```

Esto creará:
- ✅ Carpetas: `vector/index`, `documents/*`, `logs`
- ✅ Archivo `.env` (copia de `.env.agentic.example`)
- ✅ Documentos de ejemplo

### 2. Configurar Roles en Base de Datos

Abrir SQL Server Management Studio y ejecutar:
```sql
-- Archivo: BD/setup_agentic_roles.sql
```

Esto creará:
- ✅ Tabla `AGENTE_ROL` (roles de permisos de agentes)
- ✅ Tabla `EMPLEADO_AGENTE_ROL` (mapeo empleado → rol)
- ✅ 8 roles predefinidos
- ✅ Mapeo automático de empleados existentes
- ✅ 3 empleados de ejemplo

### 3. Instalar Dependencias Python

```powershell
cd backend
pip install -r requirements.txt
```

**Nota**: La instalación de FAISS puede tardar varios minutos.

### 3.1. Instalar Dependencias Frontend

```powershell
cd frontend
npm install marked
```

### 4. Configurar API Key de OpenAI

Editar `.env` y agregar:
```env
OPENAI_API_KEY=sk-tu-api-key-aqui
```

### 5. Ingestar Documentos (Opcional)

```powershell
# Ingestar documentos de ejemplo
python vector/ingest.py --config

# O ingestar un directorio específico
python vector/ingest.py --directory ./documents/policies --type policy
```

### 6. Iniciar Backend

```powershell
cd backend
python api/main.py
```

El servidor estará en: `http://localhost:8000`

### 7. Iniciar Frontend

```powershell
cd frontend
npm run dev
```

El frontend estará en: `http://localhost:5173`

---

## 📋 Verificación

### Verificar API

Abrir en navegador: `http://localhost:8000/docs`

Deberías ver los nuevos endpoints:
- ✅ **Agentic AI - Agents**: `/api/agent/*`
- ✅ **Agentic AI - Workflows**: `/api/workflow/*`
- ✅ **Agentic AI - RAG**: `/api/rag/*`

### Verificar Frontend

1. Ir a `http://localhost:5173`
2. Iniciar sesión
3. Navegar a **Consola Agentic** (menú lateral)

---

## 🔧 Troubleshooting

### Error: "No module named 'faiss'"
```powershell
pip install faiss-cpu --upgrade
```

### Error: "DLL load failed" (Windows)
Instalar Visual C++ Redistributable:
https://aka.ms/vs/17/release/vc_redist.x64.exe

### Error: "OpenAI API key not found"
Verificar que `.env` tenga:
```env
OPENAI_API_KEY=sk-...
```

### Error: "Database connection failed"
Verificar que SQL Server esté corriendo y las credenciales en `backend/api/config.py`

---

## 📊 Endpoints Disponibles

### Agents
- `POST /api/agent/run` - Ejecutar agente
- `GET /api/agent/list?user_id={id}` - Listar agentes disponibles
- `GET /api/agent/capabilities/{agent_name}` - Ver capacidades

### Workflows
- `POST /api/workflow/start` - Iniciar workflow
- `GET /api/workflow/status/{workflow_id}` - Ver estado
- `GET /api/workflow/list` - Listar workflows disponibles

### RAG
- `POST /api/rag/query` - Consulta RAG
- `POST /api/rag/search` - Búsqueda por similitud
- `POST /api/rag/ingest` - Ingestar documento
- `GET /api/rag/stats` - Estadísticas del vectorstore

---

## 🎯 Próximos Pasos

1. ✅ **Configurar API Key** - Para habilitar LLM
2. ✅ **Ejecutar setup_vectorstore.ps1** - Crear estructura
3. ✅ **Ejecutar setup_agentic_roles.sql** - Configurar roles
4. ✅ **Instalar dependencias** - pip install
5. ⏳ **Ingestar documentos reales** - Agregar docs de SG-SST
6. ⏳ **Probar agentes** - Usar la consola agentic
7. ⏳ **Ejecutar workflows** - Probar flujos predefinidos

---

## 📚 Documentación

- **Arquitectura**: `AGENTIC_README.md`
- **Roles**: `ROLES_ARCHITECTURE.md`
- **Vectorstore**: `VECTORSTORE_SETUP.md`
- **Walkthrough**: `.gemini/antigravity/brain/.../walkthrough.md`
