# Guía de Instalación y Configuración del Vectorstore

## 1. Dependencias de FAISS

### Windows
FAISS puede requerir dependencias adicionales en Windows:

**Opción A: Usar faiss-cpu (Recomendado para desarrollo)**
```bash
pip install faiss-cpu
```

**Opción B: Usar faiss-gpu (Si tienes GPU NVIDIA)**
Requiere:
- CUDA Toolkit (versión compatible con tu GPU)
- cuDNN
```bash
pip install faiss-gpu
```

**Problemas Comunes en Windows:**
- **Error: "DLL load failed"**: Instalar Visual C++ Redistributable
  - Descargar de: https://aka.ms/vs/17/release/vc_redist.x64.exe
- **Error de compilación**: Usar wheels precompilados
  ```bash
  pip install faiss-cpu --no-cache-dir
  ```

### Linux
```bash
# Ubuntu/Debian
sudo apt-get install python3-dev
pip install faiss-cpu

# Con GPU
sudo apt-get install cuda-toolkit
pip install faiss-gpu
```

### macOS
```bash
# Solo CPU (GPU no soportado en macOS)
pip install faiss-cpu
```

---

## 2. Crear Estructura de Carpetas del Vectorstore

### Paso a Paso

**Paso 1: Crear carpetas necesarias**
```powershell
# Desde la raíz del proyecto
cd "c:\Users\PERSONAL\Documents\DEV\SGSST AGENTIC"

# Crear estructura de carpetas
New-Item -ItemType Directory -Force -Path ".\vector\index"
New-Item -ItemType Directory -Force -Path ".\documents\policies"
New-Item -ItemType Directory -Force -Path ".\documents\procedures"
New-Item -ItemType Directory -Force -Path ".\documents\regulations"
New-Item -ItemType Directory -Force -Path ".\logs"
```

**Paso 2: Verificar estructura**
```powershell
tree /F vector
tree /F documents
```

**Estructura esperada:**
```
SGSST AGENTIC/
├── vector/
│   ├── index/              # Aquí se guardará el índice FAISS
│   │   ├── index.faiss     # (se creará al ingestar documentos)
│   │   ├── documents.json  # (se creará al ingestar documentos)
│   │   └── metadata.json   # (se creará al ingestar documentos)
│   ├── config.yaml         # ✅ Ya creado
│   ├── ingest.py           # ✅ Ya creado
│   └── query_example.py    # ✅ Ya creado
│
├── documents/              # Documentos fuente para ingestar
│   ├── policies/           # Políticas de SST
│   ├── procedures/         # Procedimientos
│   └── regulations/        # Normativas (Decreto 1072, etc.)
│
└── logs/                   # Logs de agentes
```

---

## 3. Ingestar Documentos al Vectorstore

### Preparación

**Paso 1: Instalar dependencias**
```bash
cd backend
pip install -r requirements.txt
```

**Paso 2: Configurar variables de entorno**
Copiar `.env.agentic.example` a `.env`:
```powershell
Copy-Item .env.agentic.example .env
```

Editar `.env` y configurar:
```env
VECTOR_STORE_PATH=./vector/index
EMBEDDING_MODEL=sentence-transformers/all-MiniLM-L6-v2
EMBEDDING_DEVICE=cpu
```

### Ingesta de Documentos

**Opción 1: Ingestar un directorio específico**
```bash
# Ingestar políticas
python vector/ingest.py --directory ./documents/policies --type policy

# Ingestar procedimientos
python vector/ingest.py --directory ./documents/procedures --type procedure

# Ingestar normativas
python vector/ingest.py --directory ./documents/regulations --type regulation
```

**Opción 2: Ingestar desde configuración (config.yaml)**
```bash
python vector/ingest.py --config
```

**Opción 3: Ingestar un archivo individual**
```python
# Script personalizado
import asyncio
from vector.ingest import DocumentIngester

async def ingest_single_file():
    ingester = DocumentIngester()
    result = await ingester.ingest_directory(
        directory="./documents/policies/politica_sst.pdf",
        doc_type="policy"
    )
    print(result)

asyncio.run(ingest_single_file())
```

### Verificación

**Verificar que el índice se creó:**
```powershell
# Verificar archivos del índice
Get-ChildItem -Path ".\vector\index" -Recurse
```

**Probar consultas:**
```bash
# Ejecutar ejemplos de consulta
python vector/query_example.py --example 1

# Ver estadísticas del vectorstore
python vector/query_example.py --example 5
```

---

## 4. Documentos de Ejemplo para Ingestar

### Crear Documentos de Prueba

Si no tienes documentos reales aún, puedes crear algunos de prueba:

