"""
Query Examples for Vectorstore

Examples of how to query the vectorstore for RAG.
"""

import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'backend'))

import asyncio
import logging
from pathlib import Path

from rag.embeddings import EmbeddingGenerator
from rag.vectorstore import VectorStore
from rag.rag_pipeline import RAGPipeline

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


async def example_simple_search():
    """Example: Simple similarity search"""
    logger.info("=== Example 1: Simple Similarity Search ===")
    
    # Initialize components
    embedding_gen = EmbeddingGenerator()
    vectorstore = VectorStore(index_path="./vector/index")
    
    # Query
    query = "¿Cuáles son los requisitos del Decreto 1072?"
    logger.info(f"Query: {query}")
    
    # Generate query embedding
    query_embedding = embedding_gen.embed_text(query)
    
    # Search
    results = vectorstore.search(query_embedding, top_k=3)
    
    # Display results
    for i, result in enumerate(results):
        logger.info(f"\nResult {i+1}:")
        logger.info(f"  Score: {result['score']:.3f}")
        logger.info(f"  Text: {result['text'][:200]}...")
        logger.info(f"  Source: {result['metadata'].get('source', 'Unknown')}")


async def example_filtered_search():
    """Example: Search with metadata filtering"""
    logger.info("\n=== Example 2: Filtered Search ===")
    
    embedding_gen = EmbeddingGenerator()
    vectorstore = VectorStore(index_path="./vector/index")
    
    query = "matriz de riesgos"
    logger.info(f"Query: {query}")
    
    # Generate embedding
    query_embedding = embedding_gen.embed_text(query)
    
    # Search with filter
    filter_metadata = {"doc_type": "procedure"}
    results = vectorstore.search(
        query_embedding,
        top_k=5,
        filter_metadata=filter_metadata
    )
    
    logger.info(f"Found {len(results)} results with filter: {filter_metadata}")
    
    for i, result in enumerate(results):
        logger.info(f"\nResult {i+1}: {result['text'][:150]}...")


async def example_rag_query():
    """Example: Complete RAG query with answer generation"""
    logger.info("\n=== Example 3: RAG Query ===")
    
    # Initialize RAG pipeline
    embedding_gen = EmbeddingGenerator()
    vectorstore = VectorStore(index_path="./vector/index")
    
    rag_pipeline = RAGPipeline(
        vectorstore=vectorstore,
        embedding_generator=embedding_gen,
        top_k=5,
        rerank=True
    )
    
    # Query
    question = "¿Qué es la jerarquía de controles en SST?"
    logger.info(f"Question: {question}")
    
    # Get answer
    result = await rag_pipeline.query(
        question=question,
        return_sources=True
    )
    
    logger.info(f"\nAnswer: {result['answer']}")
    logger.info(f"Confidence: {result['confidence']:.2f}")
    logger.info(f"\nSources ({result.get('num_sources', 0)}):")
    
    for i, source in enumerate(result.get('sources', [])):
        logger.info(f"  {i+1}. {source['source']}")
        logger.info(f"     {source['text_snippet']}")


async def example_batch_queries():
    """Example: Batch processing multiple queries"""
    logger.info("\n=== Example 4: Batch Queries ===")
    
    embedding_gen = EmbeddingGenerator()
    vectorstore = VectorStore(index_path="./vector/index")
    rag_pipeline = RAGPipeline(vectorstore, embedding_gen)
    
    queries = [
        "¿Qué es el SG-SST?",
        "¿Cuáles son los estándares mínimos?",
        "¿Cómo se evalúan los riesgos?"
    ]
    
    for i, query in enumerate(queries):
        logger.info(f"\nQuery {i+1}: {query}")
        result = await rag_pipeline.query(query, return_sources=False)
        logger.info(f"Answer: {result['answer'][:200]}...")


async def example_stats():
    """Example: Get vectorstore statistics"""
    logger.info("\n=== Example 5: Vectorstore Stats ===")
    
    vectorstore = VectorStore(index_path="./vector/index")
    stats = vectorstore.get_stats()
    
    logger.info("Vectorstore Statistics:")
    for key, value in stats.items():
        logger.info(f"  {key}: {value}")


async def main():
    """Run all examples"""
    import argparse
    
    parser = argparse.ArgumentParser(description="Query vectorstore examples")
    parser.add_argument(
        "--example",
        type=int,
        choices=[1, 2, 3, 4, 5],
        help="Run specific example (1-5)"
    )
    
    args = parser.parse_args()
    
    examples = {
        1: example_simple_search,
        2: example_filtered_search,
        3: example_rag_query,
        4: example_batch_queries,
        5: example_stats
    }
    
    if args.example:
        await examples[args.example]()
    else:
        # Run all examples
        for example_func in examples.values():
            await example_func()
            await asyncio.sleep(1)  # Brief pause between examples


if __name__ == "__main__":
    asyncio.run(main())
