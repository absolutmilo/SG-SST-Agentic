-- ==========================================================
-- BASE DE DATOS SG-SST - CUMPLIMIENTO DECRETO 1072/2015
-- Y RESOLUCIÓN 0312/2019 - OPTIMIZADA PARA AGENTE IA
-- ==========================================================
CREATE DATABASE SG_SST_AgenteInteligente;
GO
USE SG_SST_AgenteInteligente;
GO

/* ==========================================================
   FASE 1: TABLAS MAESTRAS Y ESTRUCTURA ORGANIZACIONAL
   ========================================================== */

-- Tabla de Empresa (para múltiples sedes si aplica)
CREATE TABLE EMPRESA (
    id_empresa INT PRIMARY KEY IDENTITY(1,1),
    RazonSocial NVARCHAR(200) NOT NULL,
    NIT NVARCHAR(20) UNIQUE NOT NULL,
    ActividadEconomica NVARCHAR(200) NOT NULL,
    ClaseRiesgo INT CHECK (ClaseRiesgo BETWEEN 1 AND 5) NOT NULL,
    NumeroTrabajadores INT NOT NULL DEFAULT 0,
    DireccionPrincipal NVARCHAR(300),
    Telefono NVARCHAR(20),
    FechaConstitucion DATE
);

-- Tabla de Sedes/Centros de Trabajo
CREATE TABLE SEDE (
    id_sede INT PRIMARY KEY IDENTITY(1,1),
    id_empresa INT FOREIGN KEY REFERENCES EMPRESA(id_empresa),
    NombreSede NVARCHAR(100) NOT NULL,
    Direccion NVARCHAR(300) NOT NULL,
    Ciudad NVARCHAR(100) NOT NULL,
    Departamento NVARCHAR(100) NOT NULL,
    TelefonoContacto NVARCHAR(20),
    Estado BIT DEFAULT 1
);

-- Tabla de Empleados (Mejorada)
CREATE TABLE EMPLEADO (
    id_empleado INT PRIMARY KEY IDENTITY(100,1),
    id_sede INT FOREIGN KEY REFERENCES SEDE(id_sede),
    TipoDocumento NVARCHAR(20) CHECK (TipoDocumento IN ('CC', 'CE', 'PEP', 'Pasaporte')) NOT NULL,
    NumeroDocumento NVARCHAR(20) UNIQUE NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Apellidos NVARCHAR(100) NOT NULL,
    Cargo NVARCHAR(100) NOT NULL,
    Area NVARCHAR(100) NOT NULL,
    TipoContrato NVARCHAR(50) CHECK (TipoContrato IN ('Indefinido', 'Fijo', 'Obra o Labor', 'Aprendizaje', 'Prestación de Servicios')) NOT NULL,
    Fecha_Ingreso DATE NOT NULL,
    Fecha_Retiro DATE NULL,
    Nivel_Riesgo_Laboral INT CHECK (Nivel_Riesgo_Laboral BETWEEN 1 AND 5) NOT NULL,
    Correo NVARCHAR(150),
    Telefono NVARCHAR(20),
    DireccionResidencia NVARCHAR(300),
    ContactoEmergencia NVARCHAR(100),
    TelefonoEmergencia NVARCHAR(20),
    GrupoSanguineo NVARCHAR(5),
    Estado BIT DEFAULT 1, -- 1 Activo, 0 Inactivo
    id_supervisor INT NULL,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaActualizacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_supervisor) REFERENCES EMPLEADO(id_empleado)
);

-- Índices para mejorar rendimiento
CREATE INDEX IDX_Empleado_Estado ON EMPLEADO(Estado);
CREATE INDEX IDX_Empleado_Correo ON EMPLEADO(Correo);
CREATE INDEX IDX_Empleado_Sede ON EMPLEADO(id_sede);

-- Tabla de Usuarios Autorizados para el Agente IA
CREATE TABLE USUARIOS_AUTORIZADOS (
    id_autorizado INT PRIMARY KEY IDENTITY(1,1),
    Correo_Electronico NVARCHAR(150) UNIQUE NOT NULL,
    Nombre_Persona NVARCHAR(100) NOT NULL,
    Nivel_Acceso NVARCHAR(50) CHECK (Nivel_Acceso IN ('CEO', 'Coordinador SST', 'Gerente RRHH', 'Auditor', 'Consulta')) NOT NULL,
    PuedeAprobar BIT DEFAULT 0,
    PuedeEditar BIT DEFAULT 0,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Estado BIT DEFAULT 1
);

-- Tabla de Roles
CREATE TABLE ROL (
    id_rol INT IDENTITY(1,1) PRIMARY KEY,
    NombreRol NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(200),
    EsRolSST BIT DEFAULT 0 -- Para identificar roles críticos en SST
);

CREATE TABLE EMPLEADO_ROL (
    id_empleado INT,
    id_rol INT,
    FechaAsignacion DATE DEFAULT GETDATE(),
    FechaFinalizacion DATE NULL,
    PRIMARY KEY (id_empleado, id_rol),
    FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado),
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol)
);

/* ==========================================================
   FASE 2: GESTIÓN DE RIESGOS Y PELIGROS (GTC 45)
   ========================================================== */

-- Catálogo de Peligros (según GTC 45)
CREATE TABLE CATALOGO_PELIGRO (
    id_catalogo_peligro INT PRIMARY KEY IDENTITY(1,1),
    Clasificacion NVARCHAR(50) CHECK (Clasificacion IN ('Biológico', 'Físico', 'Químico', 'Psicosocial', 'Biomecánico', 'Condiciones de Seguridad', 'Fenómenos Naturales')) NOT NULL,
    TipoPeligro NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(500)
);

-- Valoración de Probabilidad (GTC 45)
CREATE TABLE VALORACION_PROB (
    id_probabilidad INT PRIMARY KEY,
    Nivel_Deficiencia INT NOT NULL,
    Nivel_Exposicion INT NOT NULL,
    Nivel_Probabilidad INT NOT NULL,
    Interpretacion NVARCHAR(50) NOT NULL
);

-- Valoración de Consecuencias
CREATE TABLE VALORACION_CONSEC (
    id_consecuencia INT PRIMARY KEY,
    Nivel_Dano NVARCHAR(50) NOT NULL,
    Valor_NC INT NOT NULL
);

-- Matriz de Riesgos (Mejorada)
CREATE TABLE RIESGO (
    id_riesgo INT PRIMARY KEY IDENTITY(1,1),
    id_catalogo_peligro INT FOREIGN KEY REFERENCES CATALOGO_PELIGRO(id_catalogo_peligro),
    Peligro NVARCHAR(100) NOT NULL,
    Proceso NVARCHAR(100) NOT NULL,
    Actividad NVARCHAR(200) NOT NULL,
    Zona_Area NVARCHAR(100),
    id_probabilidad INT FOREIGN KEY REFERENCES VALORACION_PROB(id_probabilidad),
    id_consecuencia INT FOREIGN KEY REFERENCES VALORACION_CONSEC(id_consecuencia),
    Nivel_Riesgo_Inicial INT NOT NULL,
    Nivel_Riesgo_Residual INT,
    Controles_Fuente NVARCHAR(MAX),
    Controles_Medio NVARCHAR(MAX),
    Controles_Individuo NVARCHAR(MAX),
    MedidasIntervencion NVARCHAR(MAX),
    FechaEvaluacion DATE NOT NULL,
    ProximaRevision DATE,
    Estado NVARCHAR(20) DEFAULT 'Vigente' CHECK (Estado IN ('Vigente', 'Controlado', 'En Revisión'))
);

-- Exposición de Empleados a Riesgos
CREATE TABLE EXPOSICION (
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    id_riesgo INT FOREIGN KEY REFERENCES RIESGO(id_riesgo),
    TiempoExposicionDiario DECIMAL(5,2), -- Horas
    FrecuenciaExposicion NVARCHAR(50), -- Diaria, Semanal, Ocasional
    FechaRegistro DATE DEFAULT GETDATE(),
    PRIMARY KEY (id_empleado, id_riesgo)
);

/* ==========================================================
   FASE 3: GESTIÓN DOCUMENTAL Y NORMATIVIDAD
   ========================================================== */

-- Requisitos Legales (Mejorada)
CREATE TABLE REQUISITO_LEGAL (
    id_requisito INT PRIMARY KEY IDENTITY(500,1),
    Norma NVARCHAR(100) NOT NULL,
    Articulo NVARCHAR(50),
    Descripcion_Requisito NVARCHAR(MAX) NOT NULL,
    Fecha_Vigencia DATE NOT NULL,
    Area_Aplicacion NVARCHAR(100),
    TipoNorma NVARCHAR(50) CHECK (TipoNorma IN ('Decreto', 'Resolución', 'Ley', 'Circular')) NOT NULL,
    Entidad_Emisora NVARCHAR(100),
    Vigente BIT DEFAULT 1,
    URL_Documento NVARCHAR(500),
    FechaRevision DATE DEFAULT GETDATE()
);

-- Evaluación de Cumplimiento Legal
CREATE TABLE EVALUACION_LEGAL (
    id_evaluacion INT PRIMARY KEY IDENTITY(1,1),
    id_requisito INT FOREIGN KEY REFERENCES REQUISITO_LEGAL(id_requisito),
    FechaEvaluacion DATE NOT NULL,
    EstadoCumplimiento NVARCHAR(50) CHECK (EstadoCumplimiento IN ('Cumple', 'Cumple Parcialmente', 'No Cumple', 'No Aplica')) NOT NULL,
    Evidencias NVARCHAR(MAX),
    ResponsableEvaluacion INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    Observaciones NVARCHAR(MAX)
);

-- Documentos del SG-SST
CREATE TABLE DOCUMENTO (
    id_documento INT PRIMARY KEY IDENTITY(1,1),
    Codigo NVARCHAR(50) UNIQUE NOT NULL,
    Nombre NVARCHAR(200) NOT NULL,
    Tipo NVARCHAR(50) CHECK (Tipo IN ('Política', 'Procedimiento', 'Programa', 'Manual', 'Formato', 'Instructivo', 'Plan', 'Reglamento')) NOT NULL,
    CategoriaSGSST NVARCHAR(100), -- Ej: 'Política SST', 'COPASST', 'Plan Emergencias'
    Area NVARCHAR(100),
    FechaCreacion DATE DEFAULT GETDATE(),
    FechaUltimaRevision DATE,
    ProximaRevision DATE,
    Estado NVARCHAR(20) DEFAULT 'Vigente' CHECK (Estado IN ('Vigente', 'Obsoleto', 'En Revisión')),
    Responsable INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    RutaArchivo NVARCHAR(500),
    RequiereAprobacion BIT DEFAULT 0,
    AprobadoPor INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado)
);

