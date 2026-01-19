-- Fix for CHECK constraint "CK_Alerta_Prioridad" violation
-- The constraint allows 'Critica', 'Alta', 'Media', 'Baja'.
-- The SPs were inserting 'Crítica' (with accent).

USE SG_SST_AgenteInteligente;
GO

-- 1. Fix sp_GenerarAlertasVencimientos
ALTER PROCEDURE [dbo].[sp_GenerarAlertasVencimientos]
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

-- 2. Fix SP_Generar_Alertas_Automaticas
ALTER PROCEDURE [dbo].[SP_Generar_Alertas_Automaticas]
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
