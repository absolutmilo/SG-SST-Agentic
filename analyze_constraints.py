import re

file_path = r"c:\Users\PERSONAL\Documents\DEV\SGSST AGENTIC\BD\SetupDB.sql"

def analyze_constraints():
    try:
        with open(file_path, 'r', encoding='utf-16') as f:
            content = f.read()
    except UnicodeError:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except UnicodeError:
            with open(file_path, 'r', encoding='latin-1') as f:
                content = f.read()

    # Find all ALTER TABLE statements for EQUIPO that add a CHECK constraint
    # Pattern: ALTER TABLE [dbo].[EQUIPO] ... CHECK ... ( ... )
    
    # Simple line-by-line scan first
    lines = content.split('\n')
    for i, line in enumerate(lines):
        if ("TABLE [dbo].[EQUIPO]" in line or "TABLE [dbo].[INSPECCION]" in line) and "CHECK" in line:
            print(f"Line {i}: {line}")
            # Print context
            for j in range(1, 10):
                if i+j < len(lines):
                    print(f"  {lines[i+j]}")
                    if "GO" in lines[i+j]:
                        break

if __name__ == "__main__":
    analyze_constraints()
