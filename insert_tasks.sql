-- Script de Inserción de Tareas de Ejemplo para SG-SST
-- Generado para poblar el dashboard con datos realistas
-- Incluye tareas vencidas para probar la generación de alertas

USE SG_SST_AgenteInteligente;
GO

-- 1. Tarea Vencida (Crítica) - Auditoría
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea, AvancePorc, Fecha_Actualizacion)
VALUES (1, 'Auditoría Interna SG-SST 2024 - Fase Final', 'Auditoría', '2024-01-15', DATEADD(day, -5, GETDATE()), 'Crítica', 'Vencida', 101, 'Plan Anual', 80.00, GETDATE());

-- 2. Tarea Vencida (Alta) - Capacitación
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea, AvancePorc, Fecha_Actualizacion)
VALUES (1, 'Capacitación en Manejo de Sustancias Químicas', 'Capacitación', '2024-02-01', DATEADD(day, -2, GETDATE()), 'Alta', 'Vencida', 101, 'Plan Anual', 0.00, GETDATE());

-- 3. Tarea Pendiente (Alta) - Próxima a vencer
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea, AvancePorc, Fecha_Actualizacion)
VALUES (1, 'Renovación de Licencia de Software SST', 'Gestión Administrativa', '2024-03-01', DATEADD(day, 2, GETDATE()), 'Alta', 'Pendiente', 101, 'Sistema - Alerta', 10.00, GETDATE());

-- 4. Tarea Pendiente (Media) - Inspección
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea, AvancePorc, Fecha_Actualizacion)
VALUES (1, 'Inspección de Botiquines - Sede Principal', 'Inspección', '2024-03-10', DATEADD(day, 15, GETDATE()), 'Media', 'Pendiente', 101, 'Cronograma Inspecciones', 0.00, GETDATE());

-- 5. Tarea En Curso (Media) - Actualización Matriz
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea, AvancePorc, Fecha_Actualizacion)
VALUES (1, 'Actualización Matriz de Riesgos - Área Producción', 'Gestión de Riesgos', '2024-04-01', DATEADD(day, 20, GETDATE()), 'Media', 'En Curso', 101, 'Solicitud ARL', 45.00, GETDATE());

-- 6. Tarea Cerrada (Baja) - Entrega EPP
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea, AvancePorc, Fecha_Actualizacion, Fecha_Cierre, id_empleado_cierre, Observaciones_Cierre)
VALUES (1, 'Entrega de EPP a nuevos ingresos', 'Gestión EPP', '2024-01-10', '2024-01-20', 'Baja', 'Cerrada', 101, 'Solicitud RRHH', 100.00, GETDATE(), '2024-01-18', 101, 'Entregado conforme a matriz de EPP');

-- 7. Tarea Cerrada (Alta) - Investigación Accidente
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea, AvancePorc, Fecha_Actualizacion, Fecha_Cierre, id_empleado_cierre, Observaciones_Cierre)
VALUES (1, 'Investigación Incidente 004-2024', 'Investigación', '2024-02-15', '2024-02-28', 'Alta', 'Cerrada', 101, 'Reporte Incidente', 100.00, GETDATE(), '2024-02-25', 101, 'Causas básicas identificadas y plan de acción creado');

-- 8. Tarea Pendiente (Crítica) - Simulacro
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea, AvancePorc, Fecha_Actualizacion)
VALUES (1, 'Simulacro Nacional de Evacuación', 'Emergencias', '2024-05-01', DATEADD(day, 45, GETDATE()), 'Crítica', 'Pendiente', 101, 'Requisito Legal', 0.00, GETDATE());

-- 9. Tarea En Curso (Alta) - Comité
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea, AvancePorc, Fecha_Actualizacion)
VALUES (1, 'Preparación Reunión Mensual COPASST', 'Comité', '2024-05-10', DATEADD(day, 5, GETDATE()), 'Alta', 'En Curso', 101, 'Cronograma Comités', 30.00, GETDATE());

-- 10. Tarea Pendiente (Media) - Exámenes Médicos
INSERT INTO TAREA (id_plan, Descripcion, Tipo_Tarea, Fecha_Creacion, Fecha_Vencimiento, Prioridad, Estado, id_empleado_responsable, Origen_Tarea, AvancePorc, Fecha_Actualizacion)
VALUES (1, 'Programación EMO Periódicos - Grupo 2', 'Medicina Preventiva', '2024-06-01', DATEADD(day, 60, GETDATE()), 'Media', 'Pendiente', 101, 'Programa Vigilancia', 0.00, GETDATE());

-- Ejecutar procedimiento para generar alertas basadas en estas tareas
EXEC SP_Monitorear_Tareas_Vencidas;
EXEC sp_GenerarAlertasVencimientos;
GO
