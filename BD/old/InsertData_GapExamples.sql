USE SG_SST_AgenteInteligente;
GO

-- =============================================
-- 1. GAP 4: INSPECCIONES DE SEGURIDAD
-- =============================================
-- Schema: id_inspeccion, Tipo_Inspeccion, Area_Inspeccionada, id_sede, Fecha_Inspeccion, Fecha_Programada, id_empleado_inspector, HallazgosEncontrados, Estado, RequiereAcciones, RutaReporte
-- Valid States: 'Cancelada', 'Realizada', 'Programada'

DECLARE @IdSede INT = (SELECT TOP 1 id_sede FROM SEDE);
DECLARE @IdEmpleado INT = (SELECT TOP 1 id_empleado FROM EMPLEADO);

IF @IdSede IS NULL
BEGIN
    PRINT 'Error: No hay sedes registradas. Por favor inserte al menos una sede.';
    RETURN;
END

IF @IdEmpleado IS NULL
BEGIN
    PRINT 'Error: No hay empleados registrados. Por favor inserte al menos un empleado.';
    RETURN;
END

IF NOT EXISTS (SELECT * FROM INSPECCION WHERE Tipo_Inspeccion = 'Extintores' AND Estado = 'Programada')
BEGIN
    INSERT INTO INSPECCION (
        Tipo_Inspeccion, 
        Area_Inspeccionada, 
        id_sede, 
        Fecha_Programada, 
        Fecha_Inspeccion, 
        Estado, 
        RequiereAcciones,
        id_empleado_inspector, 
        HallazgosEncontrados,
        RutaReporte
    )
    VALUES 
    ('Extintores', 'Planta de Producción', @IdSede, DATEADD(day, -5, GETDATE()), DATEADD(day, -5, GETDATE()), 'Programada', 0, NULL, NULL, NULL),
    ('Botiquines', 'Oficinas Administrativas', @IdSede, DATEADD(day, -10, GETDATE()), DATEADD(day, -10, GETDATE()), 'Programada', 0, NULL, NULL, NULL),
    ('Puestos de Trabajo', 'Area Comercial', @IdSede, DATEADD(day, -2, GETDATE()), DATEADD(day, -2, GETDATE()), 'Programada', 0, NULL, NULL, NULL);
END
GO

-- =============================================
-- 2. GAP 5: MANTENIMIENTO DE EQUIPOS
-- =============================================
-- Schema: id_equipo, Nombre, Tipo, CodigoInterno, Marca, Modelo, NumeroSerie, id_sede, UbicacionEspecifica, Responsable, FechaAdquisicion, FechaUltimoMantenimiento, FechaProximoMantenimiento, RequiereCalibacion, FechaProximaCalibracion, Estado
-- Valid Types: 'Sistema Emergencia', 'Vehículo', 'Herramienta', 'Maquinaria', 'Camilla', 'Botiquín', 'Extintores'
-- Valid States: 'Dado de Baja', 'Fuera de Servicio', 'En Mantenimiento', 'Operativo'

DECLARE @IdSedeEq INT = (SELECT TOP 1 id_sede FROM SEDE);
DECLARE @IdResponsable INT = (SELECT TOP 1 id_empleado FROM EMPLEADO);

IF NOT EXISTS (SELECT * FROM EQUIPO WHERE Nombre = 'Aire Acondicionado Central')
BEGIN
    INSERT INTO EQUIPO (
        Nombre, Tipo, Marca, Modelo, NumeroSerie, id_sede, UbicacionEspecifica, Responsable, 
        FechaAdquisicion, FechaUltimoMantenimiento, FechaProximoMantenimiento, Estado,
        RequiereCalibacion, CodigoInterno
    )
    VALUES 
    ('Aire Acondicionado Central', 'Maquinaria', 'LG', 'Industrial-X', 'SN123456', @IdSedeEq, 'Techo Planta', @IdResponsable, 
    '2023-01-01', '2023-06-01', DATEADD(day, -15, GETDATE()), 'Operativo', 0, 'EQ-001');
END

IF NOT EXISTS (SELECT * FROM EQUIPO WHERE Nombre = 'Planta Eléctrica')
BEGIN
    INSERT INTO EQUIPO (
        Nombre, Tipo, Marca, Modelo, NumeroSerie, id_sede, UbicacionEspecifica, Responsable, 
        FechaAdquisicion, FechaUltimoMantenimiento, FechaProximoMantenimiento, Estado,
        RequiereCalibacion, CodigoInterno
    )
    VALUES 
    ('Planta Eléctrica', 'Maquinaria', 'Caterpillar', 'G3500', 'CAT98765', @IdSedeEq, 'Cuarto de Máquinas', @IdResponsable, 
    '2022-05-15', '2023-05-15', DATEADD(day, -30, GETDATE()), 'Operativo', 0, 'EQ-002');
END
GO

-- =============================================
-- 3. GAP 6: EVALUACIONES DE RIESGO (Nueva Tabla)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EVALUACION_RIESGO]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[EVALUACION_RIESGO](
        [id_evaluacion] [int] IDENTITY(1,1) NOT NULL,
        [Descripcion] [nvarchar](255) NOT NULL,
        [Tipo_Evaluacion] [nvarchar](100) NULL, -- Inicial, Matriz Peligros, Psicosocial, Biomecánico
        [Fecha_Programada] [date] NOT NULL,
        [Fecha_Realizacion] [date] NULL,
        [Responsable] [nvarchar](100) NULL,
        [Estado] [nvarchar](50) DEFAULT 'Programada', -- Programada, Realizada, Vencida
        [Resultado] [nvarchar](max) NULL,
        PRIMARY KEY CLUSTERED ([id_evaluacion] ASC)
    )
END
GO

-- Insertar ejemplos de evaluaciones vencidas
IF NOT EXISTS (SELECT * FROM EVALUACION_RIESGO WHERE Descripcion = 'Actualización Matriz de Peligros 2024')
BEGIN
    INSERT INTO EVALUACION_RIESGO (Descripcion, Tipo_Evaluacion, Fecha_Programada, Estado, Responsable)
    VALUES 
    ('Actualización Matriz de Peligros 2024', 'Matriz de Peligros', DATEADD(month, -1, GETDATE()), 'Programada', 'Coordinador SST'),
    ('Evaluación de Riesgo Psicosocial', 'Psicosocial', DATEADD(day, -20, GETDATE()), 'Programada', 'Psicólogo SST');
END
GO
