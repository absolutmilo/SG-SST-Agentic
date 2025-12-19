-- =============================================
-- SCRIPT DE LIMPIEZA DE DATOS Y MANTENIMIENTO
-- =============================================
USE [SG_SST_AgenteInteligente];
GO

PRINT 'Iniciando limpieza de datos...'

-- 1. ELIMINAR TAREAS SIN DESCRIPCIÓN VÁLIDA
-- Estas tareas fueron generadas por un error en el agente autónomo
PRINT '1. Eliminando tareas con "Alerta sin descripción"...'
DELETE FROM TAREA 
WHERE Descripcion LIKE '%Alerta sin descripción%' 
   OR Descripcion = 'Atender alerta crítica: '
   OR Descripcion = 'Gestionar alerta: ';

PRINT '   Filas afectadas: ' + CAST(@@ROWCOUNT AS VARCHAR(10));


-- 2. ELIMINAR TAREAS DUPLICADAS (Mismo responsable, descripción y fecha)
-- Mantiene solo la más reciente (id_tarea más alto)
PRINT '2. Eliminando tareas duplicadas...'
;WITH CTE_Duplicados AS (
    SELECT 
        id_tarea,
        ROW_NUMBER() OVER (
            PARTITION BY Descripcion, id_empleado_responsable, CAST(Fecha_Creacion AS DATE) 
            ORDER BY id_tarea DESC
        ) AS RowNum
    FROM TAREA
    WHERE Tipo_Tarea IN ('Gestión Alerta', 'Salud', 'Inspección', 'Capacitación')
)
DELETE FROM CTE_Duplicados 
WHERE RowNum > 1;

PRINT '   Filas afectadas: ' + CAST(@@ROWCOUNT AS VARCHAR(10));


-- 3. LIMPIAR ALERTAS HUÉRFANAS O SIN TEXTO
PRINT '3. Limpiando tabla ALERTA...'
DELETE FROM ALERTA
WHERE Mensaje IS NULL 
   OR Mensaje = '' 
   OR Mensaje = 'Alerta sin descripción';

PRINT '   Filas afectadas: ' + CAST(@@ROWCOUNT AS VARCHAR(10));


-- 4. VERIFICACIÓN DE INTEGRIDAD
PRINT '4. Verificando integridad...'
SELECT 'Total Tareas Restantes' as Métrica, COUNT(*) as Cantidad FROM TAREA
UNION ALL
SELECT 'Tareas Pendientes', COUNT(*) FROM TAREA WHERE Estado = 'Pendiente'
UNION ALL
SELECT 'Alertas Activas', COUNT(*) FROM ALERTA WHERE Estado = 'Activa';

PRINT 'Limpieza completada exitosamente.'
GO
