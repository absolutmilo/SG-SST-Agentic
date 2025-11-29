import os
import json
import datetime

def format_time(ts):
    """Convierte timestamps a formato ISO 8601."""
    return datetime.datetime.fromtimestamp(ts).isoformat()

def folder_to_json(path):
    """
    Construye un árbol JSON de archivos y carpetas incluyendo:
    - type
    - name
    - created_at
    - modified_at
    - children (si es carpeta)
    """
    stats = os.stat(path)

    node = {
        "type": "folder" if os.path.isdir(path) else "file",
        "name": os.path.basename(path),
        "created_at": format_time(stats.st_ctime),
        "modified_at": format_time(stats.st_mtime)
    }

    if os.path.isdir(path):
        node["children"] = []
        for entry in sorted(os.listdir(path)):
            full = os.path.join(path, entry)
            node["children"].append(folder_to_json(full))

    return node


# ---------------------------------------------------------
# USO: analizar la carpeta donde está el script
# ---------------------------------------------------------

# carpeta donde está el script .py
script_dir = os.path.dirname(os.path.abspath(__file__))

# analizar esa carpeta como raíz
tree_json = folder_to_json(script_dir)

# archivo de salida en la MISMA carpeta
output_file = "estructura_carpetas.json"
output_path = os.path.join(script_dir, output_file)

# guardar JSON
with open(output_path, "w", encoding="utf-8") as f:
    json.dump(tree_json, f, ensure_ascii=False, indent=4)

print(f"Archivo JSON generado en:\n{output_path}")
