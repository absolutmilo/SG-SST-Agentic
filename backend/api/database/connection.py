"""
Database connection and session management.
"""

from sqlalchemy import create_engine, event
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from typing import Generator
import logging

from api.config import get_settings

logger = logging.getLogger(__name__)

# Get settings
settings = get_settings()

# Create SQLAlchemy engine
engine = create_engine(
    settings.database.sqlalchemy_url,
    pool_size=settings.database.pool_size,
    max_overflow=settings.database.max_overflow,
    pool_timeout=settings.database.pool_timeout,
    pool_recycle=settings.database.pool_recycle,
    echo=settings.app.debug,  # Log SQL queries in debug mode
)

# Create session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class for models
Base = declarative_base()


# Event listener to set NOCOUNT ON for SQL Server
@event.listens_for(engine, "connect")
def set_nocount(dbapi_conn, connection_record):
    """Set NOCOUNT ON for SQL Server connections."""
    cursor = dbapi_conn.cursor()
    cursor.execute("SET NOCOUNT ON")
    cursor.close()


def get_db() -> Generator[Session, None, None]:
    """
    Dependency function to get database session.
    
    Usage in FastAPI:
        @app.get("/items")
        def read_items(db: Session = Depends(get_db)):
            return db.query(Item).all()
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def init_db():
    """
    Initialize database.
    Creates all tables if they don't exist.
    """
    try:
        # Import all models here to ensure they are registered
        from api.models import (
            employee, risk, event, training, medical,
            ppe, committee, task, audit, document, user
        )
        
        # Create all tables
        Base.metadata.create_all(bind=engine)
        logger.info("Database initialized successfully")
    except Exception as e:
        logger.error(f"Error initializing database: {e}")
        raise


def test_connection():
    """Test database connection."""
    try:
        from sqlalchemy import text
        with engine.connect() as conn:
            result = conn.execute(text("SELECT 1"))
            logger.info("Database connection successful")
            return True
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        return False
