# 🗺️ Roadmap: Hacia una Aplicación 100% Agentic

Este roadmap detalla los pasos necesarios para transformar el sistema SG-SST en una plataforma completamente impulsada por Agentes IA, aprovechando al máximo la integración con base de datos, RAG (Retrieval-Augmented Generation) y bases de datos vectoriales.

## Phase 1: Consolidación de Datos y Contexto (Actual) 🟢
*Objetivo: Asegurar que los agentes tengan acceso a datos estructurados y no estructurados confiables.*

- [x] **Integración SQL Server**: Conexión robusta con Stored Procedures y vistas.
- [x] **Herramientas Base**: Implementación de `RiskTools`, `DocumentTools`, etc.
- [ ] **Ingesta de Documentos Masiva**:
    - [ ] Script para indexar todos los PDFs/DOCX existentes en el sistema.
    - [ ] Pipeline automático para indexar nuevos documentos al cargarlos.
- [ ] **Vector Store Persistente**:
    - [ ] Migrar de índices en memoria a **ChromaDB** o **PGVector** (si se migra a Postgres) o mantener FAISS con persistencia robusta.
    - [ ] Implementar metadatos ricos (autor, fecha, tipo, área) para filtrado híbrido.

## Phase 2: RAG Avanzado y Memoria 🟡
*Objetivo: Que los agentes "recuerden" y "aprendan" del contexto histórico.*

- [ ] **Memoria Conversacional Persistente**:
    - [ ] Guardar historial de chat en base de datos (SQL o NoSQL).
    - [ ] Permitir a los agentes consultar conversaciones pasadas para contexto ("Como te dije ayer...").
- [ ] **RAG Híbrido (SQL + Vector)**:
    - [ ] Agente capaz de decidir si consultar SQL (datos estructurados: "¿Cuántos accidentes hubo en 2024?") o Vector Store (datos no estructurados: "¿Qué dice la política sobre trabajo en alturas?").
    - [ ] **Text-to-SQL**: Implementar capacidad para que el agente escriba sus propias consultas SQL seguras para reportes ad-hoc.
- [ ] **Citas y Referencias**:
    - [ ] Que cada respuesta del agente incluya enlaces directos a los documentos o registros de BD usados como fuente.

## Phase 3: Agentes Autónomos y Proactivos 🟠
*Objetivo: Agentes que actúan sin esperar órdenes explícitas.*

- [ ] **Monitoreo Activo**:
    - [ ] Agente "Vigía" que corre periódicamente (cron jobs) buscando anomalías en datos (ej. aumento súbito de incidentes).
    - [ ] Alertas proactivas: "Noté que vencen 5 extintores la próxima semana, ¿genero las órdenes de recarga?".
- [ ] **Workflows Multi-Agente Complejos**:
    - [ ] **Comité de Crisis Virtual**: `RiskAgent`, `LegalAgent` y `CommsAgent` colaborando para manejar un accidente grave reportado.
    - [ ] **Auditoría Continua**: Agente que revisa aleatoriamente registros nuevos y flaggea inconsistencias.
- [ ] **Aprendizaje por Refuerzo (Feedback Loop)**:
    - [ ] Sistema de "Manito arriba/abajo" en respuestas del agente.
    - [ ] Ajuste de prompts y recuperación basado en feedback del usuario.

## Phase 4: Interfaz 100% Generativa 🔴
*Objetivo: La UI se adapta a lo que el usuario necesita.*

- [ ] **UI Generativa**:
    - [ ] El agente puede renderizar componentes de UI ad-hoc (gráficos, tablas, formularios) en el chat según la consulta.
    - [ ] "Muéstrame un gráfico de tendencia" -> El agente genera el componente Vue.js on-the-fly (usando componentes predefinidos).
- [ ] **Voz y Multimodalidad**:
    - [ ] Input/Output por voz para operarios en campo.
    - [ ] Análisis de imágenes (fotos de inspecciones) para detectar peligros automáticamente.

## 📅 Plan de Ejecución Inmediato (Siguientes Pasos)

1.  **Refinar RAG**: Mejorar la calidad de los embeddings y la estrategia de chunking para documentos técnicos de SST.
2.  **Text-to-SQL Seguro**: Implementar una capa intermedia que permita consultas naturales sobre la BD sin exponer riesgos de inyección.
3.  **Memoria de Usuario**: Personalizar la experiencia según el rol y el historial del usuario.

---
*Este roadmap es un documento vivo y evolucionará con las necesidades del proyecto.*
