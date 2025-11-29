"""
RAG API Router

FastAPI endpoints for RAG (Retrieval-Augmented Generation) queries.
"""

from fastapi import APIRouter, HTTPException, UploadFile, File
from pydantic import BaseModel, Field
from typing import Optional, Dict, Any, List
import logging
from datetime import datetime

# Import RAG components
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from rag.rag_pipeline import RAGPipeline
from rag.vectorstore import VectorStore
from rag.embeddings import EmbeddingGenerator
from rag.loaders import DocumentLoader, PDFLoader, DOCXLoader

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/rag", tags=["rag"])

# Initialize RAG components
embedding_generator = EmbeddingGenerator()
vectorstore = VectorStore(index_path="./vector/index")
rag_pipeline = RAGPipeline(
    vectorstore=vectorstore,
    embedding_generator=embedding_generator,
    top_k=5,
    rerank=True
)


# ============================================
# Request/Response Models
# ============================================

class RAGQueryRequest(BaseModel):
    """Request for RAG query"""
    question: str = Field(..., description="Question to answer")
    user_id: int = Field(..., description="ID of the user making the query")
    filter_metadata: Optional[Dict[str, Any]] = Field(
        default=None,
        description="Metadata filters for document retrieval"
    )
    top_k: Optional[int] = Field(default=5, description="Number of documents to retrieve")
    return_sources: Optional[bool] = Field(default=True, description="Whether to return source documents")


class RAGQueryResponse(BaseModel):
    """Response from RAG query"""
    answer: str
    confidence: float
    sources: Optional[List[Dict[str, Any]]] = None
    num_sources: Optional[int] = None
    query: str


class DocumentIngestRequest(BaseModel):
    """Request to ingest a document"""
    file_path: str = Field(..., description="Path to the document file")
    doc_type: str = Field(default="general", description="Type of document")
    metadata: Optional[Dict[str, Any]] = Field(default=None, description="Additional metadata")


class DocumentIngestResponse(BaseModel):
    """Response from document ingestion"""
    status: str
    file_path: str
    chunks_created: int
    doc_ids: List[str]
    message: Optional[str] = None


class SearchRequest(BaseModel):
    """Request for similarity search"""
    query: str = Field(..., description="Search query")
    top_k: Optional[int] = Field(default=5, description="Number of results")
    filter_metadata: Optional[Dict[str, Any]] = Field(default=None, description="Metadata filters")


class SearchResponse(BaseModel):
    """Response from similarity search"""
    results: List[Dict[str, Any]]
    total: int
    query: str


# ============================================
# Endpoints
# ============================================

@router.post("/query", response_model=RAGQueryResponse)
async def query_rag(request: RAGQueryRequest):
    """
    Query the RAG system with a question.
    
    This endpoint:
    1. Retrieves relevant documents from vectorstore
    2. Generates an answer using LLM with retrieved context
    3. Returns answer with sources and confidence score
    """
    try:
        result = await rag_pipeline.query(
            question=request.question,
            filter_metadata=request.filter_metadata,
            return_sources=request.return_sources
        )
        
        # Log query for analytics
        logger.info(
            f"RAG query from user {request.user_id}",
            extra={
                "user_id": request.user_id,
                "question": request.question,
                "confidence": result.get("confidence", 0)
            }
        )
        
        return RAGQueryResponse(
            answer=result["answer"],
            confidence=result["confidence"],
            sources=result.get("sources"),
            num_sources=result.get("num_sources"),
            query=request.question
        )
        
    except Exception as e:
        logger.error(f"Error processing RAG query: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error processing query: {str(e)}"
        )


@router.post("/search", response_model=SearchResponse)
async def search_documents(request: SearchRequest):
    """
    Perform similarity search in the vectorstore.
    
    Returns relevant document chunks without LLM generation.
    """
    try:
        # Generate query embedding
        query_embedding = embedding_generator.embed_text(request.query)
        
        # Search vectorstore
        results = vectorstore.search(
            query_embedding=query_embedding,
            top_k=request.top_k,
            filter_metadata=request.filter_metadata
        )
        
        return SearchResponse(
            results=results,
            total=len(results),
            query=request.query
        )
        
    except Exception as e:
        logger.error(f"Error performing search: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error performing search: {str(e)}"
        )