CREATE INDEX IDX_Documento_Codigo ON DOCUMENTO(Codigo);

-- Versiones de Documentos
CREATE TABLE VERSION_DOCUMENTO (
    id_version INT PRIMARY KEY IDENTITY(1,1),
    id_documento INT FOREIGN KEY REFERENCES DOCUMENTO(id_documento),
    NumeroVersion INT NOT NULL,
    FechaVersion DATE DEFAULT GETDATE(),
    Cambios NVARCHAR(MAX),
    AprobadoPor INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    RutaArchivoVersion NVARCHAR(500)
);

/* ==========================================================
   FASE 4: GESTIÓN DE EVENTOS E INVESTIGACIÓN
   ========================================================== */

-- Eventos (Accidentes, Incidentes, Enfermedades Laborales) - MEJORADA
CREATE TABLE EVENTO (
    id_evento INT PRIMARY KEY IDENTITY(1000,1),
    Tipo_Evento NVARCHAR(50) CHECK (Tipo_Evento IN ('Accidente de Trabajo', 'Incidente', 'Enfermedad Laboral', 'Acto Inseguro', 'Condición Insegura')) NOT NULL,
    Fecha_Evento DATETIME NOT NULL,
    Hora_Evento TIME,
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    Lugar_Evento NVARCHAR(200),
    Descripcion_Evento NVARCHAR(MAX) NOT NULL,
    Parte_Cuerpo_Afectada NVARCHAR(100),
    Naturaleza_Lesion NVARCHAR(100),
    Mecanismo_Accidente NVARCHAR(200),
    Testigos NVARCHAR(500),
    Dias_Incapacidad INT DEFAULT 0,
    ClasificacionIncapacidad NVARCHAR(50) CHECK (ClasificacionIncapacidad IN ('Temporal', 'Permanente Parcial', 'Permanente Total', 'Muerte', 'Sin Incapacidad')),
    Reportado_ARL BIT DEFAULT 0,
    Fecha_Reporte_ARL DATETIME,
    Numero_Caso_ARL NVARCHAR(50),
    Requiere_Investigacion BIT DEFAULT 1,
    Estado_Investigacion NVARCHAR(50) DEFAULT 'Pendiente' CHECK (Estado_Investigacion IN ('Pendiente', 'En Proceso', 'Cerrada')),
    Fecha_Investigacion DATE,
    Causas_Inmediatas NVARCHAR(MAX),
    Causas_Basicas NVARCHAR(MAX),
    Analisis_Causas NVARCHAR(MAX),
    id_responsable_investigacion INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    FechaRegistro DATETIME DEFAULT GETDATE()
);

CREATE INDEX IDX_Evento_Tipo ON EVENTO(Tipo_Evento);
CREATE INDEX IDX_Evento_Fecha ON EVENTO(Fecha_Evento);

-- Acciones Correctivas/Preventivas derivadas de eventos
CREATE TABLE ACCION_CORRECTIVA (
    id_accion INT PRIMARY KEY IDENTITY(1,1),
    id_evento INT FOREIGN KEY REFERENCES EVENTO(id_evento),
    TipoAccion NVARCHAR(50) CHECK (TipoAccion IN ('Correctiva', 'Preventiva', 'Mejora')) NOT NULL,
    Descripcion NVARCHAR(MAX) NOT NULL,
    ResponsableEjecucion INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    FechaCompromiso DATE NOT NULL,
    FechaCierre DATE,
    Estado NVARCHAR(50) DEFAULT 'Abierta' CHECK (Estado IN ('Abierta', 'En Ejecución', 'Cerrada', 'Vencida')),
    EficaciaVerificada BIT DEFAULT 0,
    Observaciones NVARCHAR(MAX)
);

/* ==========================================================
   FASE 5: COMITÉS Y PARTICIPACIÓN
   ========================================================== */

-- Comités (COPASST, COCOVILAB)
CREATE TABLE COMITE (
    id_comite INT PRIMARY KEY IDENTITY(10,1),
    Tipo_Comite NVARCHAR(50) CHECK (Tipo_Comite IN ('COPASST', 'COCOLAB', 'COCOVICO')) NOT NULL,
    Fecha_Conformacion DATE NOT NULL,
    Fecha_Vigencia DATE NOT NULL,
    ActaConformacion NVARCHAR(500),
    Estado NVARCHAR(20) DEFAULT 'Vigente' CHECK (Estado IN ('Vigente', 'Vencido', 'Disuelto'))
);

CREATE TABLE MIEMBRO_COMITE (
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    id_comite INT FOREIGN KEY REFERENCES COMITE(id_comite),
    Rol_Miembro NVARCHAR(50) CHECK (Rol_Miembro IN ('Presidente', 'Secretario', 'Principal', 'Suplente')) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    PRIMARY KEY (id_empleado, id_comite)
);

-- Reuniones de Comité
CREATE TABLE REUNION_COMITE (
    id_reunion INT PRIMARY KEY IDENTITY(1,1),
    id_comite INT FOREIGN KEY REFERENCES COMITE(id_comite),
    NumeroReunion INT NOT NULL,
    FechaReunion DATE NOT NULL,
    TipoReunion NVARCHAR(50) CHECK (TipoReunion IN ('Ordinaria', 'Extraordinaria')) NOT NULL,
    Asistentes NVARCHAR(MAX), -- JSON o lista de IDs
    TemasDiscutidos NVARCHAR(MAX),
    Acuerdos NVARCHAR(MAX),
    RutaActa NVARCHAR(500),
    ProximaReunion DATE
);

/* ==========================================================
   FASE 6: SALUD OCUPACIONAL
   ========================================================== */

-- Exámenes Médicos Ocupacionales (Mejorada)
CREATE TABLE EXAMEN_MEDICO (
    id_examen INT PRIMARY KEY IDENTITY(3000,1),
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    Tipo_Examen NVARCHAR(50) CHECK (Tipo_Examen IN ('Preocupacional', 'Periodico', 'Post-Incapacidad', 'Retiro', 'Cambio de Ocupación')) NOT NULL,
    Fecha_Realizacion DATE NOT NULL,
    Fecha_Vencimiento DATE,
    EntidadRealizadora NVARCHAR(200),
    MedicoEvaluador NVARCHAR(100),
    Apto_Para_Cargo BIT,
    Restricciones NVARCHAR(MAX),
    Recomendaciones NVARCHAR(MAX),
    DiagnosticosCodificados NVARCHAR(500), -- Códigos CIE-10
    RequiereSeguimiento BIT DEFAULT 0,
    RutaResultados NVARCHAR(500),
    FechaRegistro DATETIME DEFAULT GETDATE()
);

CREATE INDEX IDX_Examen_Empleado ON EXAMEN_MEDICO(id_empleado);
CREATE INDEX IDX_Examen_Tipo ON EXAMEN_MEDICO(Tipo_Examen);

-- Programa de Vigilancia Epidemiológica (PVE)
CREATE TABLE PROGRAMA_VIGILANCIA (
    id_programa INT PRIMARY KEY IDENTITY(1,1),
    NombrePrograma NVARCHAR(200) NOT NULL,
    TipoRiesgo NVARCHAR(100) NOT NULL, -- Ej: Osteomuscular, Auditivo, Respiratorio
    Objetivo NVARCHAR(MAX),
    Poblacion_Objetivo NVARCHAR(MAX),
    Responsable INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    FechaInicio DATE NOT NULL,
    FechaRevision DATE,
    Estado NVARCHAR(20) DEFAULT 'Activo' CHECK (Estado IN ('Activo', 'Suspendido', 'Cerrado'))
);

CREATE TABLE SEGUIMIENTO_PVE (
    id_seguimiento INT PRIMARY KEY IDENTITY(1,1),
    id_programa INT FOREIGN KEY REFERENCES PROGRAMA_VIGILANCIA(id_programa),
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    FechaSeguimiento DATE NOT NULL,
    Hallazgos NVARCHAR(MAX),
    IntervencionRealizada NVARCHAR(MAX),
    ProximoSeguimiento DATE
);

-- Ausentismo Laboral
CREATE TABLE AUSENTISMO (
    id_ausentismo INT PRIMARY KEY IDENTITY(1,1),
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    TipoAusentismo NVARCHAR(50) CHECK (TipoAusentismo IN ('Enfermedad Común', 'Accidente de Trabajo', 'Enfermedad Laboral', 'Licencia', 'Calamidad')) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    DiasAusentismo INT,
    DiagnosticoCIE10 NVARCHAR(10),
    DescripcionDiagnostico NVARCHAR(200),
    RutaSoporte NVARCHAR(500)
);

/* ==========================================================
   FASE 7: ELEMENTOS DE PROTECCIÓN PERSONAL (EPP)
   ========================================================== */

CREATE TABLE EPP (
    id_epp INT PRIMARY KEY IDENTITY(6000,1),
    Codigo_EPP NVARCHAR(50) UNIQUE NOT NULL,
    Nombre_EPP NVARCHAR(100) NOT NULL,
    Tipo_EPP NVARCHAR(100), -- Ej: Casco, Guantes, Respirador
    Riesgo_Protegido NVARCHAR(100) NOT NULL,
    Especificaciones NVARCHAR(MAX),
    Certificacion NVARCHAR(200), -- Norma técnica
    Stock_Disponible INT DEFAULT 0,
    Ubicacion_Almacen NVARCHAR(100)
);

CREATE TABLE ENTREGA_EPP (
    id_entrega INT PRIMARY KEY IDENTITY(1,1),
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    id_epp INT FOREIGN KEY REFERENCES EPP(id_epp),
    Fecha_Entrega DATE NOT NULL,
    Cantidad INT NOT NULL DEFAULT 1,
    Vida_Util_Meses INT,
    Fecha_Reemplazo_Estimada DATE,
    Entregado_Por INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    Firma_Recibido BIT DEFAULT 0,
    RutaActaEntrega NVARCHAR(500)
);

CREATE INDEX IDX_Entrega_Empleado ON ENTREGA_EPP(id_empleado);

/* ==========================================================
   FASE 8: CAPACITACIÓN Y ENTRENAMIENTO
   ========================================================== */