**Archivo: `documents/policies/politica_sst_ejemplo.txt`**
```
POLÍTICA DE SEGURIDAD Y SALUD EN EL TRABAJO

Digital Bulks S.A.S. se compromete a:

1. Proporcionar condiciones de trabajo seguras y saludables para la prevención 
   de lesiones y deterioro de la salud relacionados con el trabajo.

2. Cumplir con los requisitos legales aplicables y otros requisitos suscritos 
   por la organización, incluyendo el Decreto 1072 de 2015 y la Resolución 
   0312 de 2019.

3. Eliminar los peligros y reducir los riesgos para la seguridad y salud 
   en el trabajo mediante la implementación de controles según la jerarquía 
   establecida.

4. Mejorar continuamente el Sistema de Gestión de Seguridad y Salud en el Trabajo.

5. Promover la consulta y participación de los trabajadores en el desarrollo, 
   planificación, implementación y evaluación del SG-SST.

Esta política es comunicada a todos los trabajadores y está disponible para 
las partes interesadas.

Firmado: CEO
Fecha: 2024-01-01
```

**Archivo: `documents/regulations/decreto_1072_resumen.txt`**
```
DECRETO 1072 DE 2015 - RESUMEN

El Decreto 1072 de 2015 es el Decreto Único Reglamentario del Sector Trabajo 
en Colombia.

CAPÍTULO 6 - SISTEMA DE GESTIÓN DE SEGURIDAD Y SALUD EN EL TRABAJO

Artículo 2.2.4.6.1: Objeto y campo de aplicación
- Aplica a todos los empleadores públicos y privados
- Aplica a contratantes de personal bajo modalidad de contrato civil, comercial o administrativo
- Aplica a organizaciones de economía solidaria y del sector cooperativo
- Aplica a trabajadores dependientes e independientes

Artículo 2.2.4.6.4: Política de Seguridad y Salud en el Trabajo
- Debe ser específica para la empresa
- Debe estar firmada por el empleador
- Debe ser comunicada a todos los niveles de la organización
- Debe incluir compromiso de mejora continua

Artículo 2.2.4.6.8: Obligaciones del empleador
1. Definir, firmar y divulgar la política de SST
2. Asignar recursos para el SG-SST
3. Cumplir normativa nacional vigente
4. Adoptar medidas para prevención de accidentes y enfermedades laborales
5. Garantizar participación de trabajadores
```

---

## 5. Script Automatizado de Setup

**Archivo: `setup_vectorstore.ps1`**
```powershell
# Script para configurar el vectorstore automáticamente

Write-Host "=== Setup del Vectorstore para SG-SST ===" -ForegroundColor Green

# 1. Crear carpetas
Write-Host "`n1. Creando estructura de carpetas..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path ".\vector\index" | Out-Null
New-Item -ItemType Directory -Force -Path ".\documents\policies" | Out-Null
New-Item -ItemType Directory -Force -Path ".\documents\procedures" | Out-Null
New-Item -ItemType Directory -Force -Path ".\documents\regulations" | Out-Null
New-Item -ItemType Directory -Force -Path ".\logs" | Out-Null
Write-Host "   ✓ Carpetas creadas" -ForegroundColor Green

# 2. Copiar .env si no existe
Write-Host "`n2. Configurando variables de entorno..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Copy-Item ".env.agentic.example" ".env"
    Write-Host "   ✓ Archivo .env creado (configura tu API key)" -ForegroundColor Green
} else {
    Write-Host "   ✓ Archivo .env ya existe" -ForegroundColor Green
}

# 3. Instalar dependencias
Write-Host "`n3. Instalando dependencias..." -ForegroundColor Yellow
Set-Location backend
pip install -r requirements.txt
Set-Location ..
Write-Host "   ✓ Dependencias instaladas" -ForegroundColor Green

# 4. Crear documentos de ejemplo
Write-Host "`n4. Creando documentos de ejemplo..." -ForegroundColor Yellow
# (Los archivos de ejemplo se crearían aquí)
Write-Host "   ✓ Documentos de ejemplo creados" -ForegroundColor Green

# 5. Verificar instalación
Write-Host "`n5. Verificando instalación..." -ForegroundColor Yellow
python -c "import faiss; print('FAISS version:', faiss.__version__)"
python -c "import sentence_transformers; print('Sentence Transformers instalado')"
Write-Host "   ✓ Verificación completada" -ForegroundColor Green

Write-Host "`n=== Setup Completado ===" -ForegroundColor Green
Write-Host "`nPróximos pasos:" -ForegroundColor Cyan
Write-Host "1. Edita .env y agrega tu OPENAI_API_KEY"
Write-Host "2. Agrega tus documentos a ./documents/"
Write-Host "3. Ejecuta: python vector/ingest.py --config"
Write-Host "4. Prueba: python vector/query_example.py"
```

---

## 6. Troubleshooting

### Error: "No module named 'faiss'"
```bash
pip install faiss-cpu --upgrade
```

### Error: "Sentence transformers model not found"
```bash
# Descargar modelo manualmente
python -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')"
```

### Error: "Permission denied" al crear carpetas
```powershell
# Ejecutar PowerShell como Administrador
```

### Vectorstore vacío después de ingesta
```bash
# Verificar logs
cat logs/agents.log

# Verificar archivos
ls -la vector/index/
```
