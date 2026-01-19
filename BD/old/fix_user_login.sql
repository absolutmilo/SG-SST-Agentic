-- Insert authorized user for login
USE [SG_SST_DB];
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[USUARIOS_AUTORIZADOS] WHERE [Correo_Electronico] = 'juan.lopez@digitalbulks.com')
BEGIN
    INSERT INTO [dbo].[USUARIOS_AUTORIZADOS] (
        [Correo_Electronico],
        [Nombre_Persona],
        [Nivel_Acceso],
        [PuedeAprobar],
        [PuedeEditar],
        [FechaRegistro],
        [Estado],
        [Password_Hash]
    )
    VALUES (
        'juan.lopez@digitalbulks.com',
        'Juan López Pérez',
        'Administrador', -- Nivel de acceso
        1, -- PuedeAprobar
        1, -- PuedeEditar
        GETDATE(),
        1, -- Estado 'Activo' (bit or int depending on schema, usually 1 for active)
        '$2b$12$8xBIW.NXDCMCOgNhmbJDd.KwfkxAY.PaPgTIQCdMj3CsaNDnztYHi' -- Hash for '123456'
    );
    
    PRINT 'User juan.lopez@digitalbulks.com created successfully.';
END
ELSE
BEGIN
    -- Update existing user just in case
    UPDATE [dbo].[USUARIOS_AUTORIZADOS]
    SET 
        [Password_Hash] = '$2b$12$8xBIW.NXDCMCOgNhmbJDd.KwfkxAY.PaPgTIQCdMj3CsaNDnztYHi',
        [Estado] = 1,
        [Nivel_Acceso] = 'Administrador'
    WHERE [Correo_Electronico] = 'juan.lopez@digitalbulks.com';
    
    PRINT 'User juan.lopez@digitalbulks.com updated successfully.';
END
GO
