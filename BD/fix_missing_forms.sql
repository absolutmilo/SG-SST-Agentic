-- =============================================
-- SCRIPT DE CORRECCIÃ“N Y ACTUALIZACIÃ“N DE ESQUEMA
-- 1. Agrega columnas faltantes (id_formulario, requiere_formulario)
-- 2. Asigna formularios a tareas huÃ©rfanas existentes
-- =============================================
USE [SG_SST_AgenteInteligente];
GO

PRINT '=== 1. VERIFICACIÃ“N Y ACTUALIZACIÃ“N DE ESTRUCTURA ==='

-- 1. Agregar columna id_formulario si no existe
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[TAREA]') AND name = 'id_formulario')
BEGIN
    ALTER TABLE [dbo].[TAREA] ADD [id_formulario] VARCHAR(50) NULL;
    PRINT '[OK] Columna id_formulario agregada.';
END
ELSE
BEGIN
    PRINT '[INFO] La columna id_formulario ya existe.';
END

-- 2. Agregar columna requiere_formulario si no existe
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[TAREA]') AND name = 'requiere_formulario')
BEGIN
    ALTER TABLE [dbo].[TAREA] ADD [requiere_formulario] BIT DEFAULT 0 WITH VALUES;
    PRINT '[OK] Columna requiere_formulario agregada.';
END
ELSE
BEGIN
    PRINT '[INFO] La columna requiere_formulario ya existe.';
END

GO

PRINT '=== 2. ASIGNACIÃ“N DE FORMULARIOS A TAREAS ==='

-- 1. InspecciÃ³n de Botiquines
UPDATE TAREA
SET id_formulario = 'form_inspeccion_botiquin', requiere_formulario = 1
WHERE (Descripcion LIKE '%botiquin%' OR Descripcion LIKE '%botiquÃn%' OR Tipo_Tarea LIKE '%InspecciÃ³n%')
AND Descripcion LIKE '%botiqu%'
AND (id_formulario IS NULL OR id_formulario = '');

PRINT 'Botiquines actualizados: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- 2. InspecciÃ³n de Extintores
UPDATE TAREA
SET id_formulario = 'form_inspeccion_extintor', requiere_formulario = 1
WHERE (Descripcion LIKE '%extintor%' OR Tipo_Tarea LIKE '%InspecciÃ³n%')
AND Descripcion LIKE '%extintor%'
AND (id_formulario IS NULL OR id_formulario = '');

PRINT 'Extintores actualizados: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- 3. InspecciÃ³n Locativa
UPDATE TAREA
SET id_formulario = 'form_inspeccion_locativa', requiere_formulario = 1
WHERE (Descripcion LIKE '%locativa%' OR Descripcion LIKE '%instalaciones%' OR Tipo_Tarea = 'InspecciÃ³n')
AND id_formulario IS NULL 
AND Descripcion NOT LIKE '%botiqu%'
AND Descripcion NOT LIKE '%extintor%';

PRINT 'Locativas actualizados: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- 4. ExÃ¡menes MÃ©dicos (EMO)
UPDATE TAREA
SET id_formulario = 'form_examen_medico', requiere_formulario = 1
WHERE (Descripcion LIKE '%emo%' OR Descripcion LIKE '%exÃ¡men%' OR Descripcion LIKE '%mÃ©dico%' OR Tipo_Tarea = 'Salud')
AND (id_formulario IS NULL OR id_formulario = '');

PRINT 'EMOs actualizados: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- 5. Capacitaciones
UPDATE TAREA
SET id_formulario = 'form_registro_capacitacion', requiere_formulario = 1
WHERE (Descripcion LIKE '%capacitaci%' OR Descripcion LIKE '%entrenamiento%' OR Tipo_Tarea = 'CapacitaciÃ³n')
AND (id_formulario IS NULL OR id_formulario = '');

PRINT 'Capacitaciones actualizados: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- 6. Actas de ReuniÃ³n / ComitÃ©s
UPDATE TAREA
SET id_formulario = 'form_acta_reunion', requiere_formulario = 1
WHERE (Descripcion LIKE '%reuniÃ³n%' OR Descripcion LIKE '%acta%' OR Descripcion LIKE '%comitÃ©%' OR Tipo_Tarea LIKE '%ComitÃ©%')
AND (id_formulario IS NULL OR id_formulario = '');

PRINT 'Actas actualizadas: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- 7. Accidentes e Incidentes
UPDATE TAREA
SET id_formulario = 'form_accidente_trabajo', requiere_formulario = 1
WHERE (Descripcion LIKE '%accidente%' OR Tipo_Tarea LIKE '%Accidente%')
AND (id_formulario IS NULL OR id_formulario = '');

UPDATE TAREA
SET id_formulario = 'form_incidente', requiere_formulario = 1
WHERE (Descripcion LIKE '%incidente%' OR Tipo_Tarea LIKE '%Incidente%')
AND (id_formulario IS NULL OR id_formulario = '');

PRINT 'Accidentes/Incidentes actualizados: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- VerificaciÃ³n final
SELECT COUNT(*) as Tareas_Con_Formulario 
FROM TAREA 
WHERE id_formulario IS NOT NULL;

PRINT 'CorrecciÃ³n completada.'
GO
