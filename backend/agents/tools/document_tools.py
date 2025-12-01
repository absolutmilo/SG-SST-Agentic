"""
Document Agent Tools

Specialized tools for the Document Processing Agent.
Integrates with database for document management and compliance verification.
"""

from typing import Dict, Any, List, Optional
from datetime import date
from .base_tools import BaseTool
import logging

logger = logging.getLogger(__name__)


class DocumentTools(BaseTool):
    """
    Tools for Document Processing Agent.
    
    Capabilities:
    - Search and retrieve documents
    - Verify compliance with legal requirements
    - Get document templates
    - Register document reviews
    - Get legal requirements
    """
    
    async def get_documents_by_type(
        self,
        doc_type: Optional[str] = None,
        estado: bool = True,
        limit: int = 50
    ) -> Dict[str, Any]:
        """
        Get documents filtered by type.
        
        Uses: CRUD search on DOCUMENTO table
        
        Args:
            doc_type: Document type (Política, Procedimiento, Instructivo, etc.)
            estado: Active status (default: True)
            limit: Maximum number of results
        
        Returns:
            List of documents
        
        Example:
            >>> docs = await tools.get_documents_by_type("Política")
        """
        try:
            filters = {"Estado": estado}
            if doc_type:
                filters["TipoDocumento"] = doc_type
            
            result = await self.crud_search(
                table_name="DOCUMENTO",
                filters=filters,
                limit=limit
            )
            
            return {
                "success": True,
                "total": result.get("total", 0),
                "documents": result.get("items", []),
                "type": doc_type or "Todos los tipos"
            }
        except Exception as e:
            logger.error(f"Error getting documents: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_legal_requirements(
        self,
        ambito: Optional[str] = None,
        estado_cumplimiento: Optional[str] = None,
        limit: int = 100
    ) -> Dict[str, Any]:
        """
        Get legal requirements.
        
        Uses: CRUD search on REQUISITO_LEGAL table
        
        Args:
            ambito: Scope (Nacional, Internacional, etc.)
            estado_cumplimiento: Compliance status (Cumple, No Cumple, Pendiente)
            limit: Maximum number of results
        
        Returns:
            List of legal requirements
        
        Example:
            >>> reqs = await tools.get_legal_requirements(ambito="Nacional")
        """
        try:
            filters = {}
            if ambito:
                filters["Ambito"] = ambito
            if estado_cumplimiento:
                filters["EstadoCumplimiento"] = estado_cumplimiento
            
            result = await self.crud_search(
                table_name="REQUISITO_LEGAL",
                filters=filters,
                limit=limit
            )
            
            return {
                "success": True,
                "total": result.get("total", 0),
                "requirements": result.get("items", []),
                "filters": {
                    "ambito": ambito,
                    "estado": estado_cumplimiento
                }
            }
        except Exception as e:
            logger.error(f"Error getting legal requirements: {e}")
            return {"success": False, "error": str(e)}
    
    async def get_document_templates(
        self,
        tipo_plantilla: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Get document templates.
        
        Uses: CRUD search on PLANTILLA_DOCUMENTO table
        
        Args:
            tipo_plantilla: Template type (optional)
        
        Returns:
            List of templates
        """
        try:
            filters = {}
            if tipo_plantilla:
                filters["TipoPlantilla"] = tipo_plantilla
            
            result = await self.crud_search(
                table_name="PLANTILLA_DOCUMENTO",
                filters=filters,
                limit=50
            )
            
            return {
                "success": True,
                "total": result.get("total", 0),
                "templates": result.get("items", [])
            }
        except Exception as e:
            logger.error(f"Error getting templates: {e}")
            return {"success": False, "error": str(e)}
    
    async def verify_document_compliance(
        self,
        document_id: int
    ) -> Dict[str, Any]:
        """
        Verify if a document meets compliance requirements.
        
        Uses: CRUD get on DOCUMENTO and EVALUACION_LEGAL tables
        
        Args:
            document_id: Document ID
        
        Returns:
            Compliance verification result
        """
        try:
            # Get document
            doc = await self.crud_get_one("DOCUMENTO", document_id)
            
            # Get legal evaluations for this document
            evaluations = await self.crud_search(
                table_name="EVALUACION_LEGAL",
                filters={"IdDocumento": document_id},
                limit=10
            )
            
            return {
                "success": True,
                "document": doc,
                "evaluations": evaluations.get("items", []),
                "total_evaluations": evaluations.get("total", 0),
                "message": f"Documento evaluado {evaluations.get('total', 0)} veces"
            }
        except Exception as e:
            logger.error(f"Error verifying compliance: {e}")
            return {"success": False, "error": str(e)}
    
    async def register_document_review(
        self,
        document_id: int,
        reviewer_id: int,
        estado: str,
        observaciones: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Register a document review.
        
        Uses: CRUD create on EVALUACION_LEGAL table
        
        Args:
            document_id: Document ID
            reviewer_id: Reviewer employee ID
            estado: Review status (Aprobado, Rechazado, Requiere Ajustes)
            observaciones: Review comments
        
        Returns:
            Created review record
        """
        try:
            data = {
                "IdDocumento": document_id,
                "IdRevisor": reviewer_id,
                "FechaEvaluacion": date.today().isoformat(),
                "Estado": estado,
                "Observaciones": observaciones
            }
            
            result = await self.crud_create("EVALUACION_LEGAL", data)
            
            return {
                "success": True,
                "review": result.get("data"),
                "message": f"Revisión registrada: {estado}"
            }
        except Exception as e:
            logger.error(f"Error registering review: {e}")
            return {"success": False, "error": str(e)}
    
    async def search_documents_by_keyword(
        self,
        keyword: str,
        limit: int = 20
    ) -> Dict[str, Any]:
        """
        Search documents by keyword in title or description.
        
        Uses: CRUD get all and filter (basic implementation)
        
        Args:
            keyword: Search keyword
            limit: Maximum results
        
        Returns:
            Matching documents
        """
        try:
            # Get all documents (would be better with full-text search)
            result = await self.crud_get_all("DOCUMENTO", limit=200)
            
            # Filter by keyword
            keyword_lower = keyword.lower()
            matching = []
            
            for doc in result.get("items", []):
                title = doc.get("NombreDocumento", "").lower()
                desc = doc.get("Descripcion", "").lower()
                
                if keyword_lower in title or keyword_lower in desc:
                    matching.append(doc)
                    if len(matching) >= limit:
                        break
            
            return {
                "success": True,
                "total": len(matching),
                "documents": matching,
                "keyword": keyword
            }
        except Exception as e:
            logger.error(f"Error searching documents: {e}")
            return {"success": False, "error": str(e)}
    
    def get_tool_descriptions(self) -> List[Dict[str, str]]:
        """Get descriptions of all available tools for LLM."""
        return [
            {
                "name": "get_documents_by_type",
                "description": "Obtiene documentos filtrados por tipo (Política, Procedimiento, etc.)",
                "parameters": "doc_type (str), estado (bool), limit (int)"
            },
            {
                "name": "get_legal_requirements",
                "description": "Obtiene requisitos legales con filtros opcionales",
                "parameters": "ambito (str), estado_cumplimiento (str), limit (int)"
            },
            {
                "name": "get_document_templates",
                "description": "Obtiene plantillas de documentos disponibles",
                "parameters": "tipo_plantilla (str, opcional)"
            },
            {
                "name": "verify_document_compliance",
                "description": "Verifica el cumplimiento de un documento con requisitos legales",
                "parameters": "document_id (int)"
            },
            {
                "name": "register_document_review",
                "description": "Registra una revisión de documento",
                "parameters": "document_id (int), reviewer_id (int), estado (str), observaciones (str)"
            },
            {
                "name": "search_documents_by_keyword",
                "description": "Busca documentos por palabra clave en título o descripción",
                "parameters": "keyword (str), limit (int)"
            }
        ]