-- Capacitaciones (Mejorada)
CREATE TABLE CAPACITACION (
    id_capacitacion INT PRIMARY KEY IDENTITY(4000,1),
    Codigo_Capacitacion NVARCHAR(50) UNIQUE,
    Tema NVARCHAR(200) NOT NULL,
    Tipo NVARCHAR(50) CHECK (Tipo IN ('Inducción', 'Reinducción', 'Específica SST', 'Brigada', 'Legal Obligatoria')) NOT NULL,
    Modalidad NVARCHAR(50) CHECK (Modalidad IN ('Presencial', 'Virtual', 'Mixta')) NOT NULL,
    Duracion_Horas DECIMAL(5,2) NOT NULL,
    Fecha_Programada DATE,
    Fecha_Realizacion DATE,
    Lugar NVARCHAR(200),
    Facilitador NVARCHAR(100),
    EntidadProveedora NVARCHAR(200),
    Objetivo NVARCHAR(MAX),
    Responsable INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    Estado NVARCHAR(50) DEFAULT 'Programada' CHECK (Estado IN ('Programada', 'Realizada', 'Cancelada', 'Reprogramada')),
    RutaMaterial NVARCHAR(500),
    RutaEvidencias NVARCHAR(500)
);

-- Asistencia a Capacitaciones
CREATE TABLE ASISTENCIA (
    id_asistencia INT PRIMARY KEY IDENTITY(1,1),
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    id_capacitacion INT FOREIGN KEY REFERENCES CAPACITACION(id_capacitacion),
    Asistio BIT NOT NULL DEFAULT 1,
    Calificacion DECIMAL(3,1), -- De 0 a 5
    Aprobo BIT,
    Observaciones NVARCHAR(500),
    FechaRegistro DATETIME DEFAULT GETDATE(),
    UNIQUE (id_empleado, id_capacitacion)
);

-- Competencias SST (para roles específicos)
CREATE TABLE COMPETENCIA_SST (
    id_competencia INT PRIMARY KEY IDENTITY(1,1),
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    TipoCompetencia NVARCHAR(100) NOT NULL, -- Ej: Brigadista, Primeros Auxilios, COPASST
    NivelCompetencia NVARCHAR(50) CHECK (NivelCompetencia IN ('Básico', 'Intermedio', 'Avanzado', 'Certificado')),
    FechaCertificacion DATE,
    FechaVencimiento DATE,
    EntidadCertificadora NVARCHAR(200),
    NumeroCertificado NVARCHAR(100),
    RutaCertificado NVARCHAR(500)
);

/* ==========================================================
   FASE 9: INSPECCIONES Y MANTENIMIENTO
   ========================================================== */

-- Inspecciones
CREATE TABLE INSPECCION (
    id_inspeccion INT PRIMARY KEY IDENTITY(5000,1),
    Tipo_Inspeccion NVARCHAR(100) NOT NULL, -- Ej: EPP, Extintores, Instalaciones, Maquinaria
    Area_Inspeccionada NVARCHAR(100) NOT NULL,
    id_sede INT FOREIGN KEY REFERENCES SEDE(id_sede),
    Fecha_Inspeccion DATE NOT NULL,
    Fecha_Programada DATE,
    id_empleado_inspector INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    HallazgosEncontrados NVARCHAR(MAX),
    Estado NVARCHAR(50) DEFAULT 'Realizada' CHECK (Estado IN ('Programada', 'Realizada', 'Cancelada')),
    RequiereAcciones BIT DEFAULT 0,
    RutaReporte NVARCHAR(500)
);

CREATE TABLE HALLAZGO_INSPECCION (
    id_hallazgo INT PRIMARY KEY IDENTITY(1,1),
    id_inspeccion INT FOREIGN KEY REFERENCES INSPECCION(id_inspeccion),
    Descripcion NVARCHAR(MAX) NOT NULL,
    NivelRiesgo NVARCHAR(50) CHECK (NivelRiesgo IN ('Bajo', 'Medio', 'Alto', 'Crítico')) NOT NULL,
    AccionRequerida NVARCHAR(MAX),
    ResponsableAccion INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    FechaCompromiso DATE,
    EstadoAccion NVARCHAR(50) DEFAULT 'Pendiente' CHECK (EstadoAccion IN ('Pendiente', 'En Proceso', 'Cerrada'))
);

-- Equipos y Maquinaria
CREATE TABLE EQUIPO (
    id_equipo INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(200) NOT NULL,
    Tipo NVARCHAR(100) CHECK (Tipo IN ('Extintores', 'Botiquín', 'Camilla', 'Maquinaria', 'Herramienta', 'Vehículo', 'Sistema Emergencia')) NOT NULL,
    CodigoInterno NVARCHAR(50) UNIQUE,
    Marca NVARCHAR(100),
    Modelo NVARCHAR(100),
    NumeroSerie NVARCHAR(100),
    id_sede INT FOREIGN KEY REFERENCES SEDE(id_sede),
    UbicacionEspecifica NVARCHAR(200),
    Responsable INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    FechaAdquisicion DATE,
    FechaUltimoMantenimiento DATE,
    FechaProximoMantenimiento DATE,
    RequiereCalibacion BIT DEFAULT 0,
    FechaProximaCalibracion DATE,
    Estado NVARCHAR(50) DEFAULT 'Operativo' CHECK (Estado IN ('Operativo', 'En Mantenimiento', 'Fuera de Servicio', 'Dado de Baja'))
);

CREATE INDEX IDX_Equipo_Tipo ON EQUIPO(Tipo);

CREATE TABLE MANTENIMIENTO_EQUIPO (
    id_mantenimiento INT PRIMARY KEY IDENTITY(1,1),
    id_equipo INT FOREIGN KEY REFERENCES EQUIPO(id_equipo),
    TipoMantenimiento NVARCHAR(50) CHECK (TipoMantenimiento IN ('Preventivo', 'Correctivo', 'Calibración')) NOT NULL,
    FechaMantenimiento DATE NOT NULL,
    ProximoMantenimiento DATE,
    ResponsableEjecucion NVARCHAR(200), -- Puede ser externo
    DescripcionActividades NVARCHAR(MAX),
    Costo DECIMAL(15,2),
    RutaReporte NVARCHAR(500)
);

/* ==========================================================
   FASE 10: PLAN DE TRABAJO Y TAREAS
   ========================================================== */

-- Plan de Trabajo Anual SST
CREATE TABLE PLAN_TRABAJO (
    id_plan INT PRIMARY KEY IDENTITY(1,1),
    Anio INT NOT NULL,
    FechaElaboracion DATE NOT NULL,
    ElaboradoPor INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    AprobadoPor INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    FechaAprobacion DATE,
    PresupuestoAsignado DECIMAL(15,2),
    Estado NVARCHAR(50) DEFAULT 'Vigente' CHECK (Estado IN ('Borrador', 'Vigente', 'Cerrado'))
);

-- Objetivos del SG-SST
CREATE TABLE OBJETIVO_SST (
    id_objetivo INT PRIMARY KEY IDENTITY(1,1),
    id_plan INT FOREIGN KEY REFERENCES PLAN_TRABAJO(id_plan),
    Descripcion NVARCHAR(MAX) NOT NULL,
    Indicador NVARCHAR(200),
    MetaEsperada NVARCHAR(100),
    ResponsableCumplimiento INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    FechaLimite DATE
);

-- Tareas del Plan de Trabajo (Mejorada)
CREATE TABLE TAREA (
    id_tarea INT PRIMARY KEY IDENTITY(2000,1),
    id_plan INT FOREIGN KEY REFERENCES PLAN_TRABAJO(id_plan),
    Descripcion NVARCHAR(MAX) NOT NULL,
    Tipo_Tarea NVARCHAR(100), -- Capacitación, Inspección, Auditoría, Comité, etc.
    Fecha_Creacion DATE NOT NULL DEFAULT GETDATE(),
    Fecha_Vencimiento DATE NOT NULL,
    Prioridad NVARCHAR(20) CHECK (Prioridad IN ('Baja', 'Media', 'Alta', 'Crítica')) DEFAULT 'Media',
    Estado NVARCHAR(50) CHECK (Estado IN ('Pendiente', 'En Curso', 'Cerrada', 'Vencida', 'Cancelada')) NOT NULL DEFAULT 'Pendiente',
    id_empleado_responsable INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    Origen_Tarea NVARCHAR(100), -- Plan Anual, Legal, Auditoría, Correo CEO, etc.
    AvancePorc DECIMAL(5,2) DEFAULT 0 CHECK (AvancePorc BETWEEN 0 AND 100),
    Fecha_Actualizacion DATETIME DEFAULT GETDATE(),
    Fecha_Cierre DATE,
    id_empleado_cierre INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    Observaciones_Cierre NVARCHAR(MAX),
    CostoEstimado DECIMAL(15,2),
    RutaEvidencia NVARCHAR(500)
);

CREATE INDEX IDX_Tarea_Estado ON TAREA(Estado);
CREATE INDEX IDX_Tarea_Responsable ON TAREA(id_empleado_responsable);
CREATE INDEX IDX_Tarea_Vencimiento ON TAREA(Fecha_Vencimiento);

/* ==========================================================
   FASE 11: AUDITORÍAS Y NO CONFORMIDADES
   ========================================================== */

-- Auditorías
CREATE TABLE AUDITORIA (
    id_auditoria INT PRIMARY KEY IDENTITY(1,1),
    Tipo NVARCHAR(100) CHECK (Tipo IN ('Interna', 'Externa', 'ARL', 'Ministerio de Trabajo')) NOT NULL,
    Fecha_Programada DATE,
    Fecha_Realizacion DATE NOT NULL,
    Alcance NVARCHAR(MAX),
    Criterios_Auditoria NVARCHAR(MAX), -- Resolución 0312/2019, ISO 45001, etc.
    Auditor_Lider INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    Equipo_Auditor NVARCHAR(500), -- JSON o lista de IDs
    EntidadAuditora NVARCHAR(200), -- Si es externa
    Hallazgos_Resumen NVARCHAR(MAX),
    Conclusiones NVARCHAR(MAX),
    Calificacion_Global DECIMAL(5,2), -- Si aplica
    Estado NVARCHAR(50) DEFAULT 'Programada' CHECK (Estado IN ('Programada', 'En Ejecución', 'Cerrada')),
    RutaInforme NVARCHAR(500)
);

