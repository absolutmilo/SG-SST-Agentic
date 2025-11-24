/* ==========================================================
   FASE 20: PROCEDIMIENTOS ALMACENADOS, VISTAS Y TRIGGERS
   ========================================================== */
USE SG_SST_AgenteInteligente;
GO

-- ============================================================
-- SP 1: Monitorear Tareas Vencidas
-- ============================================================
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

-- ============================================================
-- SP 2: Generar Alertas Automáticas
-- ============================================================
CREATE OR ALTER PROCEDURE SP_Generar_Alertas_Automaticas
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
    
    -- 1. ALERTAS DE EXÁMENES MÉDICOS PRÓXIMOS A VENCER (Mejora: ISNULL para correos)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'Examen Médico Próximo a Vencer',
        CASE 
            WHEN DATEDIFF(DAY, GETDATE(), EM.Fecha_Vencimiento) <= 15 THEN 'Crítica'
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
        '["' + ISNULL(E.Correo, @CorreoCoordinadorSST) + '","' + @CorreoCoordinadorSST + '"]'
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
        AND DATEDIFF(DAY, FechaGeneracion, GETDATE()) < 7 -- Re-alerta cada 7 días
    );

    -- 2. ALERTAS DE EXÁMENES MÉDICOS VENCIDOS (Mejora: Lógica de re-alerta)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'Examen Médico Vencido',
        'Crítica',
        'URGENTE: El examen médico ' + EM.Tipo_Examen + ' de ' + E.Nombre + ' ' + E.Apellidos + 
        ' está VENCIDO desde el ' + CONVERT(VARCHAR, EM.Fecha_Vencimiento, 103) +
        ' (' + CAST(DATEDIFF(DAY, EM.Fecha_Vencimiento, GETDATE()) AS VARCHAR) + ' días de retraso)',
        EM.Fecha_Vencimiento,
        'EXAMEN_MEDICO_VENCIDO',
        EM.id_examen,
        'Pendiente',
        '["' + @CorreoCoordinadorSST + '","' + @CorreoCEO + '"]'
    FROM EXAMEN_MEDICO EM
    INNER JOIN EMPLEADO E ON E.id_empleado = EM.id_empleado
    WHERE EM.Tipo_Examen IN ('Periodico', 'Post-Incapacidad')
    AND E.Estado = 1
    AND EM.Fecha_Vencimiento < CAST(GETDATE() AS DATE)
    AND NOT EXISTS (
        SELECT 1 FROM ALERTA 
        WHERE IdRelacionado = EM.id_examen 
        AND ModuloOrigen = 'EXAMEN_MEDICO_VENCIDO' 
        AND Estado IN ('Pendiente', 'Enviada')
        AND DATEDIFF(DAY, FechaGeneracion, GETDATE()) < 7 -- Re-alerta cada 7 días
    );

    -- 3. ALERTAS DE COMITÉS PRÓXIMOS A VENCER (Mejora: Lógica de re-alerta)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'Comité Próximo a Vencer',
        CASE WHEN DATEDIFF(DAY, GETDATE(), C.Fecha_Vigencia) <= 30 THEN 'Alta' ELSE 'Media' END,
        'El ' + C.Tipo_Comite + ' conformado el ' + CONVERT(VARCHAR, C.Fecha_Conformacion, 103) + 
        ' vence el ' + CONVERT(VARCHAR, C.Fecha_Vigencia, 103) + 
        '. Se debe iniciar proceso de nueva elección (En ' + CAST(DATEDIFF(DAY, GETDATE(), C.Fecha_Vigencia) AS VARCHAR) + ' días)',
        C.Fecha_Vigencia,
        'COMITE',
        C.id_comite,
        'Pendiente',
        '["' + @CorreoCoordinadorSST + '"]'
    FROM COMITE C
    WHERE C.Estado = 'Vigente'
    AND DATEDIFF(DAY, GETDATE(), C.Fecha_Vigencia) BETWEEN 0 AND @DiasAlertaComite
    AND NOT EXISTS (
        SELECT 1 FROM ALERTA 
        WHERE IdRelacionado = C.id_comite 
        AND ModuloOrigen = 'COMITE' 
        AND Estado IN ('Pendiente', 'Enviada')
        AND DATEDIFF(DAY, FechaGeneracion, GETDATE()) < 15 -- Re-alerta cada 15 días
    );

    -- 4. ALERTAS DE TAREAS VENCIDAS (Mejora: Lógica de re-alerta)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'Tarea Vencida', T.Prioridad,
        'La tarea "' + T.Descripcion + '" asignada a ' + E.Nombre + ' ' + E.Apellidos + 
        ' está vencida desde el ' + CONVERT(VARCHAR, T.Fecha_Vencimiento, 103) +
        ' (' + CAST(DATEDIFF(DAY, T.Fecha_Vencimiento, GETDATE()) AS VARCHAR) + ' días de retraso)',
        T.Fecha_Vencimiento, 'TAREA', T.id_tarea, 'Pendiente',
        '["' + ISNULL(E.Correo, @CorreoCoordinadorSST) + '","' + @CorreoCoordinadorSST + '"]'
    FROM TAREA T
    JOIN EMPLEADO E ON T.id_empleado_responsable = E.id_empleado
    WHERE T.Estado = 'Vencida'
    AND NOT EXISTS (
        SELECT 1 FROM ALERTA 
        WHERE IdRelacionado = T.id_tarea 
        AND ModuloOrigen = 'TAREA' 
        AND Tipo = 'Tarea Vencida' -- Asegurar que solo busque alertas de tipo 'Tarea Vencida'
        AND Estado IN ('Pendiente', 'Enviada')
        AND DATEDIFF(DAY, FechaGeneracion, GETDATE()) < 3 -- Re-alerta cada 3 días
    );

    -- 5. ALERTAS DE EPP PRÓXIMO A REEMPLAZO (Mejora: Lógica de re-alerta)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'EPP Próximo a Reemplazo', 'Media',
        'El ' + EP.Nombre_EPP + ' entregado a ' + E.Nombre + ' ' + E.Apellidos + 
        ' debe reemplazarse el ' + CONVERT(VARCHAR, ENT.Fecha_Reemplazo_Estimada, 103) +
        ' (En ' + CAST(DATEDIFF(DAY, GETDATE(), ENT.Fecha_Reemplazo_Estimada) AS VARCHAR) + ' días)',
        ENT.Fecha_Reemplazo_Estimada, 'EPP', ENT.id_entrega, 'Pendiente',
        '["' + @CorreoCoordinadorSST + '"]'
    FROM ENTREGA_EPP ENT
    JOIN EMPLEADO E ON ENT.id_empleado = E.id_empleado
    JOIN EPP EP ON ENT.id_epp = EP.id_epp
    WHERE E.Estado = 1 AND ENT.Fecha_Reemplazo_Estimada IS NOT NULL
    AND DATEDIFF(DAY, GETDATE(), ENT.Fecha_Reemplazo_Estimada) BETWEEN 0 AND @DiasAlertaEPP
    AND NOT EXISTS (
        SELECT 1 FROM ALERTA 
        WHERE IdRelacionado = ENT.id_entrega 
        AND ModuloOrigen = 'EPP' 
        AND Estado IN ('Pendiente', 'Enviada')
        AND DATEDIFF(DAY, FechaGeneracion, GETDATE()) < 15 -- Re-alerta cada 15 días
    );

    -- 6. ALERTAS DE CAPACITACIONES PROGRAMADAS (Mejora: Lógica de re-alerta)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'Capacitación Programada', 'Media',
        'Recordatorio: La capacitación "' + C.Tema + '" está programada para el ' + 
        CONVERT(VARCHAR, C.Fecha_Programada, 103) + ' (' + C.Modalidad + ', ' + 
        CAST(C.Duracion_Horas AS VARCHAR) + ' horas)',
        C.Fecha_Programada, 'CAPACITACION', C.id_capacitacion, 'Pendiente',
        '["' + ISNULL(E.Correo, @CorreoCoordinadorSST) + '"]'
    FROM CAPACITACION C
    LEFT JOIN EMPLEADO E ON C.Responsable = E.id_empleado
    WHERE C.Estado = 'Programada'
    AND DATEDIFF(DAY, GETDATE(), C.Fecha_Programada) BETWEEN 0 AND 7
    AND NOT EXISTS (
        SELECT 1 FROM ALERTA 
        WHERE IdRelacionado = C.id_capacitacion 
        AND ModuloOrigen = 'CAPACITACION' 
        AND Estado IN ('Pendiente', 'Enviada')
        AND DATEDIFF(DAY, FechaGeneracion, GETDATE()) < 2 -- Re-alerta cada 2 días
    );

    -- 7. ALERTAS DE MANTENIMIENTO DE EQUIPOS (Mejora: Lógica de re-alerta)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'Mantenimiento de Equipo Programado', 'Alta',
        'El equipo "' + EQ.Nombre + '" (' + EQ.Tipo + ') requiere mantenimiento para el ' + 
        CONVERT(VARCHAR, EQ.FechaProximoMantenimiento, 103),
        EQ.FechaProximoMantenimiento, 'EQUIPO', EQ.id_equipo, 'Pendiente',
        '["' + @CorreoCoordinadorSST + '"]'
    FROM EQUIPO EQ
    WHERE EQ.Estado = 'Operativo' AND EQ.FechaProximoMantenimiento IS NOT NULL
    AND DATEDIFF(DAY, GETDATE(), EQ.FechaProximoMantenimiento) BETWEEN 0 AND 15
    AND NOT EXISTS (
        SELECT 1 FROM ALERTA 
        WHERE IdRelacionado = EQ.id_equipo 
        AND ModuloOrigen = 'EQUIPO' 
        AND Estado IN ('Pendiente', 'Enviada')
        AND DATEDIFF(DAY, FechaGeneracion, GETDATE()) < 7 -- Re-alerta cada 7 días
    );

    -- 8. ALERTAS DE ACCIDENTES NO REPORTADOS A ARL (Nueva, excelente lógica)
    INSERT INTO ALERTA (Tipo, Prioridad, Descripcion, FechaEvento, ModuloOrigen, IdRelacionado, Estado, DestinatariosCorreo)
    SELECT 
        'Accidente sin Reportar ARL', 'Crítica',
        'URGENTE: Accidente de Trabajo de ' + E.Nombre + ' ' + E.Apellidos + 
        ' ocurrido el ' + CONVERT(VARCHAR, EV.Fecha_Evento, 103) + 
        ' NO ha sido reportado a la ARL. Plazo legal: 2 días hábiles',
        EV.Fecha_Evento, 'EVENTO_ARL', EV.id_evento, 'Pendiente',
        '["' + @CorreoCoordinadorSST + '","' + @CorreoCEO + '"]'
    FROM EVENTO EV
    JOIN EMPLEADO E ON EV.id_empleado = E.id_empleado
    WHERE EV.Tipo_Evento = 'Accidente de Trabajo'
    AND EV.Reportado_ARL = 0
    AND DATEDIFF(DAY, EV.Fecha_Evento, GETDATE()) >= 1 -- A partir de 1 día de ocurrido
    AND NOT EXISTS (
        SELECT 1 FROM ALERTA 
        WHERE IdRelacionado = EV.id_evento 
        AND ModuloOrigen = 'EVENTO_ARL' 
        AND Estado IN ('Pendiente', 'Enviada')
    );

    -- Retornar resumen de alertas generadas
    SELECT 
        COUNT(*) AS TotalAlertasGeneradas,
        SUM(CASE WHEN Prioridad = 'Crítica' THEN 1 ELSE 0 END) AS Criticas,
        SUM(CASE WHEN Prioridad = 'Alta' THEN 1 ELSE 0 END) AS Altas,
        SUM(CASE WHEN Prioridad = 'Media' THEN 1 ELSE 0 END) AS Medias,
        SUM(CASE WHEN Prioridad = 'Informativa' THEN 1 ELSE 0 END) AS Informativas
    FROM ALERTA
    WHERE CAST(FechaGeneracion AS DATE) = CAST(GETDATE() AS DATE);
