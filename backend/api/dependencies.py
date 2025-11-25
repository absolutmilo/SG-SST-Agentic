from typing import Annotated, Optional
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from pydantic import BaseModel

from api.models import get_db, AuthorizedUser
from api.utils.security import decode_access_token
from api.config import get_settings

settings = get_settings()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"{settings.api.api_prefix}/auth/token")

class TokenData(BaseModel):
    username: Optional[str] = None

async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)], db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    payload = decode_access_token(token)
    if payload is None:
        raise credentials_exception
        
    username: str = payload.get("sub")
    if username is None:
        raise credentials_exception
        
    token_data = TokenData(username=username)
    
    user = db.query(AuthorizedUser).filter(AuthorizedUser.Correo_Electronico == token_data.username).first()
    if user is None:
        raise credentials_exception
        
    if not user.Estado:
        raise HTTPException(status_code=400, detail="Inactive user")
        
    return user

async def get_current_active_user(current_user: Annotated[AuthorizedUser, Depends(get_current_user)]):
    if not current_user.Estado:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user

class RoleChecker:
    def __init__(self, allowed_roles: list[str]):
        self.allowed_roles = allowed_roles

    def __call__(self, user: AuthorizedUser = Depends(get_current_active_user)):
        if user.Nivel_Acceso not in self.allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN, 
                detail=f"Operation not permitted. Required roles: {self.allowed_roles}"
            )
