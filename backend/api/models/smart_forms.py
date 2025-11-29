"""
Smart Forms Models - Dynamic Form System for SG-SST
Allows creating and rendering forms dynamically from JSON definitions
"""

from pydantic import BaseModel, Field, validator
from typing import List, Dict, Any, Optional, Union
from enum import Enum
from datetime import datetime, date


class FieldType(str, Enum):
    """Supported field types"""
    TEXT = "text"
    NUMBER = "number"
    DATE = "date"
    DATETIME = "datetime"
    SELECT = "select"
    MULTISELECT = "multiselect"
    CHECKBOX = "checkbox"
    RADIO = "radio"
    TEXTAREA = "textarea"
    FILE = "file"
    SIGNATURE = "signature"
    EMAIL = "email"
    PHONE = "phone"
    EMPLOYEE_SELECT = "employee_select"
    AUTOCOMPLETE = "autocomplete"


class ValidationRule(BaseModel):
    """Validation rule for a field"""
    type: str  # required, min, max, pattern, email, phone, date_range, custom
    value: Any
    message: str
    condition: Optional[Dict[str, Any]] = None  # For conditional validations


class ConditionalRule(BaseModel):
    """Rule to show/hide/require fields dynamically"""
    field: str  # Field that triggers the condition
    operator: str  # equals, not_equals, contains, gt, lt, in
    value: Any
    action: str  # show, hide, require, disable, prefill


class FormField(BaseModel):
    """Definition of a form field"""
    id: str
    name: str
    label: str
    type: FieldType
    required: bool = False
    default_value: Optional[Any] = None
    placeholder: Optional[str] = None
    help_text: Optional[str] = None
    
    # For selects/radios/checkboxes
    options: Optional[List[Dict[str, Any]]] = None
    
    # Validations
    validations: List[ValidationRule] = []
    
    # Conditional rules
    conditional_rules: List[ConditionalRule] = []
    
    # Autocomplete from database
    autocomplete_from: Optional[str] = None  # Table or SP name
    autocomplete_field: Optional[str] = None  # Field to display
    autocomplete_filters: Optional[Dict[str, Any]] = None
    
    # Pre-fill from database
    prefill_from: Optional[str] = None
    prefill_query: Optional[str] = None
    
    # Layout
    section: Optional[str] = None
    order: int = 0
    grid_columns: int = 12  # Bootstrap grid (1-12)
    visible: bool = True


class FormSection(BaseModel):
    """Section grouping for form fields"""
    name: str
    title: Optional[str] = None
    description: Optional[str] = None
    order: int = 0
    collapsible: bool = False
    collapsed: bool = False


class WorkflowAction(BaseModel):
    """Action to execute on form submission"""
    action: str  # save_to_table, create_task, send_notification, update_indicators, run_sp, ai_analyze
    params: Dict[str, Any]
    condition: Optional[Dict[str, Any]] = None  # Execute only if condition is met
    order: int = 0


class SmartFormDefinition(BaseModel):
    """Complete definition of a smart form"""
    id: str
    name: str
    title: str
    description: Optional[str] = None
    category: str  # eventos, examenes, capacitaciones, inspecciones, etc.
    
    # Legal references
    legal_reference: List[str] = []
    
    # Form structure
    fields: List[FormField]
    sections: Optional[List[FormSection]] = None
    
    # Applicability criteria
    applies_to: Dict[str, Any] = {}  # Conditions for showing this form
    
    # Approval workflow
    requires_approval: bool = False
    approval_roles: List[str] = []
    
    # Workflow actions
    on_submit: List[WorkflowAction] = []
    on_save_draft: List[WorkflowAction] = []
    on_approve: List[WorkflowAction] = []
    on_reject: List[WorkflowAction] = []
    
    # Configuration
    allow_save_draft: bool = True
    allow_attachments: bool = False
    max_attachments: int = 5
    allowed_file_types: List[str] = ["pdf", "jpg", "jpeg", "png", "doc", "docx"]
    generate_pdf: bool = True
    send_notifications: bool = False
    notification_emails: List[str] = []
    
    # Metadata
    version: str = "1.0"
    created_at: datetime = Field(default_factory=datetime.now)
    updated_at: datetime = Field(default_factory=datetime.now)
    created_by: Optional[str] = None
    is_active: bool = True
    
    @validator('fields')
    def validate_fields(cls, fields):
        """Ensure field IDs are unique"""
        field_ids = [f.id for f in fields]
        if len(field_ids) != len(set(field_ids)):
            raise ValueError("Field IDs must be unique")
        return fields


class FormSubmission(BaseModel):
    """Submission of a form"""
    id: Optional[int] = None
    form_id: str
    form_version: str
    submitted_by: int  # Id_Usuario
    submitted_at: datetime = Field(default_factory=datetime.now)
    data: Dict[str, Any]  # JSON with form responses
    attachments: List[str] = []  # File paths
    status: str = "submitted"  # draft, submitted, approved, rejected
    approval_history: List[Dict[str, Any]] = []
    
    # Metadata
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None


class FormDraft(BaseModel):
    """Draft of a form (auto-saved)"""
    id: Optional[int] = None
    form_id: str
    user_id: int
    data: Dict[str, Any]
    saved_at: datetime = Field(default_factory=datetime.now)


class FormValidationError(BaseModel):
    """Validation error for a field"""
    field_id: str
    field_name: str
    error_type: str
    message: str


class FormValidationResult(BaseModel):
    """Result of form validation"""
    is_valid: bool
    errors: List[FormValidationError] = []