END
GO

-- ============================================================
-- SP 3: Calcular Indicadores de Siniestralidad (Mejora: Cálculo HHT)
-- ============================================================
CREATE OR ALTER PROCEDURE SP_Calcular_Indicadores_Siniestralidad
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
        ELSE -- Manejo de mes (si se pasa '1', '2', etc.)
        BEGIN
             DECLARE @Mes INT = TRY_CAST(@Periodo AS INT);
             IF @Mes IS NOT NULL AND @Mes BETWEEN 1 AND 12
             BEGIN
                 SET @FechaInicio = DATEFROMPARTS(@Anio, @Mes, 1);
                 SET @FechaFin = EOMONTH(@FechaInicio);
             END
             ELSE
             BEGIN
                 SET @FechaInicio = DATEFROMPARTS(@Anio, 1, 1);
                 SET @FechaFin = DATEFROMPARTS(@Anio, 12, 31);
             END
        END
    END
    
    -- Calcular métricas de accidentalidad
    SELECT 
        @NumAccidentes = COUNT(CASE WHEN Tipo_Evento = 'Accidente de Trabajo' THEN 1 END),
        @DiasIncapacidad = ISNULL(SUM(CASE WHEN Tipo_Evento = 'Accidente de Trabajo' THEN Dias_Incapacidad ELSE 0 END), 0),
        @NumIncidentes = COUNT(CASE WHEN Tipo_Evento = 'Incidente' THEN 1 END)
    FROM EVENTO 
    WHERE CAST(Fecha_Evento AS DATE) BETWEEN @FechaInicio AND @FechaFin;

    -- Calcular promedio de trabajadores (Fuente principal: Contador de EMPRESA)
    SELECT @PromedioTrabajadores = CAST(AVG(CAST(NumeroTrabajadores AS FLOAT)) AS FLOAT)
    FROM EMPRESA;
    
    -- Plan B: Si no hay dato en EMPRESA (o es 0), contar empleados activos
    IF @PromedioTrabajadores IS NULL OR @PromedioTrabajadores = 0
    BEGIN
        SELECT @PromedioTrabajadores = CAST(COUNT(*) AS FLOAT) FROM EMPLEADO WHERE Estado = 1;
    END
    
    -- Calcular HHT (Horas Hombre Trabajadas) - Usando 22 días laborables/mes
    DECLARE @Meses INT = DATEDIFF(MONTH, @FechaInicio, @FechaFin) + 1;
    SET @HorasHombreTrabajadas = @PromedioTrabajadores * 8 * 22 * @Meses;

    -- Calcular indicadores
    DECLARE @IF FLOAT = 0; -- Índice de Frecuencia
    DECLARE @IS FLOAT = 0; -- Índice de Severidad
    DECLARE @ILI FLOAT = 0; -- Índice de Lesiones Incapacitantes
    
    IF @HorasHombreTrabajadas > 0
    BEGIN
        SET @IF = (@NumAccidentes * 200000.0) / @HorasHombreTrabajadas; -- Base 200,000 HHT
        SET @IS = (@DiasIncapacidad * 200000.0) / @HorasHombreTrabajadas; -- Base 200,000 HHT
        SET @ILI = (@IF * @IS) / 1000.0;
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

