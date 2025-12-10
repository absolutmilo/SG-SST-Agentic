import re
import os

def analyze_and_clean_sql(file_path):
    print(f"Analyzing {file_path}...")
    
    # Try reading with utf-16 (common for SQL Server dumps) then utf-8
    try:
        with open(file_path, 'r', encoding='utf-16') as f:
            content = f.read()
    except UnicodeError:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except:
            print("Could not read file encoding")
            return

    # Extract INSERT statements for TAREA
    # Looking for lines like: INSERT [dbo].[TAREA] (...) VALUES (...)
    # Or bulk inserts
    
    # Let's verify table name pattern first
    # Regular expression to find insert statements specifically for TAREA
    tarea_inserts = []
    
    # This is a simple parser, assuming standard SQL Server Management Studio insert format
    # which usually is: INSERT [dbo].[TAREA] ([id_tarea], ...) VALUES (1, ...)
    
    lines = content.split('\n')
    cleanup_script = []
    
    print(f"Total lines in file: {len(lines)}")
    
    task_count = 0
    bad_tasks = 0
    finished_tasks = 0
    
    print("\n--- Scanning for TAREA inserts ---")
    
    found_tarea_insert = False
    
    for line in lines:
        if "INSERT" in line and "TAREA" in line:
            found_tarea_insert = True
            # print(f"Found insert block: {line[:100]}...")
            
        if found_tarea_insert and "VALUES" in line:
            # Extract values
            # This is tricky without a full SQL parser, assuming one line per value set or similar
            if "Alerta sin descripción" in line:
                bad_tasks += 1
                # print(f"Found bad task: {line[:100]}...")
            
            if "'Terminada'" in line or "N'Terminada'" in line:
                finished_tasks += 1
                
            task_count += 1
            
            # Reset flag if using individual inserts
            # found_tarea_insert = False 
            
    print(f"\nStats:")
    print(f"Total TAREA inserts found (approx): {task_count}")
    print(f"Tasks with 'Alerta sin descripción': {bad_tasks}")
    print(f"Finished tasks: {finished_tasks}")
    
    # Generate Cleanup SQL
    cleanup_sql = """
-- CLEANUP SCRIPT
USE [SG_SST_AgenteInteligente];
GO

-- 1. Eliminar tareas inválidas "Alerta sin descripción"
DELETE FROM TAREA 
WHERE Descripcion LIKE '%Alerta sin descripción%' 
   OR Descripcion = 'Atender alerta crítica: ';

-- 2. Corregir estado de tareas "Terminada" que no tienen formulario (si aplica)
--    O simplemente reabrir tareas sospechosas
--    Aquí asumimos que queremos limpiar tareas masivas generadas por error
--    Eliminar tareas terminadas creadas automáticamente que parecen duplicadas (mismo responsable, misma fecha, misma descripción)

WITH cte AS (
    SELECT 
        id_tarea, 
        Descripcion, 
        id_empleado_responsable, 
        Fecha_Creacion,
        ROW_NUMBER() OVER (
            PARTITION BY Descripcion, id_empleado_responsable, CAST(Fecha_Creacion AS DATE) 
            ORDER BY Fecha_Creacion DESC
        ) row_num
    FROM 
        TAREA
    WHERE 
        Tipo_Tarea = 'Gestión Alerta' -- Solo limpiar las generadas por alertas
)
DELETE FROM cte WHERE row_num > 1;

-- 3. Verificar estado de alertas relacionadas
--    Asegurar que las alertas correspondientes a tareas eliminadas se reactiven si es necesario
--    (Opcional, depende de la lógica de negocio)

SELECT 'Cleanup completed.' as Message;
"""
    
    with open('BD/cleanup_data.sql', 'w', encoding='utf-8') as f:
        f.write(cleanup_sql)
        
    print("\nCreated BD/cleanup_data.sql")

if __name__ == "__main__":
    analyze_and_clean_sql("BD/script12Dic.sql")