-- Hallazgos de Auditoría (No Conformidades)
CREATE TABLE HALLAZGO_AUDITORIA (
    id_hallazgo INT PRIMARY KEY IDENTITY(1,1),
    id_auditoria INT FOREIGN KEY REFERENCES AUDITORIA(id_auditoria),
    NumeroHallazgo NVARCHAR(50),
    TipoHallazgo NVARCHAR(50) CHECK (TipoHallazgo IN ('No Conformidad Mayor', 'No Conformidad Menor', 'Observación', 'Oportunidad de Mejora', 'Conformidad')) NOT NULL,
    Criterio NVARCHAR(200), -- Numeral o requisito incumplido
    Descripcion NVARCHAR(MAX) NOT NULL,
    Evidencia NVARCHAR(MAX),
    ResponsableArea INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    EstadoHallazgo NVARCHAR(50) DEFAULT 'Abierto' CHECK (EstadoHallazgo IN ('Abierto', 'En Tratamiento', 'Cerrado', 'Verificado'))
);

-- Plan de Acción derivado de Auditorías
CREATE TABLE PLAN_ACCION_AUDITORIA (
    id_plan_accion INT PRIMARY KEY IDENTITY(1,1),
    id_hallazgo INT FOREIGN KEY REFERENCES HALLAZGO_AUDITORIA(id_hallazgo),
    AccionPropuesta NVARCHAR(MAX) NOT NULL,
    ResponsableEjecucion INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    FechaCompromiso DATE NOT NULL,
    FechaCierre DATE,
    RecursosNecesarios NVARCHAR(MAX),
    Estado NVARCHAR(50) DEFAULT 'Abierta' CHECK (Estado IN ('Abierta', 'En Ejecución', 'Cerrada', 'Vencida')),
    VerificacionEficacia BIT DEFAULT 0,
    FechaVerificacion DATE,
    ResponsableVerificacion INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado)
);

/* ==========================================================
   FASE 12: PLAN DE EMERGENCIAS Y BRIGADAS
   ========================================================== */

-- Amenazas Identificadas
CREATE TABLE AMENAZA (
    id_amenaza INT PRIMARY KEY IDENTITY(1,1),
    TipoAmenaza NVARCHAR(100) CHECK (TipoAmenaza IN ('Natural', 'Tecnológica', 'Social', 'Biológica')) NOT NULL,
    Descripcion NVARCHAR(500) NOT NULL,
    id_sede INT FOREIGN KEY REFERENCES SEDE(id_sede),
    Probabilidad NVARCHAR(50) CHECK (Probabilidad IN ('Baja', 'Media', 'Alta')) NOT NULL,
    Impacto NVARCHAR(50) CHECK (Impacto IN ('Bajo', 'Medio', 'Alto', 'Crítico')) NOT NULL,
    NivelRiesgo NVARCHAR(50),
    MedidasPrevencion NVARCHAR(MAX),
    MedidasMitigacion NVARCHAR(MAX)
);

-- Brigadas de Emergencia
CREATE TABLE BRIGADA (
    id_brigada INT PRIMARY KEY IDENTITY(1,1),
    NombreBrigada NVARCHAR(100) NOT NULL,
    TipoBrigada NVARCHAR(100) CHECK (TipoBrigada IN ('Evacuación', 'Primeros Auxilios', 'Contra Incendios', 'Rescate', 'Integral')) NOT NULL,
    id_sede INT FOREIGN KEY REFERENCES SEDE(id_sede),
    FechaConformacion DATE NOT NULL,
    Coordinador INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    Estado NVARCHAR(50) DEFAULT 'Activa' CHECK (Estado IN ('Activa', 'Inactiva'))
);

CREATE TABLE MIEMBRO_BRIGADA (
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    id_brigada INT FOREIGN KEY REFERENCES BRIGADA(id_brigada),
    Rol NVARCHAR(100), -- Líder, Brigadista, Suplente
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    CertificacionVigente BIT DEFAULT 0,
    PRIMARY KEY (id_empleado, id_brigada)
);

-- Simulacros
CREATE TABLE SIMULACRO (
    id_simulacro INT PRIMARY KEY IDENTITY(1,1),
    TipoSimulacro NVARCHAR(100) NOT NULL, -- Evacuación, Incendio, Sismo, etc.
    id_sede INT FOREIGN KEY REFERENCES SEDE(id_sede),
    FechaProgramada DATE,
    FechaRealizacion DATE NOT NULL,
    Alcance NVARCHAR(200), -- Total, Parcial, Por áreas
    NumeroParticipantes INT,
    TiempoEvacuacion TIME,
    Responsable INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    ObjetivosAlcanzados BIT,
    LeccionesAprendidas NVARCHAR(MAX),
    AccionesMejora NVARCHAR(MAX),
    RutaInforme NVARCHAR(500)
);

/* ==========================================================
   FASE 13: CONTRATISTAS Y PROVEEDORES
   ========================================================== */

CREATE TABLE CONTRATISTA (
    id_contratista INT PRIMARY KEY IDENTITY(1,1),
    RazonSocial NVARCHAR(200) NOT NULL,
    NIT NVARCHAR(20) UNIQUE NOT NULL,
    ActividadContratada NVARCHAR(300) NOT NULL,
    NivelRiesgo INT CHECK (NivelRiesgo BETWEEN 1 AND 5),
    ContactoPrincipal NVARCHAR(100),
    TelefonoContacto NVARCHAR(20),
    CorreoContacto NVARCHAR(150),
    FechaInicioContrato DATE,
    FechaFinContrato DATE,
    Estado NVARCHAR(50) DEFAULT 'Activo' CHECK (Estado IN ('Activo', 'Inactivo', 'Suspendido'))
);

-- Evaluación SST de Contratistas (Decreto 1072 Art. 2.2.4.6.8)
CREATE TABLE EVALUACION_CONTRATISTA (
    id_evaluacion INT PRIMARY KEY IDENTITY(1,1),
    id_contratista INT FOREIGN KEY REFERENCES CONTRATISTA(id_contratista),
    FechaEvaluacion DATE NOT NULL,
    TipoEvaluacion NVARCHAR(50) CHECK (TipoEvaluacion IN ('Precontractual', 'Seguimiento', 'Cierre')) NOT NULL,
    SG_SST_Implementado BIT,
    Afiliacion_ARL_Vigente BIT,
    Cumple_Normativa BIT,
    CalificacionTotal DECIMAL(5,2),
    Observaciones NVARCHAR(MAX),
    ResponsableEvaluacion INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    Aprobado BIT DEFAULT 0,
    RutaSoportes NVARCHAR(500)
);

-- Trabajadores de Contratistas
CREATE TABLE TRABAJADOR_CONTRATISTA (
    id_trabajador_contratista INT PRIMARY KEY IDENTITY(1,1),
    id_contratista INT FOREIGN KEY REFERENCES CONTRATISTA(id_contratista),
    NumeroDocumento NVARCHAR(20) NOT NULL,
    NombreCompleto NVARCHAR(200) NOT NULL,
    Cargo NVARCHAR(100),
    ARL NVARCHAR(100),
    FechaIngresoObra DATE NOT NULL,
    FechaRetiroObra DATE,
    InduccionSST_Realizada BIT DEFAULT 0,
    FechaInduccion DATE,
    Estado BIT DEFAULT 1
);

/* ==========================================================
   FASE 14: INDICADORES DEL SG-SST
   ========================================================== */

CREATE TABLE INDICADOR (
    id_indicador INT PRIMARY KEY IDENTITY(1,1),
    TipoIndicador NVARCHAR(50) CHECK (TipoIndicador IN ('Estructura', 'Proceso', 'Resultado')) NOT NULL,
    NombreIndicador NVARCHAR(200) NOT NULL,
    FormulaCalculo NVARCHAR(500),
    UnidadMedida NVARCHAR(50),
    Frecuencia NVARCHAR(50), -- Mensual, Trimestral, Anual
    MetaEsperada DECIMAL(10,2),
    ResponsableReporte INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado)
);

CREATE TABLE RESULTADO_INDICADOR (
    id_resultado INT PRIMARY KEY IDENTITY(1,1),
    id_indicador INT FOREIGN KEY REFERENCES INDICADOR(id_indicador),
    Periodo NVARCHAR(50) NOT NULL, -- 2024-Q1, 2024-01, 2024
    Valor DECIMAL(10,2) NOT NULL,
    FechaCalculo DATE DEFAULT GETDATE(),
    Analisis NVARCHAR(MAX),
    CumpleMeta BIT
);

/* ==========================================================
   FASE 15: SISTEMA DE ALERTAS Y NOTIFICACIONES
   ========================================================== */

CREATE TABLE ALERTA (
    id_alerta INT PRIMARY KEY IDENTITY(1,1),
    Tipo NVARCHAR(100) NOT NULL, -- Examen Médico, Tarea, Comité, EPP, etc.
    Prioridad NVARCHAR(20) CHECK (Prioridad IN ('Informativa', 'Media', 'Alta', 'Crítica')) DEFAULT 'Media',
    Descripcion NVARCHAR(500) NOT NULL,
    FechaGeneracion DATETIME DEFAULT GETDATE(),
    FechaEvento DATE,
    Estado NVARCHAR(20) DEFAULT 'Pendiente' CHECK (Estado IN ('Pendiente', 'Enviada', 'Leída', 'Cerrada')),
    ModuloOrigen NVARCHAR(50), -- EXAMEN_MEDICO, TAREA, COMITE, etc.
    IdRelacionado INT, -- ID del registro que generó la alerta
    DestinatariosCorreo NVARCHAR(MAX), -- JSON con lista de correos
    Enviada BIT DEFAULT 0,
    FechaEnvio DATETIME,
    IntentosEnvio INT DEFAULT 0,
    UltimoError NVARCHAR(MAX)
);

CREATE INDEX IDX_Alerta_Estado ON ALERTA(Estado);
CREATE INDEX IDX_Alerta_Tipo ON ALERTA(Tipo);

