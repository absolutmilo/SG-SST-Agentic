# Script para configurar el vectorstore automaticamente

Write-Host "=== Setup del Vectorstore para SG-SST ===" -ForegroundColor Green

# 1. Crear carpetas
Write-Host "`n1. Creando estructura de carpetas..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path ".\vector\index" | Out-Null
New-Item -ItemType Directory -Force -Path ".\documents\policies" | Out-Null
New-Item -ItemType Directory -Force -Path ".\documents\procedures" | Out-Null
New-Item -ItemType Directory -Force -Path ".\documents\regulations" | Out-Null
New-Item -ItemType Directory -Force -Path ".\logs" | Out-Null
Write-Host "   OK Carpetas creadas" -ForegroundColor Green

# 2. Copiar .env si no existe
Write-Host "`n2. Configurando variables de entorno..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
   Copy-Item ".env.agentic.example" ".env"
   Write-Host "   OK Archivo .env creado (configura tu API key)" -ForegroundColor Green
   Write-Host "   IMPORTANTE: Edita .env y agrega tu OPENAI_API_KEY" -ForegroundColor Yellow
}
else {
   Write-Host "   OK Archivo .env ya existe" -ForegroundColor Green
}

# 3. Crear documentos de ejemplo
Write-Host "`n3. Creando documentos de ejemplo..." -ForegroundColor Yellow

$politicaSST = @'
POLITICA DE SEGURIDAD Y SALUD EN EL TRABAJO

Digital Bulks S.A.S. se compromete a:

1. Proporcionar condiciones de trabajo seguras y saludables para la prevencion 
   de lesiones y deterioro de la salud relacionados con el trabajo.

2. Cumplir con los requisitos legales aplicables y otros requisitos suscritos 
   por la organizacion, incluyendo el Decreto 1072 de 2015 y la Resolucion 
   0312 de 2019.

3. Eliminar los peligros y reducir los riesgos para la seguridad y salud 
   en el trabajo mediante la implementacion de controles segun la jerarquia 
   establecida.

4. Mejorar continuamente el Sistema de Gestion de Seguridad y Salud en el Trabajo.

5. Promover la consulta y participacion de los trabajadores en el desarrollo, 
   planificacion, implementacion y evaluacion del SG-SST.

Esta politica es comunicada a todos los trabajadores y esta disponible para 
las partes interesadas.

Firmado: CEO
Fecha: 2024-01-01
'@

$decreto1072 = @'
DECRETO 1072 DE 2015 - RESUMEN

El Decreto 1072 de 2015 es el Decreto Unico Reglamentario del Sector Trabajo 
en Colombia.

CAPITULO 6 - SISTEMA DE GESTION DE SEGURIDAD Y SALUD EN EL TRABAJO

Articulo 2.2.4.6.1: Objeto y campo de aplicacion
- Aplica a todos los empleadores publicos y privados
- Aplica a contratantes de personal bajo modalidad de contrato civil, comercial o administrativo
- Aplica a organizaciones de economia solidaria y del sector cooperativo
- Aplica a trabajadores dependientes e independientes

Articulo 2.2.4.6.4: Politica de Seguridad y Salud en el Trabajo
- Debe ser especifica para la empresa
- Debe estar firmada por el empleador
- Debe ser comunicada a todos los niveles de la organizacion
- Debe incluir compromiso de mejora continua

Articulo 2.2.4.6.8: Obligaciones del empleador
1. Definir, firmar y divulgar la politica de SST
2. Asignar recursos para el SG-SST
3. Cumplir normativa nacional vigente
4. Adoptar medidas para prevencion de accidentes y enfermedades laborales
5. Garantizar participacion de trabajadores
'@

$politicaSST | Out-File -FilePath ".\documents\policies\politica_sst_ejemplo.txt" -Encoding UTF8
$decreto1072 | Out-File -FilePath ".\documents\regulations\decreto_1072_resumen.txt" -Encoding UTF8

Write-Host "   OK Documentos de ejemplo creados" -ForegroundColor Green

# 4. Mostrar estructura creada
Write-Host "`n4. Estructura de carpetas creada:" -ForegroundColor Yellow
Write-Host "   vector/index/          - Indice FAISS (se creara al ingestar)"
Write-Host "   documents/policies/    - Politicas de SST"
Write-Host "   documents/procedures/  - Procedimientos"
Write-Host "   documents/regulations/ - Normativas"
Write-Host "   logs/                  - Logs de agentes"

Write-Host "`n=== Setup Completado ===" -ForegroundColor Green
Write-Host "`nProximos pasos:" -ForegroundColor Cyan
Write-Host "1. Instala dependencias: cd backend; pip install -r requirements.txt"
Write-Host "2. Edita .env y agrega tu OPENAI_API_KEY"
Write-Host "3. Agrega tus documentos reales a ./documents/"
Write-Host "4. Ejecuta: python vector/ingest.py --config"
Write-Host "5. Prueba: python vector/query_example.py --example 1"
