-- ============================================================
-- TABLA: PERMISO_TRABAJO
-- Gestión de permisos de trabajo para actividades de alto riesgo
-- Cumplimiento: Resolución 1409/2012, Decreto 1072/2015
-- ============================================================

CREATE TABLE [dbo].[PERMISO_TRABAJO](
    [id_permiso] [int] IDENTITY(1,1) NOT NULL,
    
    -- Clasificación del Permiso
    [TipoPermiso] [nvarchar](100) NOT NULL,
    [NumeroPermiso] [nvarchar](50) NOT NULL,
    
    -- Información del Trabajo
    [DescripcionTrabajo] [nvarchar](max) NOT NULL,
    [Ubicacion] [nvarchar](200) NOT NULL,
    [id_sede] [int] NULL,
    [Area] [nvarchar](100) NULL,
    
    -- Fechas y Vigencia
    [FechaInicio] [datetime] NOT NULL,
    [FechaFin] [datetime] NOT NULL,
    [Vigencia] [int] NULL, -- Horas de vigencia
    
    -- Responsables
    [id_solicitante] [int] NULL,
    [id_ejecutor] [int] NULL,
    [id_supervisor] [int] NULL,
    [id_autorizador] [int] NULL,
    
    -- Evaluación de Riesgos
    [RiesgosIdentificados] [nvarchar](max) NULL,
    [MedidasControl] [nvarchar](max) NULL,
    [EPPRequerido] [nvarchar](500) NULL,
    
    -- Condiciones Específicas (para permisos especiales)
    [RequiereAislamiento] [bit] NULL,
    [RequiereVentilacion] [bit] NULL,
    [RequiereMonitoreoGases] [bit] NULL,
    [RequiereVigia] [bit] NULL,
    [RequiereExtintor] [bit] NULL,
    
    -- Mediciones (para espacios confinados / trabajo en caliente)
    [NivelOxigeno] [decimal](5,2) NULL,
    [NivelLEL] [decimal](5,2) NULL, -- Lower Explosive Limit
    [NivelH2S] [decimal](5,2) NULL,
    [NivelCO] [decimal](5,2) NULL,
    [TemperaturaAmbiente] [decimal](5,2) NULL,
    
    -- Estado y Cierre
    [Estado] [nvarchar](50) NOT NULL DEFAULT 'Solicitado',
    [FechaAutorizacion] [datetime] NULL,
    [FechaCierre] [datetime] NULL,
    [ObservacionesCierre] [nvarchar](max) NULL,
    
    -- Documentación
    [RutaDocumento] [nvarchar](500) NULL,
    [RutaART] [nvarchar](500) NULL, -- Análisis de Riesgo por Tarea
    
    -- Auditoría
    [FechaCreacion] [datetime] NOT NULL DEFAULT GETDATE(),
    [CreadoPor] [int] NULL,
    [FechaModificacion] [datetime] NULL,
    [ModificadoPor] [int] NULL,
    
    PRIMARY KEY CLUSTERED ([id_permiso] ASC),
    
    CONSTRAINT [FK_PermisoTrabajo_Solicitante] FOREIGN KEY([id_solicitante]) 
        REFERENCES [dbo].[EMPLEADO] ([id_empleado]),
    CONSTRAINT [FK_PermisoTrabajo_Ejecutor] FOREIGN KEY([id_ejecutor]) 
        REFERENCES [dbo].[EMPLEADO] ([id_empleado]),
    CONSTRAINT [FK_PermisoTrabajo_Supervisor] FOREIGN KEY([id_supervisor]) 
        REFERENCES [dbo].[EMPLEADO] ([id_empleado]),
    CONSTRAINT [FK_PermisoTrabajo_Autorizador] FOREIGN KEY([id_autorizador]) 
        REFERENCES [dbo].[EMPLEADO] ([id_empleado]),
    CONSTRAINT [FK_PermisoTrabajo_Sede] FOREIGN KEY([id_sede]) 
        REFERENCES [dbo].[SEDE] ([id_sede]),
    
    CONSTRAINT [CHK_PermisoTrabajo_TipoPermiso] CHECK (
        [TipoPermiso] IN (
            'Trabajo en Alturas',
            'Trabajo en Caliente',
            'Espacios Confinados',
            'Trabajo Eléctrico',
            'Excavación',
            'Izaje de Cargas',
            'Radiografía Industrial',
            'Bloqueo y Etiquetado (LOTO)',
            'Trabajo con Químicos Peligrosos'
        )
    ),
    
    CONSTRAINT [CHK_PermisoTrabajo_Estado] CHECK (
        [Estado] IN ('Solicitado', 'Autorizado', 'En Ejecución', 'Cerrado', 'Cancelado', 'Vencido')
    )
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Índices para optimización
CREATE NONCLUSTERED INDEX [IX_PermisoTrabajo_Tipo] ON [dbo].[PERMISO_TRABAJO]([TipoPermiso])
CREATE NONCLUSTERED INDEX [IX_PermisoTrabajo_Estado] ON [dbo].[PERMISO_TRABAJO]([Estado])
CREATE NONCLUSTERED INDEX [IX_PermisoTrabajo_Fechas] ON [dbo].[PERMISO_TRABAJO]([FechaInicio], [FechaFin])
GO

-- ============================================================
-- DATOS DE EJEMPLO
-- NOTA: Estos INSERTs usan IDs de empleados genéricos (101-107)
-- Si estos IDs no existen en tu tabla EMPLEADO, comenta o ajusta los valores
-- ============================================================

-- Obtener IDs de empleados existentes para usar en los ejemplos
DECLARE @id_coord INT, @id_supervisor INT, @id_tecnico INT;

-- Intentar obtener IDs reales de empleados
SELECT TOP 1 @id_coord = id_empleado FROM EMPLEADO WHERE Estado = 1 ORDER BY id_empleado;
SELECT TOP 1 @id_supervisor = id_empleado FROM EMPLEADO WHERE Estado = 1 AND id_empleado != @id_coord ORDER BY id_empleado;
SELECT TOP 1 @id_tecnico = id_empleado FROM EMPLEADO WHERE Estado = 1 AND id_empleado NOT IN (@id_coord, @id_supervisor) ORDER BY id_empleado;

-- Solo insertar si hay empleados disponibles
IF @id_coord IS NOT NULL AND @id_supervisor IS NOT NULL AND @id_tecnico IS NOT NULL
BEGIN
    -- Ejemplo 1: Permiso de Trabajo en Caliente
    INSERT INTO [PERMISO_TRABAJO] (
        TipoPermiso, NumeroPermiso, DescripcionTrabajo, Ubicacion, Area,
        FechaInicio, FechaFin, Vigencia,
        id_solicitante, id_ejecutor, id_supervisor, id_autorizador,
        RiesgosIdentificados, MedidasControl, EPPRequerido,
        RequiereAislamiento, RequiereVentilacion, RequiereMonitoreoGases, RequiereExtintor,
        NivelLEL, Estado
    ) VALUES (
        'Trabajo en Caliente',
        'TC-2024-001',
        'Soldadura de tubería de proceso en área de almacenamiento de químicos',
        'Planta Petroquímica - Área 3',
        'Almacenamiento',
        DATEADD(hour, 1, GETDATE()),
        DATEADD(hour, 5, GETDATE()),
        4,
        @id_coord,
        @id_tecnico,
        @id_supervisor,
        @id_coord,
        'Riesgo de incendio/explosión por presencia de vapores inflamables. Riesgo de quemaduras.',
        'Medición de gases antes de iniciar. Ventilación forzada. Extintor tipo ABC a menos de 10m. Vigía permanente.',
        'Careta de soldar, guantes de carnaza, mandil de cuero, botas de seguridad, respirador con filtro',
        1, 1, 1, 1,
        0.0,
        'Autorizado'
    );

    -- Ejemplo 2: Permiso de Espacio Confinado
    INSERT INTO [PERMISO_TRABAJO] (
        TipoPermiso, NumeroPermiso, DescripcionTrabajo, Ubicacion, Area,
        FechaInicio, FechaFin, Vigencia,
        id_solicitante, id_ejecutor, id_supervisor, id_autorizador,
        RiesgosIdentificados, MedidasControl, EPPRequerido,
        RequiereAislamiento, RequiereVentilacion, RequiereMonitoreoGases, RequiereVigia,
        NivelOxigeno, NivelLEL, NivelH2S, NivelCO,
        Estado
    ) VALUES (
        'Espacios Confinados',
        'EC-2024-002',
        'Limpieza interna de tanque de almacenamiento de solventes',
        'Planta Petroquímica - Tanque T-301',
        'Almacenamiento',
        DATEADD(day, 1, GETDATE()),
        DATEADD(day, 1, DATEADD(hour, 6, GETDATE())),
        6,
        @id_coord,
        @id_tecnico,
        @id_supervisor,
        @id_coord,
        'Atmósfera deficiente en oxígeno. Presencia de vapores tóxicos (H2S). Riesgo de asfixia.',
        'Ventilación forzada continua. Monitoreo de gases cada 30 min. Vigía externo permanente. Arnés con línea de vida.',
        'Equipo de respiración autónomo (SCBA), arnés, detector multigases personal, botas antichispa',
        1, 1, 1, 1,
        20.9, 0.0, 0.0, 0.0,
        'Autorizado'
    );

    -- Ejemplo 3: Permiso de Trabajo Eléctrico
    INSERT INTO [PERMISO_TRABAJO] (
        TipoPermiso, NumeroPermiso, DescripcionTrabajo, Ubicacion, Area,
        FechaInicio, FechaFin, Vigencia,
        id_solicitante, id_ejecutor, id_supervisor, id_autorizador,
        RiesgosIdentificados, MedidasControl, EPPRequerido,
        RequiereAislamiento,
        Estado
    ) VALUES (
        'Trabajo Eléctrico',
        'TE-2024-003',
        'Mantenimiento preventivo en tablero eléctrico principal 440V',
        'Subestación Eléctrica',
        'Energía',
        DATEADD(day, 2, GETDATE()),
        DATEADD(day, 2, DATEADD(hour, 3, GETDATE())),
        3,
        @id_coord,
        @id_tecnico,
        @id_supervisor,
        @id_coord,
        'Riesgo de electrocución. Arco eléctrico. Quemaduras.',
        'Bloqueo y etiquetado (LOTO). Verificación de ausencia de tensión. Puesta a tierra temporal. Trabajo en parejas.',
        'Guantes dieléctricos clase 2, casco con protección facial, traje antiarco, calzado dieléctrico, herramientas aisladas',
        1,
        'Autorizado'
    );
    
    PRINT 'Datos de ejemplo insertados correctamente usando empleados existentes.';
END
ELSE
BEGIN
    PRINT 'No se insertaron datos de ejemplo. Asegúrate de tener al menos 3 empleados activos en la tabla EMPLEADO.';
END

GO

-- ============================================================
-- VISTA: Permisos Activos y Próximos a Vencer
-- ============================================================
CREATE VIEW [dbo].[VW_Permisos_Activos] AS
SELECT 
    p.id_permiso,
    p.TipoPermiso,
    p.NumeroPermiso,
    p.DescripcionTrabajo,
    p.Ubicacion,
    p.FechaInicio,
    p.FechaFin,
    p.Estado,
    DATEDIFF(HOUR, GETDATE(), p.FechaFin) AS HorasRestantes,
    e1.Nombre + ' ' + e1.Apellidos AS Ejecutor,
    e2.Nombre + ' ' + e2.Apellidos AS Supervisor,
    CASE 
        WHEN p.FechaFin < GETDATE() THEN 'Vencido'
        WHEN DATEDIFF(HOUR, GETDATE(), p.FechaFin) <= 2 THEN 'Próximo a Vencer'
        ELSE 'Vigente'
    END AS EstadoVigencia
FROM PERMISO_TRABAJO p
LEFT JOIN EMPLEADO e1 ON p.id_ejecutor = e1.id_empleado
LEFT JOIN EMPLEADO e2 ON p.id_supervisor = e2.id_empleado
WHERE p.Estado IN ('Autorizado', 'En Ejecución')
GO