-- Historial de Notificaciones (para trazabilidad)
CREATE TABLE HISTORIAL_NOTIFICACION (
    id_historial INT PRIMARY KEY IDENTITY(1,1),
    id_alerta INT FOREIGN KEY REFERENCES ALERTA(id_alerta),
    TipoNotificacion NVARCHAR(50) CHECK (TipoNotificacion IN ('Correo', 'SMS', 'WhatsApp', 'Sistema')) NOT NULL,
    Destinatarios NVARCHAR(MAX),
    AsuntoMensaje NVARCHAR(300),
    CuerpoMensaje NVARCHAR(MAX),
    FechaEnvio DATETIME NOT NULL,
    EstadoEnvio NVARCHAR(50) CHECK (EstadoEnvio IN ('Exitoso', 'Fallido', 'Pendiente Reintento')) NOT NULL,
    MensajeError NVARCHAR(MAX)
);

/* ==========================================================
   FASE 16: COMUNICACIÓN CON EL AGENTE IA
   ========================================================== */

-- Conversaciones con el Agente (para contexto)
CREATE TABLE CONVERSACION_AGENTE (
    id_conversacion INT PRIMARY KEY IDENTITY(1,1),
    id_usuario_autorizado INT FOREIGN KEY REFERENCES USUARIOS_AUTORIZADOS(id_autorizado),
    CorreoOrigen NVARCHAR(150) NOT NULL,
    Asunto NVARCHAR(300),
    FechaHoraRecepcion DATETIME NOT NULL,
    TipoSolicitud NVARCHAR(100), -- Consulta, Reporte, Aprobación, Tarea
    ContenidoOriginal NVARCHAR(MAX),
    InterpretacionAgente NVARCHAR(MAX), -- Lo que el agente entendió
    RespuestaGenerada NVARCHAR(MAX),
    AccionesRealizadas NVARCHAR(MAX), -- JSON con acciones ejecutadas
    FechaHoraRespuesta DATETIME,
    Estado NVARCHAR(50) DEFAULT 'Procesada' CHECK (Estado IN ('Recibida', 'En Proceso', 'Procesada', 'Error')),
    ConfianzaRespuesta DECIMAL(3,2) -- 0.00 a 1.00
);

CREATE INDEX IDX_Conversacion_Fecha ON CONVERSACION_AGENTE(FechaHoraRecepcion);
CREATE INDEX IDX_Conversacion_Usuario ON CONVERSACION_AGENTE(id_usuario_autorizado);

-- Log del Agente (para debugging y auditoría)
CREATE TABLE LOG_AGENTE (
    id_log INT PRIMARY KEY IDENTITY(1,1),
    id_conversacion INT FOREIGN KEY REFERENCES CONVERSACION_AGENTE(id_conversacion),
    FechaHora DATETIME DEFAULT GETDATE(),
    TipoEvento NVARCHAR(100), -- Correo Recibido, Consulta BD, Llamada API, Envío Email
    ModuloAfectado NVARCHAR(100),
    Descripcion NVARCHAR(MAX),
    Exitoso BIT,
    MensajeError NVARCHAR(MAX),
    TiempoEjecucionMs INT
);

-- Configuración del Agente
CREATE TABLE CONFIG_AGENTE (
    id_config INT PRIMARY KEY IDENTITY(1,1),
    Clave NVARCHAR(100) UNIQUE NOT NULL,
    Valor NVARCHAR(MAX) NOT NULL,
    TipoDato NVARCHAR(50) CHECK (TipoDato IN ('String', 'Integer', 'Boolean', 'JSON', 'Decimal')) NOT NULL,
    Descripcion NVARCHAR(300),
    FechaActualizacion DATETIME DEFAULT GETDATE()
);

/* ==========================================================
   FASE 17: PLANTILLAS DE DOCUMENTOS Y REPORTES
   ========================================================== */

CREATE TABLE PLANTILLA_DOCUMENTO (
    id_plantilla INT PRIMARY KEY IDENTITY(1,1),
    NombrePlantilla NVARCHAR(200) NOT NULL,
    TipoDocumento NVARCHAR(100) NOT NULL, -- Acta, Reporte, Formato, etc.
    CategoriaSGSST NVARCHAR(100),
    RutaPlantilla NVARCHAR(500) NOT NULL,
    Formato NVARCHAR(20) CHECK (Formato IN ('Word', 'Excel', 'PDF', 'HTML')) NOT NULL,
    VariablesDisponibles NVARCHAR(MAX), -- JSON con variables que se pueden reemplazar
    Activa BIT DEFAULT 1,
    FechaCreacion DATE DEFAULT GETDATE()
);

-- Reportes Generados por el Agente
CREATE TABLE REPORTE_GENERADO (
    id_reporte INT PRIMARY KEY IDENTITY(1,1),
    TipoReporte NVARCHAR(100) NOT NULL,
    Periodo NVARCHAR(50), -- 2024-Q1, 2024-01, etc.
    Solicitante NVARCHAR(150), -- Correo del solicitante
    FechaGeneracion DATETIME DEFAULT GETDATE(),
    Parametros NVARCHAR(MAX), -- JSON con filtros aplicados
    RutaArchivo NVARCHAR(500),
    FormatoSalida NVARCHAR(20) CHECK (FormatoSalida IN ('PDF', 'Excel', 'Word', 'HTML', 'Email')),
    EstadoGeneracion NVARCHAR(50) DEFAULT 'Completado' CHECK (EstadoGeneracion IN ('En Proceso', 'Completado', 'Error'))
);

/* ==========================================================
   FASE 18: MEJORA CONTINUA Y REVISIÓN POR LA DIRECCIÓN
   ========================================================== */

CREATE TABLE REVISION_DIRECCION (
    id_revision INT PRIMARY KEY IDENTITY(1,1),
    Periodo NVARCHAR(50) NOT NULL, -- 2024-Semestre1, 2024-Anual
    FechaRevision DATE NOT NULL,
    Asistentes NVARCHAR(MAX), -- JSON con lista de participantes
    ResultadosIndicadores NVARCHAR(MAX),
    CumplimientoObjetivos NVARCHAR(MAX),
    ResultadosAuditorias NVARCHAR(MAX),
    AccidentalidadAnalisis NVARCHAR(MAX),
    RecursosSGSST NVARCHAR(MAX),
    ComunicacionesPartes NVARCHAR(MAX), -- Trabajadores, ARL, Autoridades
    DecisionesAdoptadas NVARCHAR(MAX),
    AccionesMejora NVARCHAR(MAX),
    ResponsableElaboracion INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    AprobadoPor INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    RutaActa NVARCHAR(500)
);

-- Acciones de Mejora (general, no solo de auditorías)
CREATE TABLE ACCION_MEJORA (
    id_accion_mejora INT PRIMARY KEY IDENTITY(1,1),
    Origen NVARCHAR(100), -- Revisión Dirección, Auditoría, Sugerencia, Análisis Riesgo
    IdOrigenRelacionado INT, -- ID del registro origen
    Descripcion NVARCHAR(MAX) NOT NULL,
    TipoAccion NVARCHAR(50) CHECK (TipoAccion IN ('Correctiva', 'Preventiva', 'Mejora')) NOT NULL,
    ResponsableEjecucion INT FOREIGN KEY REFERENCES EMPLEADO(id_empleado),
    FechaCreacion DATE DEFAULT GETDATE(),
    FechaCompromiso DATE NOT NULL,
    FechaCierre DATE,
    Estado NVARCHAR(50) DEFAULT 'Abierta' CHECK (Estado IN ('Abierta', 'En Ejecución', 'Cerrada', 'Cancelada', 'Vencida')),
    EficaciaVerificada BIT DEFAULT 0,
    FechaVerificacion DATE,
    ResultadoVerificacion NVARCHAR(MAX)
);

/* ==========================================================
   FASE 19: INSERCIÓN DE DATOS MAESTROS Y DE EJEMPLO
   ========================================================== */

-- Configuración inicial de la Empresa
INSERT INTO EMPRESA (RazonSocial, NIT, ActividadEconomica, ClaseRiesgo, NumeroTrabajadores, DireccionPrincipal, Telefono)
VALUES ('Digital Bulks S.A.S.', '900.123.456-7', 'Desarrollo de Software y Consultoría IT', 1, 50, 'Calle 100 #10-50', '+57 604 1234567');

-- Sede Principal
INSERT INTO SEDE (id_empresa, NombreSede, Direccion, Ciudad, Departamento, TelefonoContacto)
VALUES (1, 'Sede Principal', 'Calle 100 #10-50 Oficina 401', 'Medellín', 'Antioquia', '+57 604 1234567');

-- Empleados
INSERT INTO EMPLEADO (id_sede, TipoDocumento, NumeroDocumento, Nombre, Apellidos, Cargo, Area, TipoContrato, Fecha_Ingreso, Nivel_Riesgo_Laboral, Correo, Telefono, ContactoEmergencia, TelefonoEmergencia) VALUES
(1, 'CC', '1234567890', 'Admin', 'CEO', 'CEO', 'Gerencia', 'Indefinido', '2015-01-01', 1, 'ceo@digitalbulks.com', '+573001234567', 'Contacto Familiar CEO', '+573009999999'),
(1, 'CC', '9876543210', 'María', 'Gómez Ruiz', 'Coordinadora SST', 'Talento Humano', 'Indefinido', '2019-11-01', 2, 'maria.gomez@digitalbulks.com', '+573101234567', 'Pedro Gómez', '+573101111111'),
(1, 'CC', '1122334455', 'Juan', 'López Pérez', 'Desarrollador Senior', 'Tecnología', 'Indefinido', '2020-01-20', 1, 'juan.lopez@digitalbulks.com', '+573201234567', 'Ana López', '+573202222222'),
(1, 'CC', '5544332211', 'Ana', 'Pérez Torres', 'Analista Financiera', 'Finanzas', 'Fijo', '2022-05-15', 1, 'ana.perez@digitalbulks.com', '+573301234567', 'Carlos Pérez', '+573303333333');

-- Usuarios Autorizados para el Agente
INSERT INTO USUARIOS_AUTORIZADOS (Correo_Electronico, Nombre_Persona, Nivel_Acceso, PuedeAprobar, PuedeEditar) VALUES
('ceo@digitalbulks.com', 'Admin CEO', 'CEO', 1, 1),
('maria.gomez@digitalbulks.com', 'María Gómez Ruiz', 'Coordinador SST', 1, 1);

-- Roles
INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES
('CEO', 'Chief Executive Officer', 0),
('Coordinador SST', 'Responsable del Sistema de Gestión SST', 1),
('Brigadista', 'Miembro de Brigada de Emergencias', 1),
('Miembro COPASST', 'Miembro del Comité Paritario', 1);

-- Asignación de Roles
INSERT INTO EMPLEADO_ROL (id_empleado, id_rol) VALUES
(100, 1), -- CEO
(101, 2); -- Coordinador SST

