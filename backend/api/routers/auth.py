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
    user = db.query(AuthorizedUser).filter(AuthorizedUser.Correo_Electronico == form_data.username).first()
    
    if not user or not user.Password_Hash or not verify_password(form_data.password, user.Password_Hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
        
    access_token_expires = timedelta(minutes=settings.security.access_token_expire_minutes)
    access_token = create_access_token(
        data={"sub": user.Correo_Electronico, "role": user.Nivel_Acceso},
        expires_delta=access_token_expires
    )
    
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

