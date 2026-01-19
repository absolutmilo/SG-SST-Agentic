from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import desc
from typing import List, Optional
from pydantic import BaseModel, EmailStr
import logging
from datetime import datetime

from api.models import get_db, AuthorizedUser, Role
from api.dependencies import get_current_active_user, RoleChecker
from api.utils.security import get_password_hash

logger = logging.getLogger(__name__)
router = APIRouter()

# --- Pydantic Models ---

class RoleRead(BaseModel):
    id_rol: int
    NombreRol: str
    Descripcion: Optional[str] = None
    
    class Config:
        from_attributes = True

class UserCreate(BaseModel):
    email: EmailStr
    full_name: str
    role_id: int
    password: str

class UserRead(BaseModel):
    id_autorizado: int
    Correo_Electronico: str
    Nombre_Persona: str
    Nivel_Acceso: Optional[str] = None # Legacy/Display
    Role: Optional[RoleRead] = None
    Estado: bool
    FechaRegistro: Optional[datetime] = None

    class Config:
        from_attributes = True

# --- Endpoints ---

@router.get("/roles", response_model=List[RoleRead])
def get_roles(
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(get_current_active_user)
):
    """List all available roles"""
    try:
        roles = db.query(Role).all()
        return roles
    except Exception as e:
        logger.error(f"Error fetching roles: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/", response_model=List[UserRead])
def get_users(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(RoleChecker(["CEO", "Coordinador SST", "Gerente General"]))
):
    """List all authorized users (Admin only)"""
    try:
        # Join with Role to get role details
        # Note: AuthorizedUser.Role relationship should be available via automap or explicit definition
        # If automap didn't create 'Role', we might need to rely on 'ROL' or manual join
        # Trying implicit relationship first. If fails, we might need a join or fix model.
        # Assuming automap names it 'ROL' or 'Role' depending on configuration.
        # Safest is to join explicitly or assume automap 'ROL'.
        
        users = db.query(AuthorizedUser).options(
            joinedload(AuthorizedUser.ROL) # Attempting standard automap naming
        ).offset(skip).limit(limit).all()
        
        # Pydantic via from_attributes uses object attributes.
        # If automap uses 'ROL' property, our Pydantic model 'Role' field alias needs to match or we map manually.
        # Let's map manually to be safe or use 'ROL' in Pydantic if we knew for sure.
        # Mapping logic:
        result = []
        for u in users:
            # Handle ROL/Role
            role_obj = getattr(u, 'ROL', None) or getattr(u, 'Role', None)
            
            result.append(UserRead(
                id_autorizado=u.id_autorizado,
                Correo_Electronico=u.Correo_Electronico,
                Nombre_Persona=u.Nombre_Persona,
                Nivel_Acceso=u.Nivel_Acceso,
                Estado=u.Estado if u.Estado is not None else False,
                FechaRegistro=u.FechaRegistro,
                Role=role_obj
            ))
            
        return result
        
    except Exception as e:
        logger.error(f"Error fetching users: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/", response_model=UserRead)
def create_user(
    user_in: UserCreate,
    db: Session = Depends(get_db),
    current_user: AuthorizedUser = Depends(RoleChecker(["CEO", "Coordinador SST", "Gerente General"]))
):
    """Create a new authorized user (Admin only)"""
    try:
        # 1. Check if email exists
        existing_user = db.query(AuthorizedUser).filter(AuthorizedUser.Correo_Electronico == user_in.email).first()
        if existing_user:
            raise HTTPException(status_code=400, detail="User with this email already exists")
            
        # 2. Get Role Name for legacy support
        role = db.query(Role).filter(Role.id_rol == user_in.role_id).first()
        if not role:
            raise HTTPException(status_code=400, detail="Invalid Role ID")
            
        # 3. Create User
        hashed_password = get_password_hash(user_in.password)
        
        new_user = AuthorizedUser(
            Correo_Electronico=user_in.email,
            Nombre_Persona=user_in.full_name,
            Password_Hash=hashed_password,
            id_rol=user_in.role_id,
            Nivel_Acceso=role.NombreRol, # Keep synced for legacy
            Estado=True,
            FechaRegistro=datetime.now(),
            PuedeAprobar=1 if "Coordinador" in role.NombreRol or "CEO" in role.NombreRol else 0,
            PuedeEditar=1 # Default to true for now
        )
        
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        
        # Manually attach role for response
        # new_user.Role = role  # Use with caution depending on SQLAlchemy version/detached state
        # Better return a constructed object
        return UserRead(
            id_autorizado=new_user.id_autorizado,
            Correo_Electronico=new_user.Correo_Electronico,
            Nombre_Persona=new_user.Nombre_Persona,
            Nivel_Acceso=new_user.Nivel_Acceso,
            Estado=new_user.Estado,
            FechaRegistro=new_user.FechaRegistro,
            Role=role
        )
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error creating user: {e}")
        raise HTTPException(status_code=500, detail=str(e))