-- ============================================================
-- SP 4: Reporte de Cumplimiento del Plan de Trabajo (Mejora: Consistencia en búsqueda)
-- ============================================================
CREATE OR ALTER PROCEDURE SP_Reporte_Cumplimiento_Plan
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

-- ============================================================
-- SP 5: Reporte de Cumplimiento EMO (Mejora: Lógica de último EMO)
-- ============================================================
CREATE OR ALTER PROCEDURE SP_Reporte_Cumplimiento_EMO
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalEmpleadosActivos INT;
    
    -- Empleados activos
    SELECT @TotalEmpleadosActivos = COUNT(*) FROM EMPLEADO WHERE Estado = 1;
    
    -- CTE para obtener el ÚLTIMO EMO Periodico/Preocupacional
    WITH UltimoEMO AS (
        SELECT 
            EM.id_empleado,
            EM.Fecha_Vencimiento,
            EM.Apto_Para_Cargo,
            ROW_NUMBER() OVER(PARTITION BY EM.id_empleado ORDER BY EM.Fecha_Realizacion DESC) as rn
        FROM EXAMEN_MEDICO EM
        WHERE EM.Tipo_Examen IN ('Periodico', 'Preocupacional')
    )
    
    -- Resumen general
    SELECT 
        @TotalEmpleadosActivos AS Total_Empleados_Activos,
        COUNT(CASE WHEN UEMO.rn = 1 AND UEMO.Apto_Para_Cargo = 1 AND (UEMO.Fecha_Vencimiento >= CAST(GETDATE() AS DATE) OR UEMO.Fecha_Vencimiento IS NULL) THEN E.id_empleado END) AS EMO_Vigentes,
        COUNT(CASE WHEN UEMO.rn = 1 AND UEMO.Fecha_Vencimiento < CAST(GETDATE() AS DATE) THEN E.id_empleado END) AS EMO_Vencidos,
        @TotalEmpleadosActivos - COUNT(CASE WHEN UEMO.rn = 1 THEN E.id_empleado END) AS Sin_EMO_Registrado,
        CAST(COUNT(CASE WHEN UEMO.rn = 1 AND UEMO.Apto_Para_Cargo = 1 AND (UEMO.Fecha_Vencimiento >= CAST(GETDATE() AS DATE) OR UEMO.Fecha_Vencimiento IS NULL) THEN E.id_empleado END) * 100.0 / NULLIF(@TotalEmpleadosActivos, 0) AS DECIMAL(5,2)) AS Porcentaje_Cumplimiento
    INTO #ResumenEMO
    FROM EMPLEADO E
    LEFT JOIN UltimoEMO UEMO ON E.id_empleado = UEMO.id_empleado
    WHERE E.Estado = 1;
    
    SELECT * FROM #ResumenEMO;
    
    -- Detalle de empleados con EMO vencido o sin EMO
    WITH UltimoEMODetalle AS (
        SELECT 
            EM.id_empleado,
            EM.Fecha_Vencimiento,
            EM.Tipo_Examen,
            ROW_NUMBER() OVER(PARTITION BY EM.id_empleado ORDER BY EM.Fecha_Realizacion DESC) as rn
        FROM EXAMEN_MEDICO EM
        WHERE EM.Tipo_Examen IN ('Periodico', 'Preocupacional')
    )
    SELECT 
        E.id_empleado, E.NumeroDocumento, E.Nombre + ' ' + E.Apellidos AS NombreCompleto, E.Cargo, E.Area, E.Correo, 
        UEMOD.Fecha_Vencimiento,
        CASE 
            WHEN UEMOD.id_empleado IS NULL THEN 'Sin EMO Registrado'
            WHEN UEMOD.Fecha_Vencimiento < CAST(GETDATE() AS DATE) THEN 'EMO Vencido'
            ELSE 'Vigente (Advertencia)'
        END AS EstadoEMO,
        CASE 
            WHEN UEMOD.Fecha_Vencimiento < CAST(GETDATE() AS DATE) THEN DATEDIFF(DAY, UEMOD.Fecha_Vencimiento, GETDATE())
            ELSE NULL
        END AS DiasVencidos
    FROM EMPLEADO E
    LEFT JOIN UltimoEMODetalle UEMOD ON E.id_empleado = UEMOD.id_empleado AND UEMOD.rn = 1
    WHERE E.Estado = 1
    AND (UEMOD.id_empleado IS NULL OR UEMOD.Fecha_Vencimiento < CAST(GETDATE() AS DATE))
    ORDER BY DiasVencidos DESC, E.Nombre;
    
    DROP TABLE #ResumenEMO;
