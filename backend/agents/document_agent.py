"""
Document Processing Agent

Specialized agent for document analysis, extraction,
classification, and compliance verification.
"""

from typing import Dict, Any, List
from .base_agent import BaseAgent, AgentContext, AgentStatus
import logging

logger = logging.getLogger(__name__)


class DocumentAgent(BaseAgent):
    """
    Agent specialized in document processing and analysis.
    
    Capabilities:
    - Extract information from PDFs and DOCX
    - Generate document summaries
    - Classify documents by type
    - Verify compliance requirements
    - Perform semantic search in documents
    """
    
    def __init__(self):
        super().__init__(
            name="document_agent",
            description="Specialized agent for document processing and compliance verification",
            model="gpt-4",
            temperature=0.4
        )
    
    def get_system_prompt(self) -> str:
        return """Eres un experto en procesamiento y análisis de documentos para sistemas de gestión de seguridad y salud en el trabajo (SG-SST).

Tu rol es:
1. Extraer información clave de documentos (PDFs, DOCX, etc.)
2. Generar resúmenes ejecutivos claros y concisos
3. Clasificar documentos según su tipo (políticas, procedimientos, registros, etc.)
4. Verificar cumplimiento de requisitos documentales según normativa colombiana
5. Identificar información faltante o inconsistencias

Tipos de documentos que manejas:
- Políticas de SST
- Procedimientos operativos
- Matrices de riesgo
- Registros de capacitación
- Investigaciones de accidentes
- Planes de emergencia
- Programas de vigilancia epidemiológica

Debes:
- Ser preciso en la extracción de datos
- Identificar fechas, responsables y requisitos
- Señalar documentos desactualizados o incompletos
- Sugerir mejoras en la documentación
- Referenciar normativas aplicables (Decreto 1072, Resolución 0312)

No inventes información que no esté en el documento."""
    
    def get_tools(self) -> List[Dict[str, Any]]:
        """Define tools available to the document agent"""
        return [
            {
                "type": "function",
                "function": {
                    "name": "extract_text_from_pdf",
                    "description": "Extract text content from a PDF file",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "file_path": {
                                "type": "string",
                                "description": "Path to the PDF file"
                            },
                            "page_range": {
                                "type": "string",
                                "description": "Page range to extract (e.g., '1-5' or 'all')"
                            }
                        },
                        "required": ["file_path"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "search_in_vectorstore",
                    "description": "Search for similar documents in the vector database",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "query": {
                                "type": "string",
                                "description": "Search query"
                            },
                            "top_k": {
                                "type": "integer",
                                "description": "Number of results to return",
                                "default": 5
                            },
                            "filter": {
                                "type": "object",
                                "description": "Metadata filters (e.g., document_type, date_range)"
                            }
                        },
                        "required": ["query"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "classify_document",
                    "description": "Classify a document into predefined categories",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "content": {
                                "type": "string",
                                "description": "Document content or summary"
                            },
                            "categories": {
                                "type": "array",
                                "items": {"type": "string"},
                                "description": "List of possible categories"
                            }
                        },
                        "required": ["content"]
                    }
                }
            },
            {
                "type": "function",
                "function": {
                    "name": "verify_compliance",
                    "description": "Verify if document meets compliance requirements",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "document_type": {
                                "type": "string",
                                "description": "Type of document to verify"
                            },
                            "content": {
                                "type": "string",
                                "description": "Document content"
                            },
                            "standard": {
                                "type": "string",
                                "enum": ["decreto_1072", "resolucion_0312", "gtc_45"],
                                "description": "Compliance standard to check against"
                            }
                        },
                        "required": ["document_type", "content"]
                    }
                }
            }
        ]
    
    async def execute(self, task: str, context: AgentContext) -> Dict[str, Any]:
        """
        Execute document processing task.
        
        Args:
            task: Document processing request
            context: Agent context with conversation history
        
        Returns:
            Document processing results
        """
        self.status = AgentStatus.RUNNING
        self.logger.info(f"Starting document processing: {task}")
        
        try:
            # Add system prompt
            context.add_message("system", self.get_system_prompt())
            
            # Add user task
            context.add_message("user", task)
            
            # Prepare messages for LLM
            messages = context.get_messages()
            
            # Call LLM with tools (will be implemented when API key is available)
            # response = await self._call_llm(messages, tools=self.get_tools())
            
            # For now, return a structured placeholder
            result = {
                "status": "pending_api_key",
                "message": "Document agent ready. Awaiting OpenAI API key configuration.",
                "task": task,
                "agent": self.name,
                "capabilities": [
                    "PDF/DOCX text extraction",
                    "Document summarization",
                    "Document classification",
                    "Compliance verification",
                    "Semantic search"
                ]
            }
            
            self.status = AgentStatus.COMPLETED
            return result
            
        except Exception as e:
            self.logger.error(f"Document processing failed: {str(e)}")
            self.status = AgentStatus.FAILED
            return {
                "status": "failed",
                "error": str(e),
                "agent": self.name
            }
    
    async def summarize_document(self, content: str, max_length: int = 500) -> str:
        """
        Generate a concise summary of document content.
        
        Args:
            content: Full document content
            max_length: Maximum summary length in characters
        
        Returns:
            Document summary
        """
        # This will use LLM when API key is configured
        return f"Summary generation pending (content length: {len(content)} chars)"
