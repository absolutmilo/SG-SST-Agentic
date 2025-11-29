-- Script para crear roles de agentes en SG-SST
-- Separa los roles de permisos de agentes de los roles organizacionales del SG-SST

USE [SG_SST_AgenteInteligente]
GO

-- =====================================================
-- 1. CREAR TABLA DE ROLES DE AGENTES
-- =====================================================
-- Esta tabla maneja ÚNICAMENTE los permisos de acceso a agentes IA
-- Es independiente de la tabla ROL que maneja roles organizacionales del SG-SST

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AGENTE_ROL')
BEGIN
    CREATE TABLE [dbo].[AGENTE_ROL] (
        [id_agente_rol] INT PRIMARY KEY IDENTITY(1,1),
        [nombre_rol] NVARCHAR(50) NOT NULL UNIQUE,
        [descripcion] NVARCHAR(255),
        [agentes_permitidos] NVARCHAR(MAX), -- JSON array con nombres de agentes
        [nivel_acceso] INT DEFAULT 1, -- 1=Básico, 2=Intermedio, 3=Avanzado, 4=Completo
        [activo] BIT DEFAULT 1,
        [FechaCreacion] DATETIME DEFAULT GETDATE(),
        [FechaActualizacion] DATETIME DEFAULT GETDATE()
    )
    
    PRINT 'Tabla AGENTE_ROL creada exitosamente'
END
ELSE
BEGIN
    PRINT 'Tabla AGENTE_ROL ya existe'
END
GO

-- =====================================================
-- 2. INSERTAR ROLES DE AGENTES
-- =====================================================

-- Admin: Acceso completo a todos los agentes
IF NOT EXISTS (SELECT * FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'admin')
BEGIN
    INSERT INTO [dbo].[AGENTE_ROL] (nombre_rol, descripcion, agentes_permitidos, nivel_acceso)
    VALUES (
        'admin', 
        'Administrador con acceso completo a todos los agentes',
        '["risk_agent", "document_agent", "email_agent", "assistant_agent"]',
        4
    )
    PRINT 'Rol admin creado'
END

-- SST Coordinator: Acceso completo (igual que admin para temas de SST)
IF NOT EXISTS (SELECT * FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'sst_coordinator')
BEGIN
    INSERT INTO [dbo].[AGENTE_ROL] (nombre_rol, descripcion, agentes_permitidos, nivel_acceso)
    VALUES (
        'sst_coordinator', 
        'Coordinador de SST con acceso completo a agentes',
        '["risk_agent", "document_agent", "email_agent", "assistant_agent"]',
        4
    )
    PRINT 'Rol sst_coordinator creado'
END

-- Supervisor: Acceso a evaluación de riesgos y asistente
IF NOT EXISTS (SELECT * FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'supervisor')
BEGIN
    INSERT INTO [dbo].[AGENTE_ROL] (nombre_rol, descripcion, agentes_permitidos, nivel_acceso)
    VALUES (
        'supervisor', 
        'Supervisor con acceso a evaluación de riesgos',
        '["risk_agent", "assistant_agent"]',
        2
    )
    PRINT 'Rol supervisor creado'
END

-- Employee: Solo asistente básico
IF NOT EXISTS (SELECT * FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'employee')
BEGIN
    INSERT INTO [dbo].[AGENTE_ROL] (nombre_rol, descripcion, agentes_permitidos, nivel_acceso)
    VALUES (
        'employee', 
        'Empleado con acceso básico al asistente',
        '["assistant_agent"]',
        1
    )
    PRINT 'Rol employee creado'
END

-- Contractor: Solo asistente básico
IF NOT EXISTS (SELECT * FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'contractor')
BEGIN
    INSERT INTO [dbo].[AGENTE_ROL] (nombre_rol, descripcion, agentes_permitidos, nivel_acceso)
    VALUES (
        'contractor', 
        'Contratista con acceso básico al asistente',
        '["assistant_agent"]',
        1
    )
    PRINT 'Rol contractor creado'
END

-- Auditor: Acceso a documentos y asistente
IF NOT EXISTS (SELECT * FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'auditor')
BEGIN
    INSERT INTO [dbo].[AGENTE_ROL] (nombre_rol, descripcion, agentes_permitidos, nivel_acceso)
    VALUES (
        'auditor', 
        'Auditor con acceso a documentos y asistente',
        '["document_agent", "assistant_agent"]',
        3
    )
    PRINT 'Rol auditor creado'