END
GO

-- ============================================================
-- SP 6: Reporte Ejecutivo para CEO (CORREGIDO Y ESTABLE)
-- ============================================================
CREATE OR ALTER PROCEDURE SP_Reporte_Ejecutivo_CEO
    @Periodo NVARCHAR(50) = 'Trimestral' -- 'Mensual', 'Trimestral', 'Anual'
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @FechaInicio DATE, @FechaFin DATE;
    
    -- Determinar período
    IF @Periodo = 'Anual'
    BEGIN
        SET @FechaInicio = DATEFROMPARTS(YEAR(GETDATE()), 1, 1);
        SET @FechaFin = CAST(GETDATE() AS DATE);
    END
    ELSE IF @Periodo = 'Trimestral'
    BEGIN
        SET @FechaFin = CAST(GETDATE() AS DATE);
        -- Calcula el inicio del trimestre anterior (hace 3 meses)
        SET @FechaInicio = DATEADD(month, DATEDIFF(month, 0, @FechaFin) - 3, 0); 
    END
    ELSE -- Mensual (Últimos 30 días aproximadamente, o mes anterior)
    BEGIN
        SET @FechaFin = CAST(GETDATE() AS DATE);
        -- Calcula el inicio del mes anterior
        SET @FechaInicio = DATEADD(month, DATEDIFF(month, 0, @FechaFin) - 1, 0); 
    END
    
    -- Ejecutar SP Siniestralidad (para obtener IF/IS)
    IF OBJECT_ID('tempdb..#Siniestralidad') IS NOT NULL DROP TABLE #Siniestralidad;
    
    CREATE TABLE #Siniestralidad (
        Anio INT, 
        Periodo NVARCHAR(20), 
        Indice_Frecuencia_IF DECIMAL(10,2), 
        Indice_Severidad_IS DECIMAL(10,2), 
        Indice_Lesiones_Incapacitantes_ILI DECIMAL(10,2), 
        Accidentes_Trabajo INT, 
        Dias_Incapacidad INT, 
        Promedio_Trabajadores INT, 
        HHT_Estimadas DECIMAL(15,2), 
        Interpretacion_IF NVARCHAR(50)
    );
    -- Se pasa el año actual y el periodo
    INSERT INTO #Siniestralidad (Anio, Periodo, Indice_Frecuencia_IF, Indice_Severidad_IS, Indice_Lesiones_Incapacitantes_ILI, Accidentes_Trabajo, Dias_Incapacidad, Promedio_Trabajadores, HHT_Estimadas, Interpretacion_IF)
    EXEC SP_Calcular_Indicadores_Siniestralidad @Anio = NULL, @Periodo = @Periodo;

    -- 1. Indicadores Clave
    SELECT 
        'INDICADORES CLAVE' AS Seccion,
        S.Indice_Frecuencia_IF,
        S.Indice_Severidad_IS,
        S.Indice_Lesiones_Incapacitantes_ILI,
        S.Accidentes_Trabajo,
        S.Dias_Incapacidad,
        S.Interpretacion_IF,
        (SELECT COUNT(*) FROM EMPLEADO WHERE Estado = 1) AS Total_Empleados
    FROM #Siniestralidad S;
    
    -- 2. Cumplimiento Operacional (Plan y Tareas Vencidas)
    SELECT 
        'CUMPLIMIENTO OPERACIONAL' AS Seccion,
        COUNT(T.id_tarea) AS Total_Tareas_Activas,
        SUM(CASE WHEN T.Estado = 'Cerrada' THEN 1 ELSE 0 END) AS Completadas_Periodo,
        SUM(CASE WHEN T.Estado = 'Vencida' THEN 1 ELSE 0 END) AS Total_Tareas_Vencidas,
        CAST(SUM(CASE WHEN T.Estado = 'Cerrada' THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(T.id_tarea), 0) AS DECIMAL(5,2)) AS Porc_Cumplimiento_General,
        (SELECT COUNT(*) FROM ALERTA WHERE Estado = 'Pendiente' AND Prioridad IN ('Crítica', 'Alta')) AS Alertas_Criticas_Pendientes
    FROM TAREA T
    WHERE T.Fecha_Creacion BETWEEN @FechaInicio AND @FechaFin
    OR T.Estado NOT IN ('Cerrada', 'Cancelada');

    -- 3. Estado de Recursos y Vigilancia
    SELECT 
        'RECURSOS Y VIGILANCIA' AS Seccion,
        (SELECT COUNT(*) FROM EQUIPO WHERE Tipo = 'Extintores' AND Estado = 'Operativo' AND FechaProximoMantenimiento < DATEADD(DAY, 30, GETDATE())) AS Extintores_Vigencia_Baja,
        (SELECT COUNT(*) FROM REQUISITO_LEGAL WHERE Vigente = 1) AS Total_Requisitos_Legales,
        (SELECT COUNT(DISTINCT id_empleado) FROM MIEMBRO_COMITE) AS Miembros_Comite,
        (SELECT COUNT(*) FROM HALLAZGO_AUDITORIA WHERE EstadoHallazgo IN ('Abierto', 'En Tratamiento')) AS Hallazgos_Auditoria_Abiertos
    
    IF OBJECT_ID('tempdb..#Siniestralidad') IS NOT NULL DROP TABLE #Siniestralidad;
