from sqlalchemy import text
from sqlalchemy.orm import Session

def get_table_constraints(db: Session, table_name: str) -> str:
    """
    Retrieves CHECK constraints and FOREIGN KEY references for a given table.
    Returns a formatted string suitable for LLM context.
    """
    constraints_info = []

    # 1. Get CHECK constraints (Allowed values)
    check_query = text("""
        SELECT c.definition
        FROM sys.check_constraints c
        INNER JOIN sys.objects o ON c.parent_object_id = o.object_id
        WHERE o.name = :table_name
    """)
    
    try:
        checks = db.execute(check_query, {"table_name": table_name}).fetchall()
        if checks:
            constraints_info.append("ALLOWED VALUES (CHECK Constraints):")
            for check in checks:
                # Clean up the definition string slightly if needed
                constraints_info.append(f"- {check.definition}")
    except Exception as e:
        constraints_info.append(f"Error fetching check constraints: {str(e)}")

    # 2. Get FOREIGN KEY constraints (Relationships)
    fk_query = text("""
        SELECT 
            fk.name AS ForeignKey,
            c.name AS ColumnName,
            ref_t.name AS ReferencedTable,
            ref_c.name AS ReferencedColumn
        FROM sys.foreign_keys fk
        INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
        INNER JOIN sys.tables t ON fkc.parent_object_id = t.object_id
        INNER JOIN sys.columns c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
        INNER JOIN sys.tables ref_t ON fkc.referenced_object_id = ref_t.object_id
        INNER JOIN sys.columns ref_c ON fkc.referenced_object_id = ref_c.object_id AND fkc.referenced_column_id = ref_c.column_id
        WHERE t.name = :table_name
    """)

    try:
        fks = db.execute(fk_query, {"table_name": table_name}).fetchall()
        if fks:
            constraints_info.append("\nRELATIONSHIPS (Foreign Keys):")
            for fk in fks:
                constraints_info.append(f"- Column '{fk.ColumnName}' references table '{fk.ReferencedTable}' (column '{fk.ReferencedColumn}')")
                constraints_info.append(f"  * IMPORTANT: You must query '{fk.ReferencedTable}' first to get a valid ID for '{fk.ColumnName}'.")
    except Exception as e:
        constraints_info.append(f"Error fetching foreign keys: {str(e)}")

    # 3. Get Column Types and Nullability
    col_query = text("""
        SELECT 
            c.name,
            t.name AS type,
            c.max_length,
            c.is_nullable
        FROM sys.columns c
        JOIN sys.types t ON c.user_type_id = t.user_type_id
        WHERE c.object_id = OBJECT_ID(:table_name)
    """)
    
    try:
        cols = db.execute(col_query, {"table_name": table_name}).fetchall()
        if cols:
            constraints_info.append("\nSCHEMA (Columns):")
            for col in cols:
                nullable = "NULL" if col.is_nullable else "NOT NULL"
                constraints_info.append(f"- {col.name} ({col.type}): {nullable}")
    except Exception as e:
        constraints_info.append(f"Error fetching columns: {str(e)}")

    return "\n".join(constraints_info)
