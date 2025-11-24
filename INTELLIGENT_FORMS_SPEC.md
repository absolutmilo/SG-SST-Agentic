# Intelligent Form System - Technical Specification

## Overview

The Intelligent Form System is the core innovation of this SG-SST application. It **eliminates redundant questions** by leveraging existing database information, providing a superior user experience while ensuring data quality.

---

## Core Principles

### 1. **Never Ask Twice**
If information exists in the database, don't ask the user to re-enter it.

### 2. **Context-Aware**
Forms adapt based on the user's role, previous entries, and related data.

### 3. **Smart Defaults**
Pre-fill fields with intelligent defaults based on patterns and relationships.

### 4. **Progressive Disclosure**
Show only relevant questions based on previous answers.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        User Interface                        │
│  (Web Form - HTML/CSS/JavaScript)                           │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ 1. Request form structure
                     ↓
┌─────────────────────────────────────────────────────────────┐
│                    FastAPI Backend                           │
│  /api/forms/{form_type}/structure                           │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ 2. Query existing data
                     ↓
┌─────────────────────────────────────────────────────────────┐
│                  Form Intelligence Service                   │
│  - Analyze context                                           │
│  - Query related entities                                    │
│  - Determine required vs. prefilled fields                   │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ 3. Fetch data
                     ↓