END
GO

-- ============================================================
-- SP 7: Crear Tarea desde Correo del Agente (Mejora: Manejo de Nombres)
-- ============================================================
CREATE OR ALTER PROCEDURE SP_Crear_Tarea_Desde_Correo
    @Descripcion NVARCHAR(MAX),
    @FechaVencimiento DATE,
    @IdResponsable INT,
    @Prioridad NVARCHAR(20) = 'Media',
    @TipoTarea NVARCHAR(100) = 'Solicitud IA', -- Ajustado Origen a 'Solicitud IA'
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
        'Solicitud IA'
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
        E.Nombre + ' ' + E.Apellidos AS Responsable,
        E.Correo AS CorreoResponsable
    FROM EMPLEADO E
    WHERE E.id_empleado = @IdResponsable;
END
GO

-- ============================================================
-- SP 8: Registrar Conversación del Agente
-- ============================================================
CREATE OR ALTER PROCEDURE SP_Registrar_Conversacion_Agente
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

-- ============================================================
-- SP 9: Obtener Contexto para el Agente
-- ============================================================
CREATE OR ALTER PROCEDURE SP_Obtener_Contexto_Agente
    @CorreoUsuario NVARCHAR(150),
    @UltimasN INT = 5
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@UltimasN)
        CA.id_conversacion, CA.Asunto, CA.FechaHoraRecepcion, CA.TipoSolicitud,
        CA.ContenidoOriginal, CA.InterpretacionAgente, CA.RespuestaGenerada, 
        CA.AccionesRealizadas, CA.ConfianzaRespuesta
    FROM CONVERSACION_AGENTE CA
    WHERE CA.CorreoOrigen = @CorreoUsuario
    AND CA.Estado = 'Procesada'
    ORDER BY CA.FechaHoraRecepcion DESC;
END
GO

