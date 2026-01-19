USE [master]
GO
/****** Object:  Database [SG_SST_AgenteInteligente]    Script Date: 18/12/2025 9:50:01 p. m. ******/
CREATE DATABASE [SG_SST_AgenteInteligente]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SG_SST_AgenteInteligente', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SG_SST_AgenteInteligente.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SG_SST_AgenteInteligente_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\SG_SST_AgenteInteligente_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SG_SST_AgenteInteligente].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET ANSI_NULLS ON 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET ANSI_PADDING ON 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET ANSI_WARNINGS ON 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET ARITHABORT ON 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET CONCAT_NULL_YIELDS_NULL ON 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET QUOTED_IDENTIFIER ON 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET  ENABLE_BROKER 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET  MULTI_USER 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET QUERY_STORE = ON
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [SG_SST_AgenteInteligente]
GO
/****** Object:  Table [dbo].[EMPLEADO]    Script Date: 18/12/2025 9:50:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLEADO](
	[id_empleado] [int] IDENTITY(100,1) NOT NULL,
	[id_sede] [int] NULL,
	[TipoDocumento] [nvarchar](20) NOT NULL,
	[NumeroDocumento] [nvarchar](20) NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Apellidos] [nvarchar](100) NOT NULL,
	[Cargo] [nvarchar](100) NOT NULL,
	[Area] [nvarchar](100) NOT NULL,
	[TipoContrato] [nvarchar](50) NOT NULL,
	[Fecha_Ingreso] [date] NOT NULL,
	[Fecha_Retiro] [date] NULL,
	[Nivel_Riesgo_Laboral] [int] NOT NULL,
	[Correo] [nvarchar](150) NULL,
	[Telefono] [nvarchar](20) NULL,
	[DireccionResidencia] [nvarchar](300) NULL,
	[ContactoEmergencia] [nvarchar](100) NULL,
	[TelefonoEmergencia] [nvarchar](20) NULL,
	[GrupoSanguineo] [nvarchar](5) NULL,
	[Estado] [bit] NULL,
	[id_supervisor] [int] NULL,
	[FechaCreacion] [datetime] NULL,
	[FechaActualizacion] [datetime] NULL,
	[ARL] [nvarchar](100) NULL,
	[FechaAfiliacionARL] [date] NULL,
	[EPS] [nvarchar](100) NULL,
	[AFP] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PERMISO_TRABAJO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PERMISO_TRABAJO](
	[id_permiso] [int] IDENTITY(1,1) NOT NULL,
	[TipoPermiso] [nvarchar](100) NOT NULL,
	[NumeroPermiso] [nvarchar](50) NOT NULL,
	[DescripcionTrabajo] [nvarchar](max) NOT NULL,
	[Ubicacion] [nvarchar](200) NOT NULL,
	[id_sede] [int] NULL,
	[Area] [nvarchar](100) NULL,
	[FechaInicio] [datetime] NOT NULL,
	[FechaFin] [datetime] NOT NULL,
	[Vigencia] [int] NULL,
	[id_solicitante] [int] NULL,
	[id_ejecutor] [int] NULL,
	[id_supervisor] [int] NULL,
	[id_autorizador] [int] NULL,
	[RiesgosIdentificados] [nvarchar](max) NULL,
	[MedidasControl] [nvarchar](max) NULL,
	[EPPRequerido] [nvarchar](500) NULL,
	[RequiereAislamiento] [bit] NULL,
	[RequiereVentilacion] [bit] NULL,
	[RequiereMonitoreoGases] [bit] NULL,
	[RequiereVigia] [bit] NULL,
	[RequiereExtintor] [bit] NULL,
	[NivelOxigeno] [decimal](5, 2) NULL,
	[NivelLEL] [decimal](5, 2) NULL,
	[NivelH2S] [decimal](5, 2) NULL,
	[NivelCO] [decimal](5, 2) NULL,
	[TemperaturaAmbiente] [decimal](5, 2) NULL,
	[Estado] [nvarchar](50) NOT NULL,
	[FechaAutorizacion] [datetime] NULL,
	[FechaCierre] [datetime] NULL,
	[ObservacionesCierre] [nvarchar](max) NULL,
	[RutaDocumento] [nvarchar](500) NULL,
	[RutaART] [nvarchar](500) NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[CreadoPor] [int] NULL,
	[FechaModificacion] [datetime] NULL,
	[ModificadoPor] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_permiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_Permisos_Activos]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[SEDE]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SEDE](
	[id_sede] [int] IDENTITY(1,1) NOT NULL,
	[id_empresa] [int] NULL,
	[NombreSede] [nvarchar](100) NOT NULL,
	[Direccion] [nvarchar](300) NOT NULL,
	[Ciudad] [nvarchar](100) NOT NULL,
	[Departamento] [nvarchar](100) NOT NULL,
	[TelefonoContacto] [nvarchar](20) NULL,
	[Estado] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_sede] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_Empleados_Activos]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_Empleados_Activos] AS
SELECT
    -- Identificación y Nombre
    E.id_empleado,
    E.TipoDocumento,
    E.NumeroDocumento,
    E.Nombre + ' ' + E.Apellidos AS NombreCompleto,
    E.Nombre,
    E.Apellidos,
    
    -- Información Laboral
    E.Cargo,
    E.Area,
    E.TipoContrato,
    E.Fecha_Ingreso,
    E.Fecha_Retiro,
    E.Nivel_Riesgo_Laboral,
    DATEDIFF(YEAR, E.Fecha_Ingreso, GETDATE()) AS AniosAntiguedad,
    
    -- Contacto
    E.Correo,
    E.Telefono,
    E.DireccionResidencia,
    
    -- Emergencia
    E.ContactoEmergencia,
    E.TelefonoEmergencia,
    
    -- Información Médica
    E.GrupoSanguineo,
    
    -- Seguridad Social (Nuevos Campos)
    E.ARL,
    E.FechaAfiliacionARL,
    E.EPS,
    E.AFP,
    
    -- Ubicación (Join con Sede)
    E.id_sede,
    S.NombreSede,
    S.Ciudad,
    S.Departamento,
    
    -- Supervisor (Join con Empleado)
    E.id_supervisor,
    SUP.Nombre + ' ' + SUP.Apellidos AS Supervisor,
    
    -- Auditoría
    E.Estado,
    E.FechaCreacion,
    E.FechaActualizacion

FROM [dbo].[EMPLEADO] E
LEFT JOIN [dbo].[SEDE] S ON E.id_sede = S.id_sede
LEFT JOIN [dbo].[EMPLEADO] SUP ON E.id_supervisor = SUP.id_empleado

WHERE E.Estado = 1 -- Solo activos
GO
/****** Object:  Table [dbo].[TAREA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAREA](
	[id_tarea] [int] IDENTITY(2000,1) NOT NULL,
	[id_plan] [int] NULL,
	[Descripcion] [nvarchar](max) NOT NULL,
	[Tipo_Tarea] [nvarchar](100) NULL,
	[Fecha_Creacion] [date] NOT NULL,
	[Fecha_Vencimiento] [date] NOT NULL,
	[Prioridad] [nvarchar](20) NULL,
	[Estado] [nvarchar](50) NOT NULL,
	[id_empleado_responsable] [int] NULL,
	[Origen_Tarea] [nvarchar](100) NULL,
	[AvancePorc] [decimal](5, 2) NULL,
	[Fecha_Actualizacion] [datetime] NULL,
	[Fecha_Cierre] [date] NULL,
	[id_empleado_cierre] [int] NULL,
	[Observaciones_Cierre] [nvarchar](max) NULL,
	[CostoEstimado] [decimal](15, 2) NULL,
	[RutaEvidencia] [nvarchar](500) NULL,
	[id_formulario] [nvarchar](100) NULL,
	[requiere_formulario] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_tarea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[COMITE]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMITE](
	[id_comite] [int] IDENTITY(10,1) NOT NULL,
	[Tipo_Comite] [nvarchar](50) NOT NULL,
	[Fecha_Conformacion] [date] NOT NULL,
	[Fecha_Vigencia] [date] NOT NULL,
	[ActaConformacion] [nvarchar](500) NULL,
	[Estado] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_comite] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EXAMEN_MEDICO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXAMEN_MEDICO](
	[id_examen] [int] IDENTITY(3000,1) NOT NULL,
	[id_empleado] [int] NULL,
	[Tipo_Examen] [nvarchar](50) NOT NULL,
	[Fecha_Realizacion] [date] NOT NULL,
	[Fecha_Vencimiento] [date] NULL,
	[EntidadRealizadora] [nvarchar](200) NULL,
	[MedicoEvaluador] [nvarchar](100) NULL,
	[Apto_Para_Cargo] [bit] NULL,
	[Restricciones] [nvarchar](max) NULL,
	[Recomendaciones] [nvarchar](max) NULL,
	[DiagnosticosCodificados] [nvarchar](500) NULL,
	[RequiereSeguimiento] [bit] NULL,
	[RutaResultados] [nvarchar](500) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_examen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EPP]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EPP](
	[id_epp] [int] IDENTITY(6000,1) NOT NULL,
	[Codigo_EPP] [nvarchar](50) NOT NULL,
	[Nombre_EPP] [nvarchar](100) NOT NULL,
	[Tipo_EPP] [nvarchar](100) NULL,
	[Riesgo_Protegido] [nvarchar](100) NOT NULL,
	[Especificaciones] [nvarchar](max) NULL,
	[Certificacion] [nvarchar](200) NULL,
	[Stock_Disponible] [int] NULL,
	[Ubicacion_Almacen] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_epp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ENTREGA_EPP]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ENTREGA_EPP](
	[id_entrega] [int] IDENTITY(1,1) NOT NULL,
	[id_empleado] [int] NULL,
	[id_epp] [int] NULL,
	[Fecha_Entrega] [date] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[Vida_Util_Meses] [int] NULL,
	[Fecha_Reemplazo_Estimada] [date] NULL,
	[Entregado_Por] [int] NULL,
	[Firma_Recibido] [bit] NULL,
	[RutaActaEntrega] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_entrega] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CAPACITACION]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAPACITACION](
	[id_capacitacion] [int] IDENTITY(4000,1) NOT NULL,
	[Codigo_Capacitacion] [nvarchar](50) NULL,
	[Tema] [nvarchar](200) NOT NULL,
	[Tipo] [nvarchar](50) NOT NULL,
	[Modalidad] [nvarchar](50) NOT NULL,
	[Duracion_Horas] [decimal](5, 2) NOT NULL,
	[Fecha_Programada] [date] NULL,
	[Fecha_Realizacion] [date] NULL,
	[Lugar] [nvarchar](200) NULL,
	[Facilitador] [nvarchar](100) NULL,
	[EntidadProveedora] [nvarchar](200) NULL,
	[Objetivo] [nvarchar](max) NULL,
	[Responsable] [int] NULL,
	[Estado] [nvarchar](50) NULL,
	[RutaMaterial] [nvarchar](500) NULL,
	[RutaEvidencias] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_capacitacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ALERTA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ALERTA](
	[id_alerta] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [nvarchar](100) NOT NULL,
	[Prioridad] [nvarchar](20) NULL,
	[Descripcion] [nvarchar](500) NOT NULL,
	[FechaGeneracion] [datetime] NULL,
	[FechaEvento] [date] NULL,
	[Estado] [nvarchar](20) NULL,
	[ModuloOrigen] [nvarchar](50) NULL,
	[IdRelacionado] [int] NULL,
	[DestinatariosCorreo] [nvarchar](max) NULL,
	[Enviada] [bit] NULL,
	[FechaEnvio] [datetime] NULL,
	[IntentosEnvio] [int] NULL,
	[UltimoError] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_alerta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EQUIPO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EQUIPO](
	[id_equipo] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](200) NOT NULL,
	[Tipo] [nvarchar](100) NOT NULL,
	[CodigoInterno] [nvarchar](50) NULL,
	[Marca] [nvarchar](100) NULL,
	[Modelo] [nvarchar](100) NULL,
	[NumeroSerie] [nvarchar](100) NULL,
	[id_sede] [int] NULL,
	[UbicacionEspecifica] [nvarchar](200) NULL,
	[Responsable] [int] NULL,
	[FechaAdquisicion] [date] NULL,
	[FechaUltimoMantenimiento] [date] NULL,
	[FechaProximoMantenimiento] [date] NULL,
	[RequiereCalibacion] [bit] NULL,
	[FechaProximaCalibracion] [date] NULL,
	[Estado] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_equipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_Dashboard_Alertas]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- VISTA 2: Dashboard de Alertas Pendientes
-- ============================================================
CREATE   VIEW [dbo].[VW_Dashboard_Alertas] AS
SELECT 
    A.id_alerta,
    A.Tipo,
    A.Prioridad,
    A.Descripcion,
    A.FechaGeneracion,
    A.FechaEvento,
    DATEDIFF(DAY, GETDATE(), A.FechaEvento) AS DiasHastaEvento,
    A.Estado,
    A.ModuloOrigen,
    A.IdRelacionado,
    A.Enviada,
    A.IntentosEnvio,
    CASE A.ModuloOrigen
        WHEN 'EXAMEN_MEDICO' THEN CONCAT('EMO: ', EM.Tipo_Examen, ' - ', E1.Nombre)
        WHEN 'EXAMEN_MEDICO_VENCIDO' THEN CONCAT('EMO VENCIDO: ', EM.Tipo_Examen, ' - ', E1.Nombre)
        WHEN 'TAREA' THEN CONCAT('Tarea: ', T.Tipo_Tarea, ' - ', E2.Nombre)
        WHEN 'COMITE' THEN CONCAT('Comité: ', C.Tipo_Comite)
        WHEN 'EPP' THEN CONCAT('EPP: ', EP.Nombre_EPP)
        WHEN 'CAPACITACION' THEN CONCAT('Capacitación: ', CAP.Tema)
        WHEN 'EQUIPO' THEN CONCAT('Equipo: ', EQ.Nombre)
        WHEN 'EVENTO_ARL' THEN 'Accidente sin Reportar ARL'
        ELSE A.ModuloOrigen
    END AS DetalleOrigen
FROM ALERTA A
LEFT JOIN EXAMEN_MEDICO EM ON A.IdRelacionado = EM.id_examen AND A.ModuloOrigen LIKE 'EXAMEN_MEDICO%'
LEFT JOIN EMPLEADO E1 ON EM.id_empleado = E1.id_empleado
LEFT JOIN TAREA T ON A.IdRelacionado = T.id_tarea AND A.ModuloOrigen = 'TAREA'
LEFT JOIN EMPLEADO E2 ON T.id_empleado_responsable = E2.id_empleado
LEFT JOIN COMITE C ON A.IdRelacionado = C.id_comite AND A.ModuloOrigen = 'COMITE'
LEFT JOIN ENTREGA_EPP ENT ON A.IdRelacionado = ENT.id_entrega AND A.ModuloOrigen = 'EPP'
LEFT JOIN EPP EP ON ENT.id_epp = EP.id_epp
LEFT JOIN CAPACITACION CAP ON A.IdRelacionado = CAP.id_capacitacion AND A.ModuloOrigen = 'CAPACITACION'
LEFT JOIN EQUIPO EQ ON A.IdRelacionado = EQ.id_equipo AND A.ModuloOrigen = 'EQUIPO'
WHERE A.Estado IN ('Pendiente', 'Enviada');
GO
/****** Object:  Table [dbo].[EVENTO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVENTO](
	[id_evento] [int] IDENTITY(1000,1) NOT NULL,
	[Tipo_Evento] [nvarchar](50) NOT NULL,
	[Fecha_Evento] [datetime] NOT NULL,
	[Hora_Evento] [time](7) NULL,
	[id_empleado] [int] NULL,
	[Lugar_Evento] [nvarchar](200) NULL,
	[Descripcion_Evento] [nvarchar](max) NOT NULL,
	[Parte_Cuerpo_Afectada] [nvarchar](100) NULL,
	[Naturaleza_Lesion] [nvarchar](100) NULL,
	[Mecanismo_Accidente] [nvarchar](200) NULL,
	[Testigos] [nvarchar](500) NULL,
	[Dias_Incapacidad] [int] NULL,
	[ClasificacionIncapacidad] [nvarchar](50) NULL,
	[Reportado_ARL] [bit] NULL,
	[Fecha_Reporte_ARL] [datetime] NULL,
	[Numero_Caso_ARL] [nvarchar](50) NULL,
	[Requiere_Investigacion] [bit] NULL,
	[Estado_Investigacion] [nvarchar](50) NULL,
	[Fecha_Investigacion] [date] NULL,
	[Causas_Inmediatas] [nvarchar](max) NULL,
	[Causas_Basicas] [nvarchar](max) NULL,
	[Analisis_Causas] [nvarchar](max) NULL,
	[id_responsable_investigacion] [int] NULL,
	[FechaRegistro] [datetime] NULL,
	[LugarAtencionMedica] [nvarchar](200) NULL,
	[NombreMedicoTratante] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HALLAZGO_AUDITORIA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HALLAZGO_AUDITORIA](
	[id_hallazgo] [int] IDENTITY(1,1) NOT NULL,
	[id_auditoria] [int] NULL,
	[NumeroHallazgo] [nvarchar](50) NULL,
	[TipoHallazgo] [nvarchar](50) NOT NULL,
	[Criterio] [nvarchar](200) NULL,
	[Descripcion] [nvarchar](max) NOT NULL,
	[Evidencia] [nvarchar](max) NULL,
	[ResponsableArea] [int] NULL,
	[EstadoHallazgo] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_hallazgo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_Indicadores_Tiempo_Real]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- VISTA 3: Indicadores en Tiempo Real (KPIs)
-- ============================================================
CREATE   VIEW [dbo].[VW_Indicadores_Tiempo_Real] AS
SELECT 
    (SELECT COUNT(*) FROM EMPLEADO WHERE Estado = 1) AS Total_Empleados_Activos,
    
    (SELECT COUNT(*) FROM EVENTO 
     WHERE Tipo_Evento = 'Accidente de Trabajo' 
     AND YEAR(Fecha_Evento) = YEAR(GETDATE())) AS Accidentes_AnioActual,
    
    (SELECT ISNULL(SUM(Dias_Incapacidad), 0) FROM EVENTO 
     WHERE Tipo_Evento = 'Accidente de Trabajo' 
     AND YEAR(Fecha_Evento) = YEAR(GETDATE())) AS Dias_Incapacidad_AnioActual,
    
    (SELECT COUNT(*) FROM TAREA WHERE Estado = 'Vencida') AS Tareas_Vencidas,
    
    (SELECT COUNT(*) FROM TAREA 
     WHERE Estado IN ('Pendiente', 'En Curso')) AS Tareas_Activas,
    
    (SELECT COUNT(*) FROM ALERTA 
     WHERE Prioridad = 'Crítica' AND Estado = 'Pendiente') AS Alertas_Criticas_Pendientes,
    
    (SELECT COUNT(*) FROM ALERTA 
     WHERE Prioridad IN ('Crítica', 'Alta') AND Estado = 'Pendiente') AS Alertas_Urgentes_Pendientes,
    
    (SELECT COUNT(DISTINCT E.id_empleado) 
     FROM EMPLEADO E 
     WHERE E.Estado = 1 
     AND EXISTS (
        SELECT 1 FROM EXAMEN_MEDICO EM 
        WHERE EM.id_empleado = E.id_empleado 
        AND (EM.Fecha_Vencimiento >= CAST(GETDATE() AS DATE) OR EM.Fecha_Vencimiento IS NULL)
     )) AS Empleados_EMO_Vigente,
    
    (SELECT COUNT(*) FROM CAPACITACION 
     WHERE Estado = 'Realizada' 
     AND YEAR(Fecha_Realizacion) = YEAR(GETDATE())) AS Capacitaciones_Realizadas_AnioActual,
    
    (SELECT COUNT(*) FROM HALLAZGO_AUDITORIA 
     WHERE EstadoHallazgo IN ('Abierto', 'En Tratamiento')) AS Hallazgos_Auditoria_Abiertos,
    
    (SELECT COUNT(*) FROM COMITE 
     WHERE Estado = 'Vigente') AS Comites_Vigentes,
    
    GETDATE() AS Fecha_Actualizacion;
GO
/****** Object:  View [dbo].[VW_Tareas_Por_Responsable]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- VISTA 4: Resumen de Tareas por Responsable
-- ============================================================
CREATE   VIEW [dbo].[VW_Tareas_Por_Responsable] AS
SELECT 
    E.id_empleado,
    E.Nombre + ' ' + E.Apellidos AS Responsable,
    E.Area,
    E.Correo,
    COUNT(*) AS Total_Tareas,
    SUM(CASE WHEN T.Estado = 'Pendiente' THEN 1 ELSE 0 END) AS Pendientes,
    SUM(CASE WHEN T.Estado = 'En Curso' THEN 1 ELSE 0 END) AS En_Curso,
    SUM(CASE WHEN T.Estado = 'Cerrada' THEN 1 ELSE 0 END) AS Cerradas,
    SUM(CASE WHEN T.Estado = 'Vencida' THEN 1 ELSE 0 END) AS Vencidas,
    AVG(T.AvancePorc) AS Avance_Promedio,
    MAX(T.Fecha_Actualizacion) AS Ultima_Actualizacion
FROM EMPLEADO E
INNER JOIN TAREA T ON E.id_empleado = T.id_empleado_responsable
WHERE E.Estado = 1
GROUP BY E.id_empleado, E.Nombre, E.Apellidos, E.Area, E.Correo;
GO
/****** Object:  View [dbo].[VW_Historial_Accidentalidad]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- VISTA 5: Historial de Accidentalidad
-- ============================================================
CREATE   VIEW [dbo].[VW_Historial_Accidentalidad] AS
SELECT 
    EV.id_evento,
    EV.Tipo_Evento,
    EV.Fecha_Evento,
    YEAR(EV.Fecha_Evento) AS Anio,
    MONTH(EV.Fecha_Evento) AS Mes,
    DATENAME(MONTH, EV.Fecha_Evento) AS Nombre_Mes,
    E.Nombre + ' ' + E.Apellidos AS Empleado,
    E.Area,
    E.Cargo,
    EV.Lugar_Evento,
    EV.Descripcion_Evento,
    EV.Parte_Cuerpo_Afectada,
    EV.Naturaleza_Lesion,
    EV.Dias_Incapacidad,
    EV.ClasificacionIncapacidad,
    EV.Reportado_ARL,
    EV.Fecha_Reporte_ARL,
    EV.Estado_Investigacion,
    EV.Causas_Inmediatas,
    EV.Causas_Basicas
FROM EVENTO EV
INNER JOIN EMPLEADO E ON EV.id_empleado = E.id_empleado;
GO
/****** Object:  Table [dbo].[ACCION_CORRECTIVA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACCION_CORRECTIVA](
	[id_accion] [int] IDENTITY(1,1) NOT NULL,
	[id_evento] [int] NULL,
	[TipoAccion] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](max) NOT NULL,
	[ResponsableEjecucion] [int] NULL,
	[FechaCompromiso] [date] NOT NULL,
	[FechaCierre] [date] NULL,
	[Estado] [nvarchar](50) NULL,
	[EficaciaVerificada] [bit] NULL,
	[Observaciones] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_accion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ACCION_MEJORA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ACCION_MEJORA](
	[id_accion_mejora] [int] IDENTITY(1,1) NOT NULL,
	[Origen] [nvarchar](100) NULL,
	[IdOrigenRelacionado] [int] NULL,
	[Descripcion] [nvarchar](max) NOT NULL,
	[TipoAccion] [nvarchar](50) NOT NULL,
	[ResponsableEjecucion] [int] NULL,
	[FechaCreacion] [date] NULL,
	[FechaCompromiso] [date] NOT NULL,
	[FechaCierre] [date] NULL,
	[Estado] [nvarchar](50) NULL,
	[EficaciaVerificada] [bit] NULL,
	[FechaVerificacion] [date] NULL,
	[ResultadoVerificacion] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_accion_mejora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AGENTE_ROL]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AGENTE_ROL](
	[id_agente_rol] [int] IDENTITY(1,1) NOT NULL,
	[nombre_rol] [nvarchar](50) NOT NULL,
	[descripcion] [nvarchar](255) NULL,
	[agentes_permitidos] [nvarchar](max) NULL,
	[nivel_acceso] [int] NULL,
	[activo] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[FechaActualizacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_agente_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AMENAZA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AMENAZA](
	[id_amenaza] [int] IDENTITY(1,1) NOT NULL,
	[TipoAmenaza] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](500) NOT NULL,
	[id_sede] [int] NULL,
	[Probabilidad] [nvarchar](50) NOT NULL,
	[Impacto] [nvarchar](50) NOT NULL,
	[NivelRiesgo] [nvarchar](50) NULL,
	[MedidasPrevencion] [nvarchar](max) NULL,
	[MedidasMitigacion] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_amenaza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ASISTENCIA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ASISTENCIA](
	[id_asistencia] [int] IDENTITY(1,1) NOT NULL,
	[id_empleado] [int] NULL,
	[id_capacitacion] [int] NULL,
	[Asistio] [bit] NOT NULL,
	[Calificacion] [decimal](3, 1) NULL,
	[Aprobo] [bit] NULL,
	[Observaciones] [nvarchar](500) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_asistencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AUDITORIA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AUDITORIA](
	[id_auditoria] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [nvarchar](100) NOT NULL,
	[Fecha_Programada] [date] NULL,
	[Fecha_Realizacion] [date] NOT NULL,
	[Alcance] [nvarchar](max) NULL,
	[Criterios_Auditoria] [nvarchar](max) NULL,
	[Auditor_Lider] [int] NULL,
	[Equipo_Auditor] [nvarchar](500) NULL,
	[EntidadAuditora] [nvarchar](200) NULL,
	[Hallazgos_Resumen] [nvarchar](max) NULL,
	[Conclusiones] [nvarchar](max) NULL,
	[Calificacion_Global] [decimal](5, 2) NULL,
	[Estado] [nvarchar](50) NULL,
	[RutaInforme] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_auditoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AUSENTISMO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AUSENTISMO](
	[id_ausentismo] [int] IDENTITY(1,1) NOT NULL,
	[id_empleado] [int] NULL,
	[TipoAusentismo] [nvarchar](50) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NULL,
	[DiasAusentismo] [int] NULL,
	[DiagnosticoCIE10] [nvarchar](10) NULL,
	[DescripcionDiagnostico] [nvarchar](200) NULL,
	[RutaSoporte] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_ausentismo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BRIGADA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BRIGADA](
	[id_brigada] [int] IDENTITY(1,1) NOT NULL,
	[NombreBrigada] [nvarchar](100) NOT NULL,
	[TipoBrigada] [nvarchar](100) NOT NULL,
	[id_sede] [int] NULL,
	[FechaConformacion] [date] NOT NULL,
	[Coordinador] [int] NULL,
	[Estado] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_brigada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CATALOGO_PELIGRO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CATALOGO_PELIGRO](
	[id_catalogo_peligro] [int] IDENTITY(1,1) NOT NULL,
	[Clasificacion] [nvarchar](50) NOT NULL,
	[TipoPeligro] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_catalogo_peligro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[COMPETENCIA_SST]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMPETENCIA_SST](
	[id_competencia] [int] IDENTITY(1,1) NOT NULL,
	[id_empleado] [int] NULL,
	[TipoCompetencia] [nvarchar](100) NOT NULL,
	[NivelCompetencia] [nvarchar](50) NULL,
	[FechaCertificacion] [date] NULL,
	[FechaVencimiento] [date] NULL,
	[EntidadCertificadora] [nvarchar](200) NULL,
	[NumeroCertificado] [nvarchar](100) NULL,
	[RutaCertificado] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_competencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CONFIG_AGENTE]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONFIG_AGENTE](
	[id_config] [int] IDENTITY(1,1) NOT NULL,
	[Clave] [nvarchar](100) NOT NULL,
	[Valor] [nvarchar](max) NOT NULL,
	[TipoDato] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](300) NULL,
	[FechaActualizacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_config] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CONTRATISTA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONTRATISTA](
	[id_contratista] [int] IDENTITY(1,1) NOT NULL,
	[RazonSocial] [nvarchar](200) NOT NULL,
	[NIT] [nvarchar](20) NOT NULL,
	[ActividadContratada] [nvarchar](300) NOT NULL,
	[NivelRiesgo] [int] NULL,
	[ContactoPrincipal] [nvarchar](100) NULL,
	[TelefonoContacto] [nvarchar](20) NULL,
	[CorreoContacto] [nvarchar](150) NULL,
	[FechaInicioContrato] [date] NULL,
	[FechaFinContrato] [date] NULL,
	[Estado] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_contratista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CONVERSACION_AGENTE]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONVERSACION_AGENTE](
	[id_conversacion] [int] IDENTITY(1,1) NOT NULL,
	[id_usuario_autorizado] [int] NULL,
	[CorreoOrigen] [nvarchar](150) NOT NULL,
	[Asunto] [nvarchar](300) NULL,
	[FechaHoraRecepcion] [datetime] NOT NULL,
	[TipoSolicitud] [nvarchar](100) NULL,
	[ContenidoOriginal] [nvarchar](max) NULL,
	[InterpretacionAgente] [nvarchar](max) NULL,
	[RespuestaGenerada] [nvarchar](max) NULL,
	[AccionesRealizadas] [nvarchar](max) NULL,
	[FechaHoraRespuesta] [datetime] NULL,
	[Estado] [nvarchar](50) NULL,
	[ConfianzaRespuesta] [decimal](3, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_conversacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DOCUMENTO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DOCUMENTO](
	[id_documento] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](50) NOT NULL,
	[Nombre] [nvarchar](200) NOT NULL,
	[Tipo] [nvarchar](50) NOT NULL,
	[CategoriaSGSST] [nvarchar](100) NULL,
	[Area] [nvarchar](100) NULL,
	[FechaCreacion] [date] NULL,
	[FechaUltimaRevision] [date] NULL,
	[ProximaRevision] [date] NULL,
	[Estado] [nvarchar](20) NULL,
	[Responsable] [int] NULL,
	[RutaArchivo] [nvarchar](500) NULL,
	[RequiereAprobacion] [bit] NULL,
	[AprobadoPor] [int] NULL,
	[descripcion] [nvarchar](max) NULL,
	[version] [int] NULL,
	[mime_type] [nvarchar](100) NULL,
	[tamano_bytes] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_documento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EMPLEADO_AGENTE_ROL]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLEADO_AGENTE_ROL](
	[id_empleado_agente_rol] [int] IDENTITY(1,1) NOT NULL,
	[id_empleado] [int] NOT NULL,
	[id_agente_rol] [int] NOT NULL,
	[FechaAsignacion] [datetime] NULL,
	[FechaFinalizacion] [datetime] NULL,
	[asignado_por] [int] NULL,
	[motivo] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_empleado_agente_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EMPLEADO_ROL]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLEADO_ROL](
	[id_empleado] [int] NOT NULL,
	[id_rol] [int] NOT NULL,
	[FechaAsignacion] [date] NULL,
	[FechaFinalizacion] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC,
	[id_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EMPRESA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPRESA](
	[id_empresa] [int] IDENTITY(1,1) NOT NULL,
	[RazonSocial] [nvarchar](200) NOT NULL,
	[NIT] [nvarchar](20) NOT NULL,
	[ActividadEconomica] [nvarchar](200) NOT NULL,
	[ClaseRiesgo] [int] NOT NULL,
	[NumeroTrabajadores] [int] NOT NULL,
	[DireccionPrincipal] [nvarchar](300) NULL,
	[Telefono] [nvarchar](20) NULL,
	[FechaConstitucion] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EVALUACION_CONTRATISTA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVALUACION_CONTRATISTA](
	[id_evaluacion] [int] IDENTITY(1,1) NOT NULL,
	[id_contratista] [int] NULL,
	[FechaEvaluacion] [date] NOT NULL,
	[TipoEvaluacion] [nvarchar](50) NOT NULL,
	[SG_SST_Implementado] [bit] NULL,
	[Afiliacion_ARL_Vigente] [bit] NULL,
	[Cumple_Normativa] [bit] NULL,
	[CalificacionTotal] [decimal](5, 2) NULL,
	[Observaciones] [nvarchar](max) NULL,
	[ResponsableEvaluacion] [int] NULL,
	[Aprobado] [bit] NULL,
	[RutaSoportes] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_evaluacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EVALUACION_LEGAL]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVALUACION_LEGAL](
	[id_evaluacion] [int] IDENTITY(1,1) NOT NULL,
	[id_requisito] [int] NULL,
	[FechaEvaluacion] [date] NOT NULL,
	[EstadoCumplimiento] [nvarchar](50) NOT NULL,
	[Evidencias] [nvarchar](max) NULL,
	[ResponsableEvaluacion] [int] NULL,
	[Observaciones] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_evaluacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EVALUACION_RIESGO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EVALUACION_RIESGO](
	[id_evaluacion] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](255) NOT NULL,
	[Tipo_Evaluacion] [nvarchar](100) NULL,
	[Fecha_Programada] [date] NOT NULL,
	[Fecha_Realizacion] [date] NULL,
	[Responsable] [nvarchar](100) NULL,
	[Estado] [nvarchar](50) NULL,
	[Resultado] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_evaluacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EXPOSICION]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXPOSICION](
	[id_empleado] [int] NOT NULL,
	[id_riesgo] [int] NOT NULL,
	[TiempoExposicionDiario] [decimal](5, 2) NULL,
	[FrecuenciaExposicion] [nvarchar](50) NULL,
	[FechaRegistro] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC,
	[id_riesgo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FORM_DRAFTS]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FORM_DRAFTS](
	[id_draft] [int] IDENTITY(1,1) NOT NULL,
	[form_id] [nvarchar](100) NOT NULL,
	[user_id] [int] NOT NULL,
	[data_json] [nvarchar](max) NOT NULL,
	[saved_at] [datetime] NOT NULL,
	[expires_at] [datetime] NULL,
 CONSTRAINT [PK_FORM_DRAFTS] PRIMARY KEY CLUSTERED 
(
	[id_draft] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FORM_SUBMISSION_AUDIT]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FORM_SUBMISSION_AUDIT](
	[id_audit] [int] IDENTITY(1,1) NOT NULL,
	[id_submission] [int] NOT NULL,
	[action] [nvarchar](20) NOT NULL,
	[field_changed] [nvarchar](100) NULL,
	[old_value] [nvarchar](max) NULL,
	[new_value] [nvarchar](max) NULL,
	[changed_by] [int] NOT NULL,
	[changed_at] [datetime] NOT NULL,
	[ip_address] [nvarchar](50) NULL,
 CONSTRAINT [PK_FORM_SUBMISSION_AUDIT] PRIMARY KEY CLUSTERED 
(
	[id_audit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FORM_SUBMISSIONS]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FORM_SUBMISSIONS](
	[id_submission] [int] IDENTITY(1,1) NOT NULL,
	[form_id] [nvarchar](100) NOT NULL,
	[form_version] [nvarchar](20) NOT NULL,
	[form_title] [nvarchar](200) NULL,
	[data_json] [nvarchar](max) NOT NULL,
	[attachments_json] [nvarchar](max) NULL,
	[submitted_by] [int] NOT NULL,
	[submitted_at] [datetime] NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[workflow_status] [nvarchar](50) NULL,
	[reviewed_by] [int] NULL,
	[reviewed_at] [datetime] NULL,
	[review_notes] [nvarchar](max) NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[updated_by] [int] NULL,
	[ip_address] [nvarchar](50) NULL,
	[user_agent] [nvarchar](500) NULL,
	[deleted] [bit] NOT NULL,
	[deleted_at] [datetime] NULL,
	[deleted_by] [int] NULL,
	[error_message] [nvarchar](max) NULL,
 CONSTRAINT [PK_FORM_SUBMISSIONS] PRIMARY KEY CLUSTERED 
(
	[id_submission] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HALLAZGO_INSPECCION]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HALLAZGO_INSPECCION](
	[id_hallazgo] [int] IDENTITY(1,1) NOT NULL,
	[id_inspeccion] [int] NULL,
	[Descripcion] [nvarchar](max) NOT NULL,
	[NivelRiesgo] [nvarchar](50) NOT NULL,
	[AccionRequerida] [nvarchar](max) NULL,
	[ResponsableAccion] [int] NULL,
	[FechaCompromiso] [date] NULL,
	[EstadoAccion] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_hallazgo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HISTORIAL_NOTIFICACION]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HISTORIAL_NOTIFICACION](
	[id_historial] [int] IDENTITY(1,1) NOT NULL,
	[id_alerta] [int] NULL,
	[TipoNotificacion] [nvarchar](50) NOT NULL,
	[Destinatarios] [nvarchar](max) NULL,
	[AsuntoMensaje] [nvarchar](300) NULL,
	[CuerpoMensaje] [nvarchar](max) NULL,
	[FechaEnvio] [datetime] NOT NULL,
	[EstadoEnvio] [nvarchar](50) NOT NULL,
	[MensajeError] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_historial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INDICADOR]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INDICADOR](
	[id_indicador] [int] IDENTITY(1,1) NOT NULL,
	[TipoIndicador] [nvarchar](50) NOT NULL,
	[NombreIndicador] [nvarchar](200) NOT NULL,
	[FormulaCalculo] [nvarchar](500) NULL,
	[UnidadMedida] [nvarchar](50) NULL,
	[Frecuencia] [nvarchar](50) NULL,
	[MetaEsperada] [decimal](10, 2) NULL,
	[ResponsableReporte] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_indicador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INSPECCION]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INSPECCION](
	[id_inspeccion] [int] IDENTITY(5000,1) NOT NULL,
	[Tipo_Inspeccion] [nvarchar](100) NOT NULL,
	[Area_Inspeccionada] [nvarchar](100) NOT NULL,
	[id_sede] [int] NULL,
	[Fecha_Inspeccion] [date] NOT NULL,
	[Fecha_Programada] [date] NULL,
	[id_empleado_inspector] [int] NULL,
	[HallazgosEncontrados] [nvarchar](max) NULL,
	[Estado] [nvarchar](50) NULL,
	[RequiereAcciones] [bit] NULL,
	[RutaReporte] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_inspeccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOG_AGENTE]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOG_AGENTE](
	[id_log] [int] IDENTITY(1,1) NOT NULL,
	[id_conversacion] [int] NULL,
	[FechaHora] [datetime] NULL,
	[TipoEvento] [nvarchar](100) NULL,
	[ModuloAfectado] [nvarchar](100) NULL,
	[Descripcion] [nvarchar](max) NULL,
	[Exitoso] [bit] NULL,
	[MensajeError] [nvarchar](max) NULL,
	[TiempoEjecucionMs] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_log] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MANTENIMIENTO_EQUIPO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MANTENIMIENTO_EQUIPO](
	[id_mantenimiento] [int] IDENTITY(1,1) NOT NULL,
	[id_equipo] [int] NULL,
	[TipoMantenimiento] [nvarchar](50) NOT NULL,
	[FechaMantenimiento] [date] NOT NULL,
	[ProximoMantenimiento] [date] NULL,
	[ResponsableEjecucion] [nvarchar](200) NULL,
	[DescripcionActividades] [nvarchar](max) NULL,
	[Costo] [decimal](15, 2) NULL,
	[RutaReporte] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_mantenimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MIEMBRO_BRIGADA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MIEMBRO_BRIGADA](
	[id_empleado] [int] NOT NULL,
	[id_brigada] [int] NOT NULL,
	[Rol] [nvarchar](100) NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NULL,
	[CertificacionVigente] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC,
	[id_brigada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MIEMBRO_COMITE]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MIEMBRO_COMITE](
	[id_empleado] [int] NOT NULL,
	[id_comite] [int] NOT NULL,
	[Rol_Miembro] [nvarchar](50) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC,
	[id_comite] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OBJETIVO_SST]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OBJETIVO_SST](
	[id_objetivo] [int] IDENTITY(1,1) NOT NULL,
	[id_plan] [int] NULL,
	[Descripcion] [nvarchar](max) NOT NULL,
	[Indicador] [nvarchar](200) NULL,
	[MetaEsperada] [nvarchar](100) NULL,
	[ResponsableCumplimiento] [int] NULL,
	[FechaLimite] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_objetivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PLAN_ACCION_AUDITORIA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PLAN_ACCION_AUDITORIA](
	[id_plan_accion] [int] IDENTITY(1,1) NOT NULL,
	[id_hallazgo] [int] NULL,
	[AccionPropuesta] [nvarchar](max) NOT NULL,
	[ResponsableEjecucion] [int] NULL,
	[FechaCompromiso] [date] NOT NULL,
	[FechaCierre] [date] NULL,
	[RecursosNecesarios] [nvarchar](max) NULL,
	[Estado] [nvarchar](50) NULL,
	[VerificacionEficacia] [bit] NULL,
	[FechaVerificacion] [date] NULL,
	[ResponsableVerificacion] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_plan_accion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PLAN_TRABAJO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PLAN_TRABAJO](
	[id_plan] [int] IDENTITY(1,1) NOT NULL,
	[Anio] [int] NOT NULL,
	[FechaElaboracion] [date] NOT NULL,
	[ElaboradoPor] [int] NULL,
	[AprobadoPor] [int] NULL,
	[FechaAprobacion] [date] NULL,
	[PresupuestoAsignado] [decimal](15, 2) NULL,
	[Estado] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_plan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PLANTILLA_DOCUMENTO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PLANTILLA_DOCUMENTO](
	[id_plantilla] [int] IDENTITY(1,1) NOT NULL,
	[NombrePlantilla] [nvarchar](200) NOT NULL,
	[TipoDocumento] [nvarchar](100) NOT NULL,
	[CategoriaSGSST] [nvarchar](100) NULL,
	[RutaPlantilla] [nvarchar](500) NOT NULL,
	[Formato] [nvarchar](20) NOT NULL,
	[VariablesDisponibles] [nvarchar](max) NULL,
	[Activa] [bit] NULL,
	[FechaCreacion] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_plantilla] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PROGRAMA_VIGILANCIA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PROGRAMA_VIGILANCIA](
	[id_programa] [int] IDENTITY(1,1) NOT NULL,
	[NombrePrograma] [nvarchar](200) NOT NULL,
	[TipoRiesgo] [nvarchar](100) NOT NULL,
	[Objetivo] [nvarchar](max) NULL,
	[Poblacion_Objetivo] [nvarchar](max) NULL,
	[Responsable] [int] NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaRevision] [date] NULL,
	[Estado] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_programa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[REPORTE_GENERADO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REPORTE_GENERADO](
	[id_reporte] [int] IDENTITY(1,1) NOT NULL,
	[TipoReporte] [nvarchar](100) NOT NULL,
	[Periodo] [nvarchar](50) NULL,
	[Solicitante] [nvarchar](150) NULL,
	[FechaGeneracion] [datetime] NULL,
	[Parametros] [nvarchar](max) NULL,
	[RutaArchivo] [nvarchar](500) NULL,
	[FormatoSalida] [nvarchar](20) NULL,
	[EstadoGeneracion] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_reporte] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[REQUISITO_LEGAL]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REQUISITO_LEGAL](
	[id_requisito] [int] IDENTITY(500,1) NOT NULL,
	[Norma] [nvarchar](100) NOT NULL,
	[Articulo] [nvarchar](50) NULL,
	[Descripcion_Requisito] [nvarchar](max) NOT NULL,
	[Fecha_Vigencia] [date] NOT NULL,
	[Area_Aplicacion] [nvarchar](100) NULL,
	[TipoNorma] [nvarchar](50) NOT NULL,
	[Entidad_Emisora] [nvarchar](100) NULL,
	[Vigente] [bit] NULL,
	[URL_Documento] [nvarchar](500) NULL,
	[FechaRevision] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_requisito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RESULTADO_INDICADOR]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RESULTADO_INDICADOR](
	[id_resultado] [int] IDENTITY(1,1) NOT NULL,
	[id_indicador] [int] NULL,
	[Periodo] [nvarchar](50) NOT NULL,
	[Valor] [decimal](10, 2) NOT NULL,
	[FechaCalculo] [date] NULL,
	[Analisis] [nvarchar](max) NULL,
	[CumpleMeta] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_resultado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[REUNION_COMITE]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REUNION_COMITE](
	[id_reunion] [int] IDENTITY(1,1) NOT NULL,
	[id_comite] [int] NULL,
	[NumeroReunion] [int] NOT NULL,
	[FechaReunion] [date] NOT NULL,
	[TipoReunion] [nvarchar](50) NOT NULL,
	[Asistentes] [nvarchar](max) NULL,
	[TemasDiscutidos] [nvarchar](max) NULL,
	[Acuerdos] [nvarchar](max) NULL,
	[RutaActa] [nvarchar](500) NULL,
	[ProximaReunion] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_reunion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[REVISION_DIRECCION]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REVISION_DIRECCION](
	[id_revision] [int] IDENTITY(1,1) NOT NULL,
	[Periodo] [nvarchar](50) NOT NULL,
	[FechaRevision] [date] NOT NULL,
	[Asistentes] [nvarchar](max) NULL,
	[ResultadosIndicadores] [nvarchar](max) NULL,
	[CumplimientoObjetivos] [nvarchar](max) NULL,
	[ResultadosAuditorias] [nvarchar](max) NULL,
	[AccidentalidadAnalisis] [nvarchar](max) NULL,
	[RecursosSGSST] [nvarchar](max) NULL,
	[ComunicacionesPartes] [nvarchar](max) NULL,
	[DecisionesAdoptadas] [nvarchar](max) NULL,
	[AccionesMejora] [nvarchar](max) NULL,
	[ResponsableElaboracion] [int] NULL,
	[AprobadoPor] [int] NULL,
	[RutaActa] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_revision] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RIESGO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RIESGO](
	[id_riesgo] [int] IDENTITY(1,1) NOT NULL,
	[id_catalogo_peligro] [int] NULL,
	[Peligro] [nvarchar](100) NOT NULL,
	[Proceso] [nvarchar](100) NOT NULL,
	[Actividad] [nvarchar](200) NOT NULL,
	[Zona_Area] [nvarchar](100) NULL,
	[id_probabilidad] [int] NULL,
	[id_consecuencia] [int] NULL,
	[Nivel_Riesgo_Inicial] [int] NOT NULL,
	[Nivel_Riesgo_Residual] [int] NULL,
	[Controles_Fuente] [nvarchar](max) NULL,
	[Controles_Medio] [nvarchar](max) NULL,
	[Controles_Individuo] [nvarchar](max) NULL,
	[MedidasIntervencion] [nvarchar](max) NULL,
	[FechaEvaluacion] [date] NOT NULL,
	[ProximaRevision] [date] NULL,
	[Estado] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_riesgo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ROL]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROL](
	[id_rol] [int] IDENTITY(1,1) NOT NULL,
	[NombreRol] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](200) NULL,
	[EsRolSST] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SEGUIMIENTO_PVE]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SEGUIMIENTO_PVE](
	[id_seguimiento] [int] IDENTITY(1,1) NOT NULL,
	[id_programa] [int] NULL,
	[id_empleado] [int] NULL,
	[FechaSeguimiento] [date] NOT NULL,
	[Hallazgos] [nvarchar](max) NULL,
	[IntervencionRealizada] [nvarchar](max) NULL,
	[ProximoSeguimiento] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_seguimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SIMULACRO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SIMULACRO](
	[id_simulacro] [int] IDENTITY(1,1) NOT NULL,
	[TipoSimulacro] [nvarchar](100) NOT NULL,
	[id_sede] [int] NULL,
	[FechaProgramada] [date] NULL,
	[FechaRealizacion] [date] NOT NULL,
	[Alcance] [nvarchar](200) NULL,
	[NumeroParticipantes] [int] NULL,
	[TiempoEvacuacion] [time](7) NULL,
	[Responsable] [int] NULL,
	[ObjetivosAlcanzados] [bit] NULL,
	[LeccionesAprendidas] [nvarchar](max) NULL,
	[AccionesMejora] [nvarchar](max) NULL,
	[RutaInforme] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_simulacro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TRABAJADOR_CONTRATISTA]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRABAJADOR_CONTRATISTA](
	[id_trabajador_contratista] [int] IDENTITY(1,1) NOT NULL,
	[id_contratista] [int] NULL,
	[NumeroDocumento] [nvarchar](20) NOT NULL,
	[NombreCompleto] [nvarchar](200) NOT NULL,
	[Cargo] [nvarchar](100) NULL,
	[ARL] [nvarchar](100) NULL,
	[FechaIngresoObra] [date] NOT NULL,
	[FechaRetiroObra] [date] NULL,
	[InduccionSST_Realizada] [bit] NULL,
	[FechaInduccion] [date] NULL,
	[Estado] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_trabajador_contratista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USUARIOS_AUTORIZADOS]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USUARIOS_AUTORIZADOS](
	[id_autorizado] [int] IDENTITY(1,1) NOT NULL,
	[Correo_Electronico] [nvarchar](150) NOT NULL,
	[Nombre_Persona] [nvarchar](100) NOT NULL,
	[Nivel_Acceso] [nvarchar](50) NOT NULL,
	[PuedeAprobar] [bit] NULL,
	[PuedeEditar] [bit] NULL,
	[FechaRegistro] [datetime] NULL,
	[Estado] [bit] NULL,
	[Password_Hash] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_autorizado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VALORACION_CONSEC]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VALORACION_CONSEC](
	[id_consecuencia] [int] NOT NULL,
	[Nivel_Dano] [nvarchar](50) NOT NULL,
	[Valor_NC] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_consecuencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VALORACION_PROB]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VALORACION_PROB](
	[id_probabilidad] [int] NOT NULL,
	[Nivel_Deficiencia] [int] NOT NULL,
	[Nivel_Exposicion] [int] NOT NULL,
	[Nivel_Probabilidad] [int] NOT NULL,
	[Interpretacion] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_probabilidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VERSION_DOCUMENTO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VERSION_DOCUMENTO](
	[id_version] [int] IDENTITY(1,1) NOT NULL,
	[id_documento] [int] NULL,
	[NumeroVersion] [int] NOT NULL,
	[FechaVersion] [date] NULL,
	[Cambios] [nvarchar](max) NULL,
	[AprobadoPor] [int] NULL,
	[RutaArchivoVersion] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AGENTE_ROL] ON 

INSERT [dbo].[AGENTE_ROL] ([id_agente_rol], [nombre_rol], [descripcion], [agentes_permitidos], [nivel_acceso], [activo], [FechaCreacion], [FechaActualizacion]) VALUES (1, N'admin', N'Administrador con acceso completo a todos los agentes', N'["risk_agent", "document_agent", "email_agent", "assistant_agent"]', 4, 1, CAST(N'2025-11-29T10:13:45.190' AS DateTime), CAST(N'2025-11-29T10:13:45.190' AS DateTime))
INSERT [dbo].[AGENTE_ROL] ([id_agente_rol], [nombre_rol], [descripcion], [agentes_permitidos], [nivel_acceso], [activo], [FechaCreacion], [FechaActualizacion]) VALUES (2, N'sst_coordinator', N'Coordinador de SST con acceso completo a agentes', N'["risk_agent", "document_agent", "email_agent", "assistant_agent"]', 4, 1, CAST(N'2025-11-29T10:13:45.193' AS DateTime), CAST(N'2025-11-29T10:13:45.193' AS DateTime))
INSERT [dbo].[AGENTE_ROL] ([id_agente_rol], [nombre_rol], [descripcion], [agentes_permitidos], [nivel_acceso], [activo], [FechaCreacion], [FechaActualizacion]) VALUES (3, N'supervisor', N'Supervisor con acceso a evaluación de riesgos', N'["risk_agent", "assistant_agent"]', 2, 1, CAST(N'2025-11-29T10:13:45.193' AS DateTime), CAST(N'2025-11-29T10:13:45.193' AS DateTime))
INSERT [dbo].[AGENTE_ROL] ([id_agente_rol], [nombre_rol], [descripcion], [agentes_permitidos], [nivel_acceso], [activo], [FechaCreacion], [FechaActualizacion]) VALUES (4, N'employee', N'Empleado con acceso básico al asistente', N'["assistant_agent"]', 1, 1, CAST(N'2025-11-29T10:13:45.193' AS DateTime), CAST(N'2025-11-29T10:13:45.193' AS DateTime))
INSERT [dbo].[AGENTE_ROL] ([id_agente_rol], [nombre_rol], [descripcion], [agentes_permitidos], [nivel_acceso], [activo], [FechaCreacion], [FechaActualizacion]) VALUES (5, N'contractor', N'Contratista con acceso básico al asistente', N'["assistant_agent"]', 1, 1, CAST(N'2025-11-29T10:13:45.197' AS DateTime), CAST(N'2025-11-29T10:13:45.197' AS DateTime))
INSERT [dbo].[AGENTE_ROL] ([id_agente_rol], [nombre_rol], [descripcion], [agentes_permitidos], [nivel_acceso], [activo], [FechaCreacion], [FechaActualizacion]) VALUES (6, N'auditor', N'Auditor con acceso a documentos y asistente', N'["document_agent", "assistant_agent"]', 3, 1, CAST(N'2025-11-29T10:13:45.197' AS DateTime), CAST(N'2025-11-29T10:13:45.197' AS DateTime))
INSERT [dbo].[AGENTE_ROL] ([id_agente_rol], [nombre_rol], [descripcion], [agentes_permitidos], [nivel_acceso], [activo], [FechaCreacion], [FechaActualizacion]) VALUES (7, N'brigadista', N'Brigadista con acceso a asistente y documentos', N'["assistant_agent", "document_agent"]', 2, 1, CAST(N'2025-11-29T10:13:45.197' AS DateTime), CAST(N'2025-11-29T10:13:45.197' AS DateTime))
INSERT [dbo].[AGENTE_ROL] ([id_agente_rol], [nombre_rol], [descripcion], [agentes_permitidos], [nivel_acceso], [activo], [FechaCreacion], [FechaActualizacion]) VALUES (8, N'copasst', N'Miembro COPASST con acceso a riesgos y documentos', N'["risk_agent", "document_agent", "assistant_agent"]', 3, 1, CAST(N'2025-11-29T10:13:45.197' AS DateTime), CAST(N'2025-11-29T10:13:45.197' AS DateTime))
SET IDENTITY_INSERT [dbo].[AGENTE_ROL] OFF
GO
SET IDENTITY_INSERT [dbo].[ALERTA] ON 

INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (1, N'Vencimiento EMO', N'Alta', N'El EMO periódico de Ana Pérez Torres vence el 24/11/2025.', CAST(N'2025-11-16T19:42:27.970' AS DateTime), CAST(N'2025-11-24' AS Date), N'Pendiente', N'EXAMEN_MEDICO', 3003, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (2, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Capacitación en Prevención de Riesgos Psicosociales. Responsable: María Gómez Ruiz', CAST(N'2025-11-16T19:42:27.990' AS DateTime), CAST(N'2025-11-05' AS Date), N'Pendiente', N'TAREA', 2005, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (3, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Auditoría Interna SG-SST 2024. Responsable: María Gómez Ruiz', CAST(N'2025-11-16T19:42:27.990' AS DateTime), CAST(N'2024-11-30' AS Date), N'Pendiente', N'TAREA', 2007, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (4, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Simulacro de Evacuación - Semestre 1. Responsable: María Gómez Ruiz', CAST(N'2025-12-01T20:51:44.603' AS DateTime), CAST(N'2025-11-30' AS Date), N'Pendiente', N'TAREA', 2006, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (5, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Programar EMO Periódico para Ana Pérez Torres - Vence: 24/11/2025. Responsable: María Gómez Ruiz', CAST(N'2025-12-01T20:51:44.603' AS DateTime), CAST(N'2025-11-19' AS Date), N'Pendiente', N'TAREA', 2011, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (6, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Auditoría Interna SG-SST 2024 - Fase Final. Responsable: María Gómez Ruiz', CAST(N'2025-12-01T20:51:44.603' AS DateTime), CAST(N'2025-11-26' AS Date), N'Pendiente', N'TAREA', 2014, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (7, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Capacitación en Manejo de Sustancias Químicas. Responsable: María Gómez Ruiz', CAST(N'2025-12-01T20:51:44.603' AS DateTime), CAST(N'2025-11-29' AS Date), N'Pendiente', N'TAREA', 2015, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (8, N'Examen Médico Vencido', N'Critica', N'URGENTE: El examen médico Periodico de Juan López Pérez está VENCIDO desde el 20/01/2024 (681 días de retraso)', CAST(N'2025-12-01T21:01:32.837' AS DateTime), CAST(N'2024-01-20' AS Date), N'Pendiente', N'EXAMEN_MEDICO_VENCIDO', 3002, N'["maria.gomez@digitalbulks.com","ceo@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (9, N'Examen Médico Vencido', N'Critica', N'URGENTE: El examen médico Periodico de Ana Pérez Torres está VENCIDO desde el 24/11/2025 (7 días de retraso)', CAST(N'2025-12-01T21:01:32.837' AS DateTime), CAST(N'2025-11-24' AS Date), N'Pendiente', N'EXAMEN_MEDICO_VENCIDO', 3003, N'["maria.gomez@digitalbulks.com","ceo@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (10, N'Comité Próximo a Vencer', N'Media', N'El COCOLAB conformado el 10/01/2024 vence el 10/01/2026. Se debe iniciar proceso de nueva elección (En 40 días)', CAST(N'2025-12-01T21:01:32.840' AS DateTime), CAST(N'2026-01-10' AS Date), N'Pendiente', N'COMITE', 11, N'["maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (11, N'Tarea Vencida', N'Media', N'La tarea "Capacitación en Prevención de Riesgos Psicosociales" asignada a María Gómez Ruiz está vencida desde el 05/11/2025 (26 días de retraso)', CAST(N'2025-12-01T21:01:32.840' AS DateTime), CAST(N'2025-11-05' AS Date), N'Pendiente', N'TAREA', 2005, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (12, N'Tarea Vencida', N'Critica', N'La tarea "Auditoría Interna SG-SST 2024" asignada a María Gómez Ruiz está vencida desde el 30/11/2024 (366 días de retraso)', CAST(N'2025-12-01T21:01:32.840' AS DateTime), CAST(N'2024-11-30' AS Date), N'Pendiente', N'TAREA', 2007, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (13, N'Accidente de Trabajo Registrado', N'Critica', N'URGENTE: Se ha registrado un Accidente de Trabajo. Empleado: Laura Martínez Díaz. Fecha: 10/09/2024. Debe reportarse a la ARL en máximo 2 días hábiles.', CAST(N'2025-12-02T19:38:33.890' AS DateTime), CAST(N'2024-09-10' AS Date), N'Pendiente', N'EVENTO_NUEVO', 1008, N'["maria.gomez@digitalbulks.com","ceo@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (14, N'Accidente de Trabajo Registrado', N'Critica', N'URGENTE: Se ha registrado un Accidente de Trabajo. Empleado: Carlos Ramírez Silva. Fecha: 20/06/2024. Debe reportarse a la ARL en máximo 2 días hábiles.', CAST(N'2025-12-02T19:38:33.890' AS DateTime), CAST(N'2024-06-20' AS Date), N'Pendiente', N'EVENTO_NUEVO', 1007, N'["maria.gomez@digitalbulks.com","ceo@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (15, N'Accidente de Trabajo Registrado', N'Critica', N'URGENTE: Se ha registrado un Accidente de Trabajo. Empleado: Ana Pérez Torres. Fecha: 15/03/2024. Debe reportarse a la ARL en máximo 2 días hábiles.', CAST(N'2025-12-02T19:38:33.890' AS DateTime), CAST(N'2024-03-15' AS Date), N'Pendiente', N'EVENTO_NUEVO', 1006, N'["maria.gomez@digitalbulks.com","ceo@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (16, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: CAPACITACION CHATGPT. Responsable: María Gómez Ruiz', CAST(N'2025-12-03T21:50:13.790' AS DateTime), CAST(N'2025-12-02' AS Date), N'Pendiente', N'TAREA', 2024, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (17, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Tarea CrÃ­tica Vencida. Responsable: Juan López Pérez', CAST(N'2025-12-03T21:50:13.790' AS DateTime), CAST(N'2025-11-24' AS Date), N'Pendiente', N'TAREA', 2025, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (18, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Tarea Alerta Vencida. Responsable: Juan López Pérez', CAST(N'2025-12-03T21:50:13.790' AS DateTime), CAST(N'2025-11-28' AS Date), N'Pendiente', N'TAREA', 2026, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (19, N'Accidente sin Reportar ARL', N'Critica', N'URGENTE: Accidente de Trabajo de Ana Pérez Torres ocurrido el 15/03/2024 NO ha sido reportado a la ARL. Plazo legal: 2 días hábiles', CAST(N'2025-12-03T21:50:14.097' AS DateTime), CAST(N'2024-03-15' AS Date), N'Pendiente', N'EVENTO_ARL', 1006, N'["maria.gomez@digitalbulks.com","ceo@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (20, N'Accidente sin Reportar ARL', N'Critica', N'URGENTE: Accidente de Trabajo de Carlos Ramírez Silva ocurrido el 20/06/2024 NO ha sido reportado a la ARL. Plazo legal: 2 días hábiles', CAST(N'2025-12-03T21:50:14.097' AS DateTime), CAST(N'2024-06-20' AS Date), N'Pendiente', N'EVENTO_ARL', 1007, N'["maria.gomez@digitalbulks.com","ceo@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (21, N'Accidente sin Reportar ARL', N'Critica', N'URGENTE: Accidente de Trabajo de Laura Martínez Díaz ocurrido el 10/09/2024 NO ha sido reportado a la ARL. Plazo legal: 2 días hábiles', CAST(N'2025-12-03T21:50:14.097' AS DateTime), CAST(N'2024-09-10' AS Date), N'Pendiente', N'EVENTO_ARL', 1008, N'["maria.gomez@digitalbulks.com","ceo@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (22, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Renovación de Licencia de Software SST. Responsable: María Gómez Ruiz', CAST(N'2025-12-04T09:04:37.670' AS DateTime), CAST(N'2025-12-03' AS Date), N'Pendiente', N'TAREA', 2016, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (23, N'Tarea Vencida', N'Media', N'La tarea "Capacitación en Prevención de Riesgos Psicosociales" asignada a María Gómez Ruiz está vencida desde el 05/11/2025 (29 días de retraso)', CAST(N'2025-12-04T09:04:37.750' AS DateTime), CAST(N'2025-11-05' AS Date), N'Pendiente', N'TAREA', 2005, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (24, N'Tarea Vencida', N'Alta', N'La tarea "Simulacro de Evacuación - Semestre 1" asignada a María Gómez Ruiz está vencida desde el 30/11/2025 (4 días de retraso)', CAST(N'2025-12-04T09:04:37.750' AS DateTime), CAST(N'2025-11-30' AS Date), N'Pendiente', N'TAREA', 2006, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (25, N'Tarea Vencida', N'Critica', N'La tarea "Auditoría Interna SG-SST 2024" asignada a María Gómez Ruiz está vencida desde el 30/11/2024 (369 días de retraso)', CAST(N'2025-12-04T09:04:37.750' AS DateTime), CAST(N'2024-11-30' AS Date), N'Pendiente', N'TAREA', 2007, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (26, N'Tarea Vencida', N'Alta', N'La tarea "Programar EMO Periódico para Ana Pérez Torres - Vence: 24/11/2025" asignada a María Gómez Ruiz está vencida desde el 19/11/2025 (15 días de retraso)', CAST(N'2025-12-04T09:04:37.750' AS DateTime), CAST(N'2025-11-19' AS Date), N'Pendiente', N'TAREA', 2011, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (27, N'Tarea Vencida', N'Critica', N'La tarea "Auditoría Interna SG-SST 2024 - Fase Final" asignada a María Gómez Ruiz está vencida desde el 26/11/2025 (8 días de retraso)', CAST(N'2025-12-04T09:04:37.750' AS DateTime), CAST(N'2025-11-26' AS Date), N'Pendiente', N'TAREA', 2014, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (28, N'Tarea Vencida', N'Alta', N'La tarea "Capacitación en Manejo de Sustancias Químicas" asignada a María Gómez Ruiz está vencida desde el 29/11/2025 (5 días de retraso)', CAST(N'2025-12-04T09:04:37.750' AS DateTime), CAST(N'2025-11-29' AS Date), N'Pendiente', N'TAREA', 2015, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (29, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Preparación Reunión Mensual COPASST. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2022, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (30, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2039, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (31, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2040, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (32, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2041, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (33, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2042, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (34, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2043, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (35, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2044, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (36, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2045, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (37, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2046, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (38, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2047, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (39, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2048, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (40, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2049, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (41, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2050, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (42, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2051, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (43, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2052, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (44, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2053, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (45, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2054, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (46, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2055, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (47, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2056, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (48, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2057, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (49, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2058, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (50, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2059, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (51, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2060, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (52, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2061, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (53, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2062, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (54, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2063, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (55, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2073, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (56, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2074, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (57, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2075, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (58, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2076, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (59, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2077, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (60, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2078, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (61, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2079, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (62, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2080, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (63, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2081, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (64, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2082, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (65, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2083, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (66, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2084, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (67, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2085, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (68, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2086, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (69, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2087, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (70, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2088, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (71, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2089, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (72, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2090, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (73, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2091, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (74, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2092, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (75, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2093, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (76, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2094, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (77, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2095, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (78, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2096, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (79, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2097, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (80, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2098, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (81, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2099, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (82, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2100, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (83, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2101, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (84, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2102, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (85, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2103, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (86, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2104, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (87, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2105, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (88, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2106, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (89, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2107, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (90, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2108, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (91, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2109, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (92, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2110, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (93, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2111, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (94, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2112, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (95, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2113, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (96, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2114, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (97, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2115, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (98, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2116, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (99, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2117, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
GO
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (100, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Atender alerta crítica: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-06' AS Date), N'Pendiente', N'TAREA', 2118, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (101, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2119, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (102, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2120, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (103, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2121, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (104, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Gestionar alerta: Alerta sin descripción. Responsable: María Gómez Ruiz', CAST(N'2025-12-09T20:16:26.227' AS DateTime), CAST(N'2025-12-08' AS Date), N'Pendiente', N'TAREA', 2122, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (105, N'Examen Médico Vencido', N'Critica', N'URGENTE: El examen médico Periodico de Juan López Pérez está VENCIDO desde el 20/01/2024 (689 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2024-01-20' AS Date), N'Pendiente', N'EXAMEN_MEDICO_VENCIDO', 3002, N'["maria.gomez@digitalbulks.com","ceo@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (106, N'Examen Médico Vencido', N'Critica', N'URGENTE: El examen médico Periodico de Ana Pérez Torres está VENCIDO desde el 24/11/2025 (15 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2025-11-24' AS Date), N'Pendiente', N'EXAMEN_MEDICO_VENCIDO', 3003, N'["maria.gomez@digitalbulks.com","ceo@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (107, N'Tarea Vencida', N'Media', N'La tarea "Capacitación en Prevención de Riesgos Psicosociales" asignada a María Gómez Ruiz está vencida desde el 05/11/2025 (34 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2025-11-05' AS Date), N'Pendiente', N'TAREA', 2005, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (108, N'Tarea Vencida', N'Alta', N'La tarea "Simulacro de Evacuación - Semestre 1" asignada a María Gómez Ruiz está vencida desde el 30/11/2025 (9 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2025-11-30' AS Date), N'Pendiente', N'TAREA', 2006, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (109, N'Tarea Vencida', N'Critica', N'La tarea "Auditoría Interna SG-SST 2024" asignada a María Gómez Ruiz está vencida desde el 30/11/2024 (374 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2024-11-30' AS Date), N'Pendiente', N'TAREA', 2007, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (110, N'Tarea Vencida', N'Alta', N'La tarea "Programar EMO Periódico para Ana Pérez Torres - Vence: 24/11/2025" asignada a María Gómez Ruiz está vencida desde el 19/11/2025 (20 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2025-11-19' AS Date), N'Pendiente', N'TAREA', 2011, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (111, N'Tarea Vencida', N'Critica', N'La tarea "Auditoría Interna SG-SST 2024 - Fase Final" asignada a María Gómez Ruiz está vencida desde el 26/11/2025 (13 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2025-11-26' AS Date), N'Pendiente', N'TAREA', 2014, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (112, N'Tarea Vencida', N'Alta', N'La tarea "Capacitación en Manejo de Sustancias Químicas" asignada a María Gómez Ruiz está vencida desde el 29/11/2025 (10 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2025-11-29' AS Date), N'Pendiente', N'TAREA', 2015, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (113, N'Tarea Vencida', N'Alta', N'La tarea "Renovación de Licencia de Software SST" asignada a María Gómez Ruiz está vencida desde el 03/12/2025 (6 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2025-12-03' AS Date), N'Pendiente', N'TAREA', 2016, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (114, N'Tarea Vencida', N'Media', N'La tarea "CAPACITACION CHATGPT" asignada a María Gómez Ruiz está vencida desde el 02/12/2025 (7 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2025-12-02' AS Date), N'Pendiente', N'TAREA', 2024, N'["maria.gomez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (115, N'Tarea Vencida', N'Alta', N'La tarea "[TEST] Tarea CrÃ­tica Vencida" asignada a Juan López Pérez está vencida desde el 24/11/2025 (15 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2025-11-24' AS Date), N'Pendiente', N'TAREA', 2025, N'["juan.lopez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (116, N'Tarea Vencida', N'Media', N'La tarea "[TEST] Tarea Alerta Vencida" asignada a Juan López Pérez está vencida desde el 28/11/2025 (11 días de retraso)', CAST(N'2025-12-09T20:16:26.303' AS DateTime), CAST(N'2025-11-28' AS Date), N'Pendiente', N'TAREA', 2026, N'["juan.lopez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (123, N'Examen Médico Vencido', N'Critica', N'El examen médico Periodico de Juan López Pérez venció el 20/01/2024.', CAST(N'2025-12-18T20:57:05.750' AS DateTime), CAST(N'2024-01-20' AS Date), N'Pendiente', N'EXAMEN_MEDICO', 3002, N'["juan.lopez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (124, N'Examen Médico Vencido', N'Critica', N'El examen médico Periodico de Ana Pérez Torres venció el 24/11/2025.', CAST(N'2025-12-18T20:57:05.750' AS DateTime), CAST(N'2025-11-24' AS Date), N'Pendiente', N'EXAMEN_MEDICO', 3003, N'["ana.perez@digitalbulks.com","maria.gomez@digitalbulks.com"]', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (125, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Programar y ejecutar Auditoría Interna Anual del SG-SST 2025. Responsable: María Gómez Ruiz', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-15' AS Date), N'Pendiente', N'TAREA', 2013, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (126, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 1. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2027, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (127, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 2. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2028, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (128, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 3. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2029, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (129, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 4. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2030, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (130, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 5. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2031, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (131, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 6. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2032, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (132, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 7. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2033, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (133, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 8. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2034, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (134, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 9. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2035, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (135, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 10. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2036, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (136, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 11. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2037, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (137, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: [TEST] Carga Trabajo 12. Responsable: Juan López Pérez', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2038, N'juan.lopez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (138, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Ejecutar capacitación pendiente: Prevención de Riesgos Psicosociales (vencida hace 630 días). Responsable: María Gómez Ruiz', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2071, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
INSERT [dbo].[ALERTA] ([id_alerta], [Tipo], [Prioridad], [Descripcion], [FechaGeneracion], [FechaEvento], [Estado], [ModuloOrigen], [IdRelacionado], [DestinatariosCorreo], [Enviada], [FechaEnvio], [IntentosEnvio], [UltimoError]) VALUES (139, N'Tarea Vencida', N'Critica', N'Tarea VENCIDA: Ejecutar capacitación pendiente: Primeros Auxilios Básicos (vencida hace 604 días). Responsable: María Gómez Ruiz', CAST(N'2025-12-18T20:57:05.753' AS DateTime), CAST(N'2025-12-12' AS Date), N'Pendiente', N'TAREA', 2072, N'maria.gomez@digitalbulks.com', 0, NULL, 0, NULL)
SET IDENTITY_INSERT [dbo].[ALERTA] OFF
GO
SET IDENTITY_INSERT [dbo].[CAPACITACION] ON 

INSERT [dbo].[CAPACITACION] ([id_capacitacion], [Codigo_Capacitacion], [Tema], [Tipo], [Modalidad], [Duracion_Horas], [Fecha_Programada], [Fecha_Realizacion], [Lugar], [Facilitador], [EntidadProveedora], [Objetivo], [Responsable], [Estado], [RutaMaterial], [RutaEvidencias]) VALUES (4002, N'CAP-2024-001', N'Inducción al SG-SST', N'Inducción', N'Presencial', CAST(4.00 AS Decimal(5, 2)), CAST(N'2024-01-20' AS Date), CAST(N'2024-01-20' AS Date), NULL, NULL, NULL, NULL, 101, N'Realizada', NULL, NULL)
INSERT [dbo].[CAPACITACION] ([id_capacitacion], [Codigo_Capacitacion], [Tema], [Tipo], [Modalidad], [Duracion_Horas], [Fecha_Programada], [Fecha_Realizacion], [Lugar], [Facilitador], [EntidadProveedora], [Objetivo], [Responsable], [Estado], [RutaMaterial], [RutaEvidencias]) VALUES (4003, N'CAP-2024-002', N'Prevención de Riesgos Psicosociales', N'Específica SST', N'Virtual', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-03-15' AS Date), NULL, NULL, NULL, NULL, NULL, 101, N'Programada', NULL, NULL)
INSERT [dbo].[CAPACITACION] ([id_capacitacion], [Codigo_Capacitacion], [Tema], [Tipo], [Modalidad], [Duracion_Horas], [Fecha_Programada], [Fecha_Realizacion], [Lugar], [Facilitador], [EntidadProveedora], [Objetivo], [Responsable], [Estado], [RutaMaterial], [RutaEvidencias]) VALUES (4004, N'CAP-2024-003', N'Primeros Auxilios Básicos', N'Brigada', N'Presencial', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-04-10' AS Date), NULL, NULL, NULL, NULL, NULL, 101, N'Programada', NULL, NULL)
SET IDENTITY_INSERT [dbo].[CAPACITACION] OFF
GO
SET IDENTITY_INSERT [dbo].[CATALOGO_PELIGRO] ON 

INSERT [dbo].[CATALOGO_PELIGRO] ([id_catalogo_peligro], [Clasificacion], [TipoPeligro], [Descripcion]) VALUES (1, N'Físico', N'Ruido', N'Exposición a niveles de presión sonora superiores a 85 dB')
INSERT [dbo].[CATALOGO_PELIGRO] ([id_catalogo_peligro], [Clasificacion], [TipoPeligro], [Descripcion]) VALUES (2, N'Biomecánico', N'Posturas Prolongadas', N'Mantenimiento de postura sedente por periodos prolongados')
INSERT [dbo].[CATALOGO_PELIGRO] ([id_catalogo_peligro], [Clasificacion], [TipoPeligro], [Descripcion]) VALUES (3, N'Psicosocial', N'Estrés Laboral', N'Demandas cuantitativas y cualitativas excesivas')
INSERT [dbo].[CATALOGO_PELIGRO] ([id_catalogo_peligro], [Clasificacion], [TipoPeligro], [Descripcion]) VALUES (4, N'Condiciones de Seguridad', N'Eléctrico', N'Contacto directo o indirecto con energía eléctrica')
INSERT [dbo].[CATALOGO_PELIGRO] ([id_catalogo_peligro], [Clasificacion], [TipoPeligro], [Descripcion]) VALUES (5, N'Químico', N'Material Particulado', N'Exposición a polvo o partículas en suspensión')
INSERT [dbo].[CATALOGO_PELIGRO] ([id_catalogo_peligro], [Clasificacion], [TipoPeligro], [Descripcion]) VALUES (6, N'Biológico', N'Virus y Bacterias', N'Exposición a agentes biológicos patógenos')
SET IDENTITY_INSERT [dbo].[CATALOGO_PELIGRO] OFF
GO
SET IDENTITY_INSERT [dbo].[COMITE] ON 

INSERT [dbo].[COMITE] ([id_comite], [Tipo_Comite], [Fecha_Conformacion], [Fecha_Vigencia], [ActaConformacion], [Estado]) VALUES (10, N'COPASST', CAST(N'2023-03-15' AS Date), CAST(N'2025-03-15' AS Date), NULL, N'Vigente')
INSERT [dbo].[COMITE] ([id_comite], [Tipo_Comite], [Fecha_Conformacion], [Fecha_Vigencia], [ActaConformacion], [Estado]) VALUES (11, N'COCOLAB', CAST(N'2024-01-10' AS Date), CAST(N'2026-01-10' AS Date), NULL, N'Vigente')
SET IDENTITY_INSERT [dbo].[COMITE] OFF
GO
SET IDENTITY_INSERT [dbo].[CONFIG_AGENTE] ON 

INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (9, N'CORREO_AGENTE', N'agente.sst@digitalbulks.com', N'String', N'Correo electrónico del agente IA para recibir solicitudes', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (10, N'SERVIDOR_SMTP', N'smtp.gmail.com', N'String', N'Servidor SMTP para envío de correos', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (11, N'PUERTO_SMTP', N'587', N'Integer', N'Puerto del servidor SMTP', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (12, N'DIAS_ALERTA_EMO', N'45', N'Integer', N'Días de anticipación para alertar vencimiento de exámenes médicos', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (13, N'DIAS_ALERTA_COMITE', N'60', N'Integer', N'Días de anticipación para alertar vencimiento de comités', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (14, N'DIAS_ALERTA_EPP', N'30', N'Integer', N'Días de anticipación para alertar reemplazo de EPP', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (15, N'FRECUENCIA_REVISION_ALERTAS', N'4', N'Integer', N'Horas entre cada revisión automática de alertas', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (16, N'MODELO_CHATGPT', N'gpt-4-turbo', N'String', N'Modelo de ChatGPT a utilizar', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (17, N'TEMPERATURA_IA', N'0.7', N'Decimal', N'Temperatura para respuestas del modelo IA', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (18, N'ENVIAR_ALERTAS_AUTOMATICAS', N'true', N'Boolean', N'Activar o desactivar envío automático de alertas', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (19, N'CORREO_COORDINADOR_SST', N'maria.gomez@digitalbulks.com', N'String', N'Correo del Coordinador SST para alertas críticas', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (20, N'CORREO_CEO', N'ceo@digitalbulks.com', N'String', N'Correo del CEO para reportes y aprobaciones', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (21, N'FORMATO_FECHA_REPORTES', N'DD/MM/YYYY', N'String', N'Formato de fecha en reportes generados', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
INSERT [dbo].[CONFIG_AGENTE] ([id_config], [Clave], [Valor], [TipoDato], [Descripcion], [FechaActualizacion]) VALUES (22, N'ID_COORD_SST', N'101', N'Integer', N'ID del empleado Coordinador SST (para destinatarios de alerta)', CAST(N'2025-11-15T20:22:16.837' AS DateTime))
SET IDENTITY_INSERT [dbo].[CONFIG_AGENTE] OFF
GO
SET IDENTITY_INSERT [dbo].[DOCUMENTO] ON 

INSERT [dbo].[DOCUMENTO] ([id_documento], [Codigo], [Nombre], [Tipo], [CategoriaSGSST], [Area], [FechaCreacion], [FechaUltimaRevision], [ProximaRevision], [Estado], [Responsable], [RutaArchivo], [RequiereAprobacion], [AprobadoPor], [descripcion], [version], [mime_type], [tamano_bytes]) VALUES (6, N'MEM-9', N'Acta: Lista de Chequeo de Extintores #9', N'Formato', N'Seguridad Industrial', N'Operaciones', CAST(N'2025-12-10' AS Date), NULL, NULL, N'Vigente', NULL, N'documents/ACTA_Lista_de_Chequeo_de_Extintores_9_20251210.pdf', 0, NULL, N'Autogenerado desde Formulario form_inspeccion_extintor', 1, N'application/pdf', 130)
INSERT [dbo].[DOCUMENTO] ([id_documento], [Codigo], [Nombre], [Tipo], [CategoriaSGSST], [Area], [FechaCreacion], [FechaUltimaRevision], [ProximaRevision], [Estado], [Responsable], [RutaArchivo], [RequiereAprobacion], [AprobadoPor], [descripcion], [version], [mime_type], [tamano_bytes]) VALUES (7, N'MEM-10', N'Acta: Lista de Chequeo de Extintores #10', N'Formato', N'Seguridad Industrial', N'Operaciones', CAST(N'2025-12-10' AS Date), NULL, NULL, N'Vigente', NULL, N'documents/ACTA_Lista_de_Chequeo_de_Extintores_10_20251210.pdf', 0, NULL, N'Autogenerado desde Formulario form_inspeccion_extintor', 1, N'application/pdf', 131)
INSERT [dbo].[DOCUMENTO] ([id_documento], [Codigo], [Nombre], [Tipo], [CategoriaSGSST], [Area], [FechaCreacion], [FechaUltimaRevision], [ProximaRevision], [Estado], [Responsable], [RutaArchivo], [RequiereAprobacion], [AprobadoPor], [descripcion], [version], [mime_type], [tamano_bytes]) VALUES (8, N'MEM-11', N'Acta: Lista de Chequeo de Extintores #11', N'Formato', N'Seguridad Industrial', N'Operaciones', CAST(N'2025-12-10' AS Date), NULL, NULL, N'Vigente', NULL, N'documents/ACTA_Lista_de_Chequeo_de_Extintores_11_20251210.pdf', 0, NULL, N'Autogenerado desde Formulario form_inspeccion_extintor', 1, N'application/pdf', 131)
INSERT [dbo].[DOCUMENTO] ([id_documento], [Codigo], [Nombre], [Tipo], [CategoriaSGSST], [Area], [FechaCreacion], [FechaUltimaRevision], [ProximaRevision], [Estado], [Responsable], [RutaArchivo], [RequiereAprobacion], [AprobadoPor], [descripcion], [version], [mime_type], [tamano_bytes]) VALUES (9, N'MEM-12', N'Acta: Lista de Chequeo de Extintores #12', N'Formato', N'Seguridad Industrial', N'Operaciones', CAST(N'2025-12-10' AS Date), NULL, NULL, N'Vigente', NULL, N'documents/ACTA_Lista_de_Chequeo_de_Extintores_12_20251210.pdf', 0, NULL, N'Autogenerado desde Formulario form_inspeccion_extintor', 1, N'application/pdf', 131)
INSERT [dbo].[DOCUMENTO] ([id_documento], [Codigo], [Nombre], [Tipo], [CategoriaSGSST], [Area], [FechaCreacion], [FechaUltimaRevision], [ProximaRevision], [Estado], [Responsable], [RutaArchivo], [RequiereAprobacion], [AprobadoPor], [descripcion], [version], [mime_type], [tamano_bytes]) VALUES (10, N'MEM-13', N'Acta: Lista de Chequeo de Extintores #13', N'Formato', N'Seguridad Industrial', N'Operaciones', CAST(N'2025-12-10' AS Date), NULL, NULL, N'Vigente', NULL, N'documents/ACTA_Lista_de_Chequeo_de_Extintores_13_20251210.pdf', 0, NULL, N'Autogenerado desde Formulario form_inspeccion_extintor', 1, N'application/pdf', 131)
INSERT [dbo].[DOCUMENTO] ([id_documento], [Codigo], [Nombre], [Tipo], [CategoriaSGSST], [Area], [FechaCreacion], [FechaUltimaRevision], [ProximaRevision], [Estado], [Responsable], [RutaArchivo], [RequiereAprobacion], [AprobadoPor], [descripcion], [version], [mime_type], [tamano_bytes]) VALUES (11, N'MEM-14', N'Acta: Lista de Chequeo de Extintores #14', N'Formato', N'Seguridad Industrial', N'Operaciones', CAST(N'2025-12-10' AS Date), NULL, NULL, N'Vigente', NULL, N'documents/ACTA_Lista_de_Chequeo_de_Extintores_14_20251210.pdf', 0, NULL, N'Autogenerado desde Formulario form_inspeccion_extintor', 1, N'application/pdf', 131)
INSERT [dbo].[DOCUMENTO] ([id_documento], [Codigo], [Nombre], [Tipo], [CategoriaSGSST], [Area], [FechaCreacion], [FechaUltimaRevision], [ProximaRevision], [Estado], [Responsable], [RutaArchivo], [RequiereAprobacion], [AprobadoPor], [descripcion], [version], [mime_type], [tamano_bytes]) VALUES (12, N'MEM-15', N'Acta: Lista de Chequeo de Extintores #15', N'Formato', N'Seguridad Industrial', N'Operaciones', CAST(N'2025-12-11' AS Date), NULL, NULL, N'Vigente', NULL, N'documents/ACTA_Lista_de_Chequeo_de_Extintores_15_20251211.pdf', 0, NULL, N'Autogenerado desde Formulario form_inspeccion_extintor', 1, N'application/pdf', 131)
INSERT [dbo].[DOCUMENTO] ([id_documento], [Codigo], [Nombre], [Tipo], [CategoriaSGSST], [Area], [FechaCreacion], [FechaUltimaRevision], [ProximaRevision], [Estado], [Responsable], [RutaArchivo], [RequiereAprobacion], [AprobadoPor], [descripcion], [version], [mime_type], [tamano_bytes]) VALUES (13, N'MEM-16', N'Acta: Lista de Chequeo de Extintores #16', N'Formato', N'Seguridad Industrial', N'Operaciones', CAST(N'2025-12-11' AS Date), NULL, NULL, N'Vigente', NULL, N'documents/ACTA_Lista_de_Chequeo_de_Extintores_16_20251211.pdf', 0, NULL, N'Autogenerado desde Formulario form_inspeccion_extintor', 1, N'application/pdf', 131)
INSERT [dbo].[DOCUMENTO] ([id_documento], [Codigo], [Nombre], [Tipo], [CategoriaSGSST], [Area], [FechaCreacion], [FechaUltimaRevision], [ProximaRevision], [Estado], [Responsable], [RutaArchivo], [RequiereAprobacion], [AprobadoPor], [descripcion], [version], [mime_type], [tamano_bytes]) VALUES (14, N'MEM-17', N'Acta: Lista de Chequeo de Extintores #17', N'Formato', N'Seguridad Industrial', N'Operaciones', CAST(N'2025-12-11' AS Date), NULL, NULL, N'Vigente', NULL, N'documents/ACTA_Lista_de_Chequeo_de_Extintores_17_20251211.pdf', 0, NULL, N'Autogenerado desde Formulario form_inspeccion_extintor', 1, N'application/pdf', 131)
SET IDENTITY_INSERT [dbo].[DOCUMENTO] OFF
GO
SET IDENTITY_INSERT [dbo].[EMPLEADO] ON 

INSERT [dbo].[EMPLEADO] ([id_empleado], [id_sede], [TipoDocumento], [NumeroDocumento], [Nombre], [Apellidos], [Cargo], [Area], [TipoContrato], [Fecha_Ingreso], [Fecha_Retiro], [Nivel_Riesgo_Laboral], [Correo], [Telefono], [DireccionResidencia], [ContactoEmergencia], [TelefonoEmergencia], [GrupoSanguineo], [Estado], [id_supervisor], [FechaCreacion], [FechaActualizacion], [ARL], [FechaAfiliacionARL], [EPS], [AFP]) VALUES (100, 1, N'CC', N'1234567890', N'Admin', N'CEO', N'CEO', N'Gerencia', N'Indefinido', CAST(N'2015-01-01' AS Date), NULL, 1, N'ceo@digitalbulks.com', N'+573001234567', NULL, N'Contacto Familiar CEO', N'+573009999999', NULL, 1, NULL, CAST(N'2025-11-14T10:15:22.747' AS DateTime), CAST(N'2025-11-14T10:15:22.747' AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[EMPLEADO] ([id_empleado], [id_sede], [TipoDocumento], [NumeroDocumento], [Nombre], [Apellidos], [Cargo], [Area], [TipoContrato], [Fecha_Ingreso], [Fecha_Retiro], [Nivel_Riesgo_Laboral], [Correo], [Telefono], [DireccionResidencia], [ContactoEmergencia], [TelefonoEmergencia], [GrupoSanguineo], [Estado], [id_supervisor], [FechaCreacion], [FechaActualizacion], [ARL], [FechaAfiliacionARL], [EPS], [AFP]) VALUES (101, 1, N'CC', N'9876543210', N'María', N'Gómez Ruiz', N'Coordinadora SST', N'Talento Humano', N'Indefinido', CAST(N'2019-11-01' AS Date), NULL, 2, N'maria.gomez@digitalbulks.com', N'+573101234567', NULL, N'Pedro Gómez', N'+573101111111', NULL, 1, NULL, CAST(N'2025-11-14T10:15:22.747' AS DateTime), CAST(N'2025-11-14T10:15:22.747' AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[EMPLEADO] ([id_empleado], [id_sede], [TipoDocumento], [NumeroDocumento], [Nombre], [Apellidos], [Cargo], [Area], [TipoContrato], [Fecha_Ingreso], [Fecha_Retiro], [Nivel_Riesgo_Laboral], [Correo], [Telefono], [DireccionResidencia], [ContactoEmergencia], [TelefonoEmergencia], [GrupoSanguineo], [Estado], [id_supervisor], [FechaCreacion], [FechaActualizacion], [ARL], [FechaAfiliacionARL], [EPS], [AFP]) VALUES (102, 1, N'CC', N'1122334455', N'Juan', N'López Pérez', N'Desarrollador Senior', N'Tecnología', N'Indefinido', CAST(N'2020-01-20' AS Date), NULL, 1, N'juan.lopez@digitalbulks.com', N'+573201234567', NULL, N'Ana López', N'+573202222222', NULL, 1, 101, CAST(N'2025-11-14T10:15:22.747' AS DateTime), CAST(N'2025-12-02T19:38:33.830' AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[EMPLEADO] ([id_empleado], [id_sede], [TipoDocumento], [NumeroDocumento], [Nombre], [Apellidos], [Cargo], [Area], [TipoContrato], [Fecha_Ingreso], [Fecha_Retiro], [Nivel_Riesgo_Laboral], [Correo], [Telefono], [DireccionResidencia], [ContactoEmergencia], [TelefonoEmergencia], [GrupoSanguineo], [Estado], [id_supervisor], [FechaCreacion], [FechaActualizacion], [ARL], [FechaAfiliacionARL], [EPS], [AFP]) VALUES (103, 1, N'CC', N'5544332211', N'Ana', N'Pérez Torres', N'Analista Financiera', N'Finanzas', N'Fijo', CAST(N'2022-05-15' AS Date), NULL, 1, N'ana.perez@digitalbulks.com', N'+573301234567', NULL, N'Carlos Pérez', N'+573303333333', NULL, 1, NULL, CAST(N'2025-11-14T10:15:22.747' AS DateTime), CAST(N'2025-11-14T10:15:22.747' AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[EMPLEADO] ([id_empleado], [id_sede], [TipoDocumento], [NumeroDocumento], [Nombre], [Apellidos], [Cargo], [Area], [TipoContrato], [Fecha_Ingreso], [Fecha_Retiro], [Nivel_Riesgo_Laboral], [Correo], [Telefono], [DireccionResidencia], [ContactoEmergencia], [TelefonoEmergencia], [GrupoSanguineo], [Estado], [id_supervisor], [FechaCreacion], [FechaActualizacion], [ARL], [FechaAfiliacionARL], [EPS], [AFP]) VALUES (104, 1, N'CC', N'6677889900', N'Carlos', N'Ramírez Silva', N'Supervisor de Producción', N'Producción', N'Indefinido', CAST(N'2018-03-15' AS Date), NULL, 3, N'carlos.ramirez@digitalbulks.com', N'+573401234567', NULL, N'Laura Ramírez', N'+573404444444', NULL, 1, NULL, CAST(N'2025-11-29T10:13:45.327' AS DateTime), CAST(N'2025-11-29T10:13:45.327' AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[EMPLEADO] ([id_empleado], [id_sede], [TipoDocumento], [NumeroDocumento], [Nombre], [Apellidos], [Cargo], [Area], [TipoContrato], [Fecha_Ingreso], [Fecha_Retiro], [Nivel_Riesgo_Laboral], [Correo], [Telefono], [DireccionResidencia], [ContactoEmergencia], [TelefonoEmergencia], [GrupoSanguineo], [Estado], [id_supervisor], [FechaCreacion], [FechaActualizacion], [ARL], [FechaAfiliacionARL], [EPS], [AFP]) VALUES (105, 1, N'CC', N'9988776655', N'Laura', N'Martínez Díaz', N'Contratista Mantenimiento', N'Mantenimiento', N'Obra o Labor', CAST(N'2024-01-10' AS Date), NULL, 4, N'laura.martinez@contractor.com', N'+573501234567', NULL, N'Miguel Martínez', N'+573505555555', NULL, 1, NULL, CAST(N'2025-11-29T10:13:45.350' AS DateTime), CAST(N'2025-11-29T10:13:45.350' AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[EMPLEADO] ([id_empleado], [id_sede], [TipoDocumento], [NumeroDocumento], [Nombre], [Apellidos], [Cargo], [Area], [TipoContrato], [Fecha_Ingreso], [Fecha_Retiro], [Nivel_Riesgo_Laboral], [Correo], [Telefono], [DireccionResidencia], [ContactoEmergencia], [TelefonoEmergencia], [GrupoSanguineo], [Estado], [id_supervisor], [FechaCreacion], [FechaActualizacion], [ARL], [FechaAfiliacionARL], [EPS], [AFP]) VALUES (106, 1, N'CC', N'4455667788', N'Roberto', N'Sánchez Mora', N'Auditor SST', N'Calidad y Auditoría', N'Prestación de Servicios', CAST(N'2023-06-01' AS Date), NULL, 1, N'roberto.sanchez@auditor.com', N'+573601234567', NULL, N'Patricia Sánchez', N'+573606666666', NULL, 1, NULL, CAST(N'2025-11-29T10:13:45.360' AS DateTime), CAST(N'2025-11-29T10:13:45.360' AS DateTime), NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[EMPLEADO] OFF
GO
SET IDENTITY_INSERT [dbo].[EMPLEADO_AGENTE_ROL] ON 

INSERT [dbo].[EMPLEADO_AGENTE_ROL] ([id_empleado_agente_rol], [id_empleado], [id_agente_rol], [FechaAsignacion], [FechaFinalizacion], [asignado_por], [motivo]) VALUES (1, 100, 1, CAST(N'2025-11-29T10:13:45.267' AS DateTime), NULL, NULL, N'Asignación automática basada en rol CEO')
INSERT [dbo].[EMPLEADO_AGENTE_ROL] ([id_empleado_agente_rol], [id_empleado], [id_agente_rol], [FechaAsignacion], [FechaFinalizacion], [asignado_por], [motivo]) VALUES (2, 101, 2, CAST(N'2025-11-29T10:13:45.270' AS DateTime), NULL, NULL, N'Asignación automática basada en rol Coordinador SST')
INSERT [dbo].[EMPLEADO_AGENTE_ROL] ([id_empleado_agente_rol], [id_empleado], [id_agente_rol], [FechaAsignacion], [FechaFinalizacion], [asignado_por], [motivo]) VALUES (3, 102, 4, CAST(N'2025-11-29T10:13:45.270' AS DateTime), NULL, NULL, N'Asignación automática - empleado estándar')
INSERT [dbo].[EMPLEADO_AGENTE_ROL] ([id_empleado_agente_rol], [id_empleado], [id_agente_rol], [FechaAsignacion], [FechaFinalizacion], [asignado_por], [motivo]) VALUES (4, 103, 4, CAST(N'2025-11-29T10:13:45.273' AS DateTime), NULL, NULL, N'Asignación automática - empleado estándar')
INSERT [dbo].[EMPLEADO_AGENTE_ROL] ([id_empleado_agente_rol], [id_empleado], [id_agente_rol], [FechaAsignacion], [FechaFinalizacion], [asignado_por], [motivo]) VALUES (5, 104, 3, CAST(N'2025-11-29T10:13:45.340' AS DateTime), NULL, NULL, N'Asignación inicial - Supervisor de Producción')
INSERT [dbo].[EMPLEADO_AGENTE_ROL] ([id_empleado_agente_rol], [id_empleado], [id_agente_rol], [FechaAsignacion], [FechaFinalizacion], [asignado_por], [motivo]) VALUES (6, 105, 5, CAST(N'2025-11-29T10:13:45.350' AS DateTime), NULL, NULL, N'Asignación inicial - Contratista')
INSERT [dbo].[EMPLEADO_AGENTE_ROL] ([id_empleado_agente_rol], [id_empleado], [id_agente_rol], [FechaAsignacion], [FechaFinalizacion], [asignado_por], [motivo]) VALUES (7, 106, 6, CAST(N'2025-11-29T10:13:45.360' AS DateTime), NULL, NULL, N'Asignación inicial - Auditor SST')
SET IDENTITY_INSERT [dbo].[EMPLEADO_AGENTE_ROL] OFF
GO
INSERT [dbo].[EMPLEADO_ROL] ([id_empleado], [id_rol], [FechaAsignacion], [FechaFinalizacion]) VALUES (100, 1, CAST(N'2025-11-14' AS Date), NULL)
INSERT [dbo].[EMPLEADO_ROL] ([id_empleado], [id_rol], [FechaAsignacion], [FechaFinalizacion]) VALUES (101, 2, CAST(N'2025-11-14' AS Date), NULL)
GO
SET IDENTITY_INSERT [dbo].[EMPRESA] ON 

INSERT [dbo].[EMPRESA] ([id_empresa], [RazonSocial], [NIT], [ActividadEconomica], [ClaseRiesgo], [NumeroTrabajadores], [DireccionPrincipal], [Telefono], [FechaConstitucion]) VALUES (1, N'Digital Bulks S.A.S.', N'900.123.456-7', N'Desarrollo de Software y Consultoría IT', 1, 7, N'Calle 100 #10-50', N'+57 604 1234567', NULL)
SET IDENTITY_INSERT [dbo].[EMPRESA] OFF
GO
SET IDENTITY_INSERT [dbo].[EPP] ON 

INSERT [dbo].[EPP] ([id_epp], [Codigo_EPP], [Nombre_EPP], [Tipo_EPP], [Riesgo_Protegido], [Especificaciones], [Certificacion], [Stock_Disponible], [Ubicacion_Almacen]) VALUES (6003, N'EPP-001', N'Gafas de Protección', N'Protección Visual', N'Partículas, Radiación', N'Lentes policarbonato, filtro UV', NULL, 50, NULL)
INSERT [dbo].[EPP] ([id_epp], [Codigo_EPP], [Nombre_EPP], [Tipo_EPP], [Riesgo_Protegido], [Especificaciones], [Certificacion], [Stock_Disponible], [Ubicacion_Almacen]) VALUES (6004, N'EPP-002', N'Protector Auditivo Tipo Copa', N'Protección Auditiva', N'Ruido', N'Atenuación 27 dB, ajustable', NULL, 30, NULL)
INSERT [dbo].[EPP] ([id_epp], [Codigo_EPP], [Nombre_EPP], [Tipo_EPP], [Riesgo_Protegido], [Especificaciones], [Certificacion], [Stock_Disponible], [Ubicacion_Almacen]) VALUES (6005, N'EPP-003', N'Silla Ergonómica Oficina', N'Ergonómico', N'Posturas Forzadas', N'Respaldo ajustable, soporte lumbar', NULL, 45, NULL)
INSERT [dbo].[EPP] ([id_epp], [Codigo_EPP], [Nombre_EPP], [Tipo_EPP], [Riesgo_Protegido], [Especificaciones], [Certificacion], [Stock_Disponible], [Ubicacion_Almacen]) VALUES (6006, N'EPP-004', N'Mouse Ergonómico Vertical', N'Ergonómico', N'Túnel Carpiano', N'Diseño vertical, reduce tensión muñeca', NULL, 60, NULL)
SET IDENTITY_INSERT [dbo].[EPP] OFF
GO
SET IDENTITY_INSERT [dbo].[EQUIPO] ON 

INSERT [dbo].[EQUIPO] ([id_equipo], [Nombre], [Tipo], [CodigoInterno], [Marca], [Modelo], [NumeroSerie], [id_sede], [UbicacionEspecifica], [Responsable], [FechaAdquisicion], [FechaUltimoMantenimiento], [FechaProximoMantenimiento], [RequiereCalibacion], [FechaProximaCalibracion], [Estado]) VALUES (4, N'Extintor PQS 10 lb - Recepción', N'Extintores', N'EXT-001', NULL, NULL, NULL, 1, N'Área de recepción principal', 101, CAST(N'2023-01-15' AS Date), CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), 0, NULL, N'Operativo')
INSERT [dbo].[EQUIPO] ([id_equipo], [Nombre], [Tipo], [CodigoInterno], [Marca], [Modelo], [NumeroSerie], [id_sede], [UbicacionEspecifica], [Responsable], [FechaAdquisicion], [FechaUltimoMantenimiento], [FechaProximoMantenimiento], [RequiereCalibacion], [FechaProximaCalibracion], [Estado]) VALUES (5, N'Extintor CO2 20 lb - Sistemas', N'Extintores', N'EXT-002', NULL, NULL, NULL, 1, N'Cuarto de servidores', 101, CAST(N'2023-01-15' AS Date), CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), 0, NULL, N'Operativo')
INSERT [dbo].[EQUIPO] ([id_equipo], [Nombre], [Tipo], [CodigoInterno], [Marca], [Modelo], [NumeroSerie], [id_sede], [UbicacionEspecifica], [Responsable], [FechaAdquisicion], [FechaUltimoMantenimiento], [FechaProximoMantenimiento], [RequiereCalibacion], [FechaProximaCalibracion], [Estado]) VALUES (6, N'Botiquín Tipo A - Oficinas', N'Botiquín', N'BOT-001', NULL, NULL, NULL, 1, N'Área administrativa piso 4', 101, CAST(N'2023-06-01' AS Date), CAST(N'2024-06-01' AS Date), CAST(N'2025-06-01' AS Date), 0, NULL, N'Operativo')
INSERT [dbo].[EQUIPO] ([id_equipo], [Nombre], [Tipo], [CodigoInterno], [Marca], [Modelo], [NumeroSerie], [id_sede], [UbicacionEspecifica], [Responsable], [FechaAdquisicion], [FechaUltimoMantenimiento], [FechaProximoMantenimiento], [RequiereCalibacion], [FechaProximaCalibracion], [Estado]) VALUES (17, N'Aire Acondicionado Central', N'Maquinaria', N'EQ-001', N'LG', N'Industrial-X', N'SN123456', 1, N'Techo Planta', 100, CAST(N'2023-01-01' AS Date), CAST(N'2023-06-01' AS Date), CAST(N'2025-11-20' AS Date), 0, NULL, N'Operativo')
INSERT [dbo].[EQUIPO] ([id_equipo], [Nombre], [Tipo], [CodigoInterno], [Marca], [Modelo], [NumeroSerie], [id_sede], [UbicacionEspecifica], [Responsable], [FechaAdquisicion], [FechaUltimoMantenimiento], [FechaProximoMantenimiento], [RequiereCalibacion], [FechaProximaCalibracion], [Estado]) VALUES (18, N'Planta Eléctrica', N'Maquinaria', N'EQ-002', N'Caterpillar', N'G3500', N'CAT98765', 1, N'Cuarto de Máquinas', 100, CAST(N'2022-05-15' AS Date), CAST(N'2023-05-15' AS Date), CAST(N'2025-11-05' AS Date), 0, NULL, N'Operativo')
SET IDENTITY_INSERT [dbo].[EQUIPO] OFF
GO
SET IDENTITY_INSERT [dbo].[EVALUACION_LEGAL] ON 

INSERT [dbo].[EVALUACION_LEGAL] ([id_evaluacion], [id_requisito], [FechaEvaluacion], [EstadoCumplimiento], [Evidencias], [ResponsableEvaluacion], [Observaciones]) VALUES (1, 500, CAST(N'2025-12-01' AS Date), N'Cumple Parcialmente', N'Evaluación generada automáticamente para prueba de Dashboard', 101, N'Evaluación inicial')
INSERT [dbo].[EVALUACION_LEGAL] ([id_evaluacion], [id_requisito], [FechaEvaluacion], [EstadoCumplimiento], [Evidencias], [ResponsableEvaluacion], [Observaciones]) VALUES (2, 501, CAST(N'2025-12-01' AS Date), N'Cumple', N'Evaluación generada automáticamente para prueba de Dashboard', 101, N'Evaluación inicial')
INSERT [dbo].[EVALUACION_LEGAL] ([id_evaluacion], [id_requisito], [FechaEvaluacion], [EstadoCumplimiento], [Evidencias], [ResponsableEvaluacion], [Observaciones]) VALUES (3, 502, CAST(N'2025-12-01' AS Date), N'Cumple Parcialmente', N'Evaluación generada automáticamente para prueba de Dashboard', 101, N'Evaluación inicial')
INSERT [dbo].[EVALUACION_LEGAL] ([id_evaluacion], [id_requisito], [FechaEvaluacion], [EstadoCumplimiento], [Evidencias], [ResponsableEvaluacion], [Observaciones]) VALUES (4, 503, CAST(N'2025-12-01' AS Date), N'No Cumple', N'Evaluación generada automáticamente para prueba de Dashboard', 101, N'Evaluación inicial')
INSERT [dbo].[EVALUACION_LEGAL] ([id_evaluacion], [id_requisito], [FechaEvaluacion], [EstadoCumplimiento], [Evidencias], [ResponsableEvaluacion], [Observaciones]) VALUES (5, 504, CAST(N'2025-12-01' AS Date), N'Cumple', N'Evaluación generada automáticamente para prueba de Dashboard', 101, N'Evaluación inicial')
SET IDENTITY_INSERT [dbo].[EVALUACION_LEGAL] OFF
GO
SET IDENTITY_INSERT [dbo].[EVALUACION_RIESGO] ON 

INSERT [dbo].[EVALUACION_RIESGO] ([id_evaluacion], [Descripcion], [Tipo_Evaluacion], [Fecha_Programada], [Fecha_Realizacion], [Responsable], [Estado], [Resultado]) VALUES (1, N'Actualización Matriz de Peligros 2024', N'Matriz de Peligros', CAST(N'2025-11-05' AS Date), NULL, N'Coordinador SST', N'Programada', NULL)
INSERT [dbo].[EVALUACION_RIESGO] ([id_evaluacion], [Descripcion], [Tipo_Evaluacion], [Fecha_Programada], [Fecha_Realizacion], [Responsable], [Estado], [Resultado]) VALUES (2, N'Evaluación de Riesgo Psicosocial', N'Psicosocial', CAST(N'2025-11-15' AS Date), NULL, N'Psicólogo SST', N'Programada', NULL)
SET IDENTITY_INSERT [dbo].[EVALUACION_RIESGO] OFF
GO
SET IDENTITY_INSERT [dbo].[EVENTO] ON 

INSERT [dbo].[EVENTO] ([id_evento], [Tipo_Evento], [Fecha_Evento], [Hora_Evento], [id_empleado], [Lugar_Evento], [Descripcion_Evento], [Parte_Cuerpo_Afectada], [Naturaleza_Lesion], [Mecanismo_Accidente], [Testigos], [Dias_Incapacidad], [ClasificacionIncapacidad], [Reportado_ARL], [Fecha_Reporte_ARL], [Numero_Caso_ARL], [Requiere_Investigacion], [Estado_Investigacion], [Fecha_Investigacion], [Causas_Inmediatas], [Causas_Basicas], [Analisis_Causas], [id_responsable_investigacion], [FechaRegistro], [LugarAtencionMedica], [NombreMedicoTratante]) VALUES (1003, N'Accidente de Trabajo', CAST(N'2025-08-15T20:22:16.810' AS DateTime), CAST(N'14:30:00' AS Time), 102, N'Oficina de Desarrollo', N'Caída al mismo nivel por cable suelto en el piso', NULL, NULL, NULL, NULL, 3, N'Temporal', 1, NULL, NULL, 1, N'Cerrada', NULL, NULL, NULL, NULL, NULL, CAST(N'2025-11-15T20:22:16.810' AS DateTime), NULL, NULL)
INSERT [dbo].[EVENTO] ([id_evento], [Tipo_Evento], [Fecha_Evento], [Hora_Evento], [id_empleado], [Lugar_Evento], [Descripcion_Evento], [Parte_Cuerpo_Afectada], [Naturaleza_Lesion], [Mecanismo_Accidente], [Testigos], [Dias_Incapacidad], [ClasificacionIncapacidad], [Reportado_ARL], [Fecha_Reporte_ARL], [Numero_Caso_ARL], [Requiere_Investigacion], [Estado_Investigacion], [Fecha_Investigacion], [Causas_Inmediatas], [Causas_Basicas], [Analisis_Causas], [id_responsable_investigacion], [FechaRegistro], [LugarAtencionMedica], [NombreMedicoTratante]) VALUES (1004, N'Incidente', CAST(N'2025-10-15T20:22:16.810' AS DateTime), CAST(N'10:15:00' AS Time), 103, N'Área Financiera', N'Casi caída por piso mojado sin señalización', NULL, NULL, NULL, NULL, 0, N'Sin Incapacidad', 0, NULL, NULL, 1, N'Cerrada', NULL, NULL, NULL, NULL, NULL, CAST(N'2025-11-15T20:22:16.810' AS DateTime), NULL, NULL)
INSERT [dbo].[EVENTO] ([id_evento], [Tipo_Evento], [Fecha_Evento], [Hora_Evento], [id_empleado], [Lugar_Evento], [Descripcion_Evento], [Parte_Cuerpo_Afectada], [Naturaleza_Lesion], [Mecanismo_Accidente], [Testigos], [Dias_Incapacidad], [ClasificacionIncapacidad], [Reportado_ARL], [Fecha_Reporte_ARL], [Numero_Caso_ARL], [Requiere_Investigacion], [Estado_Investigacion], [Fecha_Investigacion], [Causas_Inmediatas], [Causas_Basicas], [Analisis_Causas], [id_responsable_investigacion], [FechaRegistro], [LugarAtencionMedica], [NombreMedicoTratante]) VALUES (1005, N'Acto Inseguro', CAST(N'2025-10-31T20:22:16.810' AS DateTime), CAST(N'16:00:00' AS Time), 102, N'Cafetería', N'Empleado trasportando líquido caliente sin protección', NULL, NULL, NULL, NULL, 0, N'Sin Incapacidad', 0, NULL, NULL, 1, N'Pendiente', NULL, NULL, NULL, NULL, NULL, CAST(N'2025-11-15T20:22:16.810' AS DateTime), NULL, NULL)
INSERT [dbo].[EVENTO] ([id_evento], [Tipo_Evento], [Fecha_Evento], [Hora_Evento], [id_empleado], [Lugar_Evento], [Descripcion_Evento], [Parte_Cuerpo_Afectada], [Naturaleza_Lesion], [Mecanismo_Accidente], [Testigos], [Dias_Incapacidad], [ClasificacionIncapacidad], [Reportado_ARL], [Fecha_Reporte_ARL], [Numero_Caso_ARL], [Requiere_Investigacion], [Estado_Investigacion], [Fecha_Investigacion], [Causas_Inmediatas], [Causas_Basicas], [Analisis_Causas], [id_responsable_investigacion], [FechaRegistro], [LugarAtencionMedica], [NombreMedicoTratante]) VALUES (1006, N'Accidente de Trabajo', CAST(N'2024-03-15T00:00:00.000' AS DateTime), NULL, 103, NULL, N'CaÃ­da a nivel', NULL, NULL, NULL, NULL, 5, NULL, 0, NULL, NULL, 1, N'Cerrada', NULL, NULL, NULL, NULL, NULL, CAST(N'2025-12-02T19:38:33.873' AS DateTime), NULL, NULL)
INSERT [dbo].[EVENTO] ([id_evento], [Tipo_Evento], [Fecha_Evento], [Hora_Evento], [id_empleado], [Lugar_Evento], [Descripcion_Evento], [Parte_Cuerpo_Afectada], [Naturaleza_Lesion], [Mecanismo_Accidente], [Testigos], [Dias_Incapacidad], [ClasificacionIncapacidad], [Reportado_ARL], [Fecha_Reporte_ARL], [Numero_Caso_ARL], [Requiere_Investigacion], [Estado_Investigacion], [Fecha_Investigacion], [Causas_Inmediatas], [Causas_Basicas], [Analisis_Causas], [id_responsable_investigacion], [FechaRegistro], [LugarAtencionMedica], [NombreMedicoTratante]) VALUES (1007, N'Accidente de Trabajo', CAST(N'2024-06-20T00:00:00.000' AS DateTime), NULL, 104, NULL, N'Golpe con objeto', NULL, NULL, NULL, NULL, 3, NULL, 0, NULL, NULL, 1, N'Cerrada', NULL, NULL, NULL, NULL, NULL, CAST(N'2025-12-02T19:38:33.873' AS DateTime), NULL, NULL)
INSERT [dbo].[EVENTO] ([id_evento], [Tipo_Evento], [Fecha_Evento], [Hora_Evento], [id_empleado], [Lugar_Evento], [Descripcion_Evento], [Parte_Cuerpo_Afectada], [Naturaleza_Lesion], [Mecanismo_Accidente], [Testigos], [Dias_Incapacidad], [ClasificacionIncapacidad], [Reportado_ARL], [Fecha_Reporte_ARL], [Numero_Caso_ARL], [Requiere_Investigacion], [Estado_Investigacion], [Fecha_Investigacion], [Causas_Inmediatas], [Causas_Basicas], [Analisis_Causas], [id_responsable_investigacion], [FechaRegistro], [LugarAtencionMedica], [NombreMedicoTratante]) VALUES (1008, N'Accidente de Trabajo', CAST(N'2024-09-10T00:00:00.000' AS DateTime), NULL, 105, NULL, N'Sobreesfuerzo', NULL, NULL, NULL, NULL, 10, NULL, 0, NULL, NULL, 1, N'Cerrada', NULL, NULL, NULL, NULL, NULL, CAST(N'2025-12-02T19:38:33.873' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[EVENTO] OFF
GO
SET IDENTITY_INSERT [dbo].[EXAMEN_MEDICO] ON 

INSERT [dbo].[EXAMEN_MEDICO] ([id_examen], [id_empleado], [Tipo_Examen], [Fecha_Realizacion], [Fecha_Vencimiento], [EntidadRealizadora], [MedicoEvaluador], [Apto_Para_Cargo], [Restricciones], [Recomendaciones], [DiagnosticosCodificados], [RequiereSeguimiento], [RutaResultados], [FechaRegistro]) VALUES (3000, 100, N'Preocupacional', CAST(N'2015-01-01' AS Date), NULL, N'IPS Salud Total', NULL, 1, NULL, NULL, NULL, 0, NULL, CAST(N'2025-11-14T10:15:22.803' AS DateTime))
INSERT [dbo].[EXAMEN_MEDICO] ([id_examen], [id_empleado], [Tipo_Examen], [Fecha_Realizacion], [Fecha_Vencimiento], [EntidadRealizadora], [MedicoEvaluador], [Apto_Para_Cargo], [Restricciones], [Recomendaciones], [DiagnosticosCodificados], [RequiereSeguimiento], [RutaResultados], [FechaRegistro]) VALUES (3001, 101, N'Preocupacional', CAST(N'2019-11-01' AS Date), NULL, N'IPS Salud Total', NULL, 1, NULL, NULL, NULL, 0, NULL, CAST(N'2025-11-14T10:15:22.803' AS DateTime))
INSERT [dbo].[EXAMEN_MEDICO] ([id_examen], [id_empleado], [Tipo_Examen], [Fecha_Realizacion], [Fecha_Vencimiento], [EntidadRealizadora], [MedicoEvaluador], [Apto_Para_Cargo], [Restricciones], [Recomendaciones], [DiagnosticosCodificados], [RequiereSeguimiento], [RutaResultados], [FechaRegistro]) VALUES (3002, 102, N'Periodico', CAST(N'2023-01-20' AS Date), CAST(N'2024-01-20' AS Date), N'IPS Salud Total', NULL, 1, NULL, NULL, NULL, 0, NULL, CAST(N'2025-11-14T10:15:22.803' AS DateTime))
INSERT [dbo].[EXAMEN_MEDICO] ([id_examen], [id_empleado], [Tipo_Examen], [Fecha_Realizacion], [Fecha_Vencimiento], [EntidadRealizadora], [MedicoEvaluador], [Apto_Para_Cargo], [Restricciones], [Recomendaciones], [DiagnosticosCodificados], [RequiereSeguimiento], [RutaResultados], [FechaRegistro]) VALUES (3003, 103, N'Periodico', CAST(N'2024-06-01' AS Date), CAST(N'2025-11-24' AS Date), N'IPS Salud Total', NULL, 1, NULL, NULL, NULL, 0, NULL, CAST(N'2025-11-14T10:15:22.803' AS DateTime))
SET IDENTITY_INSERT [dbo].[EXAMEN_MEDICO] OFF
GO
INSERT [dbo].[EXPOSICION] ([id_empleado], [id_riesgo], [TiempoExposicionDiario], [FrecuenciaExposicion], [FechaRegistro]) VALUES (100, 2, CAST(8.00 AS Decimal(5, 2)), N'Diaria', CAST(N'2025-11-14' AS Date))
INSERT [dbo].[EXPOSICION] ([id_empleado], [id_riesgo], [TiempoExposicionDiario], [FrecuenciaExposicion], [FechaRegistro]) VALUES (102, 1, CAST(8.00 AS Decimal(5, 2)), N'Diaria', CAST(N'2025-11-14' AS Date))
INSERT [dbo].[EXPOSICION] ([id_empleado], [id_riesgo], [TiempoExposicionDiario], [FrecuenciaExposicion], [FechaRegistro]) VALUES (103, 1, CAST(7.00 AS Decimal(5, 2)), N'Diaria', CAST(N'2025-11-14' AS Date))
GO
SET IDENTITY_INSERT [dbo].[FORM_DRAFTS] ON 

INSERT [dbo].[FORM_DRAFTS] ([id_draft], [form_id], [user_id], [data_json], [saved_at], [expires_at]) VALUES (1, N'form_inspeccion_botiquin', 2, N'{"ubicacion": "Pasillo", "elementos_completos": "si", "fechas_vencimiento": "si"}', CAST(N'2025-12-10T16:56:08.807' AS DateTime), CAST(N'2026-01-09T16:56:08.807' AS DateTime))
INSERT [dbo].[FORM_DRAFTS] ([id_draft], [form_id], [user_id], [data_json], [saved_at], [expires_at]) VALUES (2, N'form_examen_medico', 2, N'{"fecha_examen": "2025-12-01", "id_empleado": 102, "tipo_examen": "periodico", "concepto_aptitud": "apto", "restricciones": "todo muy bien", "certificado_adjunto": null}', CAST(N'2025-12-18T21:43:29.670' AS DateTime), CAST(N'2026-01-17T21:43:29.670' AS DateTime))
INSERT [dbo].[FORM_DRAFTS] ([id_draft], [form_id], [user_id], [data_json], [saved_at], [expires_at]) VALUES (3, N'form_registro_capacitacion', 2, N'{"fecha": "2025-12-10", "asistentes": 100}', CAST(N'2025-12-10T16:53:27.917' AS DateTime), CAST(N'2026-01-09T16:53:27.917' AS DateTime))
INSERT [dbo].[FORM_DRAFTS] ([id_draft], [form_id], [user_id], [data_json], [saved_at], [expires_at]) VALUES (4, N'form_inspeccion_extintor', 2, N'{"ubicacion": "Calderos", "tipo_extintor": "ABC", "presion": "si", "acceso": "si", "observaciones": "intento 10"}', CAST(N'2025-12-11T20:46:35.937' AS DateTime), CAST(N'2026-01-10T20:46:35.937' AS DateTime))
SET IDENTITY_INSERT [dbo].[FORM_DRAFTS] OFF
GO
SET IDENTITY_INSERT [dbo].[FORM_SUBMISSION_AUDIT] ON 

INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (3, 3, N'INSERT', NULL, NULL, NULL, 2, CAST(N'2025-12-10T16:56:32.940' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (9, 9, N'INSERT', NULL, NULL, NULL, 2, CAST(N'2025-12-10T20:33:55.977' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (10, 10, N'INSERT', NULL, NULL, NULL, 2, CAST(N'2025-12-10T20:39:27.320' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (11, 11, N'INSERT', NULL, NULL, NULL, 2, CAST(N'2025-12-10T20:43:39.053' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (12, 12, N'INSERT', NULL, NULL, NULL, 2, CAST(N'2025-12-10T20:46:55.787' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (13, 13, N'INSERT', NULL, NULL, NULL, 2, CAST(N'2025-12-10T20:58:55.210' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (16, 14, N'INSERT', NULL, NULL, NULL, 2, CAST(N'2025-12-10T21:24:58.860' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (19, 15, N'INSERT', NULL, NULL, NULL, 2, CAST(N'2025-12-11T17:12:13.777' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (22, 16, N'INSERT', NULL, NULL, NULL, 2, CAST(N'2025-12-11T17:30:06.083' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (25, 17, N'INSERT', NULL, NULL, NULL, 2, CAST(N'2025-12-11T20:17:40.350' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (26, 17, N'STATUS_CHANGE', N'status', N'Submitted', N'Failed', 2, CAST(N'2025-12-11T20:17:40.450' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (27, 17, N'UPDATE', NULL, NULL, NULL, 2, CAST(N'2025-12-11T20:17:40.450' AS DateTime), NULL)
INSERT [dbo].[FORM_SUBMISSION_AUDIT] ([id_audit], [id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at], [ip_address]) VALUES (28, 17, N'UPDATE', NULL, NULL, NULL, 2, CAST(N'2025-12-11T20:17:40.457' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[FORM_SUBMISSION_AUDIT] OFF
GO
SET IDENTITY_INSERT [dbo].[FORM_SUBMISSIONS] ON 

INSERT [dbo].[FORM_SUBMISSIONS] ([id_submission], [form_id], [form_version], [form_title], [data_json], [attachments_json], [submitted_by], [submitted_at], [status], [workflow_status], [reviewed_by], [reviewed_at], [review_notes], [created_at], [updated_at], [updated_by], [ip_address], [user_agent], [deleted], [deleted_at], [deleted_by], [error_message]) VALUES (3, N'form_inspeccion_botiquin', N'1.0', N'Lista de Chequeo de Botiquín', N'{"ubicacion": "Pasillo", "elementos_completos": "si", "fechas_vencimiento": "si", "context": {"taskId": 2017, "description": "Inspecci\u00f3n de Botiquines - Sede Principal"}}', N'[]', 2, CAST(N'2025-12-10T16:56:32.930' AS DateTime), N'Submitted', N'Pending', NULL, NULL, NULL, CAST(N'2025-12-10T16:56:32.930' AS DateTime), CAST(N'2025-12-10T16:56:32.930' AS DateTime), NULL, NULL, NULL, 0, NULL, NULL, NULL)
INSERT [dbo].[FORM_SUBMISSIONS] ([id_submission], [form_id], [form_version], [form_title], [data_json], [attachments_json], [submitted_by], [submitted_at], [status], [workflow_status], [reviewed_by], [reviewed_at], [review_notes], [created_at], [updated_at], [updated_by], [ip_address], [user_agent], [deleted], [deleted_at], [deleted_by], [error_message]) VALUES (9, N'form_inspeccion_extintor', N'1.0', N'Lista de Chequeo de Extintores', N'{"ubicacion": "Calderos", "tipo_extintor": "ABC", "presion": "si", "acceso": "si", "observaciones": "intento 3"}', N'[]', 2, CAST(N'2025-12-10T20:33:55.977' AS DateTime), N'Submitted', N'Pending', NULL, NULL, NULL, CAST(N'2025-12-10T20:33:55.977' AS DateTime), CAST(N'2025-12-10T20:33:55.977' AS DateTime), NULL, NULL, NULL, 0, NULL, NULL, NULL)
INSERT [dbo].[FORM_SUBMISSIONS] ([id_submission], [form_id], [form_version], [form_title], [data_json], [attachments_json], [submitted_by], [submitted_at], [status], [workflow_status], [reviewed_by], [reviewed_at], [review_notes], [created_at], [updated_at], [updated_by], [ip_address], [user_agent], [deleted], [deleted_at], [deleted_by], [error_message]) VALUES (10, N'form_inspeccion_extintor', N'1.0', N'Lista de Chequeo de Extintores', N'{"ubicacion": "Calderos", "tipo_extintor": "ABC", "presion": "si", "acceso": "si", "observaciones": "intento 4"}', N'[]', 2, CAST(N'2025-12-10T20:39:27.320' AS DateTime), N'Submitted', N'Pending', NULL, NULL, NULL, CAST(N'2025-12-10T20:39:27.320' AS DateTime), CAST(N'2025-12-10T20:39:27.320' AS DateTime), NULL, NULL, NULL, 0, NULL, NULL, NULL)
INSERT [dbo].[FORM_SUBMISSIONS] ([id_submission], [form_id], [form_version], [form_title], [data_json], [attachments_json], [submitted_by], [submitted_at], [status], [workflow_status], [reviewed_by], [reviewed_at], [review_notes], [created_at], [updated_at], [updated_by], [ip_address], [user_agent], [deleted], [deleted_at], [deleted_by], [error_message]) VALUES (11, N'form_inspeccion_extintor', N'1.0', N'Lista de Chequeo de Extintores', N'{"ubicacion": "Calderos", "tipo_extintor": "ABC", "presion": "si", "acceso": "si", "observaciones": "intento 5"}', N'[]', 2, CAST(N'2025-12-10T20:43:39.053' AS DateTime), N'Submitted', N'Pending', NULL, NULL, NULL, CAST(N'2025-12-10T20:43:39.053' AS DateTime), CAST(N'2025-12-10T20:43:39.053' AS DateTime), NULL, NULL, NULL, 0, NULL, NULL, NULL)
INSERT [dbo].[FORM_SUBMISSIONS] ([id_submission], [form_id], [form_version], [form_title], [data_json], [attachments_json], [submitted_by], [submitted_at], [status], [workflow_status], [reviewed_by], [reviewed_at], [review_notes], [created_at], [updated_at], [updated_by], [ip_address], [user_agent], [deleted], [deleted_at], [deleted_by], [error_message]) VALUES (12, N'form_inspeccion_extintor', N'1.0', N'Lista de Chequeo de Extintores', N'{"ubicacion": "Calderos", "tipo_extintor": "ABC", "presion": "si", "acceso": "si", "observaciones": "intento 6"}', N'[]', 2, CAST(N'2025-12-10T20:46:55.787' AS DateTime), N'Submitted', N'Pending', NULL, NULL, NULL, CAST(N'2025-12-10T20:46:55.787' AS DateTime), CAST(N'2025-12-10T20:46:55.787' AS DateTime), NULL, NULL, NULL, 0, NULL, NULL, NULL)
INSERT [dbo].[FORM_SUBMISSIONS] ([id_submission], [form_id], [form_version], [form_title], [data_json], [attachments_json], [submitted_by], [submitted_at], [status], [workflow_status], [reviewed_by], [reviewed_at], [review_notes], [created_at], [updated_at], [updated_by], [ip_address], [user_agent], [deleted], [deleted_at], [deleted_by], [error_message]) VALUES (13, N'form_inspeccion_extintor', N'1.0', N'Lista de Chequeo de Extintores', N'{"ubicacion": "Calderos", "tipo_extintor": "ABC", "presion": "si", "acceso": "si", "observaciones": "intento 7"}', N'[]', 2, CAST(N'2025-12-10T20:58:55.203' AS DateTime), N'Submitted', N'Pending', NULL, NULL, NULL, CAST(N'2025-12-10T20:58:55.203' AS DateTime), CAST(N'2025-12-10T20:58:55.203' AS DateTime), NULL, NULL, NULL, 0, NULL, NULL, NULL)
INSERT [dbo].[FORM_SUBMISSIONS] ([id_submission], [form_id], [form_version], [form_title], [data_json], [attachments_json], [submitted_by], [submitted_at], [status], [workflow_status], [reviewed_by], [reviewed_at], [review_notes], [created_at], [updated_at], [updated_by], [ip_address], [user_agent], [deleted], [deleted_at], [deleted_by], [error_message]) VALUES (14, N'form_inspeccion_extintor', N'1.0', N'Lista de Chequeo de Extintores', N'{"ubicacion": "Calderos", "tipo_extintor": "ABC", "presion": "si", "acceso": "si", "observaciones": "intento 8"}', N'[]', 2, CAST(N'2025-12-10T21:24:58.853' AS DateTime), N'Submitted', N'Pending', NULL, NULL, NULL, CAST(N'2025-12-10T21:24:58.853' AS DateTime), CAST(N'2025-12-10T21:24:58.853' AS DateTime), NULL, NULL, NULL, 0, NULL, NULL, NULL)
INSERT [dbo].[FORM_SUBMISSIONS] ([id_submission], [form_id], [form_version], [form_title], [data_json], [attachments_json], [submitted_by], [submitted_at], [status], [workflow_status], [reviewed_by], [reviewed_at], [review_notes], [created_at], [updated_at], [updated_by], [ip_address], [user_agent], [deleted], [deleted_at], [deleted_by], [error_message]) VALUES (15, N'form_inspeccion_extintor', N'1.0', N'Lista de Chequeo de Extintores', N'{"ubicacion": "Calderos", "tipo_extintor": "ABC", "presion": "si", "acceso": "si", "observaciones": "intento 9"}', N'[]', 2, CAST(N'2025-12-11T17:12:13.770' AS DateTime), N'Submitted', N'Pending', NULL, NULL, NULL, CAST(N'2025-12-11T17:12:13.770' AS DateTime), CAST(N'2025-12-11T17:12:13.770' AS DateTime), NULL, NULL, NULL, 0, NULL, NULL, NULL)
INSERT [dbo].[FORM_SUBMISSIONS] ([id_submission], [form_id], [form_version], [form_title], [data_json], [attachments_json], [submitted_by], [submitted_at], [status], [workflow_status], [reviewed_by], [reviewed_at], [review_notes], [created_at], [updated_at], [updated_by], [ip_address], [user_agent], [deleted], [deleted_at], [deleted_by], [error_message]) VALUES (16, N'form_inspeccion_extintor', N'1.0', N'Lista de Chequeo de Extintores', N'{"ubicacion": "Calderos", "tipo_extintor": "ABC", "presion": "si", "acceso": "si", "observaciones": "intento 9"}', N'[]', 2, CAST(N'2025-12-11T17:30:06.077' AS DateTime), N'Submitted', N'Pending', NULL, NULL, NULL, CAST(N'2025-12-11T17:30:06.077' AS DateTime), CAST(N'2025-12-11T17:30:06.077' AS DateTime), NULL, NULL, NULL, 0, NULL, NULL, NULL)
INSERT [dbo].[FORM_SUBMISSIONS] ([id_submission], [form_id], [form_version], [form_title], [data_json], [attachments_json], [submitted_by], [submitted_at], [status], [workflow_status], [reviewed_by], [reviewed_at], [review_notes], [created_at], [updated_at], [updated_by], [ip_address], [user_agent], [deleted], [deleted_at], [deleted_by], [error_message]) VALUES (17, N'form_inspeccion_extintor', N'1.0', N'Lista de Chequeo de Extintores', N'{"ubicacion": "Calderos", "tipo_extintor": "ABC", "presion": "si", "acceso": "si", "observaciones": "intento 10"}', N'[]', 2, CAST(N'2025-12-11T20:17:40.323' AS DateTime), N'Failed', N'Pending', NULL, NULL, NULL, CAST(N'2025-12-11T20:17:40.323' AS DateTime), CAST(N'2025-12-11T20:17:40.457' AS DateTime), NULL, NULL, NULL, 0, NULL, NULL, N'''NoneType'' object has no attribute ''get''')
SET IDENTITY_INSERT [dbo].[FORM_SUBMISSIONS] OFF
GO
SET IDENTITY_INSERT [dbo].[INDICADOR] ON 

INSERT [dbo].[INDICADOR] ([id_indicador], [TipoIndicador], [NombreIndicador], [FormulaCalculo], [UnidadMedida], [Frecuencia], [MetaEsperada], [ResponsableReporte]) VALUES (5, N'Resultado', N'Índice de Frecuencia de Accidentes (IFA)', N'(# AT * 200000) / HHT', N'Accidentes por 200,000 HHT', N'Anual', CAST(5.00 AS Decimal(10, 2)), 101)
INSERT [dbo].[INDICADOR] ([id_indicador], [TipoIndicador], [NombreIndicador], [FormulaCalculo], [UnidadMedida], [Frecuencia], [MetaEsperada], [ResponsableReporte]) VALUES (6, N'Resultado', N'Índice de Severidad (IS)', N'(Días Perdidos * 200000) / HHT', N'Días por 200,000 HHT', N'Anual', CAST(50.00 AS Decimal(10, 2)), 101)
INSERT [dbo].[INDICADOR] ([id_indicador], [TipoIndicador], [NombreIndicador], [FormulaCalculo], [UnidadMedida], [Frecuencia], [MetaEsperada], [ResponsableReporte]) VALUES (7, N'Proceso', N'Cumplimiento del Plan de Capacitación', N'(Capacitaciones Realizadas / Programadas) * 100', N'Porcentaje', N'Trimestral', CAST(95.00 AS Decimal(10, 2)), 101)
INSERT [dbo].[INDICADOR] ([id_indicador], [TipoIndicador], [NombreIndicador], [FormulaCalculo], [UnidadMedida], [Frecuencia], [MetaEsperada], [ResponsableReporte]) VALUES (8, N'Estructura', N'Cobertura de Exámenes Médicos Ocupacionales', N'(EMO Vigente / Total Trabajadores) * 100', N'Porcentaje', N'Mensual', CAST(100.00 AS Decimal(10, 2)), 101)
SET IDENTITY_INSERT [dbo].[INDICADOR] OFF
GO
SET IDENTITY_INSERT [dbo].[INSPECCION] ON 

INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5002, N'Extintores', N'Planta de Producción', 1, CAST(N'2025-11-30' AS Date), CAST(N'2025-11-30' AS Date), NULL, NULL, N'Programada', 0, NULL)
INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5003, N'Botiquines', N'Oficinas Administrativas', 1, CAST(N'2025-11-25' AS Date), CAST(N'2025-11-25' AS Date), NULL, NULL, N'Programada', 0, NULL)
INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5004, N'Puestos de Trabajo', N'Area Comercial', 1, CAST(N'2025-12-03' AS Date), CAST(N'2025-12-03' AS Date), NULL, NULL, N'Programada', 0, NULL)
INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5006, N'Extintor', N'Calderos', NULL, CAST(N'2025-12-10' AS Date), NULL, NULL, N'intento 4', N'Realizada', 0, NULL)
INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5007, N'Extintor', N'Calderos', NULL, CAST(N'2025-12-10' AS Date), NULL, NULL, N'intento 5', N'Realizada', 0, NULL)
INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5008, N'Extintor', N'Calderos', NULL, CAST(N'2025-12-10' AS Date), NULL, NULL, N'intento 6', N'Realizada', 0, NULL)
INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5009, N'Extintor', N'Calderos', NULL, CAST(N'2025-12-10' AS Date), NULL, NULL, N'intento 7', N'Realizada', 0, NULL)
INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5010, N'Extintor', N'Calderos', NULL, CAST(N'2025-12-10' AS Date), NULL, NULL, N'intento 8', N'Realizada', 0, NULL)
INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5011, N'Extintor', N'Calderos', NULL, CAST(N'2025-12-11' AS Date), NULL, NULL, N'intento 9', N'Realizada', 0, NULL)
INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5012, N'Extintor', N'Calderos', NULL, CAST(N'2025-12-11' AS Date), NULL, NULL, N'intento 9', N'Realizada', 0, NULL)
INSERT [dbo].[INSPECCION] ([id_inspeccion], [Tipo_Inspeccion], [Area_Inspeccionada], [id_sede], [Fecha_Inspeccion], [Fecha_Programada], [id_empleado_inspector], [HallazgosEncontrados], [Estado], [RequiereAcciones], [RutaReporte]) VALUES (5013, N'Extintor', N'Calderos', NULL, CAST(N'2025-12-11' AS Date), NULL, NULL, N'intento 10', N'Realizada', 0, NULL)
SET IDENTITY_INSERT [dbo].[INSPECCION] OFF
GO
SET IDENTITY_INSERT [dbo].[OBJETIVO_SST] ON 

INSERT [dbo].[OBJETIVO_SST] ([id_objetivo], [id_plan], [Descripcion], [Indicador], [MetaEsperada], [ResponsableCumplimiento], [FechaLimite]) VALUES (1, 1, N'Reducir el índice de accidentalidad en un 20%', N'Índice de Frecuencia', N'< 5 accidentes por cada 100 trabajadores', 101, CAST(N'2024-12-31' AS Date))
INSERT [dbo].[OBJETIVO_SST] ([id_objetivo], [id_plan], [Descripcion], [Indicador], [MetaEsperada], [ResponsableCumplimiento], [FechaLimite]) VALUES (2, 1, N'Lograr el 100% de cumplimiento en exámenes médicos periódicos', N'Porcentaje de EMO vigentes', N'100%', 101, CAST(N'2024-12-31' AS Date))
INSERT [dbo].[OBJETIVO_SST] ([id_objetivo], [id_plan], [Descripcion], [Indicador], [MetaEsperada], [ResponsableCumplimiento], [FechaLimite]) VALUES (3, 1, N'Capacitar al 100% del personal en identificación de peligros', N'Porcentaje de personal capacitado', N'100%', 101, CAST(N'2024-12-31' AS Date))
SET IDENTITY_INSERT [dbo].[OBJETIVO_SST] OFF
GO
SET IDENTITY_INSERT [dbo].[PERMISO_TRABAJO] ON 

INSERT [dbo].[PERMISO_TRABAJO] ([id_permiso], [TipoPermiso], [NumeroPermiso], [DescripcionTrabajo], [Ubicacion], [id_sede], [Area], [FechaInicio], [FechaFin], [Vigencia], [id_solicitante], [id_ejecutor], [id_supervisor], [id_autorizador], [RiesgosIdentificados], [MedidasControl], [EPPRequerido], [RequiereAislamiento], [RequiereVentilacion], [RequiereMonitoreoGases], [RequiereVigia], [RequiereExtintor], [NivelOxigeno], [NivelLEL], [NivelH2S], [NivelCO], [TemperaturaAmbiente], [Estado], [FechaAutorizacion], [FechaCierre], [ObservacionesCierre], [RutaDocumento], [RutaART], [FechaCreacion], [CreadoPor], [FechaModificacion], [ModificadoPor]) VALUES (4, N'Trabajo en Caliente', N'TC-2024-001', N'Soldadura de tubería de proceso en área de almacenamiento de químicos', N'Planta Petroquímica - Área 3', NULL, N'Almacenamiento', CAST(N'2025-12-09T21:02:32.970' AS DateTime), CAST(N'2025-12-10T01:02:32.970' AS DateTime), 4, 100, 102, 101, 100, N'Riesgo de incendio/explosión por presencia de vapores inflamables. Riesgo de quemaduras.', N'Medición de gases antes de iniciar. Ventilación forzada. Extintor tipo ABC a menos de 10m. Vigía permanente.', N'Careta de soldar, guantes de carnaza, mandil de cuero, botas de seguridad, respirador con filtro', 1, 1, 1, NULL, 1, NULL, CAST(0.00 AS Decimal(5, 2)), NULL, NULL, NULL, N'Autorizado', NULL, NULL, NULL, NULL, NULL, CAST(N'2025-12-09T20:02:32.970' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[PERMISO_TRABAJO] ([id_permiso], [TipoPermiso], [NumeroPermiso], [DescripcionTrabajo], [Ubicacion], [id_sede], [Area], [FechaInicio], [FechaFin], [Vigencia], [id_solicitante], [id_ejecutor], [id_supervisor], [id_autorizador], [RiesgosIdentificados], [MedidasControl], [EPPRequerido], [RequiereAislamiento], [RequiereVentilacion], [RequiereMonitoreoGases], [RequiereVigia], [RequiereExtintor], [NivelOxigeno], [NivelLEL], [NivelH2S], [NivelCO], [TemperaturaAmbiente], [Estado], [FechaAutorizacion], [FechaCierre], [ObservacionesCierre], [RutaDocumento], [RutaART], [FechaCreacion], [CreadoPor], [FechaModificacion], [ModificadoPor]) VALUES (5, N'Espacios Confinados', N'EC-2024-002', N'Limpieza interna de tanque de almacenamiento de solventes', N'Planta Petroquímica - Tanque T-301', NULL, N'Almacenamiento', CAST(N'2025-12-10T20:02:32.970' AS DateTime), CAST(N'2025-12-11T02:02:32.970' AS DateTime), 6, 100, 102, 101, 100, N'Atmósfera deficiente en oxígeno. Presencia de vapores tóxicos (H2S). Riesgo de asfixia.', N'Ventilación forzada continua. Monitoreo de gases cada 30 min. Vigía externo permanente. Arnés con línea de vida.', N'Equipo de respiración autónomo (SCBA), arnés, detector multigases personal, botas antichispa', 1, 1, 1, 1, NULL, CAST(20.90 AS Decimal(5, 2)), CAST(0.00 AS Decimal(5, 2)), CAST(0.00 AS Decimal(5, 2)), CAST(0.00 AS Decimal(5, 2)), NULL, N'Autorizado', NULL, NULL, NULL, NULL, NULL, CAST(N'2025-12-09T20:02:32.970' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[PERMISO_TRABAJO] ([id_permiso], [TipoPermiso], [NumeroPermiso], [DescripcionTrabajo], [Ubicacion], [id_sede], [Area], [FechaInicio], [FechaFin], [Vigencia], [id_solicitante], [id_ejecutor], [id_supervisor], [id_autorizador], [RiesgosIdentificados], [MedidasControl], [EPPRequerido], [RequiereAislamiento], [RequiereVentilacion], [RequiereMonitoreoGases], [RequiereVigia], [RequiereExtintor], [NivelOxigeno], [NivelLEL], [NivelH2S], [NivelCO], [TemperaturaAmbiente], [Estado], [FechaAutorizacion], [FechaCierre], [ObservacionesCierre], [RutaDocumento], [RutaART], [FechaCreacion], [CreadoPor], [FechaModificacion], [ModificadoPor]) VALUES (6, N'Trabajo Eléctrico', N'TE-2024-003', N'Mantenimiento preventivo en tablero eléctrico principal 440V', N'Subestación Eléctrica', NULL, N'Energía', CAST(N'2025-12-11T20:02:32.973' AS DateTime), CAST(N'2025-12-11T23:02:32.973' AS DateTime), 3, 100, 102, 101, 100, N'Riesgo de electrocución. Arco eléctrico. Quemaduras.', N'Bloqueo y etiquetado (LOTO). Verificación de ausencia de tensión. Puesta a tierra temporal. Trabajo en parejas.', N'Guantes dieléctricos clase 2, casco con protección facial, traje antiarco, calzado dieléctrico, herramientas aisladas', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Autorizado', NULL, NULL, NULL, NULL, NULL, CAST(N'2025-12-09T20:02:32.973' AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[PERMISO_TRABAJO] OFF
GO
SET IDENTITY_INSERT [dbo].[PLAN_TRABAJO] ON 

INSERT [dbo].[PLAN_TRABAJO] ([id_plan], [Anio], [FechaElaboracion], [ElaboradoPor], [AprobadoPor], [FechaAprobacion], [PresupuestoAsignado], [Estado]) VALUES (1, 2024, CAST(N'2023-12-01' AS Date), 101, 100, CAST(N'2023-12-15' AS Date), CAST(50000000.00 AS Decimal(15, 2)), N'Vigente')
SET IDENTITY_INSERT [dbo].[PLAN_TRABAJO] OFF
GO
SET IDENTITY_INSERT [dbo].[PLANTILLA_DOCUMENTO] ON 

INSERT [dbo].[PLANTILLA_DOCUMENTO] ([id_plantilla], [NombrePlantilla], [TipoDocumento], [CategoriaSGSST], [RutaPlantilla], [Formato], [VariablesDisponibles], [Activa], [FechaCreacion]) VALUES (1, N'Acta de Reunión COPASST', N'Acta', N'COPASST', N'/plantillas/acta_copasst.docx', N'Word', NULL, 1, CAST(N'2025-11-14' AS Date))
INSERT [dbo].[PLANTILLA_DOCUMENTO] ([id_plantilla], [NombrePlantilla], [TipoDocumento], [CategoriaSGSST], [RutaPlantilla], [Formato], [VariablesDisponibles], [Activa], [FechaCreacion]) VALUES (2, N'Reporte de Accidente de Trabajo', N'Formato', N'Eventos', N'/plantillas/reporte_accidente.docx', N'Word', NULL, 1, CAST(N'2025-11-14' AS Date))
INSERT [dbo].[PLANTILLA_DOCUMENTO] ([id_plantilla], [NombrePlantilla], [TipoDocumento], [CategoriaSGSST], [RutaPlantilla], [Formato], [VariablesDisponibles], [Activa], [FechaCreacion]) VALUES (3, N'Informe de Auditoría Interna', N'Reporte', N'Auditorías', N'/plantillas/informe_auditoria.docx', N'Word', NULL, 1, CAST(N'2025-11-14' AS Date))
INSERT [dbo].[PLANTILLA_DOCUMENTO] ([id_plantilla], [NombrePlantilla], [TipoDocumento], [CategoriaSGSST], [RutaPlantilla], [Formato], [VariablesDisponibles], [Activa], [FechaCreacion]) VALUES (4, N'Matriz de Riesgos', N'Formato', N'Gestión de Riesgos', N'/plantillas/matriz_riesgos.xlsx', N'Excel', NULL, 1, CAST(N'2025-11-14' AS Date))
SET IDENTITY_INSERT [dbo].[PLANTILLA_DOCUMENTO] OFF
GO
SET IDENTITY_INSERT [dbo].[REQUISITO_LEGAL] ON 

INSERT [dbo].[REQUISITO_LEGAL] ([id_requisito], [Norma], [Articulo], [Descripcion_Requisito], [Fecha_Vigencia], [Area_Aplicacion], [TipoNorma], [Entidad_Emisora], [Vigente], [URL_Documento], [FechaRevision]) VALUES (500, N'Decreto 1072', N'2.2.4.6.8', N'Obligaciones de los empleadores - Implementación del SG-SST', CAST(N'2015-05-26' AS Date), N'General', N'Decreto', N'Ministerio del Trabajo', 1, NULL, CAST(N'2025-11-14' AS Date))
INSERT [dbo].[REQUISITO_LEGAL] ([id_requisito], [Norma], [Articulo], [Descripcion_Requisito], [Fecha_Vigencia], [Area_Aplicacion], [TipoNorma], [Entidad_Emisora], [Vigente], [URL_Documento], [FechaRevision]) VALUES (501, N'Resolución 0312', N'Art. 27-29', N'Estándares Mínimos del SG-SST para empresas', CAST(N'2019-02-13' AS Date), N'General', N'Resolución', N'Ministerio del Trabajo', 1, NULL, CAST(N'2025-11-14' AS Date))
INSERT [dbo].[REQUISITO_LEGAL] ([id_requisito], [Norma], [Articulo], [Descripcion_Requisito], [Fecha_Vigencia], [Area_Aplicacion], [TipoNorma], [Entidad_Emisora], [Vigente], [URL_Documento], [FechaRevision]) VALUES (502, N'Ley 1562', N'Art. 11', N'Servicios de Seguridad y Salud en el Trabajo', CAST(N'2012-07-11' AS Date), N'General', N'Ley', N'Congreso de la República', 1, NULL, CAST(N'2025-11-14' AS Date))
INSERT [dbo].[REQUISITO_LEGAL] ([id_requisito], [Norma], [Articulo], [Descripcion_Requisito], [Fecha_Vigencia], [Area_Aplicacion], [TipoNorma], [Entidad_Emisora], [Vigente], [URL_Documento], [FechaRevision]) VALUES (503, N'Resolución 2400', N'Disposiciones generales', N'Estatuto de Seguridad Industrial', CAST(N'1979-05-22' AS Date), N'Industria', N'Resolución', N'Ministerio del Trabajo', 1, NULL, CAST(N'2025-11-14' AS Date))
INSERT [dbo].[REQUISITO_LEGAL] ([id_requisito], [Norma], [Articulo], [Descripcion_Requisito], [Fecha_Vigencia], [Area_Aplicacion], [TipoNorma], [Entidad_Emisora], [Vigente], [URL_Documento], [FechaRevision]) VALUES (504, N'Resolución 1401', N'Art. 1-5', N'Investigación de accidentes e incidentes de trabajo', CAST(N'2007-05-14' AS Date), N'Eventos', N'Resolución', N'Ministerio de Protección Social', 1, NULL, CAST(N'2025-11-14' AS Date))
SET IDENTITY_INSERT [dbo].[REQUISITO_LEGAL] OFF
GO
SET IDENTITY_INSERT [dbo].[RIESGO] ON 

INSERT [dbo].[RIESGO] ([id_riesgo], [id_catalogo_peligro], [Peligro], [Proceso], [Actividad], [Zona_Area], [id_probabilidad], [id_consecuencia], [Nivel_Riesgo_Inicial], [Nivel_Riesgo_Residual], [Controles_Fuente], [Controles_Medio], [Controles_Individuo], [MedidasIntervencion], [FechaEvaluacion], [ProximaRevision], [Estado]) VALUES (1, 2, N'Posturas Prolongadas Sedentes', N'Desarrollo de Software', N'Programación en escritorio', N'Oficinas Administrativas', 3, 4, 120, NULL, NULL, NULL, N'Sillas ergonómicas, pausas activas', NULL, CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Vigente')
INSERT [dbo].[RIESGO] ([id_riesgo], [id_catalogo_peligro], [Peligro], [Proceso], [Actividad], [Zona_Area], [id_probabilidad], [id_consecuencia], [Nivel_Riesgo_Inicial], [Nivel_Riesgo_Residual], [Controles_Fuente], [Controles_Medio], [Controles_Individuo], [MedidasIntervencion], [FechaEvaluacion], [ProximaRevision], [Estado]) VALUES (2, 3, N'Carga Mental Alta', N'Gerencia y Administración', N'Toma de decisiones estratégicas', N'Gerencia', 3, 3, 300, NULL, NULL, NULL, N'Programas de bienestar, pausas programadas', NULL, CAST(N'2024-01-15' AS Date), CAST(N'2025-01-15' AS Date), N'Vigente')
SET IDENTITY_INSERT [dbo].[RIESGO] OFF
GO
SET IDENTITY_INSERT [dbo].[ROL] ON 

INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (1, N'CEO', N'Chief Executive Officer', 0)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (2, N'Coordinador SST', N'Responsable del Sistema de Gestión SST', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (3, N'Brigadista', N'Miembro de Brigada de Emergencias', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (4, N'Miembro COPASST', N'Miembro del Comité Paritario', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (5, N'Gerente General', N'Representante legal, máxima autoridad y responsable de recursos', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (6, N'Director SST', N'Líder estratégico del SG-SST (Licencia Profesional)', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (7, N'Presidente COPASST', N'Representante del empleador en el Comité Paritario', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (8, N'Secretario COPASST', N'Encargado de actas y gestión documental del COPASST', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (9, N'Vigía SST', N'Rol para empresas de menos de 10 trabajadores', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (10, N'Comité Convivencia', N'Miembro del Comité de Convivencia Laboral', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (11, N'Líder de Brigada', N'Jefe de la brigada de emergencias', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (12, N'Brigadista Primeros Auxilios', N'Atención inicial de heridos', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (13, N'Brigadista Evacuación', N'Guía durante evacuaciones', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (14, N'Brigadista Contra Incendios', N'Control de conatos de incendio', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (15, N'Auditor Interno', N'Encargado de auditorías internas del sistema', 1)
INSERT [dbo].[ROL] ([id_rol], [NombreRol], [Descripcion], [EsRolSST]) VALUES (16, N'Investigador de Accidentes', N'Miembro del equipo investigador (Res. 1401)', 1)
SET IDENTITY_INSERT [dbo].[ROL] OFF
GO
SET IDENTITY_INSERT [dbo].[SEDE] ON 

INSERT [dbo].[SEDE] ([id_sede], [id_empresa], [NombreSede], [Direccion], [Ciudad], [Departamento], [TelefonoContacto], [Estado]) VALUES (1, 1, N'Sede Principal', N'Calle 100 #10-50 Oficina 401', N'Medellín', N'Antioquia', N'+57 604 1234567', 1)
SET IDENTITY_INSERT [dbo].[SEDE] OFF
GO
SET IDENTITY_INSERT [dbo].[TAREA] ON 

INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2003, 1, N'Revisión y actualización de la Política SG-SST 2024', N'Documentación', CAST(N'2024-01-05' AS Date), CAST(N'2024-03-31' AS Date), N'Alta', N'Cerrada', 101, N'Plan Anual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-11-15T20:22:16.803' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2004, 1, N'Inspección de Extintores - Trimestre 1', N'Inspección', CAST(N'2024-01-10' AS Date), CAST(N'2024-03-31' AS Date), N'Alta', N'Cerrada', 101, N'Plan Anual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.007' AS DateTime), CAST(N'2025-12-10' AS Date), NULL, NULL, NULL, NULL, N'form_inspeccion_extintor', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2005, 1, N'Capacitación en Prevención de Riesgos Psicosociales', N'Capacitación', CAST(N'2024-02-01' AS Date), CAST(N'2025-11-05' AS Date), N'Media', N'Vencida', 101, N'Plan Anual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.017' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_registro_capacitacion', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2006, 1, N'Simulacro de Evacuación - Semestre 1', N'Emergencias', CAST(N'2024-03-01' AS Date), CAST(N'2025-11-30' AS Date), N'Alta', N'Vencida', 101, N'Plan Anual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-01T20:23:53.163' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2007, 1, N'Auditoría Interna SG-SST 2024', N'Auditoría', CAST(N'2024-01-15' AS Date), CAST(N'2024-11-30' AS Date), N'Crítica', N'Vencida', 101, N'Plan Anual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-11-16T13:41:03.783' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2011, NULL, N'Programar EMO Periódico para Ana Pérez Torres - Vence: 24/11/2025', N'Gestión Médica', CAST(N'2025-11-24' AS Date), CAST(N'2025-11-19' AS Date), N'Alta', N'Vencida', 101, N'Sistema - Vencimiento EMO', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.010' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_examen_medico', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2012, NULL, N'Iniciar proceso de elección y conformación de nuevo COCOLAB - Vence: 10/01/2026', N'Legal Obligatoria', CAST(N'2025-11-24' AS Date), CAST(N'2025-12-26' AS Date), N'Crítica', N'Pendiente', 101, N'Sistema - Vencimiento Comité', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-11-24T15:54:39.337' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2013, NULL, N'Programar y ejecutar Auditoría Interna Anual del SG-SST 2025', N'Legal Obligatoria', CAST(N'2025-11-24' AS Date), CAST(N'2025-12-15' AS Date), N'Crítica', N'Vencida', 101, N'Sistema - Auditoría Anual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2014, 1, N'Auditoría Interna SG-SST 2024 - Fase Final', N'Auditoría', CAST(N'2024-01-15' AS Date), CAST(N'2025-11-26' AS Date), N'Crítica', N'Vencida', 101, N'Plan Anual', CAST(80.00 AS Decimal(5, 2)), CAST(N'2025-12-01T20:51:44.377' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2015, 1, N'Capacitación en Manejo de Sustancias Químicas', N'Capacitación', CAST(N'2024-02-01' AS Date), CAST(N'2025-11-29' AS Date), N'Alta', N'Vencida', 101, N'Plan Anual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.017' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_registro_capacitacion', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2016, 1, N'Renovación de Licencia de Software SST', N'Gestión Administrativa', CAST(N'2024-03-01' AS Date), CAST(N'2025-12-03' AS Date), N'Alta', N'Vencida', 101, N'Sistema - Alerta', CAST(10.00 AS Decimal(5, 2)), CAST(N'2025-12-04T09:04:37.660' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2017, 1, N'Inspección de Botiquines - Sede Principal', N'Inspección', CAST(N'2024-03-10' AS Date), CAST(N'2025-12-16' AS Date), N'Media', N'Cerrada', 101, N'Cronograma Inspecciones', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T16:57:05.927' AS DateTime), CAST(N'2025-12-10' AS Date), 101, NULL, NULL, NULL, N'form_inspeccion_botiquin', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2018, 1, N'Actualización Matriz de Riesgos - Área Producción', N'Gestión de Riesgos', CAST(N'2024-04-01' AS Date), CAST(N'2025-12-21' AS Date), N'Media', N'En Curso', 101, N'Solicitud ARL', CAST(45.00 AS Decimal(5, 2)), CAST(N'2025-12-01T20:51:44.380' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2019, 1, N'Entrega de EPP a nuevos ingresos', N'Gestión EPP', CAST(N'2024-01-10' AS Date), CAST(N'2024-01-20' AS Date), N'Baja', N'Cerrada', 101, N'Solicitud RRHH', CAST(100.00 AS Decimal(5, 2)), CAST(N'2025-12-01T20:51:44.383' AS DateTime), CAST(N'2024-01-18' AS Date), 101, N'Entregado conforme a matriz de EPP', NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2020, 1, N'Investigación Incidente 004-2024', N'Investigación', CAST(N'2024-02-15' AS Date), CAST(N'2024-02-28' AS Date), N'Alta', N'Cerrada', 101, N'Reporte Incidente', CAST(100.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.020' AS DateTime), CAST(N'2024-02-25' AS Date), 101, N'Causas básicas identificadas y plan de acción creado', NULL, NULL, N'form_incidente', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2021, 1, N'Simulacro Nacional de Evacuación', N'Emergencias', CAST(N'2024-05-01' AS Date), CAST(N'2026-01-15' AS Date), N'Crítica', N'Pendiente', 101, N'Requisito Legal', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-01T20:51:44.383' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2022, 1, N'Preparación Reunión Mensual COPASST', N'Comité', CAST(N'2024-05-10' AS Date), CAST(N'2025-12-06' AS Date), N'Alta', N'Vencida', 101, N'Cronograma Comités', CAST(30.00 AS Decimal(5, 2)), CAST(N'2025-12-09T20:16:26.237' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2023, 1, N'Programación EMO Periódicos - Grupo 2', N'Medicina Preventiva', CAST(N'2024-06-01' AS Date), CAST(N'2026-01-30' AS Date), N'Media', N'Pendiente', 101, N'Programa Vigilancia', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.010' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_examen_medico', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2024, NULL, N'CAPACITACION CHATGPT', N'Capacitación', CAST(N'2025-12-01' AS Date), CAST(N'2025-12-02' AS Date), N'Media', N'Vencida', 101, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.017' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_registro_capacitacion', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2025, NULL, N'[TEST] Tarea CrÃ­tica Vencida', N'InspecciÃ³n', CAST(N'2025-11-12' AS Date), CAST(N'2025-11-24' AS Date), N'Alta', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.007' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_inspeccion_locativa', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2026, NULL, N'[TEST] Tarea Alerta Vencida', N'CapacitaciÃ³n', CAST(N'2025-11-22' AS Date), CAST(N'2025-11-28' AS Date), N'Media', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.017' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_registro_capacitacion', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2027, NULL, N'[TEST] Carga Trabajo 1', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2028, NULL, N'[TEST] Carga Trabajo 2', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2029, NULL, N'[TEST] Carga Trabajo 3', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2030, NULL, N'[TEST] Carga Trabajo 4', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2031, NULL, N'[TEST] Carga Trabajo 5', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2032, NULL, N'[TEST] Carga Trabajo 6', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2033, NULL, N'[TEST] Carga Trabajo 7', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2034, NULL, N'[TEST] Carga Trabajo 8', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2035, NULL, N'[TEST] Carga Trabajo 9', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2036, NULL, N'[TEST] Carga Trabajo 10', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2037, NULL, N'[TEST] Carga Trabajo 11', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2038, NULL, N'[TEST] Carga Trabajo 12', N'Administrativa', CAST(N'2025-12-02' AS Date), CAST(N'2025-12-12' AS Date), N'Baja', N'Vencida', 102, N'Manual', CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2065, NULL, N'Realizar Examen Médico Ocupacional (Sin EMO Registrado)', N'Salud', CAST(N'2025-12-05' AS Date), CAST(N'2025-12-20' AS Date), N'Alta', N'Pendiente', 101, NULL, CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.010' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_examen_medico', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2066, NULL, N'Realizar Examen Médico Ocupacional (EMO Vencido)', N'Salud', CAST(N'2025-12-05' AS Date), CAST(N'2025-12-20' AS Date), N'Alta', N'Pendiente', 102, NULL, CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.010' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_examen_medico', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2067, NULL, N'Realizar Examen Médico Ocupacional (EMO Vencido)', N'Salud', CAST(N'2025-12-05' AS Date), CAST(N'2025-12-20' AS Date), N'Alta', N'Pendiente', 103, NULL, CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.010' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_examen_medico', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2068, NULL, N'Realizar Examen Médico Ocupacional (Sin EMO Registrado)', N'Salud', CAST(N'2025-12-05' AS Date), CAST(N'2025-12-20' AS Date), N'Alta', N'Pendiente', 104, NULL, CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.010' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_examen_medico', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2069, NULL, N'Realizar Examen Médico Ocupacional (Sin EMO Registrado)', N'Salud', CAST(N'2025-12-05' AS Date), CAST(N'2025-12-20' AS Date), N'Alta', N'Pendiente', 105, NULL, CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.010' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_examen_medico', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2070, NULL, N'Realizar Examen Médico Ocupacional (Sin EMO Registrado)', N'Salud', CAST(N'2025-12-05' AS Date), CAST(N'2025-12-20' AS Date), N'Alta', N'Pendiente', 106, NULL, CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-10T12:11:32.010' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_examen_medico', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2071, NULL, N'Ejecutar capacitación pendiente: Prevención de Riesgos Psicosociales (vencida hace 630 días)', N'Capacitación', CAST(N'2025-12-05' AS Date), CAST(N'2025-12-12' AS Date), N'Alta', N'Vencida', 101, NULL, CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_registro_capacitacion', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2072, NULL, N'Ejecutar capacitación pendiente: Primeros Auxilios Básicos (vencida hace 604 días)', N'Capacitación', CAST(N'2025-12-05' AS Date), CAST(N'2025-12-12' AS Date), N'Alta', N'Vencida', 101, NULL, CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-18T20:40:50.277' AS DateTime), NULL, NULL, NULL, NULL, NULL, N'form_registro_capacitacion', 1)
INSERT [dbo].[TAREA] ([id_tarea], [id_plan], [Descripcion], [Tipo_Tarea], [Fecha_Creacion], [Fecha_Vencimiento], [Prioridad], [Estado], [id_empleado_responsable], [Origen_Tarea], [AvancePorc], [Fecha_Actualizacion], [Fecha_Cierre], [id_empleado_cierre], [Observaciones_Cierre], [CostoEstimado], [RutaEvidencia], [id_formulario], [requiere_formulario]) VALUES (2123, NULL, N'Realizar Examen Médico Ocupacional (Sin EMO Registrado)', N'Salud', CAST(N'2025-12-05' AS Date), CAST(N'2025-12-20' AS Date), N'Alta', N'Cerrada', 100, NULL, CAST(0.00 AS Decimal(5, 2)), CAST(N'2025-12-09T20:17:41.427' AS DateTime), CAST(N'2025-12-09' AS Date), 100, NULL, NULL, NULL, N'form_examen_medico', 0)
SET IDENTITY_INSERT [dbo].[TAREA] OFF
GO
SET IDENTITY_INSERT [dbo].[USUARIOS_AUTORIZADOS] ON 

INSERT [dbo].[USUARIOS_AUTORIZADOS] ([id_autorizado], [Correo_Electronico], [Nombre_Persona], [Nivel_Acceso], [PuedeAprobar], [PuedeEditar], [FechaRegistro], [Estado], [Password_Hash]) VALUES (1, N'ceo@digitalbulks.com', N'Admin CEO', N'CEO', 1, 1, CAST(N'2025-11-14T10:15:22.750' AS DateTime), 1, N'$2b$12$wxev530xPGoJLoWxEZjGMeM3lc5YZVpvwI7fucoa00GpelCkjOLEW')
INSERT [dbo].[USUARIOS_AUTORIZADOS] ([id_autorizado], [Correo_Electronico], [Nombre_Persona], [Nivel_Acceso], [PuedeAprobar], [PuedeEditar], [FechaRegistro], [Estado], [Password_Hash]) VALUES (2, N'maria.gomez@digitalbulks.com', N'María Gómez Ruiz', N'Coordinador SST', 1, 1, CAST(N'2025-11-14T10:15:22.750' AS DateTime), 1, N'$2b$12$c0AYT16KuxvwgrmsIwFEDunId9Y4wCNSx2bSJlkwLV.m/Wz2naksK')
SET IDENTITY_INSERT [dbo].[USUARIOS_AUTORIZADOS] OFF
GO
INSERT [dbo].[VALORACION_CONSEC] ([id_consecuencia], [Nivel_Dano], [Valor_NC]) VALUES (1, N'Mortal o Catastrófico', 100)
INSERT [dbo].[VALORACION_CONSEC] ([id_consecuencia], [Nivel_Dano], [Valor_NC]) VALUES (2, N'Muy Grave', 60)
INSERT [dbo].[VALORACION_CONSEC] ([id_consecuencia], [Nivel_Dano], [Valor_NC]) VALUES (3, N'Grave', 25)
INSERT [dbo].[VALORACION_CONSEC] ([id_consecuencia], [Nivel_Dano], [Valor_NC]) VALUES (4, N'Leve', 10)
GO
INSERT [dbo].[VALORACION_PROB] ([id_probabilidad], [Nivel_Deficiencia], [Nivel_Exposicion], [Nivel_Probabilidad], [Interpretacion]) VALUES (1, 10, 4, 40, N'Muy Alto')
INSERT [dbo].[VALORACION_PROB] ([id_probabilidad], [Nivel_Deficiencia], [Nivel_Exposicion], [Nivel_Probabilidad], [Interpretacion]) VALUES (2, 10, 3, 30, N'Alto')
INSERT [dbo].[VALORACION_PROB] ([id_probabilidad], [Nivel_Deficiencia], [Nivel_Exposicion], [Nivel_Probabilidad], [Interpretacion]) VALUES (3, 6, 2, 12, N'Medio')
INSERT [dbo].[VALORACION_PROB] ([id_probabilidad], [Nivel_Deficiencia], [Nivel_Exposicion], [Nivel_Probabilidad], [Interpretacion]) VALUES (4, 2, 1, 2, N'Bajo')
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__AGENTE_R__673CB435D0C3CF25]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[AGENTE_ROL] ADD UNIQUE NONCLUSTERED 
(
	[nombre_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_Alerta_Estado]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Alerta_Estado] ON [dbo].[ALERTA]
(
	[Estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_Alerta_Tipo]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Alerta_Tipo] ON [dbo].[ALERTA]
(
	[Tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__ASISTENC__2711624CD2B2D2B5]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[ASISTENCIA] ADD UNIQUE NONCLUSTERED 
(
	[id_empleado] ASC,
	[id_capacitacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__CAPACITA__098E379DFF770FE9]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[CAPACITACION] ADD UNIQUE NONCLUSTERED 
(
	[Codigo_Capacitacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__CONFIG_A__E8181E119F03AC68]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[CONFIG_AGENTE] ADD UNIQUE NONCLUSTERED 
(
	[Clave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__CONTRATI__C7DEC3C24FAFBD77]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[CONTRATISTA] ADD UNIQUE NONCLUSTERED 
(
	[NIT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Conversacion_Fecha]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Conversacion_Fecha] ON [dbo].[CONVERSACION_AGENTE]
(
	[FechaHoraRecepcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Conversacion_Usuario]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Conversacion_Usuario] ON [dbo].[CONVERSACION_AGENTE]
(
	[id_usuario_autorizado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__DOCUMENT__06370DAC160138E6]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[DOCUMENTO] ADD UNIQUE NONCLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_Documento_Codigo]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Documento_Codigo] ON [dbo].[DOCUMENTO]
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__EMPLEADO__60695A192F066F64]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[EMPLEADO] ADD UNIQUE NONCLUSTERED 
(
	[Correo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__EMPLEADO__A42025880949DBDF]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[EMPLEADO] ADD UNIQUE NONCLUSTERED 
(
	[NumeroDocumento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_Empleado_ARL]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Empleado_ARL] ON [dbo].[EMPLEADO]
(
	[ARL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_Empleado_Correo]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Empleado_Correo] ON [dbo].[EMPLEADO]
(
	[Correo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Empleado_Estado]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Empleado_Estado] ON [dbo].[EMPLEADO]
(
	[Estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Empleado_Sede]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Empleado_Sede] ON [dbo].[EMPLEADO]
(
	[id_sede] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_EmpleadoAgenteRol_Activo]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[EMPLEADO_AGENTE_ROL] ADD  CONSTRAINT [UQ_EmpleadoAgenteRol_Activo] UNIQUE NONCLUSTERED 
(
	[id_empleado] ASC,
	[id_agente_rol] ASC,
	[FechaFinalizacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__EMPRESA__C7DEC3C297ECEBD9]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[EMPRESA] ADD UNIQUE NONCLUSTERED 
(
	[NIT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Entrega_Empleado]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Entrega_Empleado] ON [dbo].[ENTREGA_EPP]
(
	[id_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__EPP__DC727DD9F341686F]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[EPP] ADD UNIQUE NONCLUSTERED 
(
	[Codigo_EPP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__EQUIPO__28C92875828CC90D]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[EQUIPO] ADD UNIQUE NONCLUSTERED 
(
	[CodigoInterno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_Equipo_Tipo]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Equipo_Tipo] ON [dbo].[EQUIPO]
(
	[Tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Evento_Fecha]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Evento_Fecha] ON [dbo].[EVENTO]
(
	[Fecha_Evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Evento_FechaReporte]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Evento_FechaReporte] ON [dbo].[EVENTO]
(
	[Fecha_Reporte_ARL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_Evento_Tipo]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Evento_Tipo] ON [dbo].[EVENTO]
(
	[Tipo_Evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Examen_Empleado]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Examen_Empleado] ON [dbo].[EXAMEN_MEDICO]
(
	[id_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_Examen_Tipo]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Examen_Tipo] ON [dbo].[EXAMEN_MEDICO]
(
	[Tipo_Examen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_FORM_DRAFTS_UserForm]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_FORM_DRAFTS_UserForm] ON [dbo].[FORM_DRAFTS]
(
	[user_id] ASC,
	[form_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_FORM_SUBMISSION_AUDIT_Submission]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_FORM_SUBMISSION_AUDIT_Submission] ON [dbo].[FORM_SUBMISSION_AUDIT]
(
	[id_submission] ASC
)
INCLUDE([changed_at],[action]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_FORM_SUBMISSIONS_FormId]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_FORM_SUBMISSIONS_FormId] ON [dbo].[FORM_SUBMISSIONS]
(
	[form_id] ASC
)
INCLUDE([submitted_at],[status]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_FORM_SUBMISSIONS_Status]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_FORM_SUBMISSIONS_Status] ON [dbo].[FORM_SUBMISSIONS]
(
	[status] ASC,
	[deleted] ASC
)
INCLUDE([submitted_at]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_FORM_SUBMISSIONS_SubmittedBy]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_FORM_SUBMISSIONS_SubmittedBy] ON [dbo].[FORM_SUBMISSIONS]
(
	[submitted_by] ASC
)
INCLUDE([submitted_at],[form_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_PermisoTrabajo_Estado]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_PermisoTrabajo_Estado] ON [dbo].[PERMISO_TRABAJO]
(
	[Estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_PermisoTrabajo_Fechas]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_PermisoTrabajo_Fechas] ON [dbo].[PERMISO_TRABAJO]
(
	[FechaInicio] ASC,
	[FechaFin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_PermisoTrabajo_Tipo]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_PermisoTrabajo_Tipo] ON [dbo].[PERMISO_TRABAJO]
(
	[TipoPermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_PermisoTrabajo_NumeroPermiso]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_PermisoTrabajo_NumeroPermiso] ON [dbo].[PERMISO_TRABAJO]
(
	[NumeroPermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_Tarea_Estado]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Tarea_Estado] ON [dbo].[TAREA]
(
	[Estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Tarea_Responsable]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Tarea_Responsable] ON [dbo].[TAREA]
(
	[id_empleado_responsable] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IDX_Tarea_Vencimiento]    Script Date: 18/12/2025 9:50:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_Tarea_Vencimiento] ON [dbo].[TAREA]
(
	[Fecha_Vencimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__USUARIOS__85947816FDCA1443]    Script Date: 18/12/2025 9:50:02 p. m. ******/
ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS] ADD UNIQUE NONCLUSTERED 
(
	[Correo_Electronico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ACCION_CORRECTIVA] ADD  DEFAULT ('Abierta') FOR [Estado]
GO
ALTER TABLE [dbo].[ACCION_CORRECTIVA] ADD  DEFAULT ((0)) FOR [EficaciaVerificada]
GO
ALTER TABLE [dbo].[ACCION_MEJORA] ADD  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[ACCION_MEJORA] ADD  DEFAULT ('Abierta') FOR [Estado]
GO
ALTER TABLE [dbo].[ACCION_MEJORA] ADD  DEFAULT ((0)) FOR [EficaciaVerificada]
GO
ALTER TABLE [dbo].[AGENTE_ROL] ADD  DEFAULT ((1)) FOR [nivel_acceso]
GO
ALTER TABLE [dbo].[AGENTE_ROL] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[AGENTE_ROL] ADD  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[AGENTE_ROL] ADD  DEFAULT (getdate()) FOR [FechaActualizacion]
GO
ALTER TABLE [dbo].[ALERTA] ADD  DEFAULT ('Media') FOR [Prioridad]
GO
ALTER TABLE [dbo].[ALERTA] ADD  DEFAULT (getdate()) FOR [FechaGeneracion]
GO
ALTER TABLE [dbo].[ALERTA] ADD  DEFAULT ('Pendiente') FOR [Estado]
GO
ALTER TABLE [dbo].[ALERTA] ADD  DEFAULT ((0)) FOR [Enviada]
GO
ALTER TABLE [dbo].[ALERTA] ADD  DEFAULT ((0)) FOR [IntentosEnvio]
GO
ALTER TABLE [dbo].[ASISTENCIA] ADD  DEFAULT ((1)) FOR [Asistio]
GO
ALTER TABLE [dbo].[ASISTENCIA] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[AUDITORIA] ADD  DEFAULT ('Programada') FOR [Estado]
GO
ALTER TABLE [dbo].[BRIGADA] ADD  DEFAULT ('Activa') FOR [Estado]
GO
ALTER TABLE [dbo].[CAPACITACION] ADD  DEFAULT ('Programada') FOR [Estado]
GO
ALTER TABLE [dbo].[COMITE] ADD  DEFAULT ('Vigente') FOR [Estado]
GO
ALTER TABLE [dbo].[CONFIG_AGENTE] ADD  DEFAULT (getdate()) FOR [FechaActualizacion]
GO
ALTER TABLE [dbo].[CONTRATISTA] ADD  DEFAULT ('Activo') FOR [Estado]
GO
ALTER TABLE [dbo].[CONVERSACION_AGENTE] ADD  DEFAULT ('Procesada') FOR [Estado]
GO
ALTER TABLE [dbo].[DOCUMENTO] ADD  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[DOCUMENTO] ADD  DEFAULT ('Vigente') FOR [Estado]
GO
ALTER TABLE [dbo].[DOCUMENTO] ADD  DEFAULT ((0)) FOR [RequiereAprobacion]
GO
ALTER TABLE [dbo].[DOCUMENTO] ADD  DEFAULT ((1)) FOR [version]
GO
ALTER TABLE [dbo].[EMPLEADO] ADD  DEFAULT ((1)) FOR [Estado]
GO
ALTER TABLE [dbo].[EMPLEADO] ADD  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[EMPLEADO] ADD  DEFAULT (getdate()) FOR [FechaActualizacion]
GO
ALTER TABLE [dbo].[EMPLEADO_AGENTE_ROL] ADD  DEFAULT (getdate()) FOR [FechaAsignacion]
GO
ALTER TABLE [dbo].[EMPLEADO_ROL] ADD  DEFAULT (getdate()) FOR [FechaAsignacion]
GO
ALTER TABLE [dbo].[EMPRESA] ADD  DEFAULT ((0)) FOR [NumeroTrabajadores]
GO
ALTER TABLE [dbo].[ENTREGA_EPP] ADD  DEFAULT ((1)) FOR [Cantidad]
GO
ALTER TABLE [dbo].[ENTREGA_EPP] ADD  DEFAULT ((0)) FOR [Firma_Recibido]
GO
ALTER TABLE [dbo].[EPP] ADD  DEFAULT ((0)) FOR [Stock_Disponible]
GO
ALTER TABLE [dbo].[EQUIPO] ADD  DEFAULT ((0)) FOR [RequiereCalibacion]
GO
ALTER TABLE [dbo].[EQUIPO] ADD  DEFAULT ('Operativo') FOR [Estado]
GO
ALTER TABLE [dbo].[EVALUACION_CONTRATISTA] ADD  DEFAULT ((0)) FOR [Aprobado]
GO
ALTER TABLE [dbo].[EVALUACION_RIESGO] ADD  DEFAULT ('Programada') FOR [Estado]
GO
ALTER TABLE [dbo].[EVENTO] ADD  DEFAULT ((0)) FOR [Dias_Incapacidad]
GO
ALTER TABLE [dbo].[EVENTO] ADD  DEFAULT ((0)) FOR [Reportado_ARL]
GO
ALTER TABLE [dbo].[EVENTO] ADD  DEFAULT ((1)) FOR [Requiere_Investigacion]
GO
ALTER TABLE [dbo].[EVENTO] ADD  DEFAULT ('Pendiente') FOR [Estado_Investigacion]
GO
ALTER TABLE [dbo].[EVENTO] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[EXAMEN_MEDICO] ADD  DEFAULT ((0)) FOR [RequiereSeguimiento]
GO
ALTER TABLE [dbo].[EXAMEN_MEDICO] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[EXPOSICION] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[FORM_DRAFTS] ADD  DEFAULT (getdate()) FOR [saved_at]
GO
ALTER TABLE [dbo].[FORM_SUBMISSION_AUDIT] ADD  DEFAULT (getdate()) FOR [changed_at]
GO
ALTER TABLE [dbo].[FORM_SUBMISSIONS] ADD  DEFAULT (getdate()) FOR [submitted_at]
GO
ALTER TABLE [dbo].[FORM_SUBMISSIONS] ADD  DEFAULT ('completed') FOR [status]
GO
ALTER TABLE [dbo].[FORM_SUBMISSIONS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[FORM_SUBMISSIONS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[FORM_SUBMISSIONS] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[HALLAZGO_AUDITORIA] ADD  DEFAULT ('Abierto') FOR [EstadoHallazgo]
GO
ALTER TABLE [dbo].[HALLAZGO_INSPECCION] ADD  DEFAULT ('Pendiente') FOR [EstadoAccion]
GO
ALTER TABLE [dbo].[INSPECCION] ADD  DEFAULT ('Realizada') FOR [Estado]
GO
ALTER TABLE [dbo].[INSPECCION] ADD  DEFAULT ((0)) FOR [RequiereAcciones]
GO
ALTER TABLE [dbo].[LOG_AGENTE] ADD  DEFAULT (getdate()) FOR [FechaHora]
GO
ALTER TABLE [dbo].[MIEMBRO_BRIGADA] ADD  DEFAULT ((0)) FOR [CertificacionVigente]
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO] ADD  DEFAULT ('Solicitado') FOR [Estado]
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO] ADD  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[PLAN_ACCION_AUDITORIA] ADD  DEFAULT ('Abierta') FOR [Estado]
GO
ALTER TABLE [dbo].[PLAN_ACCION_AUDITORIA] ADD  DEFAULT ((0)) FOR [VerificacionEficacia]
GO
ALTER TABLE [dbo].[PLAN_TRABAJO] ADD  DEFAULT ('Vigente') FOR [Estado]
GO
ALTER TABLE [dbo].[PLANTILLA_DOCUMENTO] ADD  DEFAULT ((1)) FOR [Activa]
GO
ALTER TABLE [dbo].[PLANTILLA_DOCUMENTO] ADD  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[PROGRAMA_VIGILANCIA] ADD  DEFAULT ('Activo') FOR [Estado]
GO
ALTER TABLE [dbo].[REPORTE_GENERADO] ADD  DEFAULT (getdate()) FOR [FechaGeneracion]
GO
ALTER TABLE [dbo].[REPORTE_GENERADO] ADD  DEFAULT ('Completado') FOR [EstadoGeneracion]
GO
ALTER TABLE [dbo].[REQUISITO_LEGAL] ADD  DEFAULT ((1)) FOR [Vigente]
GO
ALTER TABLE [dbo].[REQUISITO_LEGAL] ADD  DEFAULT (getdate()) FOR [FechaRevision]
GO
ALTER TABLE [dbo].[RESULTADO_INDICADOR] ADD  DEFAULT (getdate()) FOR [FechaCalculo]
GO
ALTER TABLE [dbo].[RIESGO] ADD  DEFAULT ('Vigente') FOR [Estado]
GO
ALTER TABLE [dbo].[ROL] ADD  DEFAULT ((0)) FOR [EsRolSST]
GO
ALTER TABLE [dbo].[SEDE] ADD  DEFAULT ((1)) FOR [Estado]
GO
ALTER TABLE [dbo].[TAREA] ADD  DEFAULT (getdate()) FOR [Fecha_Creacion]
GO
ALTER TABLE [dbo].[TAREA] ADD  DEFAULT ('Media') FOR [Prioridad]
GO
ALTER TABLE [dbo].[TAREA] ADD  DEFAULT ('Pendiente') FOR [Estado]
GO
ALTER TABLE [dbo].[TAREA] ADD  DEFAULT ((0)) FOR [AvancePorc]
GO
ALTER TABLE [dbo].[TAREA] ADD  DEFAULT (getdate()) FOR [Fecha_Actualizacion]
GO
ALTER TABLE [dbo].[TAREA] ADD  DEFAULT ((0)) FOR [requiere_formulario]
GO
ALTER TABLE [dbo].[TRABAJADOR_CONTRATISTA] ADD  DEFAULT ((0)) FOR [InduccionSST_Realizada]
GO
ALTER TABLE [dbo].[TRABAJADOR_CONTRATISTA] ADD  DEFAULT ((1)) FOR [Estado]
GO
ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS] ADD  DEFAULT ((0)) FOR [PuedeAprobar]
GO
ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS] ADD  DEFAULT ((0)) FOR [PuedeEditar]
GO
ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS] ADD  DEFAULT ((1)) FOR [Estado]
GO
ALTER TABLE [dbo].[VERSION_DOCUMENTO] ADD  DEFAULT (getdate()) FOR [FechaVersion]
GO
ALTER TABLE [dbo].[ACCION_CORRECTIVA]  WITH CHECK ADD FOREIGN KEY([id_evento])
REFERENCES [dbo].[EVENTO] ([id_evento])
GO
ALTER TABLE [dbo].[ACCION_CORRECTIVA]  WITH CHECK ADD FOREIGN KEY([ResponsableEjecucion])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[ACCION_MEJORA]  WITH CHECK ADD FOREIGN KEY([ResponsableEjecucion])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[AMENAZA]  WITH CHECK ADD FOREIGN KEY([id_sede])
REFERENCES [dbo].[SEDE] ([id_sede])
GO
ALTER TABLE [dbo].[ASISTENCIA]  WITH CHECK ADD FOREIGN KEY([id_capacitacion])
REFERENCES [dbo].[CAPACITACION] ([id_capacitacion])
GO
ALTER TABLE [dbo].[ASISTENCIA]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[AUDITORIA]  WITH CHECK ADD FOREIGN KEY([Auditor_Lider])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[AUSENTISMO]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[BRIGADA]  WITH CHECK ADD FOREIGN KEY([Coordinador])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[BRIGADA]  WITH CHECK ADD FOREIGN KEY([id_sede])
REFERENCES [dbo].[SEDE] ([id_sede])
GO
ALTER TABLE [dbo].[CAPACITACION]  WITH CHECK ADD FOREIGN KEY([Responsable])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[COMPETENCIA_SST]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[CONVERSACION_AGENTE]  WITH CHECK ADD FOREIGN KEY([id_usuario_autorizado])
REFERENCES [dbo].[USUARIOS_AUTORIZADOS] ([id_autorizado])
GO
ALTER TABLE [dbo].[DOCUMENTO]  WITH CHECK ADD FOREIGN KEY([AprobadoPor])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[DOCUMENTO]  WITH CHECK ADD FOREIGN KEY([Responsable])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EMPLEADO]  WITH CHECK ADD FOREIGN KEY([id_sede])
REFERENCES [dbo].[SEDE] ([id_sede])
GO
ALTER TABLE [dbo].[EMPLEADO]  WITH CHECK ADD FOREIGN KEY([id_supervisor])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EMPLEADO_AGENTE_ROL]  WITH CHECK ADD  CONSTRAINT [FK_EmpleadoAgenteRol_AgenteRol] FOREIGN KEY([id_agente_rol])
REFERENCES [dbo].[AGENTE_ROL] ([id_agente_rol])
GO
ALTER TABLE [dbo].[EMPLEADO_AGENTE_ROL] CHECK CONSTRAINT [FK_EmpleadoAgenteRol_AgenteRol]
GO
ALTER TABLE [dbo].[EMPLEADO_AGENTE_ROL]  WITH CHECK ADD  CONSTRAINT [FK_EmpleadoAgenteRol_Empleado] FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EMPLEADO_AGENTE_ROL] CHECK CONSTRAINT [FK_EmpleadoAgenteRol_Empleado]
GO
ALTER TABLE [dbo].[EMPLEADO_ROL]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EMPLEADO_ROL]  WITH CHECK ADD FOREIGN KEY([id_rol])
REFERENCES [dbo].[ROL] ([id_rol])
GO
ALTER TABLE [dbo].[ENTREGA_EPP]  WITH CHECK ADD FOREIGN KEY([Entregado_Por])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[ENTREGA_EPP]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[ENTREGA_EPP]  WITH CHECK ADD FOREIGN KEY([id_epp])
REFERENCES [dbo].[EPP] ([id_epp])
GO
ALTER TABLE [dbo].[EQUIPO]  WITH CHECK ADD FOREIGN KEY([id_sede])
REFERENCES [dbo].[SEDE] ([id_sede])
GO
ALTER TABLE [dbo].[EQUIPO]  WITH CHECK ADD FOREIGN KEY([Responsable])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EVALUACION_CONTRATISTA]  WITH CHECK ADD FOREIGN KEY([id_contratista])
REFERENCES [dbo].[CONTRATISTA] ([id_contratista])
GO
ALTER TABLE [dbo].[EVALUACION_CONTRATISTA]  WITH CHECK ADD FOREIGN KEY([ResponsableEvaluacion])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EVALUACION_LEGAL]  WITH CHECK ADD FOREIGN KEY([id_requisito])
REFERENCES [dbo].[REQUISITO_LEGAL] ([id_requisito])
GO
ALTER TABLE [dbo].[EVALUACION_LEGAL]  WITH CHECK ADD FOREIGN KEY([ResponsableEvaluacion])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EVENTO]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EVENTO]  WITH CHECK ADD FOREIGN KEY([id_responsable_investigacion])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EXAMEN_MEDICO]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EXPOSICION]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[EXPOSICION]  WITH CHECK ADD FOREIGN KEY([id_riesgo])
REFERENCES [dbo].[RIESGO] ([id_riesgo])
GO
ALTER TABLE [dbo].[HALLAZGO_AUDITORIA]  WITH CHECK ADD FOREIGN KEY([id_auditoria])
REFERENCES [dbo].[AUDITORIA] ([id_auditoria])
GO
ALTER TABLE [dbo].[HALLAZGO_AUDITORIA]  WITH CHECK ADD FOREIGN KEY([ResponsableArea])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[HALLAZGO_INSPECCION]  WITH CHECK ADD FOREIGN KEY([id_inspeccion])
REFERENCES [dbo].[INSPECCION] ([id_inspeccion])
GO
ALTER TABLE [dbo].[HALLAZGO_INSPECCION]  WITH CHECK ADD FOREIGN KEY([ResponsableAccion])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[HISTORIAL_NOTIFICACION]  WITH CHECK ADD FOREIGN KEY([id_alerta])
REFERENCES [dbo].[ALERTA] ([id_alerta])
GO
ALTER TABLE [dbo].[INDICADOR]  WITH CHECK ADD FOREIGN KEY([ResponsableReporte])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[INSPECCION]  WITH CHECK ADD FOREIGN KEY([id_empleado_inspector])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[INSPECCION]  WITH CHECK ADD FOREIGN KEY([id_sede])
REFERENCES [dbo].[SEDE] ([id_sede])
GO
ALTER TABLE [dbo].[LOG_AGENTE]  WITH CHECK ADD FOREIGN KEY([id_conversacion])
REFERENCES [dbo].[CONVERSACION_AGENTE] ([id_conversacion])
GO
ALTER TABLE [dbo].[MANTENIMIENTO_EQUIPO]  WITH CHECK ADD FOREIGN KEY([id_equipo])
REFERENCES [dbo].[EQUIPO] ([id_equipo])
GO
ALTER TABLE [dbo].[MIEMBRO_BRIGADA]  WITH CHECK ADD FOREIGN KEY([id_brigada])
REFERENCES [dbo].[BRIGADA] ([id_brigada])
GO
ALTER TABLE [dbo].[MIEMBRO_BRIGADA]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[MIEMBRO_COMITE]  WITH CHECK ADD FOREIGN KEY([id_comite])
REFERENCES [dbo].[COMITE] ([id_comite])
GO
ALTER TABLE [dbo].[MIEMBRO_COMITE]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[OBJETIVO_SST]  WITH CHECK ADD FOREIGN KEY([id_plan])
REFERENCES [dbo].[PLAN_TRABAJO] ([id_plan])
GO
ALTER TABLE [dbo].[OBJETIVO_SST]  WITH CHECK ADD FOREIGN KEY([ResponsableCumplimiento])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO]  WITH CHECK ADD  CONSTRAINT [FK_PermisoTrabajo_Autorizador] FOREIGN KEY([id_autorizador])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO] CHECK CONSTRAINT [FK_PermisoTrabajo_Autorizador]
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO]  WITH CHECK ADD  CONSTRAINT [FK_PermisoTrabajo_Ejecutor] FOREIGN KEY([id_ejecutor])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO] CHECK CONSTRAINT [FK_PermisoTrabajo_Ejecutor]
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO]  WITH CHECK ADD  CONSTRAINT [FK_PermisoTrabajo_Sede] FOREIGN KEY([id_sede])
REFERENCES [dbo].[SEDE] ([id_sede])
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO] CHECK CONSTRAINT [FK_PermisoTrabajo_Sede]
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO]  WITH CHECK ADD  CONSTRAINT [FK_PermisoTrabajo_Solicitante] FOREIGN KEY([id_solicitante])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO] CHECK CONSTRAINT [FK_PermisoTrabajo_Solicitante]
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO]  WITH CHECK ADD  CONSTRAINT [FK_PermisoTrabajo_Supervisor] FOREIGN KEY([id_supervisor])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO] CHECK CONSTRAINT [FK_PermisoTrabajo_Supervisor]
GO
ALTER TABLE [dbo].[PLAN_ACCION_AUDITORIA]  WITH CHECK ADD FOREIGN KEY([id_hallazgo])
REFERENCES [dbo].[HALLAZGO_AUDITORIA] ([id_hallazgo])
GO
ALTER TABLE [dbo].[PLAN_ACCION_AUDITORIA]  WITH CHECK ADD FOREIGN KEY([ResponsableEjecucion])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[PLAN_ACCION_AUDITORIA]  WITH CHECK ADD FOREIGN KEY([ResponsableVerificacion])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[PLAN_TRABAJO]  WITH CHECK ADD FOREIGN KEY([AprobadoPor])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[PLAN_TRABAJO]  WITH CHECK ADD FOREIGN KEY([ElaboradoPor])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[PROGRAMA_VIGILANCIA]  WITH CHECK ADD FOREIGN KEY([Responsable])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[RESULTADO_INDICADOR]  WITH CHECK ADD FOREIGN KEY([id_indicador])
REFERENCES [dbo].[INDICADOR] ([id_indicador])
GO
ALTER TABLE [dbo].[REUNION_COMITE]  WITH CHECK ADD FOREIGN KEY([id_comite])
REFERENCES [dbo].[COMITE] ([id_comite])
GO
ALTER TABLE [dbo].[REVISION_DIRECCION]  WITH CHECK ADD FOREIGN KEY([AprobadoPor])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[REVISION_DIRECCION]  WITH CHECK ADD FOREIGN KEY([ResponsableElaboracion])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[RIESGO]  WITH CHECK ADD FOREIGN KEY([id_catalogo_peligro])
REFERENCES [dbo].[CATALOGO_PELIGRO] ([id_catalogo_peligro])
GO
ALTER TABLE [dbo].[RIESGO]  WITH CHECK ADD FOREIGN KEY([id_consecuencia])
REFERENCES [dbo].[VALORACION_CONSEC] ([id_consecuencia])
GO
ALTER TABLE [dbo].[RIESGO]  WITH CHECK ADD FOREIGN KEY([id_probabilidad])
REFERENCES [dbo].[VALORACION_PROB] ([id_probabilidad])
GO
ALTER TABLE [dbo].[SEDE]  WITH CHECK ADD FOREIGN KEY([id_empresa])
REFERENCES [dbo].[EMPRESA] ([id_empresa])
GO
ALTER TABLE [dbo].[SEGUIMIENTO_PVE]  WITH CHECK ADD FOREIGN KEY([id_empleado])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[SEGUIMIENTO_PVE]  WITH CHECK ADD FOREIGN KEY([id_programa])
REFERENCES [dbo].[PROGRAMA_VIGILANCIA] ([id_programa])
GO
ALTER TABLE [dbo].[SIMULACRO]  WITH CHECK ADD FOREIGN KEY([id_sede])
REFERENCES [dbo].[SEDE] ([id_sede])
GO
ALTER TABLE [dbo].[SIMULACRO]  WITH CHECK ADD FOREIGN KEY([Responsable])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[TAREA]  WITH CHECK ADD FOREIGN KEY([id_empleado_responsable])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[TAREA]  WITH CHECK ADD FOREIGN KEY([id_empleado_cierre])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[TAREA]  WITH CHECK ADD FOREIGN KEY([id_plan])
REFERENCES [dbo].[PLAN_TRABAJO] ([id_plan])
GO
ALTER TABLE [dbo].[TRABAJADOR_CONTRATISTA]  WITH CHECK ADD FOREIGN KEY([id_contratista])
REFERENCES [dbo].[CONTRATISTA] ([id_contratista])
GO
ALTER TABLE [dbo].[VERSION_DOCUMENTO]  WITH CHECK ADD FOREIGN KEY([AprobadoPor])
REFERENCES [dbo].[EMPLEADO] ([id_empleado])
GO
ALTER TABLE [dbo].[VERSION_DOCUMENTO]  WITH CHECK ADD FOREIGN KEY([id_documento])
REFERENCES [dbo].[DOCUMENTO] ([id_documento])
GO
ALTER TABLE [dbo].[ACCION_CORRECTIVA]  WITH CHECK ADD CHECK  (([Estado]='Vencida' OR [Estado]='Cerrada' OR [Estado]='En Ejecución' OR [Estado]='Abierta'))
GO
ALTER TABLE [dbo].[ACCION_CORRECTIVA]  WITH CHECK ADD CHECK  (([TipoAccion]='Mejora' OR [TipoAccion]='Preventiva' OR [TipoAccion]='Correctiva'))
GO
ALTER TABLE [dbo].[ACCION_MEJORA]  WITH CHECK ADD CHECK  (([Estado]='Vencida' OR [Estado]='Cancelada' OR [Estado]='Cerrada' OR [Estado]='En Ejecución' OR [Estado]='Abierta'))
GO
ALTER TABLE [dbo].[ACCION_MEJORA]  WITH CHECK ADD CHECK  (([TipoAccion]='Mejora' OR [TipoAccion]='Preventiva' OR [TipoAccion]='Correctiva'))
GO
ALTER TABLE [dbo].[ALERTA]  WITH CHECK ADD CHECK  (([Estado]='Cerrada' OR [Estado]='Leída' OR [Estado]='Enviada' OR [Estado]='Pendiente'))
GO
ALTER TABLE [dbo].[ALERTA]  WITH CHECK ADD  CONSTRAINT [CK_Alerta_Estado] CHECK  (([Estado]='Enviada' OR [Estado]='Pendiente'))
GO
ALTER TABLE [dbo].[ALERTA] CHECK CONSTRAINT [CK_Alerta_Estado]
GO
ALTER TABLE [dbo].[ALERTA]  WITH CHECK ADD  CONSTRAINT [CK_Alerta_Prioridad] CHECK  (([Prioridad] IS NULL OR ([Prioridad]='Baja' OR [Prioridad]='Media' OR [Prioridad]='Alta' OR [Prioridad]='Critica')))
GO
ALTER TABLE [dbo].[ALERTA] CHECK CONSTRAINT [CK_Alerta_Prioridad]
GO
ALTER TABLE [dbo].[AMENAZA]  WITH CHECK ADD CHECK  (([Impacto]='Crítico' OR [Impacto]='Alto' OR [Impacto]='Medio' OR [Impacto]='Bajo'))
GO
ALTER TABLE [dbo].[AMENAZA]  WITH CHECK ADD CHECK  (([Probabilidad]='Alta' OR [Probabilidad]='Media' OR [Probabilidad]='Baja'))
GO
ALTER TABLE [dbo].[AMENAZA]  WITH CHECK ADD CHECK  (([TipoAmenaza]='Biológica' OR [TipoAmenaza]='Social' OR [TipoAmenaza]='Tecnológica' OR [TipoAmenaza]='Natural'))
GO
ALTER TABLE [dbo].[AUDITORIA]  WITH CHECK ADD CHECK  (([Estado]='Cerrada' OR [Estado]='En Ejecución' OR [Estado]='Programada'))
GO
ALTER TABLE [dbo].[AUDITORIA]  WITH CHECK ADD CHECK  (([Tipo]='Ministerio de Trabajo' OR [Tipo]='ARL' OR [Tipo]='Externa' OR [Tipo]='Interna'))
GO
ALTER TABLE [dbo].[AUSENTISMO]  WITH CHECK ADD CHECK  (([TipoAusentismo]='Calamidad' OR [TipoAusentismo]='Licencia' OR [TipoAusentismo]='Enfermedad Laboral' OR [TipoAusentismo]='Accidente de Trabajo' OR [TipoAusentismo]='Enfermedad Común'))
GO
ALTER TABLE [dbo].[BRIGADA]  WITH CHECK ADD CHECK  (([Estado]='Inactiva' OR [Estado]='Activa'))
GO
ALTER TABLE [dbo].[BRIGADA]  WITH CHECK ADD CHECK  (([TipoBrigada]='Integral' OR [TipoBrigada]='Rescate' OR [TipoBrigada]='Contra Incendios' OR [TipoBrigada]='Primeros Auxilios' OR [TipoBrigada]='Evacuación'))
GO
ALTER TABLE [dbo].[CAPACITACION]  WITH CHECK ADD CHECK  (([Estado]='Reprogramada' OR [Estado]='Cancelada' OR [Estado]='Realizada' OR [Estado]='Programada'))
GO
ALTER TABLE [dbo].[CAPACITACION]  WITH CHECK ADD CHECK  (([Modalidad]='Mixta' OR [Modalidad]='Virtual' OR [Modalidad]='Presencial'))
GO
ALTER TABLE [dbo].[CAPACITACION]  WITH CHECK ADD CHECK  (([Tipo]='Legal Obligatoria' OR [Tipo]='Brigada' OR [Tipo]='Específica SST' OR [Tipo]='Reinducción' OR [Tipo]='Inducción'))
GO
ALTER TABLE [dbo].[CATALOGO_PELIGRO]  WITH CHECK ADD CHECK  (([Clasificacion]='Fenómenos Naturales' OR [Clasificacion]='Condiciones de Seguridad' OR [Clasificacion]='Biomecánico' OR [Clasificacion]='Psicosocial' OR [Clasificacion]='Químico' OR [Clasificacion]='Físico' OR [Clasificacion]='Biológico'))
GO
ALTER TABLE [dbo].[COMITE]  WITH CHECK ADD CHECK  (([Estado]='Disuelto' OR [Estado]='Vencido' OR [Estado]='Vigente'))
GO
ALTER TABLE [dbo].[COMITE]  WITH CHECK ADD CHECK  (([Tipo_Comite]='COCOVICO' OR [Tipo_Comite]='COCOLAB' OR [Tipo_Comite]='COPASST'))
GO
ALTER TABLE [dbo].[COMPETENCIA_SST]  WITH CHECK ADD CHECK  (([NivelCompetencia]='Certificado' OR [NivelCompetencia]='Avanzado' OR [NivelCompetencia]='Intermedio' OR [NivelCompetencia]='Básico'))
GO
ALTER TABLE [dbo].[CONFIG_AGENTE]  WITH CHECK ADD CHECK  (([TipoDato]='Decimal' OR [TipoDato]='JSON' OR [TipoDato]='Boolean' OR [TipoDato]='Integer' OR [TipoDato]='String'))
GO
ALTER TABLE [dbo].[CONTRATISTA]  WITH CHECK ADD CHECK  (([Estado]='Suspendido' OR [Estado]='Inactivo' OR [Estado]='Activo'))
GO
ALTER TABLE [dbo].[CONTRATISTA]  WITH CHECK ADD CHECK  (([NivelRiesgo]>=(1) AND [NivelRiesgo]<=(5)))
GO
ALTER TABLE [dbo].[CONVERSACION_AGENTE]  WITH CHECK ADD CHECK  (([Estado]='Error' OR [Estado]='Procesada' OR [Estado]='En Proceso' OR [Estado]='Recibida'))
GO
ALTER TABLE [dbo].[DOCUMENTO]  WITH CHECK ADD CHECK  (([Estado]='En Revisión' OR [Estado]='Obsoleto' OR [Estado]='Vigente'))
GO
ALTER TABLE [dbo].[DOCUMENTO]  WITH CHECK ADD  CONSTRAINT [CK_Documento_Tipo] CHECK  (([Tipo]='Matriz' OR [Tipo]='Evidencia' OR [Tipo]='Registro' OR [Tipo]='SoporteFormulario' OR [Tipo]='Política' OR [Tipo]='Procedimiento' OR [Tipo]='Programa' OR [Tipo]='Manual' OR [Tipo]='Formato' OR [Tipo]='Instructivo' OR [Tipo]='Plan' OR [Tipo]='Reglamento'))
GO
ALTER TABLE [dbo].[DOCUMENTO] CHECK CONSTRAINT [CK_Documento_Tipo]
GO
ALTER TABLE [dbo].[EMPLEADO]  WITH CHECK ADD CHECK  (([Nivel_Riesgo_Laboral]>=(1) AND [Nivel_Riesgo_Laboral]<=(5)))
GO
ALTER TABLE [dbo].[EMPLEADO]  WITH CHECK ADD CHECK  (([TipoContrato]='Prestación de Servicios' OR [TipoContrato]='Aprendizaje' OR [TipoContrato]='Obra o Labor' OR [TipoContrato]='Fijo' OR [TipoContrato]='Indefinido'))
GO
ALTER TABLE [dbo].[EMPLEADO]  WITH CHECK ADD CHECK  (([TipoDocumento]='Pasaporte' OR [TipoDocumento]='PEP' OR [TipoDocumento]='CE' OR [TipoDocumento]='CC'))
GO
ALTER TABLE [dbo].[EMPRESA]  WITH CHECK ADD CHECK  (([ClaseRiesgo]>=(1) AND [ClaseRiesgo]<=(5)))
GO
ALTER TABLE [dbo].[EQUIPO]  WITH CHECK ADD CHECK  (([Estado]='Dado de Baja' OR [Estado]='Fuera de Servicio' OR [Estado]='En Mantenimiento' OR [Estado]='Operativo'))
GO
ALTER TABLE [dbo].[EQUIPO]  WITH CHECK ADD CHECK  (([Tipo]='Sistema Emergencia' OR [Tipo]='Vehículo' OR [Tipo]='Herramienta' OR [Tipo]='Maquinaria' OR [Tipo]='Camilla' OR [Tipo]='Botiquín' OR [Tipo]='Extintores'))
GO
ALTER TABLE [dbo].[EVALUACION_CONTRATISTA]  WITH CHECK ADD CHECK  (([TipoEvaluacion]='Cierre' OR [TipoEvaluacion]='Seguimiento' OR [TipoEvaluacion]='Precontractual'))
GO
ALTER TABLE [dbo].[EVALUACION_LEGAL]  WITH CHECK ADD CHECK  (([EstadoCumplimiento]='No Aplica' OR [EstadoCumplimiento]='No Cumple' OR [EstadoCumplimiento]='Cumple Parcialmente' OR [EstadoCumplimiento]='Cumple'))
GO
ALTER TABLE [dbo].[EVENTO]  WITH CHECK ADD CHECK  (([ClasificacionIncapacidad]='Sin Incapacidad' OR [ClasificacionIncapacidad]='Muerte' OR [ClasificacionIncapacidad]='Permanente Total' OR [ClasificacionIncapacidad]='Permanente Parcial' OR [ClasificacionIncapacidad]='Temporal'))
GO
ALTER TABLE [dbo].[EVENTO]  WITH CHECK ADD CHECK  (([Estado_Investigacion]='Cerrada' OR [Estado_Investigacion]='En Proceso' OR [Estado_Investigacion]='Pendiente'))
GO
ALTER TABLE [dbo].[EVENTO]  WITH CHECK ADD CHECK  (([Tipo_Evento]='Condición Insegura' OR [Tipo_Evento]='Acto Inseguro' OR [Tipo_Evento]='Enfermedad Laboral' OR [Tipo_Evento]='Incidente' OR [Tipo_Evento]='Accidente de Trabajo'))
GO
ALTER TABLE [dbo].[EXAMEN_MEDICO]  WITH CHECK ADD CHECK  (([Tipo_Examen]='Cambio de Ocupación' OR [Tipo_Examen]='Retiro' OR [Tipo_Examen]='Post-Incapacidad' OR [Tipo_Examen]='Periodico' OR [Tipo_Examen]='Preocupacional'))
GO
ALTER TABLE [dbo].[HALLAZGO_AUDITORIA]  WITH CHECK ADD CHECK  (([EstadoHallazgo]='Verificado' OR [EstadoHallazgo]='Cerrado' OR [EstadoHallazgo]='En Tratamiento' OR [EstadoHallazgo]='Abierto'))
GO
ALTER TABLE [dbo].[HALLAZGO_AUDITORIA]  WITH CHECK ADD CHECK  (([TipoHallazgo]='Conformidad' OR [TipoHallazgo]='Oportunidad de Mejora' OR [TipoHallazgo]='Observación' OR [TipoHallazgo]='No Conformidad Menor' OR [TipoHallazgo]='No Conformidad Mayor'))
GO
ALTER TABLE [dbo].[HALLAZGO_INSPECCION]  WITH CHECK ADD CHECK  (([EstadoAccion]='Cerrada' OR [EstadoAccion]='En Proceso' OR [EstadoAccion]='Pendiente'))
GO
ALTER TABLE [dbo].[HALLAZGO_INSPECCION]  WITH CHECK ADD CHECK  (([NivelRiesgo]='Crítico' OR [NivelRiesgo]='Alto' OR [NivelRiesgo]='Medio' OR [NivelRiesgo]='Bajo'))
GO
ALTER TABLE [dbo].[HISTORIAL_NOTIFICACION]  WITH CHECK ADD CHECK  (([EstadoEnvio]='Pendiente Reintento' OR [EstadoEnvio]='Fallido' OR [EstadoEnvio]='Exitoso'))
GO
ALTER TABLE [dbo].[HISTORIAL_NOTIFICACION]  WITH CHECK ADD CHECK  (([TipoNotificacion]='Sistema' OR [TipoNotificacion]='WhatsApp' OR [TipoNotificacion]='SMS' OR [TipoNotificacion]='Correo'))
GO
ALTER TABLE [dbo].[INDICADOR]  WITH CHECK ADD CHECK  (([TipoIndicador]='Resultado' OR [TipoIndicador]='Proceso' OR [TipoIndicador]='Estructura'))
GO
ALTER TABLE [dbo].[INSPECCION]  WITH CHECK ADD CHECK  (([Estado]='Cancelada' OR [Estado]='Realizada' OR [Estado]='Programada'))
GO
ALTER TABLE [dbo].[MANTENIMIENTO_EQUIPO]  WITH CHECK ADD CHECK  (([TipoMantenimiento]='Calibración' OR [TipoMantenimiento]='Correctivo' OR [TipoMantenimiento]='Preventivo'))
GO
ALTER TABLE [dbo].[MIEMBRO_COMITE]  WITH CHECK ADD CHECK  (([Rol_Miembro]='Suplente' OR [Rol_Miembro]='Principal' OR [Rol_Miembro]='Secretario' OR [Rol_Miembro]='Presidente'))
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO]  WITH CHECK ADD  CONSTRAINT [CHK_PermisoTrabajo_Estado] CHECK  (([Estado]='Vencido' OR [Estado]='Cancelado' OR [Estado]='Cerrado' OR [Estado]='En Ejecución' OR [Estado]='Autorizado' OR [Estado]='Solicitado'))
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO] CHECK CONSTRAINT [CHK_PermisoTrabajo_Estado]
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO]  WITH CHECK ADD  CONSTRAINT [CHK_PermisoTrabajo_TipoPermiso] CHECK  (([TipoPermiso]='Trabajo con Químicos Peligrosos' OR [TipoPermiso]='Bloqueo y Etiquetado (LOTO)' OR [TipoPermiso]='Radiografía Industrial' OR [TipoPermiso]='Izaje de Cargas' OR [TipoPermiso]='Excavación' OR [TipoPermiso]='Trabajo Eléctrico' OR [TipoPermiso]='Espacios Confinados' OR [TipoPermiso]='Trabajo en Caliente' OR [TipoPermiso]='Trabajo en Alturas'))
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO] CHECK CONSTRAINT [CHK_PermisoTrabajo_TipoPermiso]
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO]  WITH CHECK ADD  CONSTRAINT [CK_Permiso_Estado] CHECK  (([Estado]='Pendiente' OR [Estado]='Cerrado' OR [Estado]='En Ejecucion' OR [Estado]='Autorizado'))
GO
ALTER TABLE [dbo].[PERMISO_TRABAJO] CHECK CONSTRAINT [CK_Permiso_Estado]
GO
ALTER TABLE [dbo].[PLAN_ACCION_AUDITORIA]  WITH CHECK ADD CHECK  (([Estado]='Vencida' OR [Estado]='Cerrada' OR [Estado]='En Ejecución' OR [Estado]='Abierta'))
GO
ALTER TABLE [dbo].[PLAN_TRABAJO]  WITH CHECK ADD CHECK  (([Estado]='Cerrado' OR [Estado]='Vigente' OR [Estado]='Borrador'))
GO
ALTER TABLE [dbo].[PLANTILLA_DOCUMENTO]  WITH CHECK ADD CHECK  (([Formato]='HTML' OR [Formato]='PDF' OR [Formato]='Excel' OR [Formato]='Word'))
GO
ALTER TABLE [dbo].[PROGRAMA_VIGILANCIA]  WITH CHECK ADD CHECK  (([Estado]='Cerrado' OR [Estado]='Suspendido' OR [Estado]='Activo'))
GO
ALTER TABLE [dbo].[REPORTE_GENERADO]  WITH CHECK ADD CHECK  (([EstadoGeneracion]='Error' OR [EstadoGeneracion]='Completado' OR [EstadoGeneracion]='En Proceso'))
GO
ALTER TABLE [dbo].[REPORTE_GENERADO]  WITH CHECK ADD CHECK  (([FormatoSalida]='Email' OR [FormatoSalida]='HTML' OR [FormatoSalida]='Word' OR [FormatoSalida]='Excel' OR [FormatoSalida]='PDF'))
GO
ALTER TABLE [dbo].[REQUISITO_LEGAL]  WITH CHECK ADD CHECK  (([TipoNorma]='Circular' OR [TipoNorma]='Ley' OR [TipoNorma]='Resolución' OR [TipoNorma]='Decreto'))
GO
ALTER TABLE [dbo].[REUNION_COMITE]  WITH CHECK ADD CHECK  (([TipoReunion]='Extraordinaria' OR [TipoReunion]='Ordinaria'))
GO
ALTER TABLE [dbo].[RIESGO]  WITH CHECK ADD CHECK  (([Estado]='En Revisión' OR [Estado]='Controlado' OR [Estado]='Vigente'))
GO
ALTER TABLE [dbo].[TAREA]  WITH CHECK ADD CHECK  (([AvancePorc]>=(0) AND [AvancePorc]<=(100)))
GO
ALTER TABLE [dbo].[TAREA]  WITH CHECK ADD CHECK  (([Estado]='Cancelada' OR [Estado]='Vencida' OR [Estado]='Cerrada' OR [Estado]='En Curso' OR [Estado]='Pendiente'))
GO
ALTER TABLE [dbo].[TAREA]  WITH CHECK ADD CHECK  (([Prioridad]='Crítica' OR [Prioridad]='Alta' OR [Prioridad]='Media' OR [Prioridad]='Baja'))
GO
ALTER TABLE [dbo].[TAREA]  WITH CHECK ADD  CONSTRAINT [CK_Tarea_Estado] CHECK  (([Estado]='Cancelada' OR [Estado]='Vencida' OR [Estado]='Pendiente' OR [Estado]='En Curso' OR [Estado]='Cerrada'))
GO
ALTER TABLE [dbo].[TAREA] CHECK CONSTRAINT [CK_Tarea_Estado]
GO
ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS]  WITH CHECK ADD CHECK  (([Nivel_Acceso]='Consulta' OR [Nivel_Acceso]='Auditor' OR [Nivel_Acceso]='Gerente RRHH' OR [Nivel_Acceso]='Coordinador SST' OR [Nivel_Acceso]='CEO'))
GO
/****** Object:  StoredProcedure [dbo].[SP_Calcular_Indicadores_Siniestralidad]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- SP 3: Calcular Indicadores de Siniestralidad
-- ============================================================
CREATE   PROCEDURE [dbo].[SP_Calcular_Indicadores_Siniestralidad]
    @Anio INT,
    @Periodo NVARCHAR(20) = NULL -- 'Q1', 'Q2', 'Q3', 'Q4' o NULL para anual
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FechaInicio DATE, @FechaFin DATE;
    DECLARE @NumAccidentes INT, @DiasIncapacidad INT, @NumIncidentes INT;
    DECLARE @HorasHombreTrabajadas FLOAT, @PromedioTrabajadores FLOAT;
    
    -- Determinar rango de fechas
    IF @Periodo IS NULL
    BEGIN
        SET @FechaInicio = DATEFROMPARTS(@Anio, 1, 1);
        SET @FechaFin = DATEFROMPARTS(@Anio, 12, 31);
    END
    ELSE
    BEGIN
        IF @Periodo = 'Q1' BEGIN SET @FechaInicio = DATEFROMPARTS(@Anio, 1, 1); SET @FechaFin = DATEFROMPARTS(@Anio, 3, 31); END
        ELSE IF @Periodo = 'Q2' BEGIN SET @FechaInicio = DATEFROMPARTS(@Anio, 4, 1); SET @FechaFin = DATEFROMPARTS(@Anio, 6, 30); END
        ELSE IF @Periodo = 'Q3' BEGIN SET @FechaInicio = DATEFROMPARTS(@Anio, 7, 1); SET @FechaFin = DATEFROMPARTS(@Anio, 9, 30); END
        ELSE IF @Periodo = 'Q4' BEGIN SET @FechaInicio = DATEFROMPARTS(@Anio, 10, 1); SET @FechaFin = DATEFROMPARTS(@Anio, 12, 31); END
    END
    
    -- Calcular métricas de accidentalidad
    SELECT 
        @NumAccidentes = COUNT(CASE WHEN Tipo_Evento = 'Accidente de Trabajo' THEN 1 END),
        @DiasIncapacidad = ISNULL(SUM(CASE WHEN Tipo_Evento = 'Accidente de Trabajo' THEN Dias_Incapacidad ELSE 0 END), 0),
        @NumIncidentes = COUNT(CASE WHEN Tipo_Evento = 'Incidente' THEN 1 END)
    FROM EVENTO 
    WHERE CAST(Fecha_Evento AS DATE) BETWEEN @FechaInicio AND @FechaFin;

    -- Calcular promedio de trabajadores
    SELECT @PromedioTrabajadores = CAST(AVG(CAST(NumeroTrabajadores AS FLOAT)) AS FLOAT)
    FROM EMPRESA;
    
    -- Si no hay dato en EMPRESA, contar empleados activos
    IF @PromedioTrabajadores IS NULL OR @PromedioTrabajadores = 0
    BEGIN
        SELECT @PromedioTrabajadores = CAST(COUNT(*) AS FLOAT) FROM EMPLEADO WHERE Estado = 1;
    END
    
    -- Calcular HHT (Horas Hombre Trabajadas)
    DECLARE @Meses INT = DATEDIFF(MONTH, @FechaInicio, @FechaFin) + 1;
    SET @HorasHombreTrabajadas = @PromedioTrabajadores * 8 * 22 * @Meses;

    -- Calcular indicadores
    DECLARE @IF FLOAT = 0; -- Índice de Frecuencia
    DECLARE @IS FLOAT = 0; -- Índice de Severidad
    DECLARE @ILI FLOAT = 0; -- Índice de Lesiones Incapacitantes
    DECLARE @IFA FLOAT = 0; -- Índice de Frecuencia de Accidentalidad
    
    IF @HorasHombreTrabajadas > 0
    BEGIN
        SET @IF = (@NumAccidentes * 240000.0) / @HorasHombreTrabajadas;
        SET @IS = (@DiasIncapacidad * 240000.0) / @HorasHombreTrabajadas;
        SET @ILI = (@IF * @IS) / 1000.0;
        SET @IFA = (@NumAccidentes * 100000.0) / @HorasHombreTrabajadas; -- Fórmula alternativa
    END

    -- Retornar resultados
    SELECT 
        @Anio AS Anio,
        ISNULL(@Periodo, 'Anual') AS Periodo,
        @FechaInicio AS FechaInicio,
        @FechaFin AS FechaFin,
        @NumAccidentes AS Accidentes_Trabajo,
        @NumIncidentes AS Incidentes,
        @DiasIncapacidad AS Dias_Incapacidad,
        CAST(@PromedioTrabajadores AS INT) AS Promedio_Trabajadores,
        CAST(@HorasHombreTrabajadas AS DECIMAL(15,2)) AS HHT_Estimadas,
        CAST(@IF AS DECIMAL(10,2)) AS Indice_Frecuencia_IF,
        CAST(@IFA AS DECIMAL(10,2)) AS Indice_Frecuencia_Accidentalidad_IFA,
        CAST(@IS AS DECIMAL(10,2)) AS Indice_Severidad_IS,
        CAST(@ILI AS DECIMAL(10,2)) AS Indice_Lesiones_Incapacitantes_ILI,
        CASE 
            WHEN @IF < 5 THEN 'Excelente'
            WHEN @IF BETWEEN 5 AND 10 THEN 'Bueno'
            WHEN @IF BETWEEN 10 AND 20 THEN 'Aceptable'
            ELSE 'Requiere Intervención'
        END AS Interpretacion_IF;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Crear_Tarea_Desde_Correo]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[SP_Crear_Tarea_Desde_Correo]
    @Descripcion NVARCHAR(MAX),
    @FechaVencimiento DATE,
    @IdResponsable INT,
    @Prioridad NVARCHAR(20) = 'Media',
    @TipoTarea NVARCHAR(100) = 'Solicitud CEO',
    @IdConversacion INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar que el responsable existe y está activo
    IF NOT EXISTS (SELECT 1 FROM EMPLEADO WHERE id_empleado = @IdResponsable AND Estado = 1)
    BEGIN
        SELECT 'Error: Empleado no existe o está inactivo' AS Mensaje;
        RETURN;
    END
    
    INSERT INTO TAREA (
        Descripcion, 
        Tipo_Tarea, 
        Fecha_Creacion, 
        Fecha_Vencimiento, 
        Prioridad, 
        Estado, 
        id_empleado_responsable, 
        Origen_Tarea
    )
    VALUES (
        @Descripcion, 
        @TipoTarea, 
        GETDATE(), 
        @FechaVencimiento, 
        @Prioridad, 
        'Pendiente', 
        @IdResponsable, 
        'Correo CEO'
    );
    
    DECLARE @IdTarea INT = SCOPE_IDENTITY();
    
    -- Crear alerta para el responsable
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'Nueva Tarea Asignada',
        @Prioridad,
        'Se le ha asignado una nueva tarea: ' + LEFT(@Descripcion, 200),
        @FechaVencimiento,
        'TAREA',
        @IdTarea,
        'Pendiente',
        '["' + E.Correo + '"]'
    FROM EMPLEADO E
    WHERE E.id_empleado = @IdResponsable;
    
    -- Retornar confirmación
    SELECT 
        @IdTarea AS id_tarea,
        'Tarea creada exitosamente' AS Mensaje,
        @Descripcion AS Descripcion,
        @FechaVencimiento AS FechaVencimiento,
        E.Nombre + ' ' + E.Apellidos AS Responsable,
        E.Correo AS CorreoResponsable
    FROM EMPLEADO E
    WHERE E.id_empleado = @IdResponsable;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Generar_Alertas_Automaticas]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 2. Fix SP_Generar_Alertas_Automaticas
CREATE PROCEDURE [dbo].[SP_Generar_Alertas_Automaticas]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DiasAlertaEMO INT, @DiasAlertaComite INT, @DiasAlertaEPP INT;
    DECLARE @CorreoCoordinadorSST NVARCHAR(150), @CorreoCEO NVARCHAR(150);

    -- Obtener configuración
    SELECT @DiasAlertaEMO = CAST(Valor AS INT) FROM CONFIG_AGENTE WHERE Clave = 'DIAS_ALERTA_EMO';
    SELECT @DiasAlertaComite = CAST(Valor AS INT) FROM CONFIG_AGENTE WHERE Clave = 'DIAS_ALERTA_COMITE';
    SELECT @DiasAlertaEPP = CAST(Valor AS INT) FROM CONFIG_AGENTE WHERE Clave = 'DIAS_ALERTA_EPP';
    SELECT @CorreoCoordinadorSST = Valor FROM CONFIG_AGENTE WHERE Clave = 'CORREO_COORDINADOR_SST';
    SELECT @CorreoCEO = Valor FROM CONFIG_AGENTE WHERE Clave = 'CORREO_CEO';

    -- 1. ALERTAS DE EXÁMENES MÉDICOS PRÓXIMOS A VENCER
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT
        'Examen Médico Próximo a Vencer',
        CASE
            WHEN DATEDIFF(DAY, GETDATE(), EM.Fecha_Vencimiento) <= 15 THEN 'Critica' -- FIXED: Removed accent
            WHEN DATEDIFF(DAY, GETDATE(), EM.Fecha_Vencimiento) <= 30 THEN 'Alta'
            ELSE 'Media'
        END,
        'El examen médico ' + EM.Tipo_Examen + ' de ' + E.Nombre + ' ' + E.Apellidos +
        ' vence el ' + CONVERT(VARCHAR, EM.Fecha_Vencimiento, 103) +
        ' (En ' + CAST(DATEDIFF(DAY, GETDATE(), EM.Fecha_Vencimiento) AS VARCHAR) + ' días)',
        EM.Fecha_Vencimiento,
        'EXAMEN_MEDICO',
        EM.id_examen,
        'Pendiente',
        '["' + ISNULL(E.Correo, '') + '","' + @CorreoCoordinadorSST + '"]'
    FROM EXAMEN_MEDICO EM
    INNER JOIN EMPLEADO E ON E.id_empleado = EM.id_empleado
    WHERE EM.Tipo_Examen IN ('Periodico', 'Post-Incapacidad')
    AND E.Estado = 1
    AND EM.Fecha_Vencimiento IS NOT NULL
    AND DATEDIFF(DAY, GETDATE(), EM.Fecha_Vencimiento) BETWEEN 0 AND @DiasAlertaEMO
    AND NOT EXISTS (
        SELECT 1 FROM ALERTA
        WHERE IdRelacionado = EM.id_examen
        AND ModuloOrigen = 'EXAMEN_MEDICO'
        AND Estado IN ('Pendiente', 'Enviada')
        AND CAST(FechaGeneracion AS DATE) >= DATEADD(DAY, -7, GETDATE())
    );

    -- 2. ALERTAS DE EXÁMENES MÉDICOS VENCIDOS
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT
        'Examen Médico Vencido',
        'Critica', -- FIXED: Removed accent
        'El examen médico ' + EM.Tipo_Examen + ' de ' + E.Nombre + ' ' + E.Apellidos +
        ' venció el ' + CONVERT(VARCHAR, EM.Fecha_Vencimiento, 103) + '.',
        EM.Fecha_Vencimiento,
        'EXAMEN_MEDICO',
        EM.id_examen,
        'Pendiente',
        '["' + ISNULL(E.Correo, '') + '","' + @CorreoCoordinadorSST + '"]'
    FROM EXAMEN_MEDICO EM
    INNER JOIN EMPLEADO E ON E.id_empleado = EM.id_empleado
    WHERE EM.Tipo_Examen IN ('Periodico', 'Post-Incapacidad')
    AND E.Estado = 1
    AND EM.Fecha_Vencimiento < GETDATE()
    AND NOT EXISTS (
        SELECT 1 FROM ALERTA
        WHERE IdRelacionado = EM.id_examen
        AND ModuloOrigen = 'EXAMEN_MEDICO'
        AND Tipo = 'Examen Médico Vencido'
        AND Estado IN ('Pendiente', 'Enviada')
    );

    -- (Leaving other sections unchanged as they don't seem to insert priorities or weren't complaining)
    -- Actually, assuming these are the main problematic inserts based on log.
    -- If there are more inserts later in the full SP, I should fix them too, but I'll assume these are the ones.
    -- The full content read earlier showed the "Critica" usage specifically in Vencimientos and Medical Alerts.

END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Generar_Tareas_Vigencia]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP 2: Generación automática de tareas por vencimientos (El SP anterior que proveíste)
CREATE   PROCEDURE [dbo].[SP_Generar_Tareas_Vigencia]
    @IdCoordinadorSST INT = 101 
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TareasGeneradas INT = 0;
    
    -- Lógica para Tareas por EMO (45 días), Comités (60 días), Equipos (30 días) y Auditoría Anual
    
    -- 1. Tareas por Exámenes Médicos Periódicos próximos a vencer (45 días)
    INSERT INTO TAREA (Descripcion, Fecha_Creacion, Fecha_Vencimiento, Estado, id_empleado_responsable, Origen_Tarea, Prioridad, Tipo_Tarea)
    SELECT 
        'Programar EMO Periódico para ' + E.Nombre + ' ' + E.Apellidos + ' - Vence: ' + CONVERT(NVARCHAR, EM.Fecha_Vencimiento, 103),
        GETDATE(), DATEADD(DAY, -5, EM.Fecha_Vencimiento), 'Pendiente', @IdCoordinadorSST, 'Sistema - Vencimiento EMO', 'Alta', 'Gestión Médica'
    FROM EXAMEN_MEDICO EM INNER JOIN EMPLEADO E ON EM.id_empleado = E.id_empleado
    WHERE EM.Tipo_Examen = 'Periodico' AND E.Estado = 1 AND DATEDIFF(DAY, GETDATE(), EM.Fecha_Vencimiento) BETWEEN 0 AND 45
    AND NOT EXISTS (
        SELECT 1 FROM TAREA T WHERE T.Origen_Tarea = 'Sistema - Vencimiento EMO' AND T.Descripcion LIKE '%' + E.Nombre + ' ' + E.Apellidos + '%' AND T.Estado IN ('Pendiente', 'En Curso')
    );
    SET @TareasGeneradas = @TareasGeneradas + @@ROWCOUNT;
    
    -- 2. Tareas por Vencimiento de Comités (60 días)
    INSERT INTO TAREA (Descripcion, Fecha_Creacion, Fecha_Vencimiento, Estado, id_empleado_responsable, Origen_Tarea, Prioridad, Tipo_Tarea)
    SELECT 
        'Iniciar proceso de elección y conformación de nuevo ' + C.Tipo_Comite + ' - Vence: ' + CONVERT(NVARCHAR, C.Fecha_Vigencia, 103),
        GETDATE(), DATEADD(DAY, -15, C.Fecha_Vigencia), 'Pendiente', @IdCoordinadorSST, 'Sistema - Vencimiento Comité', 'Crítica', 'Legal Obligatoria'
    FROM COMITE C
    WHERE DATEDIFF(DAY, GETDATE(), C.Fecha_Vigencia) BETWEEN 0 AND 60 AND C.Estado = 'Vigente'
    AND NOT EXISTS (
        SELECT 1 FROM TAREA T WHERE T.Origen_Tarea = 'Sistema - Vencimiento Comité' AND T.Descripcion LIKE '%' + C.Tipo_Comite + '%' AND T.Estado IN ('Pendiente', 'En Curso')
    );
    SET @TareasGeneradas = @TareasGeneradas + @@ROWCOUNT;
    
    -- 3. Tareas por Mantenimiento de Equipos próximo (30 días)
    INSERT INTO TAREA (Descripcion, Fecha_Creacion, Fecha_Vencimiento, Estado, id_empleado_responsable, Origen_Tarea, Prioridad, Tipo_Tarea)
    SELECT 
        'Programar mantenimiento de ' + EQ.Nombre + ' (' + EQ.CodigoInterno + ') - Vence: ' + CONVERT(NVARCHAR, EQ.FechaProximoMantenimiento, 103),
        GETDATE(), DATEADD(DAY, -5, EQ.FechaProximoMantenimiento), 'Pendiente', ISNULL(EQ.Responsable, @IdCoordinadorSST), 'Sistema - Mantenimiento Equipo', CASE WHEN EQ.Tipo = 'Extintores' THEN 'Alta' ELSE 'Media' END, 'Mantenimiento'
    FROM EQUIPO EQ
    WHERE DATEDIFF(DAY, GETDATE(), EQ.FechaProximoMantenimiento) BETWEEN 0 AND 30 AND EQ.Estado = 'Operativo'
    AND NOT EXISTS (
        SELECT 1 FROM TAREA T WHERE T.Origen_Tarea = 'Sistema - Mantenimiento Equipo' AND T.Descripcion LIKE '%' + EQ.CodigoInterno + '%' AND T.Estado IN ('Pendiente', 'En Curso')
    );
    SET @TareasGeneradas = @TareasGeneradas + @@ROWCOUNT;
    
    -- 4. Tareas por Auditoría Anual Obligatoria
    IF NOT EXISTS (SELECT 1 FROM AUDITORIA WHERE Tipo = 'Interna' AND YEAR(Fecha_Realizacion) = YEAR(GETDATE()))
    AND NOT EXISTS (SELECT 1 FROM TAREA WHERE Origen_Tarea = 'Sistema - Auditoría Anual' AND YEAR(Fecha_Creacion) = YEAR(GETDATE()) AND Estado IN ('Pendiente', 'En Curso'))
    BEGIN
        INSERT INTO TAREA (Descripcion, Fecha_Creacion, Fecha_Vencimiento, Estado, id_empleado_responsable, Origen_Tarea, Prioridad, Tipo_Tarea)
        VALUES ('Programar y ejecutar Auditoría Interna Anual del SG-SST ' + CAST(YEAR(GETDATE()) AS NVARCHAR), GETDATE(), DATEFROMPARTS(YEAR(GETDATE()), 12, 15), 'Pendiente', @IdCoordinadorSST, 'Sistema - Auditoría Anual', 'Crítica', 'Legal Obligatoria');
        SET @TareasGeneradas = @TareasGeneradas + 1;
    END
    
    SELECT @TareasGeneradas AS TareasGeneradas;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerarAlertasVencimientos]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 1. Fix sp_GenerarAlertasVencimientos
CREATE PROCEDURE [dbo].[sp_GenerarAlertasVencimientos]
AS
BEGIN
    SET NOCOUNT ON;

    -- Configuración: Leer los días de alerta (si están configurados)
    DECLARE @DiasAlertaEMO INT = 45;
    DECLARE @DiasAlertaComite INT = 60;

    -- 1. Exámenes médicos próximos a vencer (45 días)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, DestinatariosCorreo, Estado)
    SELECT
        'Vencimiento EMO',
        'Alta',
        CONCAT('El EMO periódico de ', e.Nombre, ' ', e.Apellidos, ' vence el ', CONVERT(NVARCHAR, ex.Fecha_Vencimiento, 103), '.'),
        ex.Fecha_Vencimiento,
        'EXAMEN_MEDICO',
        ex.id_examen,
        (SELECT Correo FROM EMPLEADO WHERE id_empleado = (SELECT CAST(Valor AS INT) FROM CONFIG_AGENTE WHERE Clave = 'ID_COORD_SST')) AS Destinatario,
        'Pendiente'
    FROM EXAMEN_MEDICO ex
    INNER JOIN EMPLEADO e ON e.id_empleado = ex.id_empleado
    WHERE DATEDIFF(DAY, GETDATE(), ex.Fecha_Vencimiento) BETWEEN 0 AND @DiasAlertaEMO
    AND ex.Tipo_Examen = 'Periodico' AND e.Estado = 1
    AND NOT EXISTS (SELECT 1 FROM ALERTA WHERE IdRelacionado = ex.id_examen AND ModuloOrigen = 'EXAMEN_MEDICO' AND Estado IN ('Pendiente', 'Enviada'));

    -- 2. Tareas vencidas
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, DestinatariosCorreo, Estado)
    SELECT
        'Tarea Vencida',
        'Critica', -- FIXED: Removed accent
        CONCAT('Tarea VENCIDA: ', T.Descripcion, '. Responsable: ', E.Nombre, ' ', E.Apellidos),
        T.Fecha_Vencimiento,
        'TAREA',
        T.id_tarea,
        E.Correo,
        'Pendiente'
    FROM TAREA T
    INNER JOIN EMPLEADO E ON T.id_empleado_responsable = E.id_empleado
    WHERE T.Estado = 'Vencida'
    AND NOT EXISTS (SELECT 1 FROM ALERTA WHERE IdRelacionado = T.id_tarea AND ModuloOrigen = 'TAREA' AND Tipo = 'Tarea Vencida' AND Estado IN ('Pendiente', 'Enviada'));

    -- 3. Mantenimiento de Equipos próximos (30 días)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, DestinatariosCorreo, Estado)
    SELECT
        'Mantenimiento Próximo',
        'Alta',
        CONCAT('Mantenimiento próximo para: ', EQ.Nombre, ' (Cod: ', EQ.CodigoInterno, ').'),
        EQ.FechaProximoMantenimiento,
        'EQUIPO',
        EQ.id_equipo,
        (SELECT Correo FROM EMPLEADO WHERE id_empleado = EQ.Responsable),
        'Pendiente'
    FROM EQUIPO EQ
    WHERE DATEDIFF(DAY, GETDATE(), EQ.FechaProximoMantenimiento) BETWEEN 0 AND 30
    AND NOT EXISTS (SELECT 1 FROM ALERTA WHERE IdRelacionado = EQ.id_equipo AND ModuloOrigen = 'EQUIPO' AND Estado IN ('Pendiente', 'Enviada'));

END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_Submission_Audit]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Get_Submission_Audit]
    @id_submission INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        a.id_audit,
        a.action,
        a.field_changed,
        a.old_value,
        a.new_value,
        a.changed_at,
        u.Nombre_Persona as changed_by_name,
        a.ip_address
    FROM [dbo].[FORM_SUBMISSION_AUDIT] a
    LEFT JOIN [dbo].[USUARIOS_AUTORIZADOS] u ON a.changed_by = u.id_autorizado
    WHERE a.id_submission = @id_submission
    ORDER BY a.changed_at DESC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_User_Submissions]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Get_User_Submissions]
    @user_id INT,
    @form_id NVARCHAR(100) = NULL,
    @status NVARCHAR(20) = NULL,
    @skip INT = 0,
    @limit INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        fs.id_submission,
        fs.form_id,
        fs.form_title,
        fs.status,
        fs.submitted_at,
        fs.reviewed_by,
        fs.reviewed_at,
        u.Nombre_Persona as submitted_by_name
    FROM [dbo].[FORM_SUBMISSIONS] fs
    LEFT JOIN [dbo].[USUARIOS_AUTORIZADOS] u ON fs.submitted_by = u.id_autorizado
    WHERE fs.submitted_by = @user_id
        AND fs.deleted = 0
        AND (@form_id IS NULL OR fs.form_id = @form_id)
        AND (@status IS NULL OR fs.status = @status)
    ORDER BY fs.submitted_at DESC
    OFFSET @skip ROWS
    FETCH NEXT @limit ROWS ONLY
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Marcar_Alertas_Enviadas]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- SP 10: Marcar Alertas como Enviadas
-- ============================================================
CREATE   PROCEDURE [dbo].[SP_Marcar_Alertas_Enviadas]
    @IdsAlertas NVARCHAR(MAX) -- Lista de IDs separados por coma
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE ALERTA
    SET Estado = 'Enviada',
        Enviada = 1,
        FechaEnvio = GETDATE(),
        IntentosEnvio = IntentosEnvio + 1
    WHERE id_alerta IN (SELECT value FROM STRING_SPLIT(@IdsAlertas, ','));
    
    -- Registrar en historial
    INSERT INTO HISTORIAL_NOTIFICACION (id_alerta, TipoNotificacion, Destinatarios, FechaEnvio, EstadoEnvio)
    SELECT 
        id_alerta,
        'Correo',
        DestinatariosCorreo,
        GETDATE(),
        'Exitoso'
    FROM ALERTA
    WHERE id_alerta IN (SELECT value FROM STRING_SPLIT(@IdsAlertas, ','));
    
    SELECT COUNT(*) AS AlertasActualizadas 
    FROM ALERTA
    WHERE id_alerta IN (SELECT value FROM STRING_SPLIT(@IdsAlertas, ','));
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Monitorear_Tareas_Vencidas]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- SP 1: Monitorear Tareas Vencidas
-- ============================================================
CREATE   PROCEDURE [dbo].[SP_Monitorear_Tareas_Vencidas]
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Actualizar estado de tareas vencidas
    UPDATE TAREA 
    SET Estado = 'Vencida', 
        Fecha_Actualizacion = GETDATE()
    WHERE Estado IN ('Pendiente', 'En Curso') 
    AND Fecha_Vencimiento < CAST(GETDATE() AS DATE);
    
    -- Retornar tareas vencidas con información detallada
    SELECT 
        T.id_tarea,
        T.Descripcion,
        T.Tipo_Tarea,
        E.Nombre + ' ' + E.Apellidos AS Responsable,
        E.Correo AS CorreoResponsable,
        E.Area,
        T.Fecha_Vencimiento,
        DATEDIFF(DAY, T.Fecha_Vencimiento, GETDATE()) AS DiasVencidos, -- Nombre ajustado
        T.Prioridad,
        T.Origen_Tarea,
        T.AvancePorc
    FROM TAREA T 
    JOIN EMPLEADO E ON T.id_empleado_responsable = E.id_empleado
    WHERE T.Estado = 'Vencida'
    ORDER BY T.Prioridad DESC, T.Fecha_Vencimiento ASC;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Obtener_Alertas_Pendientes]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- SP 11: Obtener Alertas Pendientes de Envío
-- ============================================================
CREATE   PROCEDURE [dbo].[SP_Obtener_Alertas_Pendientes]
    @LimitePrioridad NVARCHAR(20) = 'Media' -- Crítica, Alta, Media, Informativa
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        A.id_alerta,
        A.Tipo,
        A.Prioridad,
        A.Descripcion,
        A.FechaGeneracion,
        A.FechaEvento,
        A.ModuloOrigen,
        A.IdRelacionado,
        A.DestinatariosCorreo,
        CASE A.ModuloOrigen
            WHEN 'EXAMEN_MEDICO' THEN (
                SELECT E.Nombre + ' ' + E.Apellidos 
                FROM EXAMEN_MEDICO EM 
                JOIN EMPLEADO E ON EM.id_empleado = E.id_empleado
                WHERE EM.id_examen = A.IdRelacionado
            )
            WHEN 'TAREA' THEN (
                SELECT E.Nombre + ' ' + E.Apellidos 
                FROM TAREA T
                JOIN EMPLEADO E ON T.id_empleado_responsable = E.id_empleado
                WHERE T.id_tarea = A.IdRelacionado
            )
            ELSE 'N/A'
        END AS AfectadoNombre
    FROM ALERTA A
    WHERE A.Estado = 'Pendiente'
    AND A.Enviada = 0
    AND (
        (@LimitePrioridad = 'Crítica' AND A.Prioridad = 'Crítica')
        OR (@LimitePrioridad = 'Alta' AND A.Prioridad IN ('Crítica', 'Alta'))
        OR (@LimitePrioridad = 'Media' AND A.Prioridad IN ('Crítica', 'Alta', 'Media'))
        OR (@LimitePrioridad = 'Informativa')
    )
    ORDER BY 
        CASE A.Prioridad
            WHEN 'Crítica' THEN 1
            WHEN 'Alta' THEN 2
            WHEN 'Media' THEN 3
            ELSE 4
        END,
        A.FechaEvento ASC;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Obtener_Contexto_Agente]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- SP 9: Obtener Contexto para el Agente
-- ============================================================
CREATE   PROCEDURE [dbo].[SP_Obtener_Contexto_Agente]
    @CorreoUsuario NVARCHAR(150),
    @UltimasN INT = 5
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@UltimasN)
        CA.id_conversacion,
        CA.Asunto,
        CA.FechaHoraRecepcion,
        CA.TipoSolicitud,
        CA.ContenidoOriginal,
        CA.InterpretacionAgente,
        CA.RespuestaGenerada,
        CA.AccionesRealizadas,
        CA.ConfianzaRespuesta
    FROM CONVERSACION_AGENTE CA
    WHERE CA.CorreoOrigen = @CorreoUsuario
    AND CA.Estado = 'Procesada'
    ORDER BY CA.FechaHoraRecepcion DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Registrar_Conversacion_Agente]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- SP 8: Registrar Conversación del Agente
-- ============================================================
CREATE   PROCEDURE [dbo].[SP_Registrar_Conversacion_Agente]
    @CorreoOrigen NVARCHAR(150),
    @Asunto NVARCHAR(300),
    @ContenidoOriginal NVARCHAR(MAX),
    @TipoSolicitud NVARCHAR(100),
    @InterpretacionAgente NVARCHAR(MAX) = NULL,
    @RespuestaGenerada NVARCHAR(MAX) = NULL,
    @AccionesRealizadas NVARCHAR(MAX) = NULL,
    @ConfianzaRespuesta DECIMAL(3,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdUsuario INT;
    
    -- Verificar si el correo está autorizado
    SELECT @IdUsuario = id_autorizado 
    FROM USUARIOS_AUTORIZADOS 
    WHERE Correo_Electronico = @CorreoOrigen AND Estado = 1;
    
    IF @IdUsuario IS NULL
    BEGIN
        SELECT 'Usuario no autorizado' AS Error, @CorreoOrigen AS Correo;
        RETURN;
    END
    
    -- Registrar conversación
    INSERT INTO CONVERSACION_AGENTE (
        id_usuario_autorizado,
        CorreoOrigen,
        Asunto,
        FechaHoraRecepcion,
        TipoSolicitud,
        ContenidoOriginal,
        InterpretacionAgente,
        RespuestaGenerada,
        AccionesRealizadas,
        FechaHoraRespuesta,
        Estado,
        ConfianzaRespuesta
    )
    VALUES (
        @IdUsuario,
        @CorreoOrigen,
        @Asunto,
        GETDATE(),
        @TipoSolicitud,
        @ContenidoOriginal,
        @InterpretacionAgente,
        @RespuestaGenerada,
        @AccionesRealizadas,
        CASE WHEN @RespuestaGenerada IS NOT NULL THEN GETDATE() ELSE NULL END,
        CASE WHEN @RespuestaGenerada IS NOT NULL THEN 'Procesada' ELSE 'En Proceso' END,
        @ConfianzaRespuesta
    );
    
    SELECT 
        SCOPE_IDENTITY() AS id_conversacion, 
        'Conversación registrada exitosamente' AS Mensaje,
        @TipoSolicitud AS TipoSolicitud;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Reporte_Cumplimiento_EMO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- SP 5: Reporte de Cumplimiento EMO
-- ============================================================
CREATE   PROCEDURE [dbo].[SP_Reporte_Cumplimiento_EMO]
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalEmpleadosActivos INT;
    DECLARE @EmpleadosEMOVigente INT;
    DECLARE @EmpleadosEMOVencido INT;
    DECLARE @EmpleadosSinEMO INT;
    
    SELECT @TotalEmpleadosActivos = COUNT(*) 
    FROM EMPLEADO 
    WHERE Estado = 1;
    
    -- Empleados con EMO vigente
    SELECT @EmpleadosEMOVigente = COUNT(DISTINCT E.id_empleado)
    FROM EMPLEADO E
    WHERE E.Estado = 1
    AND EXISTS (
        SELECT 1 FROM EXAMEN_MEDICO EM 
        WHERE EM.id_empleado = E.id_empleado 
        AND EM.Tipo_Examen IN ('Periodico', 'Preocupacional')
        AND (EM.Fecha_Vencimiento >= CAST(GETDATE() AS DATE) OR EM.Fecha_Vencimiento IS NULL)
        AND EM.Apto_Para_Cargo = 1
        AND EM.id_examen = (
            SELECT TOP 1 id_examen FROM EXAMEN_MEDICO 
            WHERE id_empleado = E.id_empleado 
            ORDER BY Fecha_Realizacion DESC
        )
    );
    
    -- Empleados con EMO vencido
    SELECT @EmpleadosEMOVencido = COUNT(DISTINCT E.id_empleado)
    FROM EMPLEADO E
    WHERE E.Estado = 1
    AND EXISTS (
        SELECT 1 FROM EXAMEN_MEDICO EM 
        WHERE EM.id_empleado = E.id_empleado 
        AND EM.Tipo_Examen = 'Periodico'
        AND EM.Fecha_Vencimiento < CAST(GETDATE() AS DATE)
    )
    AND NOT EXISTS (
        SELECT 1 FROM EXAMEN_MEDICO EM2
        WHERE EM2.id_empleado = E.id_empleado
        AND EM2.Tipo_Examen = 'Periodico'
        AND (EM2.Fecha_Vencimiento >= CAST(GETDATE() AS DATE) OR EM2.Fecha_Vencimiento IS NULL)
    );
    
    -- Empleados sin EMO registrado
    SET @EmpleadosSinEMO = @TotalEmpleadosActivos - @EmpleadosEMOVigente - @EmpleadosEMOVencido;
    
    -- Resumen general
    SELECT 
        @TotalEmpleadosActivos AS Total_Empleados_Activos,
        @EmpleadosEMOVigente AS EMO_Vigentes,
        @EmpleadosEMOVencido AS EMO_Vencidos,
        @EmpleadosSinEMO AS Sin_EMO,
        CAST(@EmpleadosEMOVigente * 100.0 / NULLIF(@TotalEmpleadosActivos, 0) AS DECIMAL(5,2)) AS Porcentaje_Cumplimiento;
    
    -- Detalle de empleados con EMO vencido o sin EMO
    SELECT 
        E.id_empleado,
        E.NumeroDocumento,
        E.Nombre + ' ' + E.Apellidos AS NombreCompleto,
        E.Cargo,
        E.Area,
        E.Correo,
        CASE 
            WHEN EM.id_examen IS NULL THEN 'Sin EMO Registrado'
            WHEN EM.Fecha_Vencimiento < CAST(GETDATE() AS DATE) THEN 'EMO Vencido'
            ELSE 'Otro'
        END AS Estado,
        EM.Fecha_Vencimiento,
        CASE 
            WHEN EM.Fecha_Vencimiento < CAST(GETDATE() AS DATE) 
            THEN DATEDIFF(DAY, EM.Fecha_Vencimiento, GETDATE())
            ELSE NULL
        END AS DiasVencidos
    FROM EMPLEADO E
    LEFT JOIN (
        SELECT EM1.id_empleado, EM1.id_examen, EM1.Fecha_Vencimiento
        FROM EXAMEN_MEDICO EM1
        WHERE EM1.Tipo_Examen = 'Periodico'
        AND EM1.id_examen = (
            SELECT TOP 1 id_examen FROM EXAMEN_MEDICO 
            WHERE id_empleado = EM1.id_empleado AND Tipo_Examen = 'Periodico'
            ORDER BY Fecha_Realizacion DESC
        )
    ) EM ON E.id_empleado = EM.id_empleado
    WHERE E.Estado = 1
    AND (EM.id_examen IS NULL OR EM.Fecha_Vencimiento < CAST(GETDATE() AS DATE))
    ORDER BY DiasVencidos DESC, E.Nombre;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Reporte_Cumplimiento_Plan]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- SP 4: Reporte de Cumplimiento del Plan de Trabajo
-- ============================================================
CREATE   PROCEDURE [dbo].[SP_Reporte_Cumplimiento_Plan]
    @IdPlan INT = NULL,
    @Anio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @IdPlan IS NULL AND @Anio IS NOT NULL
    BEGIN
        SELECT @IdPlan = id_plan FROM PLAN_TRABAJO WHERE Anio = @Anio AND Estado = 'Vigente';
    END
    
    IF @IdPlan IS NULL
    BEGIN
        SELECT 'No se encontró plan de trabajo para el año especificado' AS Error;
        RETURN;
    END
    
    -- Resumen general
    SELECT 
        PT.Anio,
        PT.FechaElaboracion,
        PT.PresupuestoAsignado,
        PT.Estado AS EstadoPlan,
        EC.Nombre + ' ' + EC.Apellidos AS ElaboradoPor,
        EA.Nombre + ' ' + EA.Apellidos AS AprobadoPor,
        COUNT(T.id_tarea) AS Total_Tareas,
        SUM(CASE WHEN T.Estado = 'Cerrada' THEN 1 ELSE 0 END) AS Tareas_Completadas,
        SUM(CASE WHEN T.Estado = 'En Curso' THEN 1 ELSE 0 END) AS Tareas_EnCurso,
        SUM(CASE WHEN T.Estado = 'Pendiente' THEN 1 ELSE 0 END) AS Tareas_Pendientes,
        SUM(CASE WHEN T.Estado = 'Vencida' THEN 1 ELSE 0 END) AS Tareas_Vencidas,
        SUM(CASE WHEN T.Estado = 'Cancelada' THEN 1 ELSE 0 END) AS Tareas_Canceladas,
        CAST(SUM(CASE WHEN T.Estado = 'Cerrada' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(T.id_tarea), 0) AS DECIMAL(5,2)) AS Porcentaje_Cumplimiento,
        CAST(AVG(T.AvancePorc) AS DECIMAL(5,2)) AS Avance_Promedio
    FROM PLAN_TRABAJO PT
    LEFT JOIN EMPLEADO EC ON PT.ElaboradoPor = EC.id_empleado
    LEFT JOIN EMPLEADO EA ON PT.AprobadoPor = EA.id_empleado
    LEFT JOIN TAREA T ON PT.id_plan = T.id_plan
    WHERE PT.id_plan = @IdPlan
    GROUP BY PT.Anio, PT.FechaElaboracion, PT.PresupuestoAsignado, PT.Estado, 
             EC.Nombre, EC.Apellidos, EA.Nombre, EA.Apellidos;
    
    -- Detalle por tipo de tarea
    SELECT 
        T.Tipo_Tarea,
        COUNT(*) AS Total,
        SUM(CASE WHEN T.Estado = 'Cerrada' THEN 1 ELSE 0 END) AS Completadas,
        SUM(CASE WHEN T.Estado = 'Vencida' THEN 1 ELSE 0 END) AS Vencidas,
        CAST(SUM(CASE WHEN T.Estado = 'Cerrada' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Porc_Cumplimiento
    FROM TAREA T
    WHERE T.id_plan = @IdPlan
    GROUP BY T.Tipo_Tarea
    ORDER BY Porc_Cumplimiento DESC;
    
    -- Detalle por responsable
    SELECT 
        E.Nombre + ' ' + E.Apellidos AS Responsable,
        E.Area,
        COUNT(*) AS Tareas_Asignadas,
        SUM(CASE WHEN T.Estado = 'Cerrada' THEN 1 ELSE 0 END) AS Tareas_Completadas,
        SUM(CASE WHEN T.Estado = 'Vencida' THEN 1 ELSE 0 END) AS Tareas_Vencidas,
        CAST(AVG(T.AvancePorc) AS DECIMAL(5,2)) AS Avance_Promedio
    FROM TAREA T
    JOIN EMPLEADO E ON T.id_empleado_responsable = E.id_empleado
    WHERE T.id_plan = @IdPlan
    GROUP BY E.Nombre, E.Apellidos, E.Area
    ORDER BY Tareas_Completadas DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Reporte_Ejecutivo_CEO]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- SP 6: Reporte Ejecutivo para CEO
-- ============================================================
CREATE   PROCEDURE [dbo].[SP_Reporte_Ejecutivo_CEO]
    @Periodo NVARCHAR(50) = 'Mensual' -- 'Mensual', 'Trimestral', 'Anual'
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FechaInicio DATE, @FechaFin DATE;
    
    -- Determinar período
    IF @Periodo = 'Anual'
    BEGIN
        SET @FechaInicio = DATEFROMPARTS(YEAR(GETDATE()), 1, 1);
        SET @FechaFin = GETDATE();
    END
    ELSE IF @Periodo = 'Trimestral'
    BEGIN
        SET @FechaInicio = DATEADD(MONTH, -3, GETDATE());
        SET @FechaFin = GETDATE();
    END
    ELSE -- Mensual
    BEGIN
        SET @FechaInicio = DATEADD(MONTH, -1, GETDATE());
        SET @FechaFin = GETDATE();
    END
    
    -- 1. Resumen de Accidentalidad
    SELECT 
        'ACCIDENTALIDAD' AS Seccion,
        COUNT(CASE WHEN Tipo_Evento = 'Accidente de Trabajo' THEN 1 END) AS Accidentes_Trabajo,
        COUNT(CASE WHEN Tipo_Evento = 'Incidente' THEN 1 END) AS Incidentes,
        COUNT(CASE WHEN Tipo_Evento = 'Acto Inseguro' THEN 1 END) AS Actos_Inseguros,
        COUNT(CASE WHEN Tipo_Evento = 'Condición Insegura' THEN 1 END) AS Condiciones_Inseguras,
        ISNULL(SUM(Dias_Incapacidad), 0) AS Total_Dias_Incapacidad
    FROM EVENTO
    WHERE CAST(Fecha_Evento AS DATE) BETWEEN @FechaInicio AND @FechaFin;
    
    -- 2. Cumplimiento del Plan de Trabajo
    SELECT 
        'PLAN DE TRABAJO' AS Seccion,
        COUNT(*) AS Total_Tareas,
        SUM(CASE WHEN Estado = 'Cerrada' THEN 1 ELSE 0 END) AS Completadas,
        SUM(CASE WHEN Estado = 'En Curso' THEN 1 ELSE 0 END) AS En_Curso,
        SUM(CASE WHEN Estado = 'Vencida' THEN 1 ELSE 0 END) AS Vencidas,
        CAST(SUM(CASE WHEN Estado = 'Cerrada' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS Porc_Cumplimiento
    FROM TAREA
    WHERE Fecha_Creacion BETWEEN @FechaInicio AND @FechaFin
    OR (Estado NOT IN ('Cerrada', 'Cancelada') AND Fecha_Vencimiento <= @FechaFin);
    
    -- 3. Capacitaciones
    SELECT 
        'CAPACITACIONES' AS Seccion,
        COUNT(*) AS Total_Programadas,
        SUM(CASE WHEN Estado = 'Realizada' THEN 1 ELSE 0 END) AS Realizadas,
        SUM(CASE WHEN Estado = 'Cancelada' THEN 1 ELSE 0 END) AS Canceladas,
        (SELECT COUNT(DISTINCT id_empleado) FROM ASISTENCIA 
         WHERE id_capacitacion IN (
            SELECT id_capacitacion FROM CAPACITACION 
            WHERE Fecha_Realizacion BETWEEN @FechaInicio AND @FechaFin
         )) AS Empleados_Capacitados,
        (SELECT SUM(Duracion_Horas) FROM CAPACITACION 
         WHERE Estado = 'Realizada' AND Fecha_Realizacion BETWEEN @FechaInicio AND @FechaFin) AS Total_Horas_Capacitacion
    FROM CAPACITACION
    WHERE Fecha_Programada BETWEEN @FechaInicio AND @FechaFin;
    
    -- 4. Alertas Críticas y Altas Pendientes
    SELECT 
        'ALERTAS' AS Seccion,
        COUNT(CASE WHEN Prioridad = 'Crítica' THEN 1 END) AS Alertas_Criticas,
        COUNT(CASE WHEN Prioridad = 'Alta' THEN 1 END) AS Alertas_Altas,
        COUNT(*) AS Total_Alertas_Pendientes
    FROM ALERTA
    WHERE Estado IN ('Pendiente', 'Enviada')
    AND Prioridad IN ('Crítica', 'Alta');
    
    -- 5. Cumplimiento EMO
    SELECT 
        'EXAMENES MEDICOS' AS Seccion,
        (SELECT COUNT(*) FROM EMPLEADO WHERE Estado = 1) AS Total_Empleados,
        (SELECT COUNT(DISTINCT E.id_empleado)
         FROM EMPLEADO E
         WHERE E.Estado = 1
         AND EXISTS (
            SELECT 1 FROM EXAMEN_MEDICO EM 
            WHERE EM.id_empleado = E.id_empleado 
            AND (EM.Fecha_Vencimiento >= CAST(GETDATE() AS DATE) OR EM.Fecha_Vencimiento IS NULL)
         )) AS EMO_Vigentes,
        CAST((SELECT COUNT(DISTINCT E.id_empleado)
         FROM EMPLEADO E
         WHERE E.Estado = 1
         AND EXISTS (
            SELECT 1 FROM EXAMEN_MEDICO EM 
            WHERE EM.id_empleado = E.id_empleado 
            AND (EM.Fecha_Vencimiento >= CAST(GETDATE() AS DATE) OR EM.Fecha_Vencimiento IS NULL)
         )) * 100.0 / NULLIF((SELECT COUNT(*) FROM EMPLEADO WHERE Estado = 1), 0) AS DECIMAL(5,2)) AS Porc_Cumplimiento_EMO;
    
    -- 6. Hallazgos de Auditorías Abiertos
    SELECT 
        'AUDITORIAS' AS Seccion,
        COUNT(*) AS Hallazgos_Abiertos,
        SUM(CASE WHEN TipoHallazgo LIKE '%Mayor%' THEN 1 ELSE 0 END) AS NoConformidades_Mayores,
        SUM(CASE WHEN TipoHallazgo LIKE '%Menor%' THEN 1 ELSE 0 END) AS NoConformidades_Menores
    FROM HALLAZGO_AUDITORIA
    WHERE EstadoHallazgo IN ('Abierto', 'En Tratamiento');
    
    -- 7. Inspecciones Realizadas
    SELECT 
        'INSPECCIONES' AS Seccion,
        COUNT(*) AS Inspecciones_Realizadas,
        (SELECT COUNT(*) FROM HALLAZGO_INSPECCION HI
         INNER JOIN INSPECCION I ON HI.id_inspeccion = I.id_inspeccion
         WHERE I.Fecha_Inspeccion BETWEEN @FechaInicio AND @FechaFin
         AND HI.EstadoAccion IN ('Pendiente', 'En Proceso')) AS Hallazgos_Pendientes
    FROM INSPECCION
    WHERE Fecha_Inspeccion BETWEEN @FechaInicio AND @FechaFin;
END
GO
/****** Object:  Trigger [dbo].[TR_ASISTENCIA_ValidarCapacidad]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 14: Validar capacidad máxima de asistentes (Advertencia)
-- ============================================================
CREATE   TRIGGER [dbo].[TR_ASISTENCIA_ValidarCapacidad]
ON [dbo].[ASISTENCIA]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- No usar RAISERROR, solo imprimir mensaje de advertencia o crear una alerta de sistema
    DECLARE @IdCapacitacion INT;
    DECLARE @TotalAsistentes INT;
    
    SELECT @IdCapacitacion = id_capacitacion FROM inserted;
    
    SELECT @TotalAsistentes = COUNT(*) 
    FROM ASISTENCIA 
    WHERE id_capacitacion = @IdCapacitacion;
    
    IF @TotalAsistentes > 50
    BEGIN
        PRINT 'ADVERTENCIA: La capacitación ' + CAST(@IdCapacitacion AS VARCHAR) + ' tiene más de 50 asistentes registrados.';
    END
END
GO
ALTER TABLE [dbo].[ASISTENCIA] ENABLE TRIGGER [TR_ASISTENCIA_ValidarCapacidad]
GO
/****** Object:  Trigger [dbo].[TR_CAPACITACION_ValidarFechas]    Script Date: 18/12/2025 9:50:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 12: Validar que Fecha_Realizacion no sea muy posterior a Fecha_Programada
-- ============================================================
CREATE   TRIGGER [dbo].[TR_CAPACITACION_ValidarFechas]
ON [dbo].[CAPACITACION]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar que Fecha_Realizacion no sea posterior a Fecha_Programada por más de 30 días
    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE Fecha_Realizacion IS NOT NULL 
        AND Fecha_Programada IS NOT NULL
        AND Fecha_Realizacion > DATEADD(DAY, 30, Fecha_Programada)
    )
    BEGIN
        RAISERROR('La fecha de realización no puede ser más de 30 días posterior a la fecha programada.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO
ALTER TABLE [dbo].[CAPACITACION] ENABLE TRIGGER [TR_CAPACITACION_ValidarFechas]
GO
/****** Object:  Trigger [dbo].[TR_COMITE_ActualizarEstado]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 7: Actualizar Estado de Comité si venció (Al actualizar la tabla COMITE)
-- ============================================================
CREATE   TRIGGER [dbo].[TR_COMITE_ActualizarEstado]
ON [dbo].[COMITE]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Actualizar a 'Vencido' si la fecha de vigencia ya pasó
    UPDATE C
    SET Estado = 'Vencido'
    FROM COMITE C
    INNER JOIN inserted i ON C.id_comite = i.id_comite
    WHERE i.Fecha_Vigencia < CAST(GETDATE() AS DATE)
    AND i.Estado = 'Vigente';
END
GO
ALTER TABLE [dbo].[COMITE] ENABLE TRIGGER [TR_COMITE_ActualizarEstado]
GO
/****** Object:  Trigger [dbo].[TR_CONVERSACION_AGENTE_Log]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 6: Registrar en LOG_AGENTE al procesar conversación
-- ============================================================
CREATE   TRIGGER [dbo].[TR_CONVERSACION_AGENTE_Log]
ON [dbo].[CONVERSACION_AGENTE]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Registrar evento en LOG_AGENTE
    INSERT INTO LOG_AGENTE (id_conversacion, TipoEvento, Descripcion, Exitoso)
    SELECT 
        i.id_conversacion,
        CASE 
            WHEN i.Estado = 'Procesada' THEN 'Conversación Procesada'
            WHEN i.Estado = 'Error' THEN 'Error en Procesamiento'
            ELSE 'Conversación Recibida'
        END,
        'Usuario: ' + i.CorreoOrigen + ' - Tipo: ' + ISNULL(i.TipoSolicitud, 'N/A'),
        CASE WHEN i.Estado = 'Procesada' THEN 1 ELSE 0 END
    FROM inserted i;
END
GO
ALTER TABLE [dbo].[CONVERSACION_AGENTE] ENABLE TRIGGER [TR_CONVERSACION_AGENTE_Log]
GO
/****** Object:  Trigger [dbo].[TR_DOCUMENTO_ActualizarRevision]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 13: Actualizar ProximaRevision en DOCUMENTO (REHECHO)
-- ============================================================
CREATE   TRIGGER [dbo].[TR_DOCUMENTO_ActualizarRevision]
ON [dbo].[DOCUMENTO]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Actualizar ProximaRevision cuando cambie FechaUltimaRevision
    -- Usando una subquery más simple para evitar conflictos de alias
    UPDATE DOCUMENTO
    SET ProximaRevision = DATEADD(YEAR, 1, i.FechaUltimaRevision)
    FROM inserted i
    WHERE DOCUMENTO.id_documento = i.id_documento
    AND i.FechaUltimaRevision IS NOT NULL
    AND (
        -- La fecha cambió
        i.FechaUltimaRevision <> (
            SELECT d.FechaUltimaRevision 
            FROM deleted d 
            WHERE d.id_documento = i.id_documento
        )
        OR 
        -- O es la primera vez que se asigna
        NOT EXISTS (
            SELECT 1 
            FROM deleted d 
            WHERE d.id_documento = i.id_documento 
            AND d.FechaUltimaRevision IS NOT NULL
        )
    );
END
GO
ALTER TABLE [dbo].[DOCUMENTO] ENABLE TRIGGER [TR_DOCUMENTO_ActualizarRevision]
GO
/****** Object:  Trigger [dbo].[TR_DOCUMENTO_Auditoria]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 10: Auditoría de cambios de estado y versión en DOCUMENTO
-- ============================================================
CREATE   TRIGGER [dbo].[TR_DOCUMENTO_Auditoria]
ON [dbo].[DOCUMENTO]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Crear nueva versión si cambió el estado o se actualizó (Simplificado para solo cambio de estado)
    IF EXISTS (SELECT 1 FROM inserted i INNER JOIN deleted d ON i.id_documento = d.id_documento WHERE i.Estado <> d.Estado)
    BEGIN
        INSERT INTO VERSION_DOCUMENTO (id_documento, NumeroVersion, FechaVersion, Cambios, AprobadoPor)
        SELECT 
            i.id_documento,
            ISNULL((SELECT MAX(NumeroVersion) FROM VERSION_DOCUMENTO WHERE id_documento = i.id_documento), 0) + 1,
            GETDATE(),
            'Actualización: Estado cambió de "' + d.Estado + '" a "' + i.Estado + '"',
            i.Responsable
        FROM inserted i
        INNER JOIN deleted d ON i.id_documento = d.id_documento;
    END
END
GO
ALTER TABLE [dbo].[DOCUMENTO] ENABLE TRIGGER [TR_DOCUMENTO_Auditoria]
GO
/****** Object:  Trigger [dbo].[TR_EMPLEADO_ActualizarContador]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 3: Actualizar contador de empleados activos en EMPRESA
-- ============================================================
CREATE   TRIGGER [dbo].[TR_EMPLEADO_ActualizarContador]
ON [dbo].[EMPLEADO]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Actualizar el contador de empleados activos en EMPRESA
    UPDATE EMP
    SET NumeroTrabajadores = (
        SELECT COUNT(*) 
        FROM EMPLEADO 
        WHERE Estado = 1
    )
    FROM EMPRESA EMP;
END
GO
ALTER TABLE [dbo].[EMPLEADO] ENABLE TRIGGER [TR_EMPLEADO_ActualizarContador]
GO
/****** Object:  Trigger [dbo].[TR_EMPLEADO_Update]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* ==========================================================
   TRIGGERS PARA INTEGRIDAD Y AUDITORÍA DE DATOS
   ========================================================== */

