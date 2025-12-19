DROP TRIGGER IF EXISTS [dbo].[TR_FORM_SUBMISSIONS_AuditLog];
GO

-- Create the corrected trigger
CREATE TRIGGER [dbo].[TR_FORM_SUBMISSIONS_AuditLog]
ON [dbo].[FORM_SUBMISSIONS]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @action NVARCHAR(20)
    
    -- Determine action type
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @action = 'UPDATE'
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @action = 'INSERT'
    ELSE
        SET @action = 'DELETE'
    
    -- For INSERT and UPDATE
    IF @action IN ('INSERT', 'UPDATE')
    BEGIN
        -- Log status changes (only for UPDATEs where status changed)
        IF @action = 'UPDATE' AND UPDATE(status)
        BEGIN
            INSERT INTO [dbo].[FORM_SUBMISSION_AUDIT] 
                ([id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at])
            SELECT 
                i.id_submission,
                'STATUS_CHANGE',
                'status',
                d.status,
                i.status,
                i.submitted_by,  -- Use submitted_by since there's no updated_by column
                GETDATE()
            FROM inserted i
            INNER JOIN deleted d ON i.id_submission = d.id_submission
            WHERE i.status <> d.status
              OR (i.status IS NULL AND d.status IS NOT NULL)
              OR (i.status IS NOT NULL AND d.status IS NULL)
        END
        
        -- Log general action for all INSERTs and UPDATEs
        INSERT INTO [dbo].[FORM_SUBMISSION_AUDIT] 
            ([id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at])
        SELECT 
            id_submission, 
            @action,
            NULL,  -- field_changed is NULL for general actions
            NULL,  -- old_value is NULL
            NULL,  -- new_value is NULL  
            submitted_by,  -- Use submitted_by as changed_by
            GETDATE()
        FROM inserted
    END
    
    -- For DELETE
    IF @action = 'DELETE'
    BEGIN
        INSERT INTO [dbo].[FORM_SUBMISSION_AUDIT] 
            ([id_submission], [action], [field_changed], [old_value], [new_value], [changed_by], [changed_at])
        SELECT 
            id_submission, 
            @action,
            NULL,
            NULL,
            NULL,
            submitted_by,  -- Use submitted_by as changed_by (or NULL if not available)
            GETDATE()
        FROM deleted
    END
END
GO