-- ============================================================
-- SP 10: Marcar Alertas como Enviadas
-- ============================================================
CREATE OR ALTER PROCEDURE SP_Marcar_Alertas_Enviadas
    @IdsAlertas NVARCHAR(MAX), -- Lista de IDs separados por coma
    @TipoNotificacion NVARCHAR(50) = 'Correo'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Actualizar estado de las alertas
    UPDATE ALERTA
    SET Estado = 'Enviada',
        Enviada = 1,
        FechaEnvio = GETDATE(),
        IntentosEnvio = IntentosEnvio + 1
    WHERE id_alerta IN (SELECT TRY_CAST(value AS INT) FROM STRING_SPLIT(@IdsAlertas, ','));
    
    -- Registrar en historial
    INSERT INTO HISTORIAL_NOTIFICACION (id_alerta, TipoNotificacion, Destinatarios, FechaEnvio, EstadoEnvio)
    SELECT 
        id_alerta,
        @TipoNotificacion,
        DestinatariosCorreo,
        GETDATE(),
        'Exitoso'
    FROM ALERTA
    WHERE id_alerta IN (SELECT TRY_CAST(value AS INT) FROM STRING_SPLIT(@IdsAlertas, ','));
    
    SELECT COUNT(*) AS AlertasActualizadas 
    FROM ALERTA
    WHERE id_alerta IN (SELECT TRY_CAST(value AS INT) FROM STRING_SPLIT(@IdsAlertas, ','));
END
GO

-- ============================================================
-- SP 11: Obtener Alertas Pendientes de Envío
-- ============================================================
CREATE OR ALTER PROCEDURE SP_Obtener_Alertas_Pendientes
    @LimitePrioridad NVARCHAR(20) = 'Media'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Uso de CTE para obtener datos de origen y evitar repeticiones de subconsultas
    WITH AlertasPendientes AS (
        SELECT 
            A.id_alerta, A.Tipo, A.Prioridad, A.Descripcion, A.FechaGeneracion, A.FechaEvento, A.ModuloOrigen, A.IdRelacionado, A.DestinatariosCorreo,
            CASE A.ModuloOrigen
                WHEN 'EXAMEN_MEDICO' THEN (SELECT E.Nombre + ' ' + E.Apellidos FROM EXAMEN_MEDICO EM JOIN EMPLEADO E ON EM.id_empleado = E.id_empleado WHERE EM.id_examen = A.IdRelacionado)
                WHEN 'TAREA' THEN (SELECT E.Nombre + ' ' + E.Apellidos FROM TAREA T JOIN EMPLEADO E ON T.id_empleado_responsable = E.id_empleado WHERE T.id_tarea = A.IdRelacionado)
                WHEN 'EVENTO_ARL' THEN (SELECT E.Nombre + ' ' + E.Apellidos FROM EVENTO EV JOIN EMPLEADO E ON EV.id_empleado = E.id_empleado WHERE EV.id_evento = A.IdRelacionado)
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
    )
    SELECT *
    FROM AlertasPendientes
    ORDER BY 
        CASE Prioridad
            WHEN 'Crítica' THEN 1
            WHEN 'Alta' THEN 2
            WHEN 'Media' THEN 3
            ELSE 4
        END,
        FechaEvento ASC;
END
GO

/* ==========================================================
   VISTAS PARA CONSULTAS RÁPIDAS DEL AGENTE
   ========================================================== */

-- ============================================================
-- VISTA 1: Empleados Activos con Información Completa
-- ============================================================
CREATE OR ALTER VIEW VW_Empleados_Activos AS
SELECT 
    E.id_empleado, E.NumeroDocumento, E.Nombre + ' ' + E.Apellidos AS NombreCompleto, E.Nombre, E.Apellidos, E.Cargo, E.Area, 
    E.Correo, E.Telefono, E.TipoContrato, E.Nivel_Riesgo_Laboral, S.NombreSede, S.Ciudad, S.Departamento, E.Fecha_Ingreso, 
    DATEDIFF(YEAR, E.Fecha_Ingreso, GETDATE()) AS AniosAntiguedad, E.ContactoEmergencia, E.TelefonoEmergencia, 
    SUP.Nombre + ' ' + SUP.Apellidos AS Supervisor
FROM EMPLEADO E
INNER JOIN SEDE S ON E.id_sede = S.id_sede
LEFT JOIN EMPLEADO SUP ON E.id_supervisor = SUP.id_empleado
WHERE E.Estado = 1;
GO

-- ============================================================
-- VISTA 2: Dashboard de Alertas Pendientes
-- ============================================================
CREATE OR ALTER VIEW VW_Dashboard_Alertas AS
SELECT 
    A.id_alerta, A.Tipo, A.Prioridad, A.Descripcion, A.FechaGeneracion, A.FechaEvento, 
    DATEDIFF(DAY, GETDATE(), A.FechaEvento) AS DiasHastaEvento, A.Estado, A.ModuloOrigen, 
    A.IdRelacionado, A.Enviada, A.IntentosEnvio, 
    CASE A.ModuloOrigen
        WHEN 'EXAMEN_MEDICO' THEN CONCAT('EMO: ', EM.Tipo_Examen, ' - ', E1.Nombre)
        WHEN 'EXAMEN_MEDICO_VENCIDO' THEN CONCAT('EMO VENCIDO: ', EM.Tipo_Examen, ' - ', E1.Nombre)
        WHEN 'TAREA' THEN CONCAT('Tarea: ', T.Tipo_Tarea, ' - ', E2.Nombre)
        WHEN 'COMITE' THEN CONCAT('Comité: ', C.Tipo_Comite)
        WHEN 'EPP' THEN CONCAT('EPP: ', EP.Nombre_EPP)
        WHEN 'CAPACITACION' THEN CONCAT('Capacitación: ', CAP.Tema)
        WHEN 'EQUIPO' THEN CONCAT('Equipo: ', EQ.Nombre)
        WHEN 'EVENTO_ARL' THEN 'Accidente sin Reportar ARL'
        WHEN 'EVENTO_NUEVO' THEN 'Nuevo Accidente'
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

