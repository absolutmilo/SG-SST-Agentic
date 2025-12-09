-- ============================================================
-- SCRIPT: Insertar Roles Estándar SG-SST (Normatividad Colombia)
-- ============================================================
USE [SG_SST_AgenteInteligente]
GO

-- 1. Roles de Alta Dirección y Responsables
IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Gerente General')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Gerente General', 'Representante legal, máxima autoridad y responsable de recursos', 1);

IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Director SST')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Director SST', 'Líder estratégico del SG-SST (Licencia Profesional)', 1);

IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Coordinador SST')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Coordinador SST', 'Responsable operativo del SG-SST', 1);

-- 2. Roles de Participación y Comités (Res. 0312 / Dec. 1072)
IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Presidente COPASST')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Presidente COPASST', 'Representante del empleador en el Comité Paritario', 1);

IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Secretario COPASST')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Secretario COPASST', 'Encargado de actas y gestión documental del COPASST', 1);

IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Miembro COPASST')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Miembro COPASST', 'Integrante del Comité Paritario de SST', 1);

IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Vigía SST')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Vigía SST', 'Rol para empresas de menos de 10 trabajadores', 1);

IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Comité Convivencia')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Comité Convivencia', 'Miembro del Comité de Convivencia Laboral', 1);

-- 3. Roles de Emergencias (Brigadas)
IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Líder de Brigada')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Líder de Brigada', 'Jefe de la brigada de emergencias', 1);

IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Brigadista Primeros Auxilios')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Brigadista Primeros Auxilios', 'Atención inicial de heridos', 1);

IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Brigadista Evacuación')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Brigadista Evacuación', 'Guía durante evacuaciones', 1);

IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Brigadista Contra Incendios')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Brigadista Contra Incendios', 'Control de conatos de incendio', 1);

-- 4. Roles de Verificación
IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Auditor Interno')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Auditor Interno', 'Encargado de auditorías internas del sistema', 1);

IF NOT EXISTS (SELECT 1 FROM ROL WHERE NombreRol = 'Investigador de Accidentes')
    INSERT INTO ROL (NombreRol, Descripcion, EsRolSST) VALUES ('Investigador de Accidentes', 'Miembro del equipo investigador (Res. 1401)', 1);

SELECT * FROM ROL WHERE EsRolSST = 1;
