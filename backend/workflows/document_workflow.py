"""
Document Processing Workflow

Workflow for document ingestion, processing, and indexing.
"""

from typing import Dict, Any
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from orchestrator.workflow_engine import Workflow, WorkflowStep


def create_document_workflow(workflow_id: str, params: Dict[str, Any]) -> Workflow:
    """
    Create a document processing workflow.
    
    Workflow steps:
    1. Load and extract content
    2. Classify document
    3. Index in vectorstore
    4. Verify compliance
    5. Generate summary
    6. Store and catalog
    
    Args:
        workflow_id: Unique workflow ID
        params: Workflow parameters (file_path, doc_type, etc.)
    
    Returns:
        Configured Workflow
    """
    
    file_path = params.get("file_path", "")
    doc_type = params.get("doc_type", "auto")
    
    steps = [
        WorkflowStep(
            step_id="extract_content",
            name="Extraer Contenido",
            agent_name="document_agent",
            params={
                "task": f"Extraer contenido de {file_path}",
                "file_path": file_path
            }
        ),
        WorkflowStep(
            step_id="classify_document",
            name="Clasificar Documento",
            agent_name="document_agent",
            depends_on=["extract_content"],
            params={
                "task": "Clasificar tipo de documento",
                "auto_classify": doc_type == "auto"
            }
        ),
        WorkflowStep(
            step_id="index_vectorstore",
            name="Indexar en Vectorstore",
            depends_on=["extract_content"],
            params={
                "task": "Generar embeddings e indexar en FAISS",
                "chunk_size": 1000,
                "chunk_overlap": 200
            }
        ),
        WorkflowStep(
            step_id="verify_compliance",
            name="Verificar Cumplimiento",
            agent_name="document_agent",
            depends_on=["classify_document"],
            params={
                "task": "Verificar cumplimiento de requisitos documentales",
                "standard": "decreto_1072"
            }
        ),
        WorkflowStep(
            step_id="generate_summary",
            name="Generar Resumen",
            agent_name="document_agent",
            depends_on=["extract_content"],
            params={
                "task": "Generar resumen ejecutivo del documento",
                "max_length": 200
            }
        ),
        WorkflowStep(
            step_id="catalog_document",
            name="Catalogar Documento",
            depends_on=["classify_document", "generate_summary", "verify_compliance"],
            params={
                "task": "Almacenar documento con metadata en base de datos"
            }
        )
    ]
    
    workflow = Workflow(
        workflow_id=workflow_id,
        name="Procesamiento de Documentos",
        description=f"Workflow de procesamiento para {file_path}",
        steps=steps,
        metadata={
            "file_path": file_path,
            "doc_type": doc_type,
            "workflow_type": "document_processing"
        }
    )
    
    return workflow


async def execute_document_workflow(file_path: str, doc_type: str = "auto") -> Dict[str, Any]:
    """
    Execute document processing workflow.
    
    Args:
        file_path: Path to document file
        doc_type: Document type (or 'auto' for automatic classification)
    
    Returns:
        Workflow execution results
    """
    from orchestrator.workflow_engine import WorkflowEngine
    
    engine = WorkflowEngine()
    workflow_id = f"doc_{os.path.basename(file_path)}".replace(".", "_").lower()
    
    params = {
        "file_path": file_path,
        "doc_type": doc_type
    }
    
    # Register the workflow template
    engine.register_template("document_processing", create_document_workflow)
    
    # Start workflow
    result = await engine.start_workflow(workflow_id, "document_processing", params)
    
    return result