-- ============================================================
-- VISTA 3: Indicadores en Tiempo Real (KPIs)
-- ============================================================
CREATE OR ALTER VIEW VW_Indicadores_Tiempo_Real AS
SELECT 
    (SELECT COUNT(*) FROM EMPLEADO WHERE Estado = 1) AS Total_Empleados_Activos,
    (SELECT COUNT(*) FROM EVENTO WHERE Tipo_Evento = 'Accidente de Trabajo' AND YEAR(Fecha_Evento) = YEAR(GETDATE())) AS Accidentes_AnioActual,
    (SELECT ISNULL(SUM(Dias_Incapacidad), 0) FROM EVENTO WHERE Tipo_Evento = 'Accidente de Trabajo' AND YEAR(Fecha_Evento) = YEAR(GETDATE())) AS Dias_Incapacidad_AnioActual,
    (SELECT COUNT(*) FROM TAREA WHERE Estado = 'Vencida') AS Tareas_Vencidas,
    (SELECT COUNT(*) FROM TAREA WHERE Estado IN ('Pendiente', 'En Curso')) AS Tareas_Activas,
    (SELECT COUNT(*) FROM ALERTA WHERE Prioridad = 'Crítica' AND Estado = 'Pendiente') AS Alertas_Criticas_Pendientes,
    (SELECT COUNT(*) FROM ALERTA WHERE Prioridad IN ('Crítica', 'Alta') AND Estado = 'Pendiente') AS Alertas_Urgentes_Pendientes,
    (SELECT COUNT(DISTINCT E.id_empleado) FROM EMPLEADO E 
     WHERE E.Estado = 1 AND EXISTS (SELECT 1 FROM EXAMEN_MEDICO EM WHERE EM.id_empleado = E.id_empleado AND (EM.Fecha_Vencimiento >= CAST(GETDATE() AS DATE) OR EM.Fecha_Vencimiento IS NULL))) AS Empleados_EMO_Vigente,
    (SELECT COUNT(*) FROM CAPACITACION WHERE Estado = 'Realizada' AND YEAR(Fecha_Realizacion) = YEAR(GETDATE())) AS Capacitaciones_Realizadas_AnioActual,
    (SELECT COUNT(*) FROM HALLAZGO_AUDITORIA WHERE EstadoHallazgo IN ('Abierto', 'En Tratamiento')) AS Hallazgos_Auditoria_Abiertos,
    (SELECT COUNT(*) FROM COMITE WHERE Estado = 'Vigente') AS Comites_Vigentes,
    GETDATE() AS Fecha_Actualizacion;
GO

-- ============================================================
-- VISTA 4: Resumen de Tareas por Responsable
-- ============================================================
CREATE OR ALTER VIEW VW_Tareas_Por_Responsable AS
SELECT 
    E.id_empleado, E.Nombre + ' ' + E.Apellidos AS Responsable, E.Area, E.Correo, 
    COUNT(*) AS Total_Tareas,
    SUM(CASE WHEN T.Estado = 'Pendiente' THEN 1 ELSE 0 END) AS Pendientes,
    SUM(CASE WHEN T.Estado = 'En Curso' THEN 1 ELSE 0 END) AS En_Curso,
    SUM(CASE WHEN T.Estado = 'Cerrada' THEN 1 ELSE 0 END) AS Cerradas,
    SUM(CASE WHEN T.Estado = 'Vencida' THEN 1 ELSE 0 END) AS Vencidas,
    CAST(AVG(T.AvancePorc) AS DECIMAL(5,2)) AS Avance_Promedio,
    MAX(T.Fecha_Actualizacion) AS Ultima_Actualizacion
FROM EMPLEADO E
INNER JOIN TAREA T ON E.id_empleado = T.id_empleado_responsable
WHERE E.Estado = 1
GROUP BY E.id_empleado, E.Nombre, E.Apellidos, E.Area, E.Correo;
GO

-- ============================================================
-- VISTA 5: Historial de Accidentalidad
-- ============================================================
CREATE OR ALTER VIEW VW_Historial_Accidentalidad AS
SELECT 
    EV.id_evento, EV.Tipo_Evento, EV.Fecha_Evento, YEAR(EV.Fecha_Evento) AS Anio, MONTH(EV.Fecha_Evento) AS Mes, DATENAME(MONTH, EV.Fecha_Evento) AS Nombre_Mes, 
    E.Nombre + ' ' + E.Apellidos AS Empleado, E.Area, E.Cargo, EV.Lugar_Evento, EV.Descripcion_Evento, EV.Parte_Cuerpo_Afectada, 
    EV.Naturaleza_Lesion, EV.Dias_Incapacidad, EV.ClasificacionIncapacidad, EV.Reportado_ARL, EV.Fecha_Reporte_ARL, 
    EV.Estado_Investigacion, EV.Causas_Inmediatas, EV.Causas_Basicas