END

-- Brigadista: Acceso a asistente y documentos de emergencia
IF NOT EXISTS (SELECT * FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'brigadista')
BEGIN
    INSERT INTO [dbo].[AGENTE_ROL] (nombre_rol, descripcion, agentes_permitidos, nivel_acceso)
    VALUES (
        'brigadista', 
        'Brigadista con acceso a asistente y documentos',
        '["assistant_agent", "document_agent"]',
        2
    )
    PRINT 'Rol brigadista creado'
END

-- COPASST: Acceso a riesgos, documentos y asistente
IF NOT EXISTS (SELECT * FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'copasst')
BEGIN
    INSERT INTO [dbo].[AGENTE_ROL] (nombre_rol, descripcion, agentes_permitidos, nivel_acceso)
    VALUES (
        'copasst', 
        'Miembro COPASST con acceso a riesgos y documentos',
        '["risk_agent", "document_agent", "assistant_agent"]',
        3
    )
    PRINT 'Rol copasst creado'
END
GO

-- =====================================================
-- 3. CREAR TABLA DE MAPEO EMPLEADO -> AGENTE_ROL
-- =====================================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EMPLEADO_AGENTE_ROL')
BEGIN
    CREATE TABLE [dbo].[EMPLEADO_AGENTE_ROL] (
        [id_empleado_agente_rol] INT PRIMARY KEY IDENTITY(1,1),
        [id_empleado] INT NOT NULL,
        [id_agente_rol] INT NOT NULL,
        [FechaAsignacion] DATETIME DEFAULT GETDATE(),
        [FechaFinalizacion] DATETIME NULL,
        [asignado_por] INT NULL, -- id_empleado de quien asignó el rol
        [motivo] NVARCHAR(255) NULL,
        
        CONSTRAINT FK_EmpleadoAgenteRol_Empleado 
            FOREIGN KEY (id_empleado) REFERENCES [dbo].[EMPLEADO](id_empleado),
        CONSTRAINT FK_EmpleadoAgenteRol_AgenteRol 
            FOREIGN KEY (id_agente_rol) REFERENCES [dbo].[AGENTE_ROL](id_agente_rol),
        CONSTRAINT UQ_EmpleadoAgenteRol_Activo 
            UNIQUE (id_empleado, id_agente_rol, FechaFinalizacion)
    )
    
    PRINT 'Tabla EMPLEADO_AGENTE_ROL creada exitosamente'
END
ELSE
BEGIN
    PRINT 'Tabla EMPLEADO_AGENTE_ROL ya existe'
END
GO

-- =====================================================
-- 4. ASIGNAR ROLES DE AGENTES A EMPLEADOS EXISTENTES
-- =====================================================

-- Mapeo basado en los roles organizacionales existentes en la tabla ROL

-- CEO (id_empleado=100, id_rol=1) -> admin
IF NOT EXISTS (SELECT * FROM [dbo].[EMPLEADO_AGENTE_ROL] WHERE id_empleado = 100)
BEGIN
    INSERT INTO [dbo].[EMPLEADO_AGENTE_ROL] (id_empleado, id_agente_rol, motivo)
    VALUES (
        100, 
        (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'admin'),
        'Asignación automática basada en rol CEO'
    )
    PRINT 'CEO asignado a rol admin'
END

-- Coordinador SST (id_empleado=101, id_rol=2) -> sst_coordinator
IF NOT EXISTS (SELECT * FROM [dbo].[EMPLEADO_AGENTE_ROL] WHERE id_empleado = 101)
BEGIN
    INSERT INTO [dbo].[EMPLEADO_AGENTE_ROL] (id_empleado, id_agente_rol, motivo)
    VALUES (
        101, 
        (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'sst_coordinator'),
        'Asignación automática basada en rol Coordinador SST'
    )
    PRINT 'Coordinador SST asignado a rol sst_coordinator'
END

-- Desarrollador Senior (id_empleado=102) -> employee
IF NOT EXISTS (SELECT * FROM [dbo].[EMPLEADO_AGENTE_ROL] WHERE id_empleado = 102)
BEGIN
    INSERT INTO [dbo].[EMPLEADO_AGENTE_ROL] (id_empleado, id_agente_rol, motivo)
    VALUES (
        102, 
        (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'employee'),
        'Asignación automática - empleado estándar'
    )
    PRINT 'Desarrollador asignado a rol employee'
