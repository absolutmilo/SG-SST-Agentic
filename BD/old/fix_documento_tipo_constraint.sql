-- Fix DOCUMENTO Tipo Constraint to allow 'SoporteFormulario'
-- This script drops the existing constraint and recreates it with all required values

USE [SG_SST_DB];
GO

-- Drop existing constraint if it exists
IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Documento_Tipo')
BEGIN
    ALTER TABLE [dbo].[DOCUMENTO] DROP CONSTRAINT [CK_Documento_Tipo];
    PRINT 'Dropped existing CK_Documento_Tipo constraint';
END
GO

-- Create new constraint with all allowed values including 'SoporteFormulario'
ALTER TABLE [dbo].[DOCUMENTO] WITH CHECK ADD CONSTRAINT [CK_Documento_Tipo] 
CHECK (
    [Tipo] IN (
        'Matriz',
        'Evidencia',
        'Registro',
        'SoporteFormulario',  -- Required for Smart Forms uploads
        'Política',
        'Procedimiento',
        'Programa',
        'Manual',
        'Formato',
        'Instructivo',
        'Plan',
        'Reglamento'
    )
);
GO

PRINT 'Successfully updated CK_Documento_Tipo constraint to allow SoporteFormulario';
GO