FROM EVENTO EV
INNER JOIN EMPLEADO E ON EV.id_empleado = E.id_empleado;
GO

/* ==========================================================
   TRIGGERS PARA INTEGRIDAD Y AUDITORÍA DE DATOS
   ========================================================== */

-- ============================================================
-- TRIGGER 1: Actualizar Fecha_Actualizacion en EMPLEADO
-- ============================================================
CREATE OR ALTER TRIGGER TR_EMPLEADO_Update
ON EMPLEADO
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

-- ============================================================
-- TRIGGER 2: Actualizar Fecha_Actualizacion y Fecha_Cierre en TAREA
-- ============================================================
CREATE OR ALTER TRIGGER TR_TAREA_Update
ON TAREA
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

-- ============================================================
-- TRIGGER 3: Actualizar contador de empleados activos en EMPRESA
-- ============================================================
CREATE OR ALTER TRIGGER TR_EMPLEADO_ActualizarContador
ON EMPLEADO
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

-- ============================================================
-- TRIGGER 4: Validar y auto-calcular Fecha de Vencimiento EMO (1 año)
-- ============================================================
CREATE OR ALTER TRIGGER TR_EXAMEN_MEDICO_ValidarFecha
ON EXAMEN_MEDICO
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

-- ============================================================
-- TRIGGER 5: Crear Alerta Crítica al Registrar Accidente de Trabajo
-- ============================================================
CREATE OR ALTER TRIGGER TR_EVENTO_CrearAlertaAT
ON EVENTO
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

-- ============================================================
-- TRIGGER 6: Registrar en LOG_AGENTE al procesar conversación
-- ============================================================
CREATE OR ALTER TRIGGER TR_CONVERSACION_AGENTE_Log
ON CONVERSACION_AGENTE
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

-- ============================================================
-- TRIGGER 7: Actualizar Estado de Comité si venció (Al actualizar la tabla COMITE)
-- ============================================================
CREATE OR ALTER TRIGGER TR_COMITE_ActualizarEstado
ON COMITE
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

-- ============================================================
-- TRIGGER 8: Prevenir la eliminación de Accidentes de Trabajo (INTEGRIDAD)
-- ============================================================
CREATE OR ALTER TRIGGER TR_EVENTO_PreventDelete
ON EVENTO
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

-- ============================================================
-- TRIGGER 9: Reducir Stock de EPP y Crear Alerta de Stock Bajo
-- ============================================================
CREATE OR ALTER TRIGGER TR_ENTREGA_EPP_Stock
ON ENTREGA_EPP
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

-- ============================================================
-- TRIGGER 10: Auditoría de cambios de estado y versión en DOCUMENTO
-- ============================================================
CREATE OR ALTER TRIGGER TR_DOCUMENTO_Auditoria
ON DOCUMENTO
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

-- ============================================================
-- TRIGGER 11: Crear tarea automática al registrar hallazgo crítico (CORREGIDO)
-- ============================================================
CREATE OR ALTER TRIGGER TR_HALLAZGO_AUDITORIA_CrearTarea
ON HALLAZGO_AUDITORIA
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

-- ============================================================
-- TRIGGER 12: Validar que Fecha_Realizacion no sea muy posterior a Fecha_Programada
-- ============================================================
CREATE OR ALTER TRIGGER TR_CAPACITACION_ValidarFechas
ON CAPACITACION
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

-- ============================================================
-- TRIGGER 13: Actualizar ProximaRevision en DOCUMENTO (REHECHO)
-- ============================================================
CREATE OR ALTER TRIGGER TR_DOCUMENTO_ActualizarRevision
ON DOCUMENTO
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

-- ============================================================
-- TRIGGER 14: Validar capacidad máxima de asistentes (Advertencia)
-- ============================================================
CREATE OR ALTER TRIGGER TR_ASISTENCIA_ValidarCapacidad
ON ASISTENCIA
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

-- ============================================================
-- TRIGGER 15: Actualizar estado de PLAN_TRABAJO al cierre del año
-- ============================================================
CREATE OR ALTER TRIGGER TR_PLAN_TRABAJO_CerrarAnio
ON PLAN_TRABAJO
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

-- ============================================================
-- TRIGGER 16: Alerta por Inactivación de empleado con tareas activas
-- ============================================================
CREATE OR ALTER TRIGGER TR_EMPLEADO_ValidarInactivacion
ON EMPLEADO
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

-- ============================================================
-- TRIGGER 17: Crear alerta por cambio de responsable en TAREA
-- ============================================================
CREATE OR ALTER TRIGGER TR_TAREA_CambioResponsable
ON TAREA
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

-- ============================================================
-- TRIGGER 18: Crear alerta de seguimiento al aumentar Días_Incapacidad
-- ============================================================
CREATE OR ALTER TRIGGER TR_EVENTO_SeguimientoIncapacidad
ON EVENTO
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

PRINT '========================================================';
PRINT 'SCRIPTS DE LOGICA COMPLETADOS Y OPTIMIZADOS.';
PRINT '========================================================';
PRINT 'PROCEDIMIENTOS ALMACENADOS CREADOS: 11';
PRINT 'VISTAS CREADAS: 5';
PRINT 'TRIGGERS CREADOS: 18';
PRINT 'El Agente IA ya puede interactuar con la BD a través de estos componentes.';
PRINT '========================================================';