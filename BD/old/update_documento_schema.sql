USE [SG_SST_AgenteInteligente];
GO

PRINT '=== ACTUALIZACION DE TABLA DOCUMENTO ==='

-- 1. Agregar descripcion
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[DOCUMENTO]') AND name = 'descripcion')
BEGIN
    ALTER TABLE [dbo].[DOCUMENTO] ADD [descripcion] NVARCHAR(MAX) NULL;
    PRINT 'Columna descripcion agregada.';
END

-- 2. Agregar version
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[DOCUMENTO]') AND name = 'version')
BEGIN
    ALTER TABLE [dbo].[DOCUMENTO] ADD [version] INT DEFAULT 1 WITH VALUES;
    PRINT 'Columna version agregada.';
END

-- 3. Agregar mime_type (Critico para descargas)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[DOCUMENTO]') AND name = 'mime_type')
BEGIN
    ALTER TABLE [dbo].[DOCUMENTO] ADD [mime_type] NVARCHAR(100) NULL;
    PRINT 'Columna mime_type agregada.';
END

-- 4. Agregar tamano_bytes
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[DOCUMENTO]') AND name = 'tamano_bytes')
BEGIN
    ALTER TABLE [dbo].[DOCUMENTO] ADD [tamano_bytes] BIGINT NULL;
    PRINT 'Columna tamano_bytes agregada.';
END

PRINT 'Actualizacion completada.'
GO