┌─────────────────────────────────────────────────────────────┐
│                      Database (SQL Server)                   │
│  - EMPLEADO, EVENTO, CAPACITACION, etc.                     │
└─────────────────────────────────────────────────────────────┘
```

---

## API Endpoints

### 1. Get Form Structure

**Endpoint**: `GET /api/forms/{form_type}/structure`

**Parameters**:
- `form_type`: Type of form (e.g., "medical_exam", "event_report", "training")
- `context`: JSON object with context data (e.g., `{"employee_id": 102}`)

**Response**:
```json
{
  "form_type": "medical_exam",
  "title": "Registro de Examen Médico Ocupacional",
  "prefilled_data": {
    "employee_id": 102,
    "employee_name": "Juan López Pérez",
    "document_number": "1122334455",
    "position": "Desarrollador Senior",
    "department": "Tecnología",
    "hire_date": "2020-01-20",
    "risk_level": 1,
    "last_exam_date": "2023-01-20",
    "last_exam_type": "Periodico"
  },
  "readonly_fields": [
    "employee_name",
    "document_number",
    "position",
    "department",
    "hire_date",
    "risk_level"
  ],
  "required_fields": [
    {
      "name": "exam_type",
      "label": "Tipo de Examen",
      "type": "select",
      "options": ["Preocupacional", "Periodico", "Post-Incapacidad", "Retiro"],
      "required": true,
      "suggested_value": "Periodico",
      "help_text": "Último examen fue Periodico el 2023-01-20"
    },
    {
      "name": "exam_date",
      "label": "Fecha de Realización",
      "type": "date",
      "required": true,
      "min_date": "2024-01-01",
      "max_date": "2025-12-31"
    },
    {
      "name": "medical_entity",
      "label": "Entidad Realizadora",
      "type": "text",
      "required": true,
      "suggested_value": "IPS Salud Total",
      "help_text": "Última entidad utilizada"
    }
  ],
  "conditional_fields": [
    {
      "name": "restrictions",
      "label": "Restricciones Médicas",
      "type": "textarea",
      "required": false,
      "show_if": {
        "field": "fit_for_position",
        "value": false
      }
    }
  ]
}
```

### 2. Validate Form Data

**Endpoint**: `POST /api/forms/{form_type}/validate`

**Request Body**:
```json
{
  "employee_id": 102,
  "exam_type": "Periodico",
  "exam_date": "2024-11-20",
  "medical_entity": "IPS Salud Total",
  "fit_for_position": true
}
```

**Response**:
```json
{
  "valid": true,
  "errors": [],
  "warnings": [
    {
      "field": "exam_date",
      "message": "El examen anterior fue hace menos de 1 año. ¿Está seguro?"
    }
  ],
  "suggestions": [
    {
      "field": "expiration_date",
      "suggested_value": "2025-11-20",
      "reason": "Basado en examen periódico anual"
    }
  ]
}
```

### 3. Submit Form

**Endpoint**: `POST /api/forms/{form_type}/submit`

**Request Body**:
```json
{
  "employee_id": 102,
  "exam_type": "Periodico",
  "exam_date": "2024-11-20",
  "expiration_date": "2025-11-20",
  "medical_entity": "IPS Salud Total",
  "evaluating_physician": "Dr. Carlos Méndez",
  "fit_for_position": true,
  "restrictions": null,
  "recommendations": "Continuar con pausas activas",
  "diagnoses": null
}
```

**Response**:
```json
{
  "success": true,
  "record_id": 3045,
  "message": "Examen médico registrado exitosamente",
  "next_actions": [
    {
      "type": "alert",
      "message": "Se ha programado una alerta para 45 días antes del vencimiento"
    },
    {
      "type": "task",
      "message": "Se ha creado una tarea para seguimiento médico"
    }
  ]
}
```

---

## Form Types and Intelligence Rules

### 1. Medical Exam Registration (`medical_exam`)

**Context Required**: `employee_id`

**Intelligent Behaviors**:
- ✅ Auto-fill employee data (name, document, position, department)
- ✅ Show last exam information for reference
- ✅ Suggest exam type based on time since last exam
- ✅ Suggest medical entity based on previous exams
- ✅ Calculate expiration date automatically
- ✅ Warn if exam is too soon after previous one

**Skip Questions**:
- Employee name (already in DB)
- Document number (already in DB)
- Position (already in DB)
- Department (already in DB)
- Hire date (already in DB)
- Risk level (already in DB)

**Ask Only**:
- Exam type
- Exam date
- Medical entity (with suggestion)
- Evaluating physician
- Fit for position (yes/no)
- Restrictions (if not fit)
- Recommendations
- Diagnoses (optional)

---

### 2. Event/Accident Report (`event_report`)

**Context Required**: None (can start fresh or with `employee_id`)

**Intelligent Behaviors**:
- ✅ If employee selected, auto-fill employee data
- ✅ Suggest location based on employee's usual work area
- ✅ Show employee's risk exposures for reference
- ✅ Auto-determine if ARL reporting is required based on event type
- ✅ Auto-assign investigator based on event severity
- ✅ Suggest witnesses from same department

**Skip Questions** (if employee selected):
- Employee name
- Document number
- Position
- Department
- Supervisor

**Ask Only**:
- Event type
- Date and time
- Location (with suggestion)
- Description
- Body part affected (if accident)
- Nature of injury (if accident)
- Witnesses
- Disability days (if applicable)

**Conditional Questions**:
- If "Accidente de Trabajo": Ask about ARL reporting
- If disability > 1 day: Ask about disability classification
- If severity is high: Auto-require investigation

---

### 3. Training Session Registration (`training_session`)

**Context Required**: None

**Intelligent Behaviors**:
- ✅ Suggest facilitator based on training topic
- ✅ Suggest duration based on training type
- ✅ Auto-populate participant list based on department/role
- ✅ Check for scheduling conflicts
- ✅ Suggest location based on expected attendance

**Skip Questions**:
- None (new training session)

**Ask Only**:
- Training topic
- Training type
- Modality (presencial/virtual/mixta)
- Scheduled date
- Duration
- Facilitator (with suggestion)
- Target audience (department/role)
- Location (with suggestion)

---

### 4. Training Attendance (`training_attendance`)

**Context Required**: `training_id`

**Intelligent Behaviors**:
- ✅ Show training details (read-only)
- ✅ Pre-populate participant list based on target audience
- ✅ Allow bulk attendance marking
- ✅ Auto-calculate pass/fail based on score
- ✅ Generate certificates for approved participants

**Skip Questions**:
- Training topic (already defined)
- Training date (already defined)
- Facilitator (already defined)

**Ask Only**:
- Attendance status for each participant (present/absent)
- Score for each participant (if applicable)
- Observations (optional)

---

### 5. Inspection Report (`inspection`)

**Context Required**: `site_id` (optional)

**Intelligent Behaviors**:
- ✅ If site selected, auto-fill site data
- ✅ Suggest inspection type based on due inspections
- ✅ Show last inspection results for reference
- ✅ Auto-assign inspector based on area
- ✅ Pre-populate checklist based on inspection type

**Skip Questions** (if site selected):
- Site name
- Site address
- Site contact

**Ask Only**:
- Inspection type
- Inspection date
- Inspector (with suggestion)
- Findings (checklist + free text)
- Photos/evidence (optional)
- Corrective actions needed

---

## Implementation Example

### Backend Service (Python/FastAPI)

```python
# services/form_service.py

