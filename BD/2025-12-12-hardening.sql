-- SG_SST_AgenteInteligente hardening - 2025-12-12
-- Apply in target DB context.

-- 1) Modern database settings
ALTER DATABASE SG_SST_AgenteInteligente SET READ_COMMITTED_SNAPSHOT ON;
ALTER DATABASE SG_SST_AgenteInteligente SET AUTO_CLOSE OFF;
ALTER DATABASE SG_SST_AgenteInteligente SET ANSI_NULLS ON;
ALTER DATABASE SG_SST_AgenteInteligente SET ANSI_PADDING ON;
ALTER DATABASE SG_SST_AgenteInteligente SET ANSI_WARNINGS ON;
ALTER DATABASE SG_SST_AgenteInteligente SET ARITHABORT ON;
ALTER DATABASE SG_SST_AgenteInteligente SET CONCAT_NULL_YIELDS_NULL ON;
ALTER DATABASE SG_SST_AgenteInteligente SET QUOTED_IDENTIFIER ON;
-- Uncomment if point-in-time recovery is required
-- ALTER DATABASE SG_SST_AgenteInteligente SET RECOVERY FULL;

-- 2) Clean duplicate permit numbers before enforcing uniqueness
;WITH d AS (
  SELECT id_permiso,
         ROW_NUMBER() OVER (PARTITION BY NumeroPermiso ORDER BY FechaCreacion DESC, id_permiso DESC) AS rn
  FROM dbo.PERMISO_TRABAJO
)
DELETE FROM d WHERE rn > 1;

-- 3) Enforce unique permit numbers
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.PERMISO_TRABAJO') AND name = 'UX_PermisoTrabajo_NumeroPermiso'
)
BEGIN
  CREATE UNIQUE INDEX UX_PermisoTrabajo_NumeroPermiso ON dbo.PERMISO_TRABAJO(NumeroPermiso);
END

-- 4) Strengthen status domains
IF OBJECT_ID('dbo.CK_Permiso_Estado','C') IS NULL
ALTER TABLE dbo.PERMISO_TRABAJO WITH CHECK ADD CONSTRAINT CK_Permiso_Estado
  CHECK (Estado IN ('Autorizado','En Ejecucion','Cerrado','Pendiente'));

IF OBJECT_ID('dbo.CK_Tarea_Estado','C') IS NULL
ALTER TABLE dbo.TAREA WITH CHECK ADD CONSTRAINT CK_Tarea_Estado
  CHECK (Estado IN ('Cerrada','En Curso','Pendiente','Vencida','Cancelada'));

IF OBJECT_ID('dbo.CK_Alerta_Estado','C') IS NULL
ALTER TABLE dbo.ALERTA WITH CHECK ADD CONSTRAINT CK_Alerta_Estado
  CHECK (Estado IN ('Pendiente','Enviada'));

IF OBJECT_ID('dbo.CK_Alerta_Prioridad','C') IS NULL
ALTER TABLE dbo.ALERTA WITH CHECK ADD CONSTRAINT CK_Alerta_Prioridad
  CHECK (Prioridad IN ('Critica','Alta','Media','Baja'));

-- 5) Fix divide-by-zero in SP_Reporte_Cumplimiento_Plan
IF OBJECT_ID('dbo.SP_Reporte_Cumplimiento_Plan','P') IS NOT NULL
EXEC('ALTER PROCEDURE [dbo].[SP_Reporte_Cumplimiento_Plan]
    @IdPlan INT = NULL,
    @Anio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @IdPlan IS NULL AND @Anio IS NOT NULL
    BEGIN
        SELECT @IdPlan = id_plan FROM PLAN_TRABAJO WHERE Anio = @Anio AND Estado = ''Vigente'';
    END
    IF @IdPlan IS NULL
    BEGIN
        SELECT ''No se encontro plan de trabajo para el ano especificado'' AS Error;
        RETURN;
    END
    -- Resumen general
    SELECT PT.Anio, PT.FechaElaboracion, PT.PresupuestoAsignado, PT.Estado AS EstadoPlan,
           EC.Nombre + '' '' + EC.Apellidos AS ElaboradoPor,
           EA.Nombre + '' '' + EA.Apellidos AS AprobadoPor,
           COUNT(T.id_tarea) AS Total_Tareas,
           SUM(CASE WHEN T.Estado = ''Cerrada'' THEN 1 ELSE 0 END) AS Tareas_Completadas,
           SUM(CASE WHEN T.Estado = ''En Curso'' THEN 1 ELSE 0 END) AS Tareas_EnCurso,
           SUM(CASE WHEN T.Estado = ''Pendiente'' THEN 1 ELSE 0 END) AS Tareas_Pendientes,
           SUM(CASE WHEN T.Estado = ''Vencida'' THEN 1 ELSE 0 END) AS Tareas_Vencidas,
           SUM(CASE WHEN T.Estado = ''Cancelada'' THEN 1 ELSE 0 END) AS Tareas_Canceladas,
           CAST(SUM(CASE WHEN T.Estado = ''Cerrada'' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(T.id_tarea), 0) AS DECIMAL(5,2)) AS Porcentaje_Cumplimiento,
           CAST(AVG(T.AvancePorc) AS DECIMAL(5,2)) AS Avance_Promedio
    FROM PLAN_TRABAJO PT
    LEFT JOIN EMPLEADO EC ON PT.ElaboradoPor = EC.id_empleado
    LEFT JOIN EMPLEADO EA ON PT.AprobadoPor = EA.id_empleado
    LEFT JOIN TAREA T ON PT.id_plan = T.id_plan
    WHERE PT.id_plan = @IdPlan
    GROUP BY PT.Anio, PT.FechaElaboracion, PT.PresupuestoAsignado, PT.Estado,
             EC.Nombre, EC.Apellidos, EA.Nombre, EA.Apellidos;
    -- Detalle por tipo de tarea (guard divide by zero)
    SELECT T.Tipo_Tarea,
           COUNT(*) AS Total,
           SUM(CASE WHEN T.Estado = ''Cerrada'' THEN 1 ELSE 0 END) AS Completadas,
           SUM(CASE WHEN T.Estado = ''Vencida'' THEN 1 ELSE 0 END) AS Vencidas,
           CAST(SUM(CASE WHEN T.Estado = ''Cerrada'' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*),0) AS DECIMAL(5,2)) AS Porc_Cumplimiento
    FROM TAREA T
    WHERE T.id_plan = @IdPlan
    GROUP BY T.Tipo_Tarea
    ORDER BY Porc_Cumplimiento DESC;
    -- Detalle por responsable
    SELECT E.Nombre + '' '' + E.Apellidos AS Responsable,
           E.Area,
           COUNT(*) AS Tareas_Asignadas,
           SUM(CASE WHEN T.Estado = ''Cerrada'' THEN 1 ELSE 0 END) AS Tareas_Completadas,
           SUM(CASE WHEN T.Estado = ''Vencida'' THEN 1 ELSE 0 END) AS Tareas_Vencidas,
           CAST(AVG(T.AvancePorc) AS DECIMAL(5,2)) AS Avance_Promedio
    FROM TAREA T
    JOIN EMPLEADO E ON T.id_empleado_responsable = E.id_empleado
    WHERE T.id_plan = @IdPlan
    GROUP BY E.Nombre, E.Apellidos, E.Area
    ORDER BY Tareas_Completadas DESC;
END');
