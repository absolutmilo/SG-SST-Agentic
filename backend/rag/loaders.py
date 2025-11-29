"""
Document Loaders

Load and process documents from various formats (PDF, DOCX, TXT)
for ingestion into the vectorstore.
"""

from typing import List, Dict, Any, Optional
from pathlib import Path
import logging

logger = logging.getLogger(__name__)


class Document:
    """Represents a document chunk with content and metadata"""
    
    def __init__(
        self,
        content: str,
        metadata: Optional[Dict[str, Any]] = None,
        doc_id: Optional[str] = None
    ):
        self.content = content
        self.metadata = metadata or {}
        self.doc_id = doc_id
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "content": self.content,
            "metadata": self.metadata,
            "doc_id": self.doc_id
        }


class DocumentLoader:
    """Base class for document loaders"""
    
    def __init__(self, chunk_size: int = 1000, chunk_overlap: int = 200):
        self.chunk_size = chunk_size
        self.chunk_overlap = chunk_overlap
        self.logger = logging.getLogger("rag.loader")
    
    def load(self, file_path: str) -> List[Document]:
        """Load a document and return chunks"""
        raise NotImplementedError
    
    def chunk_text(self, text: str, metadata: Optional[Dict[str, Any]] = None) -> List[Document]:
        """
        Split text into overlapping chunks.
        
        Args:
            text: Text to chunk
            metadata: Metadata to attach to each chunk
        
        Returns:
            List of Document chunks
        """
        chunks = []
        start = 0
        
        while start < len(text):
            end = start + self.chunk_size
            chunk_text = text[start:end]
            
            # Try to break at sentence boundary
            if end < len(text):
                last_period = chunk_text.rfind('.')
                last_newline = chunk_text.rfind('\n')
                break_point = max(last_period, last_newline)
                
                if break_point > self.chunk_size * 0.5:  # At least 50% of chunk size
                    chunk_text = chunk_text[:break_point + 1]
                    end = start + break_point + 1
            
            chunk_metadata = metadata.copy() if metadata else {}
            chunk_metadata['chunk_index'] = len(chunks)
            chunk_metadata['start_char'] = start
            chunk_metadata['end_char'] = end
            
            chunks.append(Document(
                content=chunk_text.strip(),
                metadata=chunk_metadata
            ))
            
            start = end - self.chunk_overlap
        
        return chunks


class PDFLoader(DocumentLoader):
    """Load PDF documents"""
    
    def load(self, file_path: str) -> List[Document]:
        """
        Load a PDF file and extract text.
        
        Args:
            file_path: Path to PDF file
        
        Returns:
            List of Document chunks
        """
        try:
            # This will use pypdf when installed
            # For now, return placeholder
            self.logger.info(f"Loading PDF: {file_path}")
            
            metadata = {
                "source": file_path,
                "file_type": "pdf",
                "loader": "PDFLoader"
            }
            
            # Placeholder - will implement with pypdf
            return [Document(
                content=f"PDF content from {file_path} (pending pypdf installation)",
                metadata=metadata
            )]
            
        except Exception as e:
            self.logger.error(f"Failed to load PDF {file_path}: {e}")
            return []


class DOCXLoader(DocumentLoader):
    """Load DOCX documents"""
    
    def load(self, file_path: str) -> List[Document]:
        """
        Load a DOCX file and extract text.
        
        Args:
            file_path: Path to DOCX file
        
        Returns:
            List of Document chunks
        """
        try:
            # This will use python-docx when installed
            self.logger.info(f"Loading DOCX: {file_path}")
            
            metadata = {
                "source": file_path,
                "file_type": "docx",
                "loader": "DOCXLoader"
            }
            
            # Placeholder - will implement with python-docx
            return [Document(
                content=f"DOCX content from {file_path} (pending python-docx installation)",
                metadata=metadata
            )]
            
        except Exception as e:
            self.logger.error(f"Failed to load DOCX {file_path}: {e}")
            return []


class TextLoader(DocumentLoader):
    """Load plain text documents"""
    
    def load(self, file_path: str) -> List[Document]:
        """
        Load a text file.
        
        Args:
            file_path: Path to text file
        
        Returns:
            List of Document chunks
        """
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                text = f.read()
            
            metadata = {
                "source": file_path,
                "file_type": "txt",
                "loader": "TextLoader"
            }
            
            return self.chunk_text(text, metadata)
            
        except Exception as e:
            self.logger.error(f"Failed to load text file {file_path}: {e}")
            return []


class DirectoryLoader:
    """Load all documents from a directory"""
    
    LOADER_MAP = {
        '.pdf': PDFLoader,
        '.docx': DOCXLoader,
        '.doc': DOCXLoader,
        '.txt': TextLoader,
        '.md': TextLoader
    }
    
    def __init__(self, chunk_size: int = 1000, chunk_overlap: int = 200):
        self.chunk_size = chunk_size
        self.chunk_overlap = chunk_overlap
        self.logger = logging.getLogger("rag.directory_loader")
    
    def load(self, directory: str, recursive: bool = True) -> List[Document]:
        """
        Load all supported documents from a directory.
        
        Args:
            directory: Directory path
            recursive: Whether to search subdirectories
        
        Returns:
            List of all Document chunks
        """
        path = Path(directory)
        
        if not path.exists():
            self.logger.error(f"Directory not found: {directory}")
            return []
        
        all_documents = []
        pattern = "**/*" if recursive else "*"
        
        for file_path in path.glob(pattern):
            if file_path.is_file():
                suffix = file_path.suffix.lower()
                
                if suffix in self.LOADER_MAP:
                    loader_class = self.LOADER_MAP[suffix]
                    loader = loader_class(
                        chunk_size=self.chunk_size,
                        chunk_overlap=self.chunk_overlap
                    )
                    
                    documents = loader.load(str(file_path))
                    all_documents.extend(documents)
                    
                    self.logger.info(
                        f"Loaded {len(documents)} chunks from {file_path.name}"
                    )
        
        self.logger.info(
            f"Loaded total of {len(all_documents)} chunks from {directory}"
        )
        
        return all_documents
