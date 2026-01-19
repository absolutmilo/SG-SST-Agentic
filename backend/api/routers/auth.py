from datetime import timedelta
from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from pydantic import BaseModel

from api.models import get_db, AuthorizedUser
from api.utils.security import verify_password, create_access_token
from api.config import get_settings
from api.dependencies import get_current_active_user

settings = get_settings()
router = APIRouter()

class Token(BaseModel):
    access_token: str
    token_type: str

class User(BaseModel):
    id_autorizado: int
    Correo_Electronico: str
    Nombre_Persona: str
    Nivel_Acceso: str
    Estado: bool

@router.post("/token", response_model=Token)
async def login_for_access_token(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
    db: Session = Depends(get_db)
):
    import logging
    logger = logging.getLogger(__name__)
    
    user = db.query(AuthorizedUser).filter(AuthorizedUser.Correo_Electronico == form_data.username).first()
    
    # Debug logging
    if not user:
        logger.warning(f"Login attempt failed: User not found - {form_data.username}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if not user.Password_Hash:
        logger.warning(f"Login attempt failed: No password hash for user - {form_data.username}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    logger.info(f"User found: {form_data.username}, Hash length: {len(user.Password_Hash)}, Hash prefix: {user.Password_Hash[:10] if len(user.Password_Hash) >= 10 else user.Password_Hash}")
    
    password_valid = verify_password(form_data.password, user.Password_Hash)
    logger.info(f"Password verification result for {form_data.username}: {password_valid}")
    
    if not password_valid:
        logger.warning(f"Login attempt failed: Invalid password for user - {form_data.username}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
        
    # Determine Role Name for token
    role_name = user.Nivel_Acceso # Default fallback
    if user.id_rol:
        from api.models import Role
        # We need to query this inside the session
        # Note: 'user' is already attached to 'db' session from the query above
        db_role = db.query(Role).filter(Role.id_rol == user.id_rol).first()
        if db_role:
            role_name = db_role.NombreRol
            
    access_token_expires = timedelta(minutes=settings.security.access_token_expire_minutes)
    access_token = create_access_token(
        data={"sub": user.Correo_Electronico, "role": role_name},
        expires_delta=access_token_expires
    )
    
    logger.info(f"Login successful for user: {form_data.username} with role: {role_name}")
    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/me", response_model=User)
async def read_users_me(current_user: Annotated[AuthorizedUser, Depends(get_current_active_user)]):
    return User(
        id_autorizado=current_user.id_autorizado,
        Correo_Electronico=current_user.Correo_Electronico,
        Nombre_Persona=current_user.Nombre_Persona,
        Nivel_Acceso=current_user.Nivel_Acceso,
        Estado=current_user.Estado
    )

