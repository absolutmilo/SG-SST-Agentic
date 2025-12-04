-- Script para poblar datos de Cumplimiento Legal (Resolución 0312)
-- Actualizado para trabajar con los datos existentes en REQUISITO_LEGAL

USE SG_SST_AgenteInteligente;
GO

-- 1. Variables para la evaluación
DECLARE @IdEvaluador INT = 101; -- Coordinador SST
DECLARE @FechaEval DATE = GETDATE();

-- 2. Limpiar evaluaciones anteriores (opcional, para reiniciar el indicador)
-- DELETE FROM EVALUACION_LEGAL;

-- 3. Insertar Evaluaciones para TODOS los requisitos existentes que no tengan evaluación reciente
INSERT INTO EVALUACION_LEGAL (id_requisito, FechaEvaluacion, EstadoCumplimiento, Evidencias, ResponsableEvaluacion, Observaciones)
SELECT 
    id_requisito,
    @FechaEval,
    CASE 
        -- Simular cumplimiento variado
        WHEN id_requisito % 3 = 0 THEN 'Cumple'
        WHEN id_requisito % 3 = 1 THEN 'Cumple Parcialmente'
        ELSE 'No Cumple'
    END,
    'Evaluación generada automáticamente para prueba de Dashboard',
    @IdEvaluador,
    'Evaluación inicial'
FROM REQUISITO_LEGAL RL
WHERE NOT EXISTS (
    SELECT 1 FROM EVALUACION_LEGAL EL 
    WHERE EL.id_requisito = RL.id_requisito
);

-- 4. Actualizar algunos registros específicos para asegurar un puntaje realista
-- Si existe el requisito de Res 0312 (id 501), marcarlo como Cumple
UPDATE EVALUACION_LEGAL 
SET EstadoCumplimiento = 'Cumple' 
WHERE id_requisito IN (SELECT id_requisito FROM REQUISITO_LEGAL WHERE Norma LIKE '%0312%');

-- Marcar Decreto 1072 como Cumple Parcialmente
UPDATE EVALUACION_LEGAL 
SET EstadoCumplimiento = 'Cumple Parcialmente' 
WHERE id_requisito IN (SELECT id_requisito FROM REQUISITO_LEGAL WHERE Norma LIKE '%1072%');

GO
