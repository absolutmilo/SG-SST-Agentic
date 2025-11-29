"""
Embedding Generation

Generate vector embeddings for text using sentence transformers.
"""

from typing import List, Optional
import logging
import numpy as np

logger = logging.getLogger(__name__)


class EmbeddingGenerator:
    """
    Generate embeddings using sentence transformers.
    
    Uses 'sentence-transformers/all-MiniLM-L6-v2' by default
    (384 dimensions, good balance of speed and quality)
    """
    
    def __init__(
        self,
        model_name: str = "sentence-transformers/all-MiniLM-L6-v2",
        device: str = "cpu"
    ):
        self.model_name = model_name
        self.device = device
        self.model = None
        self.logger = logging.getLogger("rag.embeddings")
    
    def _load_model(self):
        """Lazy load the embedding model"""
        if self.model is None:
            try:
                # This will use sentence-transformers when installed
                # from sentence_transformers import SentenceTransformer
                # self.model = SentenceTransformer(self.model_name, device=self.device)
                
                self.logger.info(f"Embedding model ready: {self.model_name}")
                # Placeholder for now
                self.model = "placeholder"
                
            except Exception as e:
                self.logger.error(f"Failed to load embedding model: {e}")
                raise
    
    def embed_text(self, text: str) -> np.ndarray:
        """
        Generate embedding for a single text.
        
        Args:
            text: Text to embed
        
        Returns:
            Embedding vector as numpy array
        """
        return self.embed_batch([text])[0]
    
    def embed_batch(self, texts: List[str]) -> List[np.ndarray]:
        """
        Generate embeddings for a batch of texts.
        
        Args:
            texts: List of texts to embed
        
        Returns:
            List of embedding vectors
        """
        if not texts:
            return []
        
        self._load_model()
        
        try:
            # This will use the actual model when installed
            # embeddings = self.model.encode(
            #     texts,
            #     batch_size=32,
            #     show_progress_bar=len(texts) > 100
            # )
            
            # Placeholder: return random embeddings
            self.logger.info(f"Generating embeddings for {len(texts)} texts")
            embeddings = [np.random.rand(384) for _ in texts]
            
            return embeddings
            
        except Exception as e:
            self.logger.error(f"Failed to generate embeddings: {e}")
            raise
    
    def get_embedding_dimension(self) -> int:
        """Get the dimension of embeddings produced by this model"""
        # all-MiniLM-L6-v2 produces 384-dimensional embeddings
        dimension_map = {
            "sentence-transformers/all-MiniLM-L6-v2": 384,
            "sentence-transformers/all-mpnet-base-v2": 768,
            "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2": 384
        }
        return dimension_map.get(self.model_name, 384)


class CachedEmbeddingGenerator(EmbeddingGenerator):
    """Embedding generator with caching to avoid recomputing"""
    
    def __init__(
        self,
        model_name: str = "sentence-transformers/all-MiniLM-L6-v2",
        device: str = "cpu",
        cache_size: int = 10000
    ):
        super().__init__(model_name, device)
        self.cache: Dict[str, np.ndarray] = {}
        self.cache_size = cache_size
    
    def embed_text(self, text: str) -> np.ndarray:
        """Generate embedding with caching"""
        if text in self.cache:
            self.logger.debug("Cache hit for embedding")
            return self.cache[text]
        
        embedding = super().embed_text(text)
        
        # Add to cache if not full
        if len(self.cache) < self.cache_size:
            self.cache[text] = embedding
        
        return embedding
    
    def clear_cache(self):
        """Clear the embedding cache"""
        self.cache.clear()
        self.logger.info("Embedding cache cleared")