-- Catálogo de Peligros (según GTC 45)
INSERT INTO CATALOGO_PELIGRO (Clasificacion, TipoPeligro, Descripcion) VALUES
('Físico', 'Ruido', 'Exposición a niveles de presión sonora superiores a 85 dB'),
('Biomecánico', 'Posturas Prolongadas', 'Mantenimiento de postura sedente por periodos prolongados'),
('Psicosocial', 'Estrés Laboral', 'Demandas cuantitativas y cualitativas excesivas'),
('Condiciones de Seguridad', 'Eléctrico', 'Contacto directo o indirecto con energía eléctrica'),
('Químico', 'Material Particulado', 'Exposición a polvo o partículas en suspensión'),
('Biológico', 'Virus y Bacterias', 'Exposición a agentes biológicos patógenos');

-- Valoración de Probabilidad (GTC 45)
INSERT INTO VALORACION_PROB (id_probabilidad, Nivel_Deficiencia, Nivel_Exposicion, Nivel_Probabilidad, Interpretacion) VALUES
(1, 10, 4, 40, 'Muy Alto'),
(2, 10, 3, 30, 'Alto'),
(3, 6, 2, 12, 'Medio'),
(4, 2, 1, 2, 'Bajo');

-- Valoración de Consecuencias
INSERT INTO VALORACION_CONSEC (id_consecuencia, Nivel_Dano, Valor_NC) VALUES
(1, 'Mortal o Catastrófico', 100),
(2, 'Muy Grave', 60),
(3, 'Grave', 25),
(4, 'Leve', 10);

-- Riesgos Identificados
INSERT INTO RIESGO (id_catalogo_peligro, Peligro, Proceso, Actividad, Zona_Area, id_probabilidad, id_consecuencia, Nivel_Riesgo_Inicial, Controles_Individuo, FechaEvaluacion, ProximaRevision) VALUES
(2, 'Posturas Prolongadas Sedentes', 'Desarrollo de Software', 'Programación en escritorio', 'Oficinas Administrativas', 3, 4, 120, 'Sillas ergonómicas, pausas activas', '2024-01-15', '2025-01-15'),
(3, 'Carga Mental Alta', 'Gerencia y Administración', 'Toma de decisiones estratégicas', 'Gerencia', 3, 3, 300, 'Programas de bienestar, pausas programadas', '2024-01-15', '2025-01-15');

-- Exposición de Empleados
INSERT INTO EXPOSICION (id_empleado, id_riesgo, TiempoExposicionDiario, FrecuenciaExposicion) VALUES
(102, 1, 8.0, 'Diaria'), -- Juan López expuesto a Posturas
(103, 1, 7.0, 'Diaria'), -- Ana Pérez expuesta a Posturas
(100, 2, 8.0, 'Diaria'); -- CEO expuesto a Carga Mental

-- Requisitos Legales Principales
INSERT INTO REQUISITO_LEGAL (Norma, Articulo, Descripcion_Requisito, Fecha_Vigencia, TipoNorma, Entidad_Emisora, Area_Aplicacion) VALUES
('Decreto 1072', '2.2.4.6.8', 'Obligaciones de los empleadores - Implementación del SG-SST', '2015-05-26', 'Decreto', 'Ministerio del Trabajo', 'General'),
('Resolución 0312', 'Art. 27-29', 'Estándares Mínimos del SG-SST para empresas', '2019-02-13', 'Resolución', 'Ministerio del Trabajo', 'General'),
('Ley 1562', 'Art. 11', 'Servicios de Seguridad y Salud en el Trabajo', '2012-07-11', 'Ley', 'Congreso de la República', 'General'),
('Resolución 2400', 'Disposiciones generales', 'Estatuto de Seguridad Industrial', '1979-05-22', 'Resolución', 'Ministerio del Trabajo', 'Industria'),
('Resolución 1401', 'Art. 1-5', 'Investigación de accidentes e incidentes de trabajo', '2007-05-14', 'Resolución', 'Ministerio de Protección Social', 'Eventos');

-- Comités
INSERT INTO COMITE (Tipo_Comite, Fecha_Conformacion, Fecha_Vigencia, Estado) VALUES
('COPASST', '2023-03-15', '2025-03-15', 'Vigente'),
('COCOLAB', '2024-01-10', '2026-01-10', 'Vigente');

-- Exámenes Médicos (para generar alertas)
INSERT INTO EXAMEN_MEDICO (id_empleado, Tipo_Examen, Fecha_Realizacion, Fecha_Vencimiento, EntidadRealizadora, Apto_Para_Cargo) VALUES
(100, 'Preocupacional', '2015-01-01', NULL, 'IPS Salud Total', 1),
(101, 'Preocupacional', '2019-11-01', NULL, 'IPS Salud Total', 1),
(102, 'Periodico', '2023-01-20', DATEADD(YEAR, 1, '2023-01-20'), 'IPS Salud Total', 1), -- Vencido
(103, 'Periodico', '2024-06-01', DATEADD(DAY, 30, GETDATE()), 'IPS Salud Total', 1); -- Próximo a vencer

-- Plan de Trabajo Anual
INSERT INTO PLAN_TRABAJO (Anio, FechaElaboracion, ElaboradoPor, AprobadoPor, FechaAprobacion, PresupuestoAsignado, Estado) VALUES
(2024, '2023-12-01', 101, 100, '2023-12-15', 50000000, 'Vigente');

-- Objetivos del SG-SST
INSERT INTO OBJETIVO_SST (id_plan, Descripcion, Indicador, MetaEsperada, ResponsableCumplimiento, FechaLimite) VALUES
(1, 'Reducir el índice de accidentalidad en un 20%', 'Índice de Frecuencia', '< 5 accidentes por cada 100 trabajadores', 101, '2024-12-31'),
(1, 'Lograr el 100% de cumplimiento en exámenes médicos periódicos', 'Porcentaje de EMO vigentes', '100%', 101, '2024-12-31'),
(1, 'Capacitar al 100% del personal en identificación de peligros', 'Porcentaje de personal capacitado', '100%', 101, '2024-12-31');

-- Tareas de ejemplo
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Estado, id_empleado_responsable, Origen_Tarea, Prioridad) VALUES
(1, 'Actualización de Matriz de Riesgos 2024', 'Gestión de Riesgos', '2024-01-05', '2024-03-31', 'Cerrada', 101, 'Plan Anual', 'Alta'),
(1, 'Inspección Trimestral de Extintores', 'Inspección', '2024-10-01', DATEADD(DAY, -10, GETDATE()), 'Vencida', 101, 'Plan Anual', 'Alta'),
(1, 'Capacitación en Trabajo Seguro en Alturas', 'Capacitación', '2024-11-01', DATEADD(DAY, 20, GETDATE()), 'Pendiente', 101, 'Plan Anual', 'Media');

-- Capacitaciones
INSERT INTO CAPACITACION (Codigo_Capacitacion, Tema, Tipo, Modalidad, Duracion_Horas, Fecha_Programada, Responsable, Estado) VALUES
('CAP-2024-001', 'Inducción General SST', 'Inducción', 'Presencial', 4, DATEADD(DAY, 15, GETDATE()), 101, 'Programada'),
('CAP-2024-002', 'Prevención de Riesgos Psicosociales', 'Específica SST', 'Virtual', 2, DATEADD(DAY, -30, GETDATE()), 101, 'Realizada');

-- EPP
INSERT INTO EPP (Codigo_EPP, Nombre_EPP, Tipo_EPP, Riesgo_Protegido, Especificaciones, Stock_Disponible) VALUES
('EPP-001', 'Gafas de Protección', 'Protección Visual', 'Partículas y Salpicaduras', 'Anti-empañante, Certificación ANSI Z87.1', 50),
('EPP-002', 'Tapones Auditivos', 'Protección Auditiva', 'Ruido Industrial', 'NRR 32dB, Desechables', 200),
('EPP-003', 'Guantes Anticorte', 'Protección Manos', 'Cortes y Laceraciones', 'Nivel 5 ANSI', 30);

-- Equipos
INSERT INTO EQUIPO (Nombre, Tipo, CodigoInterno, id_sede, UbicacionEspecifica, Responsable, FechaAdquisicion, FechaProximoMantenimiento, RequiereCalibacion) VALUES
('Extintor CO2 10lb - Recepción', 'Extintores', 'EXT-001', 1, 'Recepción Principal', 101, '2023-01-15', DATEADD(MONTH, 1, GETDATE()), 1),
('Extintor Multipropósito - Oficinas', 'Extintores', 'EXT-002', 1, 'Pasillo Oficinas Piso 4', 101, '2023-01-15', DATEADD(DAY, 15, GETDATE()), 1),
('Botiquín Tipo A', 'Botiquín', 'BOT-001', 1, 'Área Común Piso 4', 101, '2024-01-10', DATEADD(MONTH, 6, GETDATE()), 0);

-- Eventos (para cálculo de indicadores)
INSERT INTO EVENTO (Tipo_Evento, Fecha_Evento, Hora_Evento, id_empleado, Lugar_Evento, Descripcion_Evento, Dias_Incapacidad, Reportado_ARL, Estado_Investigacion) VALUES
('Accidente de Trabajo', DATEADD(MONTH, -3, GETDATE()), '10:30:00', 102, 'Oficina Desarrollo', 'Caída de silla ergonómica al intentar alcanzar objeto en altura', 5, 1, 'Cerrada'),
('Incidente', DATEADD(MONTH, -1, GETDATE()), '14:15:00', 103, 'Pasillo Principal', 'Tropiezo con cable de red en el piso, sin lesión', 0, 0, 'Cerrada'),
('Acto Inseguro', DATEADD(DAY, -15, GETDATE()), '09:00:00', 102, 'Escaleras', 'Uso de celular mientras bajaba escaleras', 0, 0, 'Pendiente');

-- Indicadores del SG-SST
INSERT INTO INDICADOR (TipoIndicador, NombreIndicador, FormulaCalculo, UnidadMedida, Frecuencia, MetaEsperada, ResponsableReporte) VALUES
('Resultado', 'Índice de Frecuencia de Accidentalidad', '(# Accidentes * 200000) / Horas Hombre Trabajadas', 'Accidentes por 200,000 HHT', 'Anual', 5.00, 101),
('Resultado', 'Índice de Severidad', '(Días de Incapacidad * 200000) / Horas Hombre Trabajadas', 'Días por 200,000 HHT', 'Anual', 50.00, 101),
('Proceso', 'Cumplimiento del Plan de Trabajo', '(Actividades Ejecutadas / Actividades Programadas) * 100', 'Porcentaje', 'Trimestral', 90.00, 101),
('Estructura', 'Cobertura Exámenes Médicos Ocupacionales', '(Empleados con EMO Vigente / Total Empleados Activos) * 100', 'Porcentaje', 'Mensual', 100.00, 101);