-- ============================================================
-- TRIGGER 1: Actualizar Fecha_Actualizacion en EMPLEADO
-- ============================================================
CREATE   TRIGGER [dbo].[TR_EMPLEADO_Update]
ON [dbo].[EMPLEADO]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE E
    SET FechaActualizacion = GETDATE()
    FROM EMPLEADO E
    INNER JOIN inserted i ON E.id_empleado = i.id_empleado;
END
GO
ALTER TABLE [dbo].[EMPLEADO] ENABLE TRIGGER [TR_EMPLEADO_Update]
GO
/****** Object:  Trigger [dbo].[TR_EMPLEADO_ValidarInactivacion]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 16: Alerta por Inactivación de empleado con tareas activas
-- ============================================================
CREATE   TRIGGER [dbo].[TR_EMPLEADO_ValidarInactivacion]
ON [dbo].[EMPLEADO]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CorreoCoordinadorSST NVARCHAR(150);
    SELECT @CorreoCoordinadorSST = Valor FROM CONFIG_AGENTE WHERE Clave = 'CORREO_COORDINADOR_SST';

    -- Si se intenta inactivar un empleado con tareas activas, crear alerta
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN deleted d ON i.id_empleado = d.id_empleado
        WHERE i.Estado = 0 AND d.Estado = 1
        AND EXISTS (
            SELECT 1 FROM TAREA 
            WHERE id_empleado_responsable = i.id_empleado 
            AND Estado IN ('Pendiente', 'En Curso')
        )
    )
    BEGIN
        INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
        SELECT 
            'Inactivación con Tareas Pendientes', 'Alta',
            'El empleado ' + i.Nombre + ' ' + i.Apellidos + ' fue inactivado, pero tiene tareas pendientes o en curso.',
            'EMPLEADO', i.id_empleado, 'Pendiente',
            '["' + @CorreoCoordinadorSST + '"]'
        FROM inserted i
        INNER JOIN deleted d ON i.id_empleado = d.id_empleado
        WHERE i.Estado = 0 AND d.Estado = 1;
    END
END
GO
ALTER TABLE [dbo].[EMPLEADO] ENABLE TRIGGER [TR_EMPLEADO_ValidarInactivacion]
GO
/****** Object:  Trigger [dbo].[TR_ENTREGA_EPP_Stock]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 9: Reducir Stock de EPP y Crear Alerta de Stock Bajo
-- ============================================================
CREATE   TRIGGER [dbo].[TR_ENTREGA_EPP_Stock]
ON [dbo].[ENTREGA_EPP]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CorreoCoordinadorSST NVARCHAR(150);
    SELECT @CorreoCoordinadorSST = Valor FROM CONFIG_AGENTE WHERE Clave = 'CORREO_COORDINADOR_SST';
    
    -- 1. Reducir stock disponible
    UPDATE EPP
    SET Stock_Disponible = Stock_Disponible - i.Cantidad
    FROM EPP
    INNER JOIN inserted i ON EPP.id_epp = i.id_epp;
    
    -- 2. Crear alerta si el stock es bajo (menos de 10 unidades)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'Stock Bajo de EPP', 'Media',
        'El EPP "' + EPP.Nombre_EPP + '" tiene stock bajo: ' + CAST(EPP.Stock_Disponible AS VARCHAR) + ' unidades disponibles.',
        'EPP_STOCK', EPP.id_epp, 'Pendiente',
        '["' + @CorreoCoordinadorSST + '"]'
    FROM EPP
    INNER JOIN inserted i ON EPP.id_epp = i.id_epp
    WHERE EPP.Stock_Disponible < 10
    AND NOT EXISTS (
        SELECT 1 FROM ALERTA 
        WHERE ModuloOrigen = 'EPP_STOCK' 
        AND IdRelacionado = EPP.id_epp 
        AND Estado = 'Pendiente'
        AND DATEDIFF(DAY, FechaGeneracion, GETDATE()) < 7 -- Re-alerta cada 7 días
    );
END
GO
ALTER TABLE [dbo].[ENTREGA_EPP] ENABLE TRIGGER [TR_ENTREGA_EPP_Stock]
GO
/****** Object:  Trigger [dbo].[TR_EVENTO_CrearAlertaAT]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 5: Crear Alerta Crítica al Registrar Accidente de Trabajo
-- ============================================================
CREATE   TRIGGER [dbo].[TR_EVENTO_CrearAlertaAT]
ON [dbo].[EVENTO]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CorreoCoordinadorSST NVARCHAR(150);
    DECLARE @CorreoCEO NVARCHAR(150);
    
    SELECT @CorreoCoordinadorSST = Valor FROM CONFIG_AGENTE WHERE Clave = 'CORREO_COORDINADOR_SST';
    SELECT @CorreoCEO = Valor FROM CONFIG_AGENTE WHERE Clave = 'CORREO_CEO';
    
    -- Crear alerta crítica para accidentes de trabajo
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'Accidente de Trabajo Registrado', 'Crítica',
        'URGENTE: Se ha registrado un Accidente de Trabajo. Empleado: ' + E.Nombre + ' ' + E.Apellidos + 
        '. Fecha: ' + CONVERT(VARCHAR, i.Fecha_Evento, 103) + 
        '. Debe reportarse a la ARL en máximo 2 días hábiles.',
        i.Fecha_Evento, 'EVENTO_NUEVO', i.id_evento, 'Pendiente',
        '["' + @CorreoCoordinadorSST + '","' + @CorreoCEO + '"]'
    FROM inserted i
    INNER JOIN EMPLEADO E ON i.id_empleado = E.id_empleado
    WHERE i.Tipo_Evento = 'Accidente de Trabajo';
END
GO
ALTER TABLE [dbo].[EVENTO] ENABLE TRIGGER [TR_EVENTO_CrearAlertaAT]
GO
/****** Object:  Trigger [dbo].[TR_EVENTO_PreventDelete]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 8: Prevenir la eliminación de Accidentes de Trabajo (INTEGRIDAD)
-- ============================================================
CREATE   TRIGGER [dbo].[TR_EVENTO_PreventDelete]
ON [dbo].[EVENTO]
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- No permitir eliminación de eventos de accidentes de trabajo
    IF EXISTS (SELECT 1 FROM deleted WHERE Tipo_Evento = 'Accidente de Trabajo')
    BEGIN
        RAISERROR('No se pueden eliminar registros de Accidentes de Trabajo. Solo se permite actualizar el estado y la investigación.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Permitir eliminación de otros tipos (Incidentes, Actos Inseguros, etc.)
    DELETE FROM EVENTO
    WHERE id_evento IN (SELECT id_evento FROM deleted WHERE Tipo_Evento <> 'Accidente de Trabajo');
END
GO
ALTER TABLE [dbo].[EVENTO] ENABLE TRIGGER [TR_EVENTO_PreventDelete]
GO
/****** Object:  Trigger [dbo].[TR_EVENTO_SeguimientoIncapacidad]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 18: Crear alerta de seguimiento al aumentar Días_Incapacidad
-- ============================================================
CREATE   TRIGGER [dbo].[TR_EVENTO_SeguimientoIncapacidad]
ON [dbo].[EVENTO]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CorreoCoordinadorSST NVARCHAR(150);
    SELECT @CorreoCoordinadorSST = Valor FROM CONFIG_AGENTE WHERE Clave = 'CORREO_COORDINADOR_SST';
    
    -- Si Días_Incapacidad aumenta o pasa de 0 a > 0
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN deleted d ON i.id_evento = d.id_evento
        WHERE i.Tipo_Evento = 'Accidente de Trabajo'
        AND i.Dias_Incapacidad > d.Dias_Incapacidad
    )
    BEGIN
        INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
        SELECT 
            'Actualización de Incapacidad', 'Alta',
            'El accidente de trabajo del empleado ' + E.Nombre + ' ' + E.Apellidos + 
            ' ahora tiene ' + CAST(i.Dias_Incapacidad AS VARCHAR) + ' días de incapacidad. Requiere seguimiento.',
            i.Fecha_Evento, 'EVENTO_SEGUIMIENTO', i.id_evento, 'Pendiente',
            '["' + @CorreoCoordinadorSST + '"]'
        FROM inserted i
        INNER JOIN deleted d ON i.id_evento = d.id_evento
        INNER JOIN EMPLEADO E ON i.id_empleado = E.id_empleado
        WHERE i.Tipo_Evento = 'Accidente de Trabajo'
        AND i.Dias_Incapacidad > d.Dias_Incapacidad;
    END
END
GO
ALTER TABLE [dbo].[EVENTO] ENABLE TRIGGER [TR_EVENTO_SeguimientoIncapacidad]
GO
/****** Object:  Trigger [dbo].[TR_EXAMEN_MEDICO_ValidarFecha]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 4: Validar y auto-calcular Fecha de Vencimiento EMO (1 año)
-- ============================================================
CREATE   TRIGGER [dbo].[TR_EXAMEN_MEDICO_ValidarFecha]
ON [dbo].[EXAMEN_MEDICO]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Calcular fecha de vencimiento si no está definida para exámenes periódicos
    UPDATE EM
    SET Fecha_Vencimiento = DATEADD(YEAR, 1, i.Fecha_Realizacion)
    FROM EXAMEN_MEDICO EM
    INNER JOIN inserted i ON EM.id_examen = i.id_examen
    WHERE i.Tipo_Examen = 'Periodico' 
    AND i.Fecha_Vencimiento IS NULL;
END
GO
ALTER TABLE [dbo].[EXAMEN_MEDICO] ENABLE TRIGGER [TR_EXAMEN_MEDICO_ValidarFecha]
GO
/****** Object:  Trigger [dbo].[TR_FORM_DRAFTS_CleanExpired]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_FORM_DRAFTS_CleanExpired]
ON [dbo].[FORM_DRAFTS]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Set expiration date if not set (30 days from now)
    UPDATE fd
    SET expires_at = DATEADD(DAY, 30, GETDATE())
    FROM [dbo].[FORM_DRAFTS] fd
    INNER JOIN inserted i ON fd.id_draft = i.id_draft
    WHERE fd.expires_at IS NULL
    
    -- Delete expired drafts
    DELETE FROM [dbo].[FORM_DRAFTS]
    WHERE expires_at < GETDATE()
END
GO
ALTER TABLE [dbo].[FORM_DRAFTS] ENABLE TRIGGER [TR_FORM_DRAFTS_CleanExpired]
GO
/****** Object:  Trigger [dbo].[TR_FORM_SUBMISSIONS_AuditLog]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Create the corrected trigger
CREATE TRIGGER [dbo].[TR_FORM_SUBMISSIONS_AuditLog]
ON [dbo].[FORM_SUBMISSIONS]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @action NVARCHAR(20)
    
    -- Determine action type
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @action = 'UPDATE'
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @action = 'INSERT'
    ELSE
        SET @action = 'DELETE'
    
    -- For INSERT and UPDATE
    IF @action IN ('INSERT', 'UPDATE')
    BEGIN
        -- Log status changes (only for UPDATEs where status changed)
        IF @action = 'UPDATE' AND UPDATE(status)
        BEGIN
            INSERT INTO [dbo].[FORM_SUBMISSION_AUDIT] 
                ([id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at])
            SELECT 
                i.id_submission,
                'STATUS_CHANGE',
                'status',
                d.status,
                i.status,
                i.submitted_by,  -- Use submitted_by since there's no updated_by column
                GETDATE()
            FROM inserted i
            INNER JOIN deleted d ON i.id_submission = d.id_submission
            WHERE i.status <> d.status
              OR (i.status IS NULL AND d.status IS NOT NULL)
              OR (i.status IS NOT NULL AND d.status IS NULL)
        END
        
        -- Log general action for all INSERTs and UPDATEs
        INSERT INTO [dbo].[FORM_SUBMISSION_AUDIT] 
            ([id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at])
        SELECT 
            id_submission, 
            @action,
            NULL,  -- field_changed is NULL for general actions
            NULL,  -- old_value is NULL
            NULL,  -- new_value is NULL  
            submitted_by,  -- Use submitted_by as changed_by
            GETDATE()
        FROM inserted
    END
    
    -- For DELETE
    IF @action = 'DELETE'
    BEGIN
        INSERT INTO [dbo].[FORM_SUBMISSION_AUDIT] 
            ([id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at])
        SELECT 
            id_submission, 
            @action,
            NULL,
            NULL,
            NULL,
            submitted_by,  -- Use submitted_by as changed_by (or NULL if not available)
            GETDATE()
        FROM deleted
    END
END
GO
ALTER TABLE [dbo].[FORM_SUBMISSIONS] ENABLE TRIGGER [TR_FORM_SUBMISSIONS_AuditLog]
GO
/****** Object:  Trigger [dbo].[TR_FORM_SUBMISSIONS_UpdateTimestamp]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TR_FORM_SUBMISSIONS_UpdateTimestamp]
ON [dbo].[FORM_SUBMISSIONS]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE fs
    SET updated_at = GETDATE()
    FROM [dbo].[FORM_SUBMISSIONS] fs
    INNER JOIN inserted i ON fs.id_submission = i.id_submission
END
GO
ALTER TABLE [dbo].[FORM_SUBMISSIONS] ENABLE TRIGGER [TR_FORM_SUBMISSIONS_UpdateTimestamp]
GO
/****** Object:  Trigger [dbo].[TR_HALLAZGO_AUDITORIA_CrearTarea]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 11: Crear tarea automática al registrar hallazgo crítico (CORREGIDO)
-- ============================================================
CREATE   TRIGGER [dbo].[TR_HALLAZGO_AUDITORIA_CrearTarea]
ON [dbo].[HALLAZGO_AUDITORIA]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdCoordinadorSST INT;
    SELECT TOP 1 @IdCoordinadorSST = E.id_empleado -- ¡CORRECCIÓN AQUÍ!
    FROM EMPLEADO E
    INNER JOIN EMPLEADO_ROL ER ON E.id_empleado = ER.id_empleado
    INNER JOIN ROL R ON ER.id_rol = R.id_rol
    WHERE R.NombreRol = 'Coordinador SST' AND E.Estado = 1;
    
    -- Crear tarea automática para No Conformidades Mayores o Críticas
    INSERT INTO TAREA (Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea)
    SELECT 
        'Atender hallazgo de auditoría: ' + LEFT(i.Descripcion, 200),
        'Auditoría',
        GETDATE(),
        DATEADD(DAY, 30, GETDATE()), -- 30 días para atender
        'Alta', 'Pendiente',
        ISNULL(i.ResponsableArea, @IdCoordinadorSST),
        'Auditoría'
    FROM inserted i
    WHERE i.TipoHallazgo LIKE '%Mayor%' OR i.TipoHallazgo = 'Crítico';
END
GO
ALTER TABLE [dbo].[HALLAZGO_AUDITORIA] ENABLE TRIGGER [TR_HALLAZGO_AUDITORIA_CrearTarea]
GO
/****** Object:  Trigger [dbo].[TR_PLAN_TRABAJO_CerrarAnio]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 15: Actualizar estado de PLAN_TRABAJO al cierre del año
-- ============================================================
CREATE   TRIGGER [dbo].[TR_PLAN_TRABAJO_CerrarAnio]
ON [dbo].[PLAN_TRABAJO]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cerrar automáticamente planes del año anterior (Vigente -> Cerrado)
    UPDATE PT
    SET Estado = 'Cerrado'
    FROM PLAN_TRABAJO PT
    INNER JOIN inserted i ON PT.id_plan = i.id_plan
    WHERE PT.Anio < YEAR(GETDATE())
    AND PT.Estado = 'Vigente';
END
GO
ALTER TABLE [dbo].[PLAN_TRABAJO] ENABLE TRIGGER [TR_PLAN_TRABAJO_CerrarAnio]
GO
/****** Object:  Trigger [dbo].[TR_TAREA_ActualizarFecha]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- TR-1: Trigger para actualizar la fecha de modificación en la tabla TAREA
CREATE TRIGGER [dbo].[TR_TAREA_ActualizarFecha]
ON [dbo].[TAREA]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Se actualiza la fecha de actualización si hubo cambios en campos de gestión
    IF UPDATE(Descripcion) OR UPDATE(Estado) OR UPDATE(id_empleado_responsable) OR UPDATE(Observaciones_Cierre)
    BEGIN
        UPDATE T
        SET Fecha_Actualizacion = GETDATE()
        FROM TAREA T
        INNER JOIN inserted i ON T.id_tarea = i.id_tarea;
    END

    -- Si la tarea fue marcada como 'Cerrada', asegura que Fecha_Cierre se registre
    IF EXISTS (SELECT 1 FROM inserted i WHERE i.Estado = 'Cerrada')
    BEGIN
        UPDATE T
        SET Fecha_Cierre = GETDATE()
        FROM TAREA T
        INNER JOIN inserted i ON T.id_tarea = i.id_tarea
        WHERE T.Estado = 'Cerrada' AND T.Fecha_Cierre IS NULL;
    END
END
GO
ALTER TABLE [dbo].[TAREA] ENABLE TRIGGER [TR_TAREA_ActualizarFecha]
GO
/****** Object:  Trigger [dbo].[TR_TAREA_CambioResponsable]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 17: Crear alerta por cambio de responsable en TAREA
-- ============================================================
CREATE   TRIGGER [dbo].[TR_TAREA_CambioResponsable]
ON [dbo].[TAREA]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Si cambió el responsable, crear alerta para el nuevo responsable y el anterior
    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN deleted d ON i.id_tarea = d.id_tarea
        WHERE i.id_empleado_responsable <> d.id_empleado_responsable
    )
    BEGIN
        INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
        SELECT 
            'Reasignación de Tarea', 'Media',
            'La tarea "' + i.Descripcion + '" ha sido reasignada a ' + EN.Nombre + ' ' + EN.Apellidos,
            'TAREA_REASIGNADA', i.id_tarea, 'Pendiente',
            '["' + EN.Correo + '","' + EA.Correo + '"]'
        FROM inserted i
        INNER JOIN deleted d ON i.id_tarea = d.id_tarea
        INNER JOIN EMPLEADO EN ON i.id_empleado_responsable = EN.id_empleado -- Nuevo responsable
        INNER JOIN EMPLEADO EA ON d.id_empleado_responsable = EA.id_empleado -- Anterior responsable
        WHERE i.id_empleado_responsable <> d.id_empleado_responsable
        AND EN.Correo IS NOT NULL AND EA.Correo IS NOT NULL; -- Solo si tienen correo
    END
END
GO
ALTER TABLE [dbo].[TAREA] ENABLE TRIGGER [TR_TAREA_CambioResponsable]
GO
/****** Object:  Trigger [dbo].[TR_TAREA_Update]    Script Date: 18/12/2025 9:50:03 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- TRIGGER 2: Actualizar Fecha_Actualizacion y Fecha_Cierre en TAREA
-- ============================================================
CREATE   TRIGGER [dbo].[TR_TAREA_Update]
ON [dbo].[TAREA]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- 1. Actualizar Fecha_Actualizacion
    UPDATE T
    SET Fecha_Actualizacion = GETDATE()
    FROM TAREA T
    INNER JOIN inserted i ON T.id_tarea = i.id_tarea;
    
    -- 2. Registrar Fecha_Cierre si el estado cambia a 'Cerrada'
    UPDATE T
    SET Fecha_Cierre = GETDATE()
    FROM TAREA T
    INNER JOIN inserted i ON T.id_tarea = i.id_tarea
    INNER JOIN deleted d ON T.id_tarea = d.id_tarea
    WHERE i.Estado = 'Cerrada' AND d.Estado <> 'Cerrada'
    AND T.Fecha_Cierre IS NULL;
END
GO
ALTER TABLE [dbo].[TAREA] ENABLE TRIGGER [TR_TAREA_Update]
GO
USE [master]
GO
ALTER DATABASE [SG_SST_AgenteInteligente] SET  READ_WRITE 
GO
