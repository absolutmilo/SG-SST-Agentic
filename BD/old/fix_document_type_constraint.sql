-- Fix Document Type Constraint
-- The current constraint does not allow 'SoporteFormulario', causing uploads to fail.

USE [SG_SST_AgenteInteligente]
GO

-- 1. Drop the existing constraint (using the name provided by user, or handling error if not found)
-- Note: Constraint names with random suffixes (like 09A971A2) are auto-generated. 
-- We try to drop specifically the one the user found, but it's safer to drop by checking column parent.
DECLARE @ConstraintName nvarchar(200)
SELECT @ConstraintName = Name FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('DOCUMENTO') AND parent_column_id = (SELECT column_id FROM sys.columns WHERE object_id = OBJECT_ID('DOCUMENTO') AND name = 'Tipo')

IF @ConstraintName IS NOT NULL
BEGIN
    DECLARE @SQL nvarchar(MAX) = 'ALTER TABLE [dbo].[DOCUMENTO] DROP CONSTRAINT [' + @ConstraintName + ']'
    PRINT 'Dropping constraint: ' + @ConstraintName
    EXEC sp_executesql @SQL
END
GO

-- 2. Add the correct constraint with a fixed name
ALTER TABLE [dbo].[DOCUMENTO] WITH CHECK ADD CONSTRAINT [CK_Documento_Tipo] CHECK (
    [Tipo] IN (
        'Reglamento', 
        'Plan', 
        'Instructivo', 
        'Formato', 
        'Manual', 
        'Programa', 
        'Procedimiento', 
        'Política',
        'SoporteFormulario', -- Required for Smart Forms uploads
        'Registro',         -- Common in SGSST
        'Evidencia',        -- Common in SGSST
        'Matriz'            -- Common in SGSST
    )
);
GO

PRINT 'Constraint CK_Documento_Tipo created successfully.'