END

-- Analista Financiera (id_empleado=103) -> employee
IF NOT EXISTS (SELECT * FROM [dbo].[EMPLEADO_AGENTE_ROL] WHERE id_empleado = 103)
BEGIN
    INSERT INTO [dbo].[EMPLEADO_AGENTE_ROL] (id_empleado, id_agente_rol, motivo)
    VALUES (
        103, 
        (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'employee'),
        'Asignación automática - empleado estándar'
    )
    PRINT 'Analista asignado a rol employee'
END
GO

-- =====================================================
-- 5. ASIGNAR ROLES ESPECIALES BASADOS EN ROL SST
-- =====================================================

-- Asignar rol 'brigadista' a todos los empleados que tienen id_rol=3 (Brigadista)
INSERT INTO [dbo].[EMPLEADO_AGENTE_ROL] (id_empleado, id_agente_rol, motivo)
SELECT 
    er.id_empleado,
    (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'brigadista'),
    'Asignación automática basada en rol Brigadista'
FROM [dbo].[EMPLEADO_ROL] er
WHERE er.id_rol = 3 -- Brigadista
  AND er.FechaFinalizacion IS NULL
  AND NOT EXISTS (
      SELECT 1 FROM [dbo].[EMPLEADO_AGENTE_ROL] ear 
      WHERE ear.id_empleado = er.id_empleado 
        AND ear.id_agente_rol = (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'brigadista')
        AND ear.FechaFinalizacion IS NULL
  )

-- Asignar rol 'copasst' a todos los empleados que tienen id_rol=4 (Miembro COPASST)
INSERT INTO [dbo].[EMPLEADO_AGENTE_ROL] (id_empleado, id_agente_rol, motivo)
SELECT 
    er.id_empleado,
    (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'copasst'),
    'Asignación automática basada en rol COPASST'
FROM [dbo].[EMPLEADO_ROL] er
WHERE er.id_rol = 4 -- Miembro COPASST
  AND er.FechaFinalizacion IS NULL
  AND NOT EXISTS (
      SELECT 1 FROM [dbo].[EMPLEADO_AGENTE_ROL] ear 
      WHERE ear.id_empleado = er.id_empleado 
        AND ear.id_agente_rol = (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'copasst')
        AND ear.FechaFinalizacion IS NULL
  )
GO

-- =====================================================
-- 6. CREAR EMPLEADOS DE EJEMPLO ADICIONALES
-- =====================================================

-- Supervisor de ejemplo
IF NOT EXISTS (SELECT * FROM [dbo].[EMPLEADO] WHERE NumeroDocumento = '6677889900')
BEGIN
    INSERT INTO [dbo].[EMPLEADO] 
    (id_sede, TipoDocumento, NumeroDocumento, Nombre, Apellidos, Cargo, Area, TipoContrato, 
     Fecha_Ingreso, Nivel_Riesgo_Laboral, Correo, Telefono, ContactoEmergencia, TelefonoEmergencia, Estado)
    VALUES 
    (1, 'CC', '6677889900', 'Carlos', 'Ramírez Silva', 'Supervisor de Producción', 
     'Producción', 'Indefinido', '2018-03-15', 3, 'carlos.ramirez@digitalbulks.com', 
     '+573401234567', 'Laura Ramírez', '+573404444444', 1)
    
    DECLARE @supervisor_id INT = SCOPE_IDENTITY()
    
    -- Asignar rol de agente supervisor
    INSERT INTO [dbo].[EMPLEADO_AGENTE_ROL] (id_empleado, id_agente_rol, motivo)
    VALUES (
        @supervisor_id, 
        (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'supervisor'),
        'Asignación inicial - Supervisor de Producción'
    )
    
    PRINT 'Supervisor de ejemplo creado y asignado'
END
GO