from typing import Dict, List, Any, Optional
from sqlalchemy.orm import Session
from models import Employee, MedicalExam, Event, Training
from datetime import datetime, timedelta

class FormIntelligenceService:
    
    def __init__(self, db: Session):
        self.db = db
    
    def get_medical_exam_structure(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Generate intelligent form structure for medical exam registration.
        """
        employee_id = context.get("employee_id")
        
        if not employee_id:
            # No context, return full form
            return self._get_full_medical_exam_form()
        
        # Get employee data
        employee = self.db.query(Employee).filter(
            Employee.id_empleado == employee_id
        ).first()
        
        if not employee:
            raise ValueError(f"Employee {employee_id} not found")
        
        # Get last medical exam
        last_exam = self.db.query(MedicalExam).filter(
            MedicalExam.id_empleado == employee_id
        ).order_by(MedicalExam.Fecha_Realizacion.desc()).first()
        
        # Build prefilled data
        prefilled_data = {
            "employee_id": employee.id_empleado,
            "employee_name": f"{employee.Nombre} {employee.Apellidos}",
            "document_number": employee.NumeroDocumento,
            "position": employee.Cargo,
            "department": employee.Area,
            "hire_date": employee.Fecha_Ingreso.isoformat(),
            "risk_level": employee.Nivel_Riesgo_Laboral
        }
        
        # Add last exam info if exists
        if last_exam:
            prefilled_data["last_exam_date"] = last_exam.Fecha_Realizacion.isoformat()
            prefilled_data["last_exam_type"] = last_exam.Tipo_Examen
        
        # Determine suggested exam type
        suggested_exam_type = self._suggest_exam_type(employee, last_exam)
        
        # Determine suggested medical entity
        suggested_entity = last_exam.EntidadRealizadora if last_exam else "IPS Salud Total"
        
        # Build required fields
        required_fields = [
            {
                "name": "exam_type",
                "label": "Tipo de Examen",
                "type": "select",
                "options": [
                    "Preocupacional",
                    "Periodico",
                    "Post-Incapacidad",
                    "Retiro",
                    "Cambio de Ocupación"
                ],
                "required": True,
                "suggested_value": suggested_exam_type,
                "help_text": self._get_exam_type_help_text(last_exam)
            },
            {
                "name": "exam_date",
                "label": "Fecha de Realización",
                "type": "date",
                "required": True,
                "min_date": (datetime.now() - timedelta(days=30)).isoformat(),
                "max_date": datetime.now().isoformat()
            },
            {
                "name": "medical_entity",
                "label": "Entidad Realizadora",
                "type": "text",
                "required": True,
                "suggested_value": suggested_entity,
                "help_text": "Última entidad utilizada" if last_exam else None
            },
            {
                "name": "evaluating_physician",
                "label": "Médico Evaluador",
                "type": "text",
                "required": True
            },
            {
                "name": "fit_for_position",
                "label": "¿Apto para el cargo?",
                "type": "boolean",
                "required": True
            }
        ]
        
        # Conditional fields
        conditional_fields = [
            {
                "name": "restrictions",
                "label": "Restricciones Médicas",
                "type": "textarea",
                "required": False,
                "show_if": {
                    "field": "fit_for_position",
                    "value": False
                },
                "help_text": "Describa las restricciones médicas del trabajador"
            },
            {
                "name": "recommendations",
                "label": "Recomendaciones",
                "type": "textarea",
                "required": False
            },
            {
                "name": "diagnoses",
                "label": "Diagnósticos (Códigos CIE-10)",
                "type": "text",
                "required": False,
                "help_text": "Códigos CIE-10 separados por comas"
            }
        ]
        
        return {
            "form_type": "medical_exam",
            "title": "Registro de Examen Médico Ocupacional",
            "prefilled_data": prefilled_data,
            "readonly_fields": [
                "employee_name",
                "document_number",
                "position",
                "department",
                "hire_date",
                "risk_level"
            ],
            "required_fields": required_fields,
            "conditional_fields": conditional_fields
        }
    
    def _suggest_exam_type(
        self,
        employee: Employee,
        last_exam: Optional[MedicalExam]
    ) -> str:
        """
        Suggest exam type based on employee history.
        """
        if not last_exam:
            return "Preocupacional"
        
        # Check if employee is retiring
        if employee.Fecha_Retiro:
            return "Retiro"
        
        # Check time since last exam
        days_since_last = (datetime.now().date() - last_exam.Fecha_Realizacion).days
        
        # If last exam was periodic and more than 1 year ago
        if last_exam.Tipo_Examen == "Periodico" and days_since_last > 365:
            return "Periodico"
        
        # Default to periodic
        return "Periodico"
    
    def _get_exam_type_help_text(self, last_exam: Optional[MedicalExam]) -> str:
        """
        Generate helpful text for exam type selection.
        """
        if not last_exam:
            return "Primer examen del empleado"
        
        days_since = (datetime.now().date() - last_exam.Fecha_Realizacion).days
        
        return (
            f"Último examen fue {last_exam.Tipo_Examen} "
            f"el {last_exam.Fecha_Realizacion.strftime('%d/%m/%Y')} "
            f"({days_since} días atrás)"
        )
    
    def validate_medical_exam(
        self,
        data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Validate medical exam data and provide warnings/suggestions.
        """
        errors = []
        warnings = []
        suggestions = []
        
        employee_id = data.get("employee_id")
        exam_date = datetime.fromisoformat(data.get("exam_date"))
        exam_type = data.get("exam_type")
        
        # Get last exam
        last_exam = self.db.query(MedicalExam).filter(
            MedicalExam.id_empleado == employee_id
        ).order_by(MedicalExam.Fecha_Realizacion.desc()).first()
        
        # Check if exam is too soon
        if last_exam and exam_type == "Periodico":
            days_since = (exam_date.date() - last_exam.Fecha_Realizacion).days
            if days_since < 365:
                warnings.append({
                    "field": "exam_date",
                    "message": (
                        f"El examen anterior fue hace {days_since} días. "
                        "Los exámenes periódicos suelen ser anuales. ¿Está seguro?"
                    )
                })
        
        # Suggest expiration date
        if exam_type == "Periodico":
            expiration = exam_date + timedelta(days=365)
            suggestions.append({
                "field": "expiration_date",
                "suggested_value": expiration.isoformat(),
                "reason": "Basado en examen periódico anual"
            })
        
        return {
            "valid": len(errors) == 0,
            "errors": errors,
            "warnings": warnings,
            "suggestions": suggestions
        }
```

### Frontend Implementation (JavaScript)

```javascript
// js/forms.js

class IntelligentForm {
    constructor(formType, containerId) {
        this.formType = formType;
        this.container = document.getElementById(containerId);
        this.structure = null;
        this.data = {};
    }
    
    async load(context = {}) {
        // Fetch form structure from API
        const response = await fetch(
            `/api/forms/${this.formType}/structure?context=${JSON.stringify(context)}`
        );
        this.structure = await response.json();
        
        // Render form
        this.render();
    }
    
    render() {
        let html = `<h2>${this.structure.title}</h2>`;
        
        // Show prefilled data (read-only)
        if (Object.keys(this.structure.prefilled_data).length > 0) {
            html += '<div class="prefilled-section">';
            html += '<h3>Información del Empleado</h3>';
            html += '<div class="readonly-fields">';
            
            for (const [key, value] of Object.entries(this.structure.prefilled_data)) {
                if (this.structure.readonly_fields.includes(key)) {
                    html += `
                        <div class="field-group">
                            <label>${this.formatLabel(key)}</label>
                            <div class="readonly-value">${value}</div>
                        </div>
                    `;
                }
            }
            
            html += '</div></div>';
        }
        
        // Render required fields
        html += '<div class="required-section">';
        html += '<h3>Información del Examen</h3>';
        
        for (const field of this.structure.required_fields) {
            html += this.renderField(field);
        }
        
        html += '</div>';
        
        // Render conditional fields (hidden initially)
        html += '<div class="conditional-section">';
        
        for (const field of this.structure.conditional_fields) {
            html += this.renderField(field, true);
        }
        
        html += '</div>';
        
        // Submit button
        html += `
            <div class="form-actions">
                <button type="button" class="btn-primary" onclick="intelligentForm.submit()">
                    Guardar
                </button>
                <button type="button" class="btn-secondary" onclick="intelligentForm.cancel()">
                    Cancelar
                </button>
            </div>
        `;
        
        this.container.innerHTML = html;
        
        // Attach event listeners
        this.attachListeners();
    }
    
    renderField(field, hidden = false) {
        let html = `<div class="field-group ${hidden ? 'hidden' : ''}" data-field="${field.name}">`;
        html += `<label for="${field.name}">${field.label}`;
        
        if (field.required) {
            html += '<span class="required">*</span>';
        }
        
        html += '</label>';
        
        // Render input based on type
        switch (field.type) {
            case 'text':
                html += `<input type="text" id="${field.name}" name="${field.name}" `;
                if (field.suggested_value) {
                    html += `value="${field.suggested_value}" `;
                }
                if (field.required) {
                    html += 'required ';
                }
                html += '/>';
                break;
            
            case 'select':
                html += `<select id="${field.name}" name="${field.name}" `;
                if (field.required) {
                    html += 'required ';
                }
                html += '>';
                html += '<option value="">Seleccione...</option>';
                
                for (const option of field.options) {
                    html += `<option value="${option}" `;
                    if (option === field.suggested_value) {
                        html += 'selected ';
                    }
                    html += `>${option}</option>`;
                }
                
                html += '</select>';
                break;
            
            case 'date':
                html += `<input type="date" id="${field.name}" name="${field.name}" `;
                if (field.min_date) {
                    html += `min="${field.min_date}" `;
                }
                if (field.max_date) {
                    html += `max="${field.max_date}" `;
                }
                if (field.required) {
                    html += 'required ';
                }
                html += '/>';
                break;
            
            case 'boolean':
                html += `
                    <div class="radio-group">
                        <label>
                            <input type="radio" name="${field.name}" value="true" required />
                            Sí
                        </label>
                        <label>
                            <input type="radio" name="${field.name}" value="false" required />
                            No
                        </label>
                    </div>
                `;
                break;
            
            case 'textarea':
                html += `<textarea id="${field.name}" name="${field.name}" rows="4" `;
                if (field.required) {
                    html += 'required ';
                }
                html += '></textarea>';
                break;
        }
        
        // Help text
        if (field.help_text) {
            html += `<small class="help-text">${field.help_text}</small>`;
        }
        
        html += '</div>';
        
        return html;
    }
    
    attachListeners() {
        // Handle conditional field visibility
        for (const field of this.structure.conditional_fields) {
            if (field.show_if) {
                const triggerField = document.querySelector(
                    `[name="${field.show_if.field}"]`
                );
                
                if (triggerField) {
                    triggerField.addEventListener('change', (e) => {
                        const conditionalField = document.querySelector(
                            `[data-field="${field.name}"]`
                        );
                        
                        const triggerValue = e.target.value === 'true' ? true : 
                                           e.target.value === 'false' ? false : 
                                           e.target.value;
                        
                        if (triggerValue === field.show_if.value) {
                            conditionalField.classList.remove('hidden');
                        } else {
                            conditionalField.classList.add('hidden');
                        }
                    });
                }
            }
        }
    }
    
    async submit() {
        // Collect form data
        const formData = {
            ...this.structure.prefilled_data
        };
        
        // Get values from required fields
        for (const field of this.structure.required_fields) {
            const input = document.querySelector(`[name="${field.name}"]`);
            if (input) {
                formData[field.name] = input.value;
            }
        }
        
        // Get values from conditional fields (if visible)
        for (const field of this.structure.conditional_fields) {
            const fieldGroup = document.querySelector(`[data-field="${field.name}"]`);
            if (fieldGroup && !fieldGroup.classList.contains('hidden')) {
                const input = document.querySelector(`[name="${field.name}"]`);
                if (input) {
                    formData[field.name] = input.value;
                }
            }
        }
        
        // Validate
        const validation = await fetch(
            `/api/forms/${this.formType}/validate`,
            {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formData)
            }
        ).then(r => r.json());
        
        if (!validation.valid) {
            alert('Por favor corrija los errores en el formulario');
            return;
        }
        
        // Show warnings if any
        if (validation.warnings.length > 0) {
            const proceed = confirm(
                'Advertencias:\n' + 
                validation.warnings.map(w => `- ${w.message}`).join('\n') +
                '\n\n¿Desea continuar?'
            );
            
            if (!proceed) {
                return;
            }
        }
        
        // Apply suggestions
        for (const suggestion of validation.suggestions) {
            formData[suggestion.field] = suggestion.suggested_value;
        }
        
        // Submit
        const result = await fetch(
            `/api/forms/${this.formType}/submit`,
            {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formData)
            }
        ).then(r => r.json());
        
        if (result.success) {
            alert('Registro guardado exitosamente');
            window.location.href = '/dashboard.html';
        } else {
            alert('Error al guardar: ' + result.message);
        }
    }
    
    formatLabel(key) {
        // Convert snake_case to Title Case
        return key.split('_')
            .map(word => word.charAt(0).toUpperCase() + word.slice(1))
            .join(' ');
    }
}

