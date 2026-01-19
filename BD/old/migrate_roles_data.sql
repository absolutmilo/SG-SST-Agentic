-- Retry Data Migration for Roles
-- Use this if the previous script added the column but failed to update data.
USE [SG_SST_AgenteInteligente];
GO

-- 1. Update Data (Retry)
PRINT 'Updating null roles...';

UPDATE [dbo].[USUARIOS_AUTORIZADOS]
SET [id_rol] = 2 -- Coordinador SST
WHERE [Nivel_Acceso] IN ('Administrador', 'Admin') AND ([id_rol] IS NULL OR [id_rol] = 0);

UPDATE [dbo].[USUARIOS_AUTORIZADOS]
SET [id_rol] = 5 -- Gerente General
WHERE [Nivel_Acceso] = 'Gerente' AND ([id_rol] IS NULL OR [id_rol] = 0);

-- Default fallback for any others (Active users only)
UPDATE [dbo].[USUARIOS_AUTORIZADOS]
SET [id_rol] = 9 -- Vigía SST (Safe default)
WHERE [id_rol] IS NULL AND [Estado] = 1;

PRINT 'Data update completed.';
GO

-- 2. Add Foreign Key Constraint (Retry)
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Usuarios_Rol]') AND parent_object_id = OBJECT_ID(N'[dbo].[USUARIOS_AUTORIZADOS]'))
BEGIN
    ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_Rol] FOREIGN KEY([id_rol])
    REFERENCES [dbo].[ROL] ([id_rol]);
    
    ALTER TABLE [dbo].[USUARIOS_AUTORIZADOS] CHECK CONSTRAINT [FK_Usuarios_Rol];
    PRINT 'Added FK_Usuarios_Rol constraint';
END
ELSE
BEGIN
    PRINT 'Constraint FK_Usuarios_Rol already exists.';
END
GO

-- 3. Verification
SELECT u.Correo_Electronico, u.Nivel_Acceso, u.id_rol, r.NombreRol 
FROM [dbo].[USUARIOS_AUTORIZADOS] u
LEFT JOIN [dbo].[ROL] r ON u.id_rol = r.id_rol;
GO
