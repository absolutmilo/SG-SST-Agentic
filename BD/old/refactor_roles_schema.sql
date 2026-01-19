-- Refactor USUARIOS_AUTORIZADOS to use ROL table
USE [SG_SST_AgenteInteligente]; -- Using the DB name from user's provided queries
GO

-- 1. Add id_rol column if it doesn't exist
IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'id_rol' AND Object_ID = Object_ID(N'dbo.USUARIOS_AUTORIZADOS'))
BEGIN
    ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS] ADD [id_rol] INT NULL;
    PRINT 'Added column id_rol to USUARIOS_AUTORIZADOS';
END
GO

-- 2. Migrate Data: Map string Nivel_Acceso to Role IDs
-- Mapping:
-- 'Administrador' -> 2 (Coordinador SST) - Most logical equivalent for a system admin in this context
-- Fallback for unmatched -> 2 (Change this if needed)

UPDATE [dbo].[USUARIOS_AUTORIZADOS]
SET [id_rol] = 2 -- Coordinador SST
WHERE [Nivel_Acceso] IN ('Administrador', 'Admin') AND [id_rol] IS NULL;

-- Map other potential values if they exist (example)
UPDATE [dbo].[USUARIOS_AUTORIZADOS]
SET [id_rol] = 5 -- Gerente General
WHERE [Nivel_Acceso] = 'Gerente' AND [id_rol] IS NULL;

-- Default for any remaining NULLs (optional, or handle manually)
-- UPDATE [dbo].[USUARIOS_AUTORIZADOS] SET [id_rol] = 9 WHERE [id_rol] IS NULL; -- 9=Vigía SST

PRINT 'Data migration completed';
GO

-- 3. Add Foreign Key Constraint
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Usuarios_Rol]') AND parent_object_id = OBJECT_ID(N'[dbo].[USUARIOS_AUTORIZADOS]'))
BEGIN
    ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_Rol] FOREIGN KEY([id_rol])
    REFERENCES [dbo].[ROL] ([id_rol]);
    
    ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS] CHECK CONSTRAINT [FK_Usuarios_Rol];
    PRINT 'Added FK_Usuarios_Rol constraint';
END
GO

-- 4. Verify
SELECT u.Correo_Electronico, u.Nivel_Acceso, r.NombreRol 
FROM [dbo].[USUARIOS_AUTORIZADOS] u
LEFT JOIN [dbo].[ROL] r ON u.id_rol = r.id_rol;
GO
