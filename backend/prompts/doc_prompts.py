"""
Document Processing Prompts

Prompt templates for document analysis and processing.
"""


class DocumentPrompts:
    """Prompt templates for document agent"""
    
    DOCUMENT_SUMMARY = """Genera un resumen ejecutivo del siguiente documento:

Tipo de documento: {doc_type}
Contenido:
{content}

El resumen debe incluir:
1. Propósito principal del documento
2. Puntos clave (máximo 5)
3. Información crítica (fechas, responsables, requisitos)
4. Conclusiones o recomendaciones principales

Longitud máxima: {max_length} palabras
Tono: Profesional y conciso"""
    
    DOCUMENT_CLASSIFICATION = """Clasifica el siguiente documento en una de estas categorías:

Categorías disponibles:
- Política de SST
- Procedimiento operativo
- Matriz de riesgos
- Registro de capacitación
- Investigación de accidente
- Plan de emergencia
- Programa de vigilancia epidemiológica
- Reglamento interno
- Acta de reunión
- Informe de auditoría
- Otro

Documento:
{content}

Proporciona:
1. Categoría principal
2. Subcategoría (si aplica)
3. Confianza de la clasificación (0-100%)
4. Razones de la clasificación"""
    
    INFORMATION_EXTRACTION = """Extrae la siguiente información del documento:

Documento:
{content}

Información a extraer:
{fields_to_extract}

Para cada campo, proporciona:
- Valor encontrado (o "No encontrado")
- Ubicación en el documento (página/sección)
- Nivel de confianza

Formato de salida: JSON"""
    
    COMPLIANCE_VERIFICATION = """Verifica el cumplimiento del documento contra los requisitos:

Documento:
{content}

Tipo de documento: {doc_type}
Estándar de cumplimiento: {standard}

Requisitos a verificar:
{requirements}

Para cada requisito, indica:
1. ¿Cumple? (Sí/No/Parcial)
2. Evidencia encontrada
3. Gaps identificados
4. Recomendaciones de mejora

Formato: Tabla markdown"""
    
    DOCUMENT_COMPARISON = """Compara los siguientes documentos:

Documento 1:
{doc1}

Documento 2:
{doc2}

Proporciona:
1. Similitudes principales
2. Diferencias clave
3. Información presente en uno pero no en el otro
4. Inconsistencias o contradicciones
5. Recomendaciones de consolidación

Formato: Secciones claras"""
    
    METADATA_EXTRACTION = """Extrae los metadatos del documento:

Documento:
{content}

Extrae:
- Título
- Autor(es)
- Fecha de creación
- Fecha de última modificación
- Versión
- Departamento/Área
- Palabras clave
- Clasificación de confidencialidad
- Fecha de revisión programada
- Aprobadores

Formato: JSON"""
    
    @classmethod
    def format_summary(
        cls,
        content: str,
        doc_type: str = "General",
        max_length: int = 200
    ) -> str:
        """Format document summary prompt"""
        return cls.DOCUMENT_SUMMARY.format(
            doc_type=doc_type,
            content=content,
            max_length=max_length
        )
    
    @classmethod
    def format_classification(cls, content: str) -> str:
        """Format document classification prompt"""
        return cls.DOCUMENT_CLASSIFICATION.format(content=content)
    
    @classmethod
    def format_extraction(
        cls,
        content: str,
        fields_to_extract: list
    ) -> str:
        """Format information extraction prompt"""
        fields_str = "\n".join(f"- {field}" for field in fields_to_extract)
        return cls.INFORMATION_EXTRACTION.format(
            content=content,
            fields_to_extract=fields_str
        )
    
    @classmethod
    def format_compliance_check(
        cls,
        content: str,
        doc_type: str,
        standard: str,
        requirements: list
    ) -> str:
        """Format compliance verification prompt"""
        req_str = "\n".join(f"- {req}" for req in requirements)
        return cls.COMPLIANCE_VERIFICATION.format(
            content=content,
            doc_type=doc_type,
            standard=standard,
            requirements=req_str
        )