-- Configuración del Agente IA
INSERT INTO CONFIG_AGENTE (Clave, Valor, TipoDato, Descripcion) VALUES
('CORREO_AGENTE', 'agente.sst@digitalbulks.com', 'String', 'Correo electrónico del agente SST'),
('CORREO_COORDINADOR_SST', 'maria.gomez@digitalbulks.com', 'String', 'Correo del Coordinador SST para escalamiento'),
('DIAS_ALERTA_EMO', '45', 'Integer', 'Días de anticipación para alertar vencimiento de exámenes médicos'),
('DIAS_ALERTA_COMITE', '60', 'Integer', 'Días de anticipación para alertar vencimiento de comités'),
('DIAS_ALERTA_EQUIPOS', '30', 'Integer', 'Días de anticipación para alertar mantenimiento de equipos'),
('FRECUENCIA_REVISION_ALERTAS', '6', 'Integer', 'Horas entre cada revisión del sistema de alertas'),
('OPENAI_MODEL', 'gpt-4', 'String', 'Modelo de OpenAI a utilizar'),
('UMBRAL_CONFIANZA_RESPUESTA', '0.80', 'Decimal', 'Umbral mínimo de confianza para respuestas automáticas');

-- Plantillas de Documentos
INSERT INTO PLANTILLA_DOCUMENTO (NombrePlantilla, TipoDocumento, CategoriaSGSST, RutaPlantilla, Formato, Activa) VALUES
('Acta de Reunión COPASST', 'Acta', 'COPASST', '/plantillas/acta_copasst.docx', 'Word', 1),
('Reporte de Accidente de Trabajo', 'Formato', 'Eventos', '/plantillas/reporte_accidente.docx', 'Word', 1),
('Informe de Auditoría Interna', 'Reporte', 'Auditorías', '/plantillas/informe_auditoria.docx', 'Word', 1),
('Matriz de Riesgos', 'Formato', 'Gestión de Riesgos', '/plantillas/matriz_riesgos.xlsx', 'Excel', 1);

GO

/* ==========================================================
   FASE 20: PROCEDIMIENTOS ALMACENADOS OPTIMIZADOS
   ========================================================== */

-- SP 1: Monitoreo y actualización de tareas vencidas
CREATE OR ALTER PROCEDURE SP_Monitorear_Tareas_Vencidas
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Actualizar estado de tareas vencidas
    UPDATE TAREA 
    SET Estado = 'Vencida', 
        Fecha_Actualizacion = GETDATE()
    WHERE Estado IN ('Pendiente', 'En Curso') 
    AND Fecha_Vencimiento < CAST(GETDATE() AS DATE);
    
    -- Retornar tareas vencidas con información del responsable
    SELECT 
        T.id_tarea,
        T.Descripcion,
        T.Tipo_Tarea,
        E.Nombre + ' ' + E.Apellidos AS Responsable,
        E.Correo AS CorreoResponsable,
        E.Area,
        T.Fecha_Vencimiento,
        DATEDIFF(DAY, T.Fecha_Vencimiento, GETDATE()) AS DiasVencida,
        T.Prioridad,
        T.Origen_Tarea
    FROM TAREA T 
    INNER JOIN EMPLEADO E ON T.id_empleado_responsable = E.id_empleado
    WHERE T.Estado = 'Vencida' 
    ORDER BY T.Prioridad DESC, T.Fecha_Vencimiento ASC;
END
GO

-- SP 2: Generación automática de tareas por vencimientos
CREATE OR ALTER PROCEDURE SP_Generar_Tareas_Vigencia
    @IdCoordinadorSST INT 
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TareasGeneradas INT = 0;
    
    -- 1. Tareas por Exámenes Médicos Periódicos próximos a vencer (45 días)
    INSERT INTO TAREA (Descripcion, Fecha_Creacion, Fecha_Vencimiento, Estado, id_empleado_responsable, Origen_Tarea, Prioridad, Tipo_Tarea)
    SELECT 
        'Programar EMO Periódico para ' + E.Nombre + ' ' + E.Apellidos + ' - Vence: ' + CONVERT(NVARCHAR, EM.Fecha_Vencimiento, 103),
        GETDATE(),
        DATEADD(DAY, -5, EM.Fecha_Vencimiento),
        'Pendiente',
        @IdCoordinadorSST,
        'Sistema - Vencimiento EMO',
        'Alta',
        'Gestión Médica'
    FROM EXAMEN_MEDICO EM
    INNER JOIN EMPLEADO E ON EM.id_empleado = E.id_empleado
    WHERE EM.Tipo_Examen = 'Periodico' 
    AND E.Estado = 1
    AND DATEDIFF(DAY, GETDATE(), EM.Fecha_Vencimiento) BETWEEN 0 AND 45
    AND NOT EXISTS (
        SELECT 1 FROM TAREA T 
        WHERE T.Origen_Tarea = 'Sistema - Vencimiento EMO' 
        AND T.Descripcion LIKE '%' + E.Nombre + ' ' + E.Apellidos + '%' 
        AND T.Estado IN ('Pendiente', 'En Curso')
    );
    
    SET @TareasGeneradas = @TareasGeneradas + @@ROWCOUNT;
    
    -- 2. Tareas por Vencimiento de Comités (60 días)
    INSERT INTO TAREA (Descripcion, Fecha_Creacion, Fecha_Vencimiento, Estado, id_empleado_responsable, Origen_Tarea, Prioridad, Tipo_Tarea)
    SELECT 
        'Iniciar proceso de elección y conformación de nuevo ' + C.Tipo_Comite + ' - Vence: ' + CONVERT(NVARCHAR, C.Fecha_Vigencia, 103),
        GETDATE(),
        DATEADD(DAY, -15, C.Fecha_Vigencia),
        'Pendiente',
        @IdCoordinadorSST,
        'Sistema - Vencimiento Comité',
        'Crítica',
        'Legal Obligatoria'
    FROM COMITE C
    WHERE DATEDIFF(DAY, GETDATE(), C.Fecha_Vigencia) BETWEEN 0 AND 60
    AND C.Estado = 'Vigente'
    AND NOT EXISTS (
        SELECT 1 FROM TAREA T 
        WHERE T.Origen_Tarea = 'Sistema - Vencimiento Comité' 
        AND T.Descripcion LIKE '%' + C.Tipo_Comite + '%' 
        AND T.Estado IN ('Pendiente', 'En Curso')
    );
    
    SET @TareasGeneradas = @TareasGeneradas + @@ROWCOUNT;
    
    -- 3. Tareas por Mantenimiento de Equipos próximo (30 días)
    INSERT INTO TAREA (Descripcion, Fecha_Creacion, Fecha_Vencimiento, Estado, id_empleado_responsable, Origen_Tarea, Prioridad, Tipo_Tarea)
    SELECT 
        'Programar mantenimiento de ' + EQ.Nombre + ' (' + EQ.CodigoInterno + ') - Vence: ' + CONVERT(NVARCHAR, EQ.FechaProximoMantenimiento, 103),
        GETDATE(),
        DATEADD(DAY, -5, EQ.FechaProximoMantenimiento),
        'Pendiente',
        ISNULL(EQ.Responsable, @IdCoordinadorSST),
        'Sistema - Mantenimiento Equipo',
        CASE WHEN EQ.Tipo = 'Extintores' THEN 'Alta' ELSE 'Media' END,
        'Mantenimiento'
    FROM EQUIPO EQ
    WHERE DATEDIFF(DAY, GETDATE(), EQ.FechaProximoMantenimiento) BETWEEN 0 AND 30
    AND EQ.Estado = 'Operativo'
    AND NOT EXISTS (
        SELECT 1 FROM TAREA T 
        WHERE T.Origen_Tarea = 'Sistema - Mantenimiento Equipo' 
        AND T.Descripcion LIKE '%' + EQ.CodigoInterno + '%' 
        AND T.Estado IN ('Pendiente', 'En Curso')
    );
    
    SET @TareasGeneradas = @TareasGeneradas + @@ROWCOUNT;
    
    -- 4. Tareas por Auditoría Anual Obligatoria
    IF NOT EXISTS (
        SELECT 1 FROM AUDITORIA 
        WHERE Tipo = 'Interna' 
        AND YEAR(Fecha_Realizacion) = YEAR(GETDATE())
    )
    AND NOT EXISTS (
        SELECT 1 FROM TAREA 
        WHERE Origen_Tarea = 'Sistema - Auditoría Anual' 
        AND YEAR(Fecha_Creacion) = YEAR(GETDATE())
        AND Estado IN ('Pendiente', 'En Curso')
    )
    BEGIN
        INSERT INTO TAREA (Descripcion, Fecha_Creacion, Fecha_Vencimiento, Estado, id_empleado_responsable, Origen_Tarea, Prioridad, Tipo_Tarea)
        VALUES (
            'Programar y ejecutar Auditoría Interna Anual del SG-SST ' + CAST(YEAR(GETDATE()) AS NVARCHAR),
            GETDATE(),
            DATEFROMPARTS(YEAR(GETDATE()), 12, 15), -- 15 de diciembre del año actual
            'Pendiente',
            @IdCoordinadorSST,
            'Sistema - Auditoría Anual',
            'Crítica',
            'Legal Obligatoria'
        );
        SET @TareasGeneradas = @TareasGeneradas + 1;
    END
    
    -- Retornar resumen
    SELECT @TareasGeneradas AS TareasGeneradas;
END
GO