// Usage
let intelligentForm;

function loadMedicalExamForm(employeeId) {
    intelligentForm = new IntelligentForm('medical_exam', 'form-container');
    intelligentForm.load({ employee_id: employeeId });
}
```

---

## Benefits

### For Users
- ✅ **Faster data entry** - No repetitive typing
- ✅ **Fewer errors** - Pre-filled data is accurate
- ✅ **Better UX** - Only see relevant questions
- ✅ **Helpful suggestions** - Smart defaults based on patterns

### For the Organization
- ✅ **Higher data quality** - Consistent, validated data
- ✅ **Better compliance** - All required fields captured
- ✅ **Audit trail** - Track what was auto-filled vs. manually entered
- ✅ **Efficiency** - Reduce time spent on administrative tasks

### For Developers
- ✅ **Reusable** - Same pattern for all forms
- ✅ **Maintainable** - Logic centralized in service layer
- ✅ **Testable** - Easy to unit test intelligence rules
- ✅ **Extensible** - Easy to add new form types

---

## Testing Strategy

### Unit Tests
```python
def test_medical_exam_form_with_existing_employee():
    # Given an employee with previous exam
    employee = create_test_employee()
    last_exam = create_test_exam(employee, exam_type="Periodico")
    
    # When requesting form structure
    service = FormIntelligenceService(db)
    structure = service.get_medical_exam_structure({
        "employee_id": employee.id_empleado
    })
    
    # Then employee data should be prefilled
    assert structure["prefilled_data"]["employee_name"] == "Juan López"
    assert structure["prefilled_data"]["last_exam_type"] == "Periodico"
    
    # And suggested exam type should be Periodico
    exam_type_field = next(
        f for f in structure["required_fields"] 
        if f["name"] == "exam_type"
    )
    assert exam_type_field["suggested_value"] == "Periodico"
```

### Integration Tests
```python
def test_full_medical_exam_workflow():
    # 1. Get form structure
    response = client.get("/api/forms/medical_exam/structure?context={\"employee_id\": 102}")
    assert response.status_code == 200
    
    # 2. Validate data
    form_data = {
        "employee_id": 102,
        "exam_type": "Periodico",
        "exam_date": "2024-11-20"
    }
    response = client.post("/api/forms/medical_exam/validate", json=form_data)
    assert response.status_code == 200
    
    # 3. Submit form
    response = client.post("/api/forms/medical_exam/submit", json=form_data)
    assert response.status_code == 200
    assert response.json()["success"] == True
```

---

## Future Enhancements

1. **Machine Learning**
   - Predict exam results based on historical data
   - Suggest corrective actions based on similar events
   - Identify patterns in accident causes

2. **Natural Language Processing**
   - Allow users to describe events in natural language
   - Auto-extract structured data from descriptions
   - Suggest relevant regulations based on context

3. **Mobile App**
   - Offline form completion
   - Photo/video evidence capture
   - GPS location tagging

4. **Voice Input**
   - Voice-to-text for field workers
   - Hands-free accident reporting
   - Multilingual support

---

**Document Version**: 1.0  
**Last Updated**: November 22, 2025
