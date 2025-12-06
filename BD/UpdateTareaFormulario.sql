USE SG_SST_AgenteInteligente;
GO

-- Add id_formulario column to TAREA table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[TAREA]') AND name = 'id_formulario')
BEGIN
    ALTER TABLE [dbo].[TAREA]
    ADD [id_formulario] [nvarchar](100) NULL;
    
    PRINT 'Column id_formulario added to TAREA table.';
END
ELSE
BEGIN
    PRINT 'Column id_formulario already exists in TAREA table.';
END
GO