-- SP 3: Cálculo de Indicadores de Siniestralidad
CREATE OR ALTER PROCEDURE SP_Calcular_Indicadores_Siniestralidad
    @Anio INT,
    @Mes INT = NULL -- Si es NULL, calcula anual
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @NumAccidentes INT;
    DECLARE @DiasIncapacidad INT;
    DECLARE @NumIncidentes INT;
    DECLARE @HorasHombreTrabajadas FLOAT;
    DECLARE @TotalEmpleados INT;
    DECLARE @FechaInicio DATE;
    DECLARE @FechaFin DATE;
    
    -- Definir rango de fechas
    IF @Mes IS NULL
    BEGIN
        SET @FechaInicio = DATEFROMPARTS(@Anio, 1, 1);
        SET @FechaFin = DATEFROMPARTS(@Anio, 12, 31);
    END
    ELSE
    BEGIN
        SET @FechaInicio = DATEFROMPARTS(@Anio, @Mes, 1);
        SET @FechaFin = EOMONTH(@FechaInicio);
    END
    
    -- Contar accidentes e incidentes
    SELECT 
        @NumAccidentes = COUNT(CASE WHEN Tipo_Evento = 'Accidente de Trabajo' THEN 1 END),
        @DiasIncapacidad = ISNULL(SUM(CASE WHEN Tipo_Evento = 'Accidente de Trabajo' THEN Dias_Incapacidad ELSE 0 END), 0),
        @NumIncidentes = COUNT(CASE WHEN Tipo_Evento = 'Incidente' THEN 1 END)
    FROM EVENTO 
    WHERE CAST(Fecha_Evento AS DATE) BETWEEN @FechaInicio AND @FechaFin;
    
    -- Calcular promedio de empleados activos en el período
    SELECT @TotalEmpleados = COUNT(DISTINCT id_empleado)
    FROM EMPLEADO
    WHERE Estado = 1 
    AND Fecha_Ingreso <= @FechaFin
    AND (Fecha_Retiro IS NULL OR Fecha_Retiro >= @FechaInicio);
    
    -- Estimar Horas Hombre Trabajadas
    -- Fórmula: Empleados * Horas/día * Días laborables
    IF @Mes IS NULL
        SET @HorasHombreTrabajadas = @TotalEmpleados * 8 * 240; -- 240 días laborables/año
    ELSE
        SET @HorasHombreTrabajadas = @TotalEmpleados * 8 * 20; -- 20 días laborables/mes
    
    -- Evitar división por cero
    IF @HorasHombreTrabajadas = 0
    BEGIN
        SELECT 
            @Anio AS Anio,
            @Mes AS Mes,
            0 AS Indice_Frecuencia,
            0 AS Indice_Severidad,
            0 AS Indice_Lesion_Incapacitante,
            @NumAccidentes AS Total_Accidentes,
            @NumIncidentes AS Total_Incidentes,
            @DiasIncapacidad AS Dias_Incapacidad_Total,
            @TotalEmpleados AS Promedio_Empleados,
            @HorasHombreTrabajadas AS HHT_Estimadas;
        RETURN;
    END
    
    -- Calcular indicadores
    DECLARE @IF FLOAT = (@NumAccidentes * 200000.0) / @HorasHombreTrabajadas;
    DECLARE @IS FLOAT = (@DiasIncapacidad * 200000.0) / @HorasHombreTrabajadas;
    DECLARE @ILI FLOAT = @IF * @IS / 1000.0;
    
    -- Retornar resultados
    SELECT 
        @Anio AS Anio,
        @Mes AS Mes,
        ROUND(@IF, 2) AS Indice_Frecuencia,
        ROUND(@IS, 2) AS Indice_Severidad,
        ROUND(@ILI, 2) AS Indice_Lesion_Incapacitante,
        @NumAccidentes AS Total_Accidentes,
        @NumIncidentes AS Total_Incidentes,
        @DiasIncapacidad AS Dias_Incapacidad_Total,
        @TotalEmpleados AS Promedio_Empleados,
        CAST(@HorasHombreTrabajadas AS INT) AS HHT_Estimadas;
END
GO

-- SP 4: Reporte de Cumplimiento del Plan de Trabajo
CREATE OR ALTER PROCEDURE SP_Reporte_Cumplimiento_Plan
    @IdPlan INT = NULL, -- Si es NULL, toma el plan del año actual
    @FechaCorte DATE = NULL -- Si es NULL, usa fecha actual
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Valores por defecto
    IF @FechaCorte IS NULL
        SET @FechaCorte = GETDATE();
    
    IF @IdPlan IS NULL
    BEGIN
        SELECT TOP 1 @IdPlan = id_plan 
        FROM PLAN_TRABAJO 
        WHERE Anio = YEAR(@FechaCorte) 
        AND Estado = 'Vigente'
        ORDER BY FechaElaboracion DESC;
    END
    
    IF @IdPlan IS NULL
    BEGIN
        SELECT 'No existe plan de trabajo para el año especificado' AS Mensaje;
        RETURN;
    END
    
    -- Calcular métricas de cumplimiento
    SELECT 
        PT.Anio,
        PT.PresupuestoAsignado,
        COUNT(T.id_tarea) AS Tareas_Totales,
        COUNT(CASE WHEN T.Estado = 'Cerrada' THEN 1 END) AS Tareas_Cerradas,
        COUNT(CASE WHEN T.Estado = 'En Curso' THEN 1 END) AS Tareas_EnCurso,
        COUNT(CASE WHEN T.Estado = 'Pendiente' THEN 1 END) AS Tareas_Pendientes,
        COUNT(CASE WHEN T.Estado = 'Vencida' THEN 1 END) AS Tareas_Vencidas,
        CAST(
            CASE 
                WHEN COUNT(T.id_tarea) = 0 THEN 0
                ELSE (COUNT(CASE WHEN T.Estado = 'Cerrada' THEN 1 END) * 100.0 / COUNT(T.id_tarea))
            END AS DECIMAL(5,2)
        ) AS Porcentaje_Cumplimiento,
        COUNT(CASE WHEN T.Estado = 'Cerrada' AND T.Fecha_Cierre <= T.Fecha_Vencimiento THEN 1 END) AS Tareas_A_Tiempo,
        COUNT(CASE WHEN T.Estado = 'Cerrada' AND T.Fecha_Cierre > T.Fecha_Vencimiento THEN 1 END) AS Tareas_Fuera_Tiempo
    FROM PLAN_TRABAJO PT
    LEFT JOIN TAREA T ON PT.id_plan = T.id_plan
    WHERE PT.id_plan = @IdPlan
    GROUP BY PT.Anio, PT.PresupuestoAsignado;
    
    -- Detalle por tipo de tarea
    SELECT 
        T.Tipo_Tarea,
        COUNT(T.id_tarea) AS Total,
        COUNT(CASE WHEN T.Estado = 'Cerrada' THEN 1 END) AS Cerradas,
        CAST(
            CASE 
                WHEN COUNT(T.id_tarea) = 0 THEN 0
                ELSE (COUNT(CASE WHEN T.Estado = 'Cerrada' THEN 1 END) * 100.0 / COUNT(T.id_tarea))
            END AS DECIMAL(5,2)
        ) AS Porcentaje_Cumplimiento
    FROM TAREA T
    WHERE T.id_plan = @IdPlan
    GROUP BY T.Tipo_Tarea
    ORDER BY Porcentaje_Cumplimiento ASC;
END
GO

-- SP 5: Reporte de Cumplimiento de Exámenes Médicos Ocupacionales
CREATE OR ALTER PROCEDURE SP_Reporte_Cumplimiento_EMO
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalEmpleadosActivos INT;
    DECLARE @EmpleadosEMOVigente INT;
    DECLARE @EmpleadosSinEMO INT;
    DECLARE @EMOPorVencer INT;
    
    -- Total de empleados activos
    SELECT @TotalEmpleadosActivos = COUNT(id_empleado) 
    FROM EMPLEADO 
    WHERE Estado = 1;
    
    -- Empleados con EMO vigente y apto
    SELECT @EmpleadosEMOVigente = COUNT(DISTINCT E.id_empleado)
    FROM EMPLEADO E
    INNER JOIN EXAMEN_MEDICO EM ON E.id_empleado = EM.id_empleado
    WHERE E.Estado = 1 
    AND EM.Tipo_Examen IN ('Preocupacional', 'Periodico')
    AND EM.Apto_Para_Cargo = 1
    AND (EM.Fecha_Vencimiento IS NULL OR EM.Fecha_Vencimiento >= GETDATE());
    
    -- Empleados sin examen médico
    SELECT @EmpleadosSinEMO = COUNT(E.id_empleado)
    FROM EMPLEADO E
    WHERE E.Estado = 1
    AND NOT EXISTS (
        SELECT 1 FROM EXAMEN_MEDICO EM 
        WHERE EM.id_empleado = E.id_empleado
    );
    
    -- EMO próximos a vencer (45 días)
    SELECT @EMOPorVencer = COUNT(DISTINCT EM.id_empleado)
    FROM EXAMEN_MEDICO EM
    INNER JOIN EMPLEADO E ON EM.id_empleado = E.id_empleado
    WHERE E.Estado = 1
    AND EM.Tipo_Examen = 'Periodico'
    AND DATEDIFF(DAY, GETDATE(), EM.Fecha_Vencimiento) BETWEEN 0 AND 45;
    
    -- Resumen general
    SELECT 
        @TotalEmpleadosActivos AS Total_Empleados_Activos,
        @EmpleadosEMOVigente AS EMO_Vigentes,
        @EmpleadosSinEMO AS Sin_EMO,
        @EMOPorVencer AS EMO_Por_Vencer_45_Dias,
        CAST(@EmpleadosEMOVigente AS DECIMAL(5,2)) * 100 / NULLIF(@TotalEmpleadosActivos, 0) AS Porcentaje_Cumplimiento;
    
    -- Detalle de empleados sin EMO vigente
    SELECT 
        E.id_empleado,
        E.NumeroDocumento,
        E.Nombre + ' ' + E.Apellidos AS NombreCompleto,
        E.Cargo,
        E.Area,
        E.Correo,
        E.Fecha_Ingreso,
        DATEDIFF(DAY, E.Fecha_Ingreso, GETDATE()) AS Dias_Desde_Ingreso,
        CASE 
            WHEN NOT EXISTS (SELECT 1 FROM EXAMEN_MEDICO WHERE id_empleado = E.id_empleado) THEN 'Sin Examen Registrado'
            WHEN EXISTS (SELECT 1 FROM EXAMEN_MEDICO WHERE id_empleado = E.id_empleado AND Fecha_Vencimiento < GETDATE()) THEN 'Examen Vencido'
            ELSE 'Otro'
        END AS EstadoEMO
    FROM EMPLEADO E
    WHERE E.Estado = 1
    AND E.id_empleado NOT IN (
        SELECT EM.id_empleado
        FROM EXAMEN_