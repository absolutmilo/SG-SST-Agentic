import pyodbc
import sys

try:
    conn = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=localhost;'
        'DATABASE=SG_SST_AgenteInteligente;'
        'Trusted_Connection=yes;'
    )
    cursor = conn.cursor()
    
    # Get constraint definition
    query = """
    SELECT 
        cc.name AS constraint_name,
        cc.definition
    FROM sys.check_constraints cc
    JOIN sys.tables t ON cc.parent_object_id = t.object_id
    JOIN sys.columns c ON cc.parent_object_id = c.object_id 
        AND cc.parent_column_id = c.column_id
    WHERE t.name = 'DOCUMENTO'
    """
    
    cursor.execute(query)
    results = cursor.fetchall()
    
    if results:
        for row in results:
            print(f"Constraint: {row[0]}")
            print(f"Definition: {row[1]}")
    else:
        # Fallback: list all constraints on DOCUMENTO
        print("No specific column constraints found, listing all on DOCUMENTO:")
        cursor.execute("SELECT name, definition FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('DOCUMENTO')")
        for row in cursor.fetchall():
            print(f"- {row.name}: {row.definition}")

    # Also list SP definition to see what it inserts
    print("\n--- SP: sp_GenerarAlertasVencimientos ---")
    cursor.execute("SELECT OBJECT_DEFINITION(OBJECT_ID('sp_GenerarAlertasVencimientos'))")
    row = cursor.fetchone()
    if row:
        print(row[0])
        
    print("\n--- SP: SP_Generar_Alertas_Automaticas ---")
    cursor.execute("SELECT OBJECT_DEFINITION(OBJECT_ID('SP_Generar_Alertas_Automaticas'))")
    row = cursor.fetchone()
    if row:
        print(row[0])

    conn.close()
    
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
