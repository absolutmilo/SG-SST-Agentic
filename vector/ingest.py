"""
Document Ingestion Script

Ingest documents into the vectorstore for RAG.
"""

import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

import yaml
import asyncio
import logging
from pathlib import Path
from typing import List, Dict, Any

from rag.loaders import DirectoryLoader, Document
from rag.embeddings import EmbeddingGenerator
from rag.vectorstore import VectorStore

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class DocumentIngester:
    """Ingest documents into vectorstore"""
    
    def __init__(self, config_path: str = "config.yaml"):
        """Initialize ingester with configuration"""
        self.config = self._load_config(config_path)
        
        # Initialize components
        self.embedding_generator = EmbeddingGenerator(
            model_name=self.config["embedding_model"],
            device=self.config["device"]
        )
        
        self.vectorstore = VectorStore(
            dimension=self.config["embedding_dimension"],
            index_path=self.config["index_path"]
        )
        
        self.loader = DirectoryLoader(
            chunk_size=self.config["chunk_size"],
            chunk_overlap=self.config["chunk_overlap"]
        )
    
    def _load_config(self, config_path: str) -> Dict[str, Any]:
        """Load configuration from YAML file"""
        config_file = Path(__file__).parent / config_path
        
        if not config_file.exists():
            logger.warning(f"Config file not found: {config_file}, using defaults")
            return self._get_default_config()
        
        with open(config_file, 'r', encoding='utf-8') as f:
            return yaml.safe_load(f)
    
    def _get_default_config(self) -> Dict[str, Any]:
        """Get default configuration"""
        return {
            "embedding_model": "sentence-transformers/all-MiniLM-L6-v2",
            "embedding_dimension": 384,
            "device": "cpu",
            "vectorstore_type": "faiss",
            "index_path": "./vector/index",
            "chunk_size": 1000,
            "chunk_overlap": 200,
            "document_sources": []
        }
    
    async def ingest_directory(
        self,
        directory: str,
        doc_type: str = "general",
        recursive: bool = True
    ) -> Dict[str, Any]:
        """
        Ingest all documents from a directory.
        
        Args:
            directory: Directory path
            doc_type: Document type for metadata
            recursive: Search subdirectories
        
        Returns:
            Ingestion results
        """
        logger.info(f"Starting ingestion from: {directory}")
        
        # Load documents
        documents = self.loader.load(directory, recursive=recursive)
        
        if not documents:
            logger.warning(f"No documents found in {directory}")
            return {
                "status": "no_documents",
                "directory": directory,
                "count": 0
            }
        
        logger.info(f"Loaded {len(documents)} document chunks")
        
        # Add document type to metadata
        for doc in documents:
            doc.metadata["doc_type"] = doc_type
            doc.metadata.update(self.config.get("default_metadata", {}))
        
        # Generate embeddings
        texts = [doc.content for doc in documents]
        logger.info("Generating embeddings...")
        embeddings = self.embedding_generator.embed_batch(texts)
        
        # Add to vectorstore
        metadata = [doc.metadata for doc in documents]
        logger.info("Adding to vectorstore...")
        doc_ids = self.vectorstore.add_documents(texts, embeddings, metadata)
        
        # Save vectorstore
        logger.info("Saving vectorstore...")
        self.vectorstore.save()
        
        logger.info(f"Ingestion complete: {len(doc_ids)} chunks indexed")
        
        return {
            "status": "success",
            "directory": directory,
            "count": len(doc_ids),
            "doc_ids": doc_ids
        }
    
    async def ingest_from_config(self) -> Dict[str, Any]:
        """Ingest documents from sources defined in config"""
        sources = self.config.get("document_sources", [])
        
        if not sources:
            logger.warning("No document sources defined in config")
            return {
                "status": "no_sources",
                "results": []
            }
        
        results = []
        
        for source in sources:
            path = source.get("path")
            doc_type = source.get("type", "general")
            recursive = source.get("recursive", True)
            
            if not path or not Path(path).exists():
                logger.warning(f"Source path not found: {path}")
                continue
            
            result = await self.ingest_directory(path, doc_type, recursive)
            results.append(result)
        
        total_docs = sum(r.get("count", 0) for r in results)
        
        return {
            "status": "success",
            "total_documents": total_docs,
            "sources_processed": len(results),
            "results": results
        }


async def main():
    """Main ingestion function"""
    import argparse
    
    parser = argparse.ArgumentParser(description="Ingest documents into vectorstore")
    parser.add_argument(
        "--directory",
        type=str,
        help="Directory to ingest documents from"
    )
    parser.add_argument(
        "--type",
        type=str,
        default="general",
        help="Document type for metadata"
    )
    parser.add_argument(
        "--config",
        action="store_true",
        help="Ingest from config file sources"
    )
    
    args = parser.parse_args()
    
    ingester = DocumentIngester()
    
    if args.config:
        logger.info("Ingesting from config file sources...")
        result = await ingester.ingest_from_config()
    elif args.directory:
        logger.info(f"Ingesting from directory: {args.directory}")
        result = await ingester.ingest_directory(args.directory, args.type)
    else:
        logger.error("Please specify --directory or --config")
        return
    
    logger.info(f"Ingestion result: {result}")


if __name__ == "__main__":
    asyncio.run(main())
