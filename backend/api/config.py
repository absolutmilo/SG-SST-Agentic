"""
Configuration management for SG-SST API.
Loads settings from config.toml file.
"""

import os
import tomli
from pathlib import Path
from typing import List, Optional
from pydantic import BaseModel, Field


class AppConfig(BaseModel):
    """Application configuration."""
    name: str = "SG-SST API"
    version: str = "1.0.0"
    description: str = "Sistema de Gestión de Seguridad y Salud en el Trabajo"
    debug: bool = False
    environment: str = "production"


class ServerConfig(BaseModel):
    """Server configuration."""
    host: str = "0.0.0.0"
    port: int = 8000
    reload: bool = False


class DatabaseConfig(BaseModel):
    """Database configuration."""
    driver: str = "ODBC Driver 17 for SQL Server"
    server: str
    database: str
    username: Optional[str] = ""  # Optional for Windows Authentication
    password: Optional[str] = ""  # Optional for Windows Authentication
    port: int = 1433
    trusted_connection: bool = False
    pool_size: int = 5
    max_overflow: int = 10
    pool_timeout: int = 30
    pool_recycle: int = 3600

    @property
    def connection_string(self) -> str:
        """Generate SQL Server connection string."""
        # Don't add port if using named instance (contains backslash)
        server_str = self.server if "\\" in self.server else f"{self.server},{self.port}"
        
        if self.trusted_connection:
            return (
                f"DRIVER={{{self.driver}}};"
                f"SERVER={server_str};"
                f"DATABASE={self.database};"
                f"Trusted_Connection=yes;"
            )
        else:
            return (
                f"DRIVER={{{self.driver}}};"
                f"SERVER={server_str};"
                f"DATABASE={self.database};"
                f"UID={self.username};"
                f"PWD={self.password};"
            )

    @property
    def sqlalchemy_url(self) -> str:
        """Generate SQLAlchemy connection URL."""
        from urllib.parse import quote_plus
        return f"mssql+pyodbc:///?odbc_connect={quote_plus(self.connection_string)}"


class SecurityConfig(BaseModel):
    """Security configuration."""
    secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    refresh_token_expire_days: int = 7
    min_password_length: int = 8
    require_uppercase: bool = True
    require_lowercase: bool = True
    require_numbers: bool = True
    require_special_chars: bool = True


class CORSConfig(BaseModel):
    """CORS configuration."""
    origins: List[str] = ["http://localhost:5173"]
    allow_credentials: bool = True
    allow_methods: List[str] = ["*"]
    allow_headers: List[str] = ["*"]


class AlertsConfig(BaseModel):
    """Alerts configuration."""
    dias_alerta_emo: int = 45
    dias_alerta_comite: int = 60
    dias_alerta_equipos: int = 30
    dias_alerta_capacitacion: int = 15
    dias_alerta_documentos: int = 30
    frecuencia_revision_horas: int = 6
    max_intentos_envio: int = 3


class EmailConfig(BaseModel):
    """Email configuration."""
    enabled: bool = False
    smtp_server: str = "smtp.gmail.com"
    smtp_port: int = 587
    smtp_username: str = ""
    smtp_password: str = ""
    from_email: str = ""
    from_name: str = "SG-SST Sistema"
    use_tls: bool = True


class LoggingConfig(BaseModel):
    """Logging configuration."""
    level: str = "INFO"
    format: str = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    file_enabled: bool = True
    file_path: str = "logs/api.log"
    file_max_bytes: int = 10485760
    file_backup_count: int = 5
    console_enabled: bool = True


class APIConfig(BaseModel):
    """API configuration."""
    title: str = "SG-SST API"
    description: str = "API para el Sistema de Gestión de Seguridad y Salud en el Trabajo"
    version: str = "1.0.0"
    docs_url: str = "/docs"
    redoc_url: str = "/redoc"
    openapi_url: str = "/openapi.json"
    api_prefix: str = "/api/v1"
    rate_limit_enabled: bool = True
    rate_limit_requests: int = 100
    rate_limit_period: int = 60


class FilesConfig(BaseModel):
    """Files configuration."""
    upload_enabled: bool = True
    upload_path: str = "uploads"
    max_file_size: int = 10485760
    allowed_extensions: List[str] = [
        ".pdf", ".doc", ".docx", ".xls", ".xlsx",
        ".jpg", ".jpeg", ".png", ".gif",
        ".zip", ".rar"
    ]


class ReportsConfig(BaseModel):
    """Reports configuration."""
    temp_path: str = "temp/reports"
    default_format: str = "pdf"
    logo_path: str = "assets/logo.png"
    company_name: str = "Digital Bulks S.A.S."


class IndicatorsConfig(BaseModel):
    """Indicators configuration."""
    horas_trabajo_dia: int = 8
    dias_laborables_mes: int = 20
    dias_laborables_anio: int = 240
    factor_calculo: int = 200000


class CacheConfig(BaseModel):
    """Cache configuration."""
    enabled: bool = False
    backend: str = "memory"
    ttl: int = 300


class FeaturesConfig(BaseModel):
    """Feature flags."""
    intelligent_forms: bool = True
    auto_alerts: bool = True
    auto_tasks: bool = True
    email_notifications: bool = False
    sms_notifications: bool = False
    whatsapp_notifications: bool = False


class Settings(BaseModel):
    """Main settings class."""
    app: AppConfig
    server: ServerConfig
    database: DatabaseConfig
    security: SecurityConfig
    cors: CORSConfig
    alerts: AlertsConfig
    email: EmailConfig
    logging: LoggingConfig
    api: APIConfig
    files: FilesConfig
    reports: ReportsConfig
    indicators: IndicatorsConfig
    cache: CacheConfig
    features: FeaturesConfig

    @classmethod
    def load_from_toml(cls, config_path: Optional[str] = None) -> "Settings":
        """Load settings from TOML file."""
        if config_path is None:
            # Try to find config.toml in current directory or parent
            current_dir = Path(__file__).parent
            config_path = current_dir / "config.toml"
            
            if not config_path.exists():
                config_path = current_dir.parent / "config.toml"
            
            if not config_path.exists():
                raise FileNotFoundError(
                    "config.toml not found. Please copy config.example.toml to config.toml "
                    "and update with your settings."
                )
        
        # Load TOML file (tomli requires binary mode)
        with open(config_path, "rb") as f:
            config_data = tomli.load(f)
        
        # Create Settings instance
        return cls(
            app=AppConfig(**config_data.get("app", {})),
            server=ServerConfig(**config_data.get("server", {})),
            database=DatabaseConfig(**config_data.get("database", {})),
            security=SecurityConfig(**config_data.get("security", {})),
            cors=CORSConfig(**config_data.get("cors", {})),
            alerts=AlertsConfig(**config_data.get("alerts", {})),
            email=EmailConfig(**config_data.get("email", {})),
            logging=LoggingConfig(**config_data.get("logging", {})),
            api=APIConfig(**config_data.get("api", {})),
            files=FilesConfig(**config_data.get("files", {})),
            reports=ReportsConfig(**config_data.get("reports", {})),
            indicators=IndicatorsConfig(**config_data.get("indicators", {})),
            cache=CacheConfig(**config_data.get("cache", {})),
            features=FeaturesConfig(**config_data.get("features", {})),
        )


# Global settings instance
settings: Optional[Settings] = None


def get_settings() -> Settings:
    """Get settings instance (singleton pattern)."""
    global settings
    if settings is None:
        settings = Settings.load_from_toml()
    return settings


# For convenience
def reload_settings():
    """Reload settings from file."""
    global settings
    settings = Settings.load_from_toml()
