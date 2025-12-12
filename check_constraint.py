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
    WHERE t.name = 'DOCUMENTO' AND c.name = 'Tipo'
    """
    
    cursor.execute(query)
    result = cursor.fetchone()
    
    if result:
        print(f"Constraint Name: {result[0]}")
        print(f"Definition: {result[1]}")
    else:
        print("No CHECK constraint found on DOCUMENTO.Tipo")
    
    conn.close()
    
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
