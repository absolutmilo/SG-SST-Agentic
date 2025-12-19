-- Diagnostic script for FORM_SUBMISSION_AUDIT table
-- Run this to check the table structure and constraints

-- 1. Check table structure
SELECT 
    c.name AS column_name,
    t.name AS data_type,
    c.max_length,
    c.is_nullable,
    c.is_identity
FROM sys.columns c
JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('FORM_SUBMISSION_AUDIT')
ORDER BY c.column_id;

-- 2. Check for default constraints
SELECT 
    dc.name AS constraint_name,
    c.name AS column_name,
    dc.definition AS default_value
FROM sys.default_constraints dc
JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('FORM_SUBMISSION_AUDIT');

-- 3. Check for NOT NULL constraints
SELECT 
    c.name AS column_name,
    c.is_nullable
FROM sys.columns c
WHERE c.object_id = OBJECT_ID('FORM_SUBMISSION_AUDIT')
AND c.is_nullable = 0;
