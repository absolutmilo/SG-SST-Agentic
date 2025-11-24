"""
SG-SST API - Main Application
FastAPI application for Colombian SG-SST compliance system.
"""

from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from contextlib import asynccontextmanager
import logging
import sys
from pathlib import Path

from api.config import get_settings
from api.database import test_connection, init_db

# Configure logging
settings = get_settings()

# Create logs directory if it doesn't exist
if settings.logging.file_enabled:
    log_dir = Path(settings.logging.file_path).parent
    log_dir.mkdir(parents=True, exist_ok=True)

# Setup logging
logging.basicConfig(
    level=getattr(logging, settings.logging.level),
    format=settings.logging.format,
    handlers=[
        logging.StreamHandler(sys.stdout) if settings.logging.console_enabled else logging.NullHandler(),
        logging.FileHandler(settings.logging.file_path) if settings.logging.file_enabled else logging.NullHandler(),
    ]
)

logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Lifespan context manager for startup and shutdown events.
    """
    # Startup
    logger.info(f"Starting {settings.app.name} v{settings.app.version}")
    logger.info(f"Environment: {settings.app.environment}")
    
    # Test database connection
    if test_connection():
        logger.info("Database connection verified")
    else:
        logger.error("Database connection failed!")
        # In production, you might want to exit here
        if not settings.app.debug:
            sys.exit(1)
    
    # Initialize database (create tables if needed)
    # Commented out for now since we're using existing database
    # init_db()
    
    logger.info("Application startup complete")
    
    yield
    
    # Shutdown
    logger.info("Shutting down application")


# Create FastAPI application
app = FastAPI(
    title=settings.api.title,
    description=settings.api.description,
    version=settings.api.version,
    docs_url=settings.api.docs_url,
    redoc_url=settings.api.redoc_url,
    openapi_url=settings.api.openapi_url,
    lifespan=lifespan,
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors.origins,
    allow_credentials=settings.cors.allow_credentials,
    allow_methods=settings.cors.allow_methods,
    allow_headers=settings.cors.allow_headers,
)


# Exception handlers
@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    """Handle validation errors."""
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content={
            "detail": exc.errors(),
            "message": "Validation error",
        },
    )


@app.exception_handler(Exception)
async def general_exception_handler(request: Request, exc: Exception):
    """Handle general exceptions."""
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "message": "Internal server error",
            "detail": str(exc) if settings.app.debug else "An error occurred",
        },
    )


# Root endpoint
@app.get("/", tags=["Root"])
async def root():
    """Root endpoint - API information."""
    return {
        "name": settings.app.name,
        "version": settings.app.version,
        "description": settings.app.description,
        "environment": settings.app.environment,
        "docs": settings.api.docs_url,
        "status": "operational",
    }


# Health check endpoint
@app.get("/health", tags=["Health"])
async def health_check():
    """Health check endpoint."""
    db_status = "healthy" if test_connection() else "unhealthy"
    
    return {
        "status": "healthy" if db_status == "healthy" else "degraded",
        "version": settings.app.version,
        "database": db_status,
    }


# Import and include routers
from api.routers import crud, procedures

# Generic CRUD router - works for ALL tables!
app.include_router(
    crud.router,
    prefix=f"{settings.api.api_prefix}/crud",
    tags=["CRUD Operations"]
)

# Stored procedures router - uses your existing SQL Server logic!
app.include_router(
    procedures.router,
    prefix=f"{settings.api.api_prefix}/procedures",
    tags=["Stored Procedures"]
)


if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run(
        "main:app",
        host=settings.server.host,
        port=settings.server.port,
        reload=settings.server.reload,
        log_level=settings.logging.level.lower(),
    )