@router.post("/ingest", response_model=DocumentIngestResponse)
async def ingest_document(request: DocumentIngestRequest):
    """
    Ingest a document into the vectorstore.
    
    Supported formats: PDF, DOCX, TXT
    """
    try:
        file_path = request.file_path
        
        # Validate file exists
        if not os.path.exists(file_path):
            raise HTTPException(
                status_code=404,
                detail=f"File not found: {file_path}"
            )
        
        # Determine loader based on file extension
        ext = os.path.splitext(file_path)[1].lower()
        
        if ext == '.pdf':
            loader = PDFLoader()
        elif ext in ['.docx', '.doc']:
            loader = DOCXLoader()
        else:
            loader = DocumentLoader()
        
        # Load document
        documents = loader.load(file_path)
        
        if not documents:
            raise HTTPException(
                status_code=400,
                detail="No content extracted from document"
            )
        
        # Add metadata
        for doc in documents:
            doc.metadata["doc_type"] = request.doc_type
            if request.metadata:
                doc.metadata.update(request.metadata)
        
        # Generate embeddings
        texts = [doc.content for doc in documents]
        embeddings = embedding_generator.embed_batch(texts)
        
        # Add to vectorstore
        metadata = [doc.metadata for doc in documents]
        doc_ids = vectorstore.add_documents(texts, embeddings, metadata)
        
        # Save vectorstore
        vectorstore.save()
        
        return DocumentIngestResponse(
            status="success",
            file_path=file_path,
            chunks_created=len(doc_ids),
            doc_ids=doc_ids,
            message=f"Successfully ingested {len(doc_ids)} chunks"
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error ingesting document: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error ingesting document: {str(e)}"
        )


@router.post("/ingest/upload")
async def upload_and_ingest(
    file: UploadFile = File(...),
    doc_type: str = "general",
    user_id: int = 0
):
    """
    Upload and ingest a document file.
    
    This endpoint accepts file uploads and processes them.
    """
    try:
        # Save uploaded file temporarily
        temp_path = f"./temp/{file.filename}"
        os.makedirs("./temp", exist_ok=True)
        
        with open(temp_path, "wb") as f:
            content = await file.read()
            f.write(content)
        
        # Ingest the file
        ingest_request = DocumentIngestRequest(
            file_path=temp_path,
            doc_type=doc_type,
            metadata={"uploaded_by": user_id, "original_filename": file.filename}
        )
        
        result = await ingest_document(ingest_request)
        
        # Clean up temp file
        os.remove(temp_path)
        
        return result
        
    except Exception as e:
        logger.error(f"Error uploading and ingesting file: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error uploading file: {str(e)}"
        )


@router.get("/stats")
async def get_vectorstore_stats():
    """Get statistics about the vectorstore"""
    try:
        stats = vectorstore.get_stats()
        return stats
        
    except Exception as e:
        logger.error(f"Error getting vectorstore stats: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Error getting stats: {str(e)}"
        )


@router.delete("/document/{doc_id}")
async def delete_document(doc_id: str):
    """
    Delete a document from the vectorstore.
    
    Note: This is a placeholder. Actual implementation would require
    document tracking and deletion logic.
    """
    # TODO: Implement document deletion
    return {
        "status": "not_implemented",
        "doc_id": doc_id,
        "message": "Document deletion not yet implemented"
    }


@router.get("/documents")
async def list_documents(
    doc_type: Optional[str] = None,
    limit: int = 50,
    offset: int = 0
):
    """
    List documents in the vectorstore.
    
    Note: This is a placeholder. Actual implementation would require
    document catalog in database.
    """
    # TODO: Implement document listing from database
    return {
        "documents": [],
        "total": 0,
        "limit": limit,
        "offset": offset,
        "message": "Document listing not yet implemented"
    }