-- Contratista de ejemplo
IF NOT EXISTS (SELECT * FROM [dbo].[EMPLEADO] WHERE NumeroDocumento = '9988776655')
BEGIN
    INSERT INTO [dbo].[EMPLEADO] 
    (id_sede, TipoDocumento, NumeroDocumento, Nombre, Apellidos, Cargo, Area, TipoContrato, 
     Fecha_Ingreso, Nivel_Riesgo_Laboral, Correo, Telefono, ContactoEmergencia, TelefonoEmergencia, Estado)
    VALUES 
    (1, 'CC', '9988776655', 'Laura', 'Martínez Díaz', 'Contratista Mantenimiento', 
     'Mantenimiento', 'Obra o Labor', '2024-01-10', 4, 'laura.martinez@contractor.com', 
     '+573501234567', 'Miguel Martínez', '+573505555555', 1)
    
    DECLARE @contractor_id INT = SCOPE_IDENTITY()
    
    -- Asignar rol de agente contractor
    INSERT INTO [dbo].[EMPLEADO_AGENTE_ROL] (id_empleado, id_agente_rol, motivo)
    VALUES (
        @contractor_id, 
        (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'contractor'),
        'Asignación inicial - Contratista'
    )
    
    PRINT 'Contratista de ejemplo creado y asignado'
END
GO

-- Auditor de ejemplo
IF NOT EXISTS (SELECT * FROM [dbo].[EMPLEADO] WHERE NumeroDocumento = '4455667788')
BEGIN
    INSERT INTO [dbo].[EMPLEADO] 
    (id_sede, TipoDocumento, NumeroDocumento, Nombre, Apellidos, Cargo, Area, TipoContrato, 
     Fecha_Ingreso, Nivel_Riesgo_Laboral, Correo, Telefono, ContactoEmergencia, TelefonoEmergencia, Estado)
    VALUES 
    (1, 'CC', '4455667788', 'Roberto', 'Sánchez Mora', 'Auditor SST', 
     'Calidad y Auditoría', 'Prestación de Servicios', '2023-06-01', 1, 'roberto.sanchez@auditor.com', 
     '+573601234567', 'Patricia Sánchez', '+573606666666', 1)
    
    DECLARE @auditor_id INT = SCOPE_IDENTITY()
    
    -- Asignar rol de agente auditor
    INSERT INTO [dbo].[EMPLEADO_AGENTE_ROL] (id_empleado, id_agente_rol, motivo)
    VALUES (
        @auditor_id, 
        (SELECT id_agente_rol FROM [dbo].[AGENTE_ROL] WHERE nombre_rol = 'auditor'),
        'Asignación inicial - Auditor SST'
    )
    
    PRINT 'Auditor de ejemplo creado y asignado'
END
GO

-- =====================================================
-- 7. QUERIES DE VERIFICACIÓN
-- =====================================================

PRINT ''
PRINT '========================================='
PRINT 'VERIFICACIÓN DE ROLES DE AGENTES'
PRINT '========================================='
PRINT ''

-- Ver todos los roles de agentes creados
PRINT 'Roles de Agentes Disponibles:'
SELECT 
    id_agente_rol,
    nombre_rol,
    descripcion,
    agentes_permitidos,
    nivel_acceso,
    activo
FROM [dbo].[AGENTE_ROL]
ORDER BY nivel_acceso DESC, nombre_rol

PRINT ''
PRINT 'Asignaciones de Roles de Agentes:'

-- Ver asignaciones de roles de agentes
SELECT 
    e.id_empleado,
    e.Nombre + ' ' + e.Apellidos AS NombreCompleto,
    e.Cargo,
    r.NombreRol AS RolOrganizacional,
    ar.nombre_rol AS RolAgente,
    ar.agentes_permitidos AS AgentesPermitidos,
    ar.nivel_acceso AS NivelAcceso,
    ear.FechaAsignacion,
    ear.motivo
FROM [dbo].[EMPLEADO] e
LEFT JOIN [dbo].[EMPLEADO_ROL] er ON e.id_empleado = er.id_empleado AND er.FechaFinalizacion IS NULL
LEFT JOIN [dbo].[ROL] r ON er.id_rol = r.id_rol
LEFT JOIN [dbo].[EMPLEADO_AGENTE_ROL] ear ON e.id_empleado = ear.id_empleado AND ear.FechaFinalizacion IS NULL
LEFT JOIN [dbo].[AGENTE_ROL] ar ON ear.id_agente_rol = ar.id_agente_rol
WHERE e.Estado = 1
ORDER BY ar.nivel_acceso DESC, e.id_empleado

PRINT ''
PRINT '========================================='
PRINT 'SETUP COMPLETADO EXITOSAMENTE'
PRINT '========================================='
GO
