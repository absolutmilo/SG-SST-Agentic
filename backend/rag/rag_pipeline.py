"""
RAG Pipeline

Complete Retrieval-Augmented Generation pipeline combining
document retrieval with LLM generation.
"""

from typing import List, Dict, Any, Optional
import logging
from .loaders import Document
from .embeddings import EmbeddingGenerator
from .vectorstore import VectorStore

logger = logging.getLogger(__name__)


class RAGPipeline:
    """
    Complete RAG pipeline for question answering.
    
    Workflow:
    1. Generate query embedding
    2. Retrieve relevant documents from vectorstore
    3. Rerank results (optional)
    4. Generate answer using LLM with retrieved context
    5. Track citations
    """
    
    def __init__(
        self,
        vectorstore: VectorStore,
        embedding_generator: EmbeddingGenerator,
        top_k: int = 5,
        rerank: bool = False
    ):
        self.vectorstore = vectorstore
        self.embedding_generator = embedding_generator
        self.top_k = top_k
        self.rerank = rerank
        self.logger = logging.getLogger("rag.pipeline")
    
    async def query(
        self,
        question: str,
        filter_metadata: Optional[Dict[str, Any]] = None,
        return_sources: bool = True
    ) -> Dict[str, Any]:
        """
        Query the RAG system.
        
        Args:
            question: User question
            filter_metadata: Optional metadata filters for retrieval
            return_sources: Whether to return source documents
        
        Returns:
            Answer with optional sources and citations
        """
        try:
            # Step 1: Generate query embedding
            self.logger.info(f"Processing query: {question}")
            query_embedding = self.embedding_generator.embed_text(question)
            
            # Step 2: Retrieve relevant documents
            results = self.vectorstore.search(
                query_embedding=query_embedding,
                top_k=self.top_k,
                filter_metadata=filter_metadata
            )
            
            if not results:
                return {
                    "answer": "No se encontraron documentos relevantes para responder la pregunta.",
                    "sources": [],
                    "confidence": 0.0
                }
            
            # Step 3: Rerank if enabled
            if self.rerank:
                results = self._rerank_results(question, results)
            
            # Step 4: Build context from retrieved documents
            context = self._build_context(results)
            
            # Step 5: Generate answer with LLM (placeholder for now)
            answer = await self._generate_answer(question, context)
            
            # Step 6: Extract citations
            citations = self._extract_citations(results)
            
            response = {
                "answer": answer,
                "confidence": self._calculate_confidence(results),
                "query": question
            }
            
            if return_sources:
                response["sources"] = citations
                response["num_sources"] = len(results)
            
            return response
            
        except Exception as e:
            self.logger.error(f"RAG query failed: {e}")
            return {
                "answer": f"Error procesando la consulta: {str(e)}",
                "sources": [],
                "confidence": 0.0
            }
    
    def _build_context(self, results: List[Dict[str, Any]]) -> str:
        """Build context string from retrieved documents"""
        context_parts = []
        
        for i, result in enumerate(results):
            text = result.get("text", "")
            metadata = result.get("metadata", {})
            source = metadata.get("source", "Unknown")
            
            context_parts.append(
                f"[Documento {i+1}] (Fuente: {source})\n{text}\n"
            )
        
        return "\n".join(context_parts)
    
    async def _generate_answer(self, question: str, context: str) -> str:
        """Generate answer using LLM with context"""
        # This will use OpenAI API when configured
        # For now, return placeholder
        
        prompt = f"""Basándote en el siguiente contexto, responde la pregunta.

Contexto:
{context}

Pregunta: {question}

Respuesta:"""
        
        # Placeholder response
        return f"Respuesta generada basada en {len(context)} caracteres de contexto (pendiente configuración de API de OpenAI)"
    
    def _rerank_results(
        self,
        query: str,
        results: List[Dict[str, Any]]
    ) -> List[Dict[str, Any]]:
        """Rerank results for better relevance"""
        # Simple reranking based on keyword matching
        # Can be enhanced with cross-encoder models
        
        query_words = set(query.lower().split())
        
        def relevance_score(result: Dict[str, Any]) -> float:
            text = result.get("text", "").lower()
            text_words = set(text.split())
            
            # Jaccard similarity
            intersection = query_words & text_words
            union = query_words | text_words
            
            if not union:
                return 0.0
            
            return len(intersection) / len(union)
        
        # Sort by relevance score
        reranked = sorted(results, key=relevance_score, reverse=True)
        
        self.logger.info("Results reranked")
        
        return reranked
    
    def _extract_citations(self, results: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Extract citation information from results"""
        citations = []
        
        for result in results:
            metadata = result.get("metadata", {})
            citations.append({
                "source": metadata.get("source", "Unknown"),
                "text_snippet": result.get("text", "")[:200] + "...",
                "score": result.get("score", 0.0),
                "metadata": metadata
            })
        
        return citations
    
    def _calculate_confidence(self, results: List[Dict[str, Any]]) -> float:
        """Calculate confidence score based on retrieval results"""
        if not results:
            return 0.0
        
        # Average of top result scores
        scores = [r.get("score", 0.0) for r in results]
        return sum(scores) / len(scores) if scores else 0.0


class HybridRAGPipeline(RAGPipeline):
    """
    Hybrid RAG pipeline combining semantic and keyword search.
    """
    
    async def query(
        self,
        question: str,
        filter_metadata: Optional[Dict[str, Any]] = None,
        return_sources: bool = True
    ) -> Dict[str, Any]:
        """Query using hybrid search (semantic + keyword)"""
        
        # Get semantic search results
        semantic_results = await super().query(
            question,
            filter_metadata,
            return_sources=False
        )
        
        # TODO: Add keyword search (BM25) and merge results
        
        return semantic_results
