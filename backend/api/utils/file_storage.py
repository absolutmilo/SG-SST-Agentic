import os
import shutil
from fastapi import UploadFile, HTTPException
from pathlib import Path
import uuid
import logging

logger = logging.getLogger(__name__)

# Base upload directory
UPLOAD_DIR = Path("uploads/documents")

def get_storage_path() -> Path:
    """Ensure upload directory exists and return it"""
    UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
    return UPLOAD_DIR

async def save_upload_file(file: UploadFile, subfolder: str = "general") -> dict:
    """
    Save an uploaded file to disk.
    Returns metadata including the stored path.
    """
    try:
        # Create subfolder if needed (e.g., by category)
        target_dir = get_storage_path() / subfolder
        target_dir.mkdir(parents=True, exist_ok=True)
        
        # Generate unique filename to prevent collisions
        # structure: {uuid}_{original_filename}
        file_ext = os.path.splitext(file.filename)[1]
        unique_name = f"{uuid.uuid4()}{file_ext}"
        target_path = target_dir / unique_name
        
        # Save file
        with target_path.open("wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
            
        file_stats = target_path.stat()
            
        return {
            "original_name": file.filename,
            "stored_name": unique_name,
            "relative_path": str(Path(subfolder) / unique_name).replace("\\", "/"),
            "full_path": str(target_path),
            "size_bytes": file_stats.st_size,
            "mime_type": file.content_type
        }
        
    except Exception as e:
        logger.error(f"Failed to save file: {e}")
        raise HTTPException(status_code=500, detail=f"Could not save file: {str(e)}")

def delete_file(relative_path: str):
    """Delete a file from storage"""
    try:
        if not relative_path:
            return
            
        full_path = get_storage_path() / relative_path
        if full_path.exists():
            full_path.unlink()
            logger.info(f"Deleted file: {full_path}")
    except Exception as e:
        logger.error(f"Error deleting file {relative_path}: {e}")

def get_file_path_absolute(relative_path: str) -> Path:
    """Get absolute path for file serving"""
    return get_storage_path() / relative_path
