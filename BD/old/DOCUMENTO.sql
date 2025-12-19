USE [SG_SST_AgenteInteligente];
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DOCUMENTO]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[DOCUMENTO](
        [id_documento] [int] IDENTITY(1,1) NOT NULL,
        [titulo] [nvarchar](255) NOT NULL,
        [descripcion] [nvarchar](max) NULL,
        [tipo] [nvarchar](50) NOT NULL, -- 'Politica', 'Acta', 'Procedimiento', 'Registro', 'Externo', 'Matriz'
        [categoria] [nvarchar](100) NULL, -- 'Legal', 'Tecnico', 'Recursos Humanos', 'Salud', 'Seguridad Industrial'
        [ruta_archivo] [nvarchar](500) NOT NULL,
        [version] [int] DEFAULT 1 NOT NULL,
        [estado] [nvarchar](50) DEFAULT 'Vigente' NOT NULL, -- 'Vigente', 'Obsoleto', 'En Revision', 'Borrador'
        [fecha_creacion] [datetime] DEFAULT GETDATE() NOT NULL,
        [fecha_actualizacion] [datetime] DEFAULT GETDATE() NOT NULL,
        [id_empleado_autor] [int] NULL,
        [mime_type] [nvarchar](100) NULL,
        [tamano_bytes] [bigint] NULL,
        CONSTRAINT [PK_DOCUMENTO] PRIMARY KEY CLUSTERED 
        (
            [id_documento] ASC
        )
    );
    
    -- Foreign Key to EMPLEADO
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMPLEADO]') AND type in (N'U'))
    BEGIN
        ALTER TABLE [dbo].[DOCUMENTO]  WITH CHECK ADD CONSTRAINT [FK_DOCUMENTO_EMPLEADO] FOREIGN KEY([id_empleado_autor])
        REFERENCES [dbo].[EMPLEADO] ([id_empleado]);
        
        ALTER TABLE [dbo].[DOCUMENTO] CHECK CONSTRAINT [FK_DOCUMENTO_EMPLEADO];
    END

    PRINT 'Tabla DOCUMENTO creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'La tabla DOCUMENTO ya existe.';
END
GO
