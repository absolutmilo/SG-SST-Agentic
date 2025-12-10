"""
Form Catalog - Definitions of all Smart Forms
Includes industry-specific forms for petrochemical sector
"""

from api.models.smart_forms import (
    SmartFormDefinition,
    FormField,
    FormSection,
    FieldType,
    ValidationRule,
    ConditionalRule,
    WorkflowAction
)

# Import petrochemical-specific forms
try:
    from .form_catalog_petrochemical import (
        get_permiso_caliente_form,
        get_permiso_espacio_confinado_form
    )
    PETROCHEMICAL_FORMS_AVAILABLE = True
except ImportError as e:
    import logging
    logging.warning(f"Petrochemical forms not available: {e}")
    PETROCHEMICAL_FORMS_AVAILABLE = False


def get_form_catalog():
    """Returns catalog of all available forms"""
    catalog = {
        "form_accidente_trabajo": get_accidente_trabajo_form(),
        "form_incidente": get_incidente_form(),
        "form_enfermedad_laboral": get_enfermedad_laboral_form(),
        "form_entrega_epp": get_entrega_epp_form(),
        "form_autoevaluacion_0312": get_autoevaluacion_form(),
        "form_examen_medico": get_examen_medico_form(),
        "form_inspeccion_extintor": get_inspeccion_extintor_form(),
        "form_inspeccion_botiquin": get_inspeccion_botiquin_form(),
        "form_inspeccion_locativa": get_inspeccion_locativa_form(),
        "form_registro_capacitacion": get_registro_capacitacion_form(),
        "form_permiso_alturas": get_permiso_alturas_form(),
        "form_accion_correctiva": get_accion_correctiva_form(),
        "form_registro_mantenimiento": get_registro_mantenimiento_form(),
        "form_evaluacion_riesgo": get_evaluacion_riesgo_form(),
        "form_acta_reunion": get_acta_reunion_form(),
    }
    
    # Add petrochemical forms if available
    if PETROCHEMICAL_FORMS_AVAILABLE:
        catalog.update({
            "form_permiso_caliente": get_permiso_caliente_form(),
            "form_permiso_espacio_confinado": get_permiso_espacio_confinado_form(),
        })
    
    return catalog


def get_form_definition(form_id: str):
    """Get specific form definition"""
    catalog = get_form_catalog()
    return catalog.get(form_id)


# ============================================================
# 1. ACCIDENTE DE TRABAJO
# ============================================================

def get_accidente_trabajo_form() -> SmartFormDefinition:
    """Accident at Work Report and Investigation Form"""
    return SmartFormDefinition(
        id="form_accidente_trabajo",
        name="Accidente de Trabajo",
        title="Reporte e Investigación de Accidente de Trabajo",
        description="Formulario para reportar accidentes laborales según Resolución 1401 de 2007",
        category="eventos",
        legal_reference=["Resolución 1401 de 2007", "Decreto 1072 de 2015"],
        
        sections=[
            FormSection(name="datos_trabajador", title="1. Datos del Trabajador", order=1),
            FormSection(name="datos_evento", title="2. Datos del Evento", order=2),
            FormSection(name="lesion", title="3. Lesión", order=3),
            FormSection(name="investigacion", title="4. Investigación", order=4),
        ],
        
        fields=[
            # Sección 1: Datos del Trabajador
            FormField(
                id="id_empleado",
                name="empleado",
                label="Trabajador Accidentado",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                section="datos_trabajador",
                order=1,
                grid_columns=6,
                autocomplete_from="EMPLEADO",
                autocomplete_field="NombreCompleto"
            ),
            
            # Sección 2: Datos del Evento
            FormField(
                id="fecha_accidente",
                name="fecha",
                label="Fecha y Hora del Accidente",
                type=FieldType.DATETIME,
                required=True,
                section="datos_evento",
                order=10,
                grid_columns=6,
                validations=[
                    ValidationRule(
                        type="date_range",
                        value={"max": "today"},
                        message="La fecha no puede ser futura"
                    )
                ]
            ),
            FormField(
                id="lugar_accidente",
                name="lugar",
                label="Lugar del Accidente",
                type=FieldType.TEXT,
                required=True,
                section="datos_evento",
                order=11,
                grid_columns=6,
                placeholder="Ej: Planta de producción, Área de almacén..."
            ),
            FormField(
                id="descripcion",
                name="descripcion",
                label="Descripción Detallada del Accidente",
                type=FieldType.TEXTAREA,
                required=True,
                section="datos_evento",
                order=12,
                grid_columns=12,
                placeholder="Describa cómo ocurrió el accidente, qué estaba haciendo el trabajador, qué condiciones existían...",
                validations=[
                    ValidationRule(
                        type="min",
                        value=50,
                        message="Debe proporcionar una descripción detallada (mínimo 50 caracteres)"
                    )
                ]
            ),
            FormField(
                id="testigos",
                name="testigos",
                label="Testigos del Accidente",
                type=FieldType.TEXTAREA,
                required=False,
                section="datos_evento",
                order=13,
                grid_columns=12,
                placeholder="Nombres de los testigos presenciales"
            ),
            
            # Sección 3: Lesión
            FormField(
                id="parte_cuerpo",
                name="parte_cuerpo",
                label="Parte del Cuerpo Afectada",
                type=FieldType.SELECT,
                required=True,
                section="lesion",
                order=20,
                grid_columns=6,
                options=[
                    {"value": "cabeza", "label": "Cabeza"},
                    {"value": "ojos", "label": "Ojos"},
                    {"value": "cuello", "label": "Cuello"},
                    {"value": "hombros", "label": "Hombros"},
                    {"value": "brazos", "label": "Brazos"},
                    {"value": "manos", "label": "Manos"},
                    {"value": "dedos", "label": "Dedos"},
                    {"value": "torso", "label": "Torso"},
                    {"value": "espalda", "label": "Espalda"},
                    {"value": "piernas", "label": "Piernas"},
                    {"value": "pies", "label": "Pies"},
                    {"value": "multiple", "label": "Múltiples partes"},
                    {"value": "otro", "label": "Otro"}
                ]
            ),
            FormField(
                id="tipo_lesion",
                name="tipo_lesion",
                label="Tipo de Lesión",
                type=FieldType.SELECT,
                required=True,
                section="lesion",
                order=21,
                grid_columns=6,
                options=[
                    {"value": "contusion", "label": "Contusión"},
                    {"value": "herida", "label": "Herida"},
                    {"value": "fractura", "label": "Fractura"},
                    {"value": "quemadura", "label": "Quemadura"},
                    {"value": "amputacion", "label": "Amputación"},
                    {"value": "esguince", "label": "Esguince"},
                    {"value": "luxacion", "label": "Luxación"},
                    {"value": "otro", "label": "Otro"}
                ]
            ),
            FormField(
                id="dias_incapacidad",
                name="dias_incapacidad",
                label="Días de Incapacidad",
                type=FieldType.NUMBER,
                required=False,
                section="lesion",
                order=22,
                grid_columns=6,
                validations=[
                    ValidationRule(
                        type="min",
                        value=0,
                        message="No puede ser negativo"
                    )
                ]
            ),
            FormField(
                id="atencion_medica",
                name="atencion_medica",
                label="¿Recibió Atención Médica?",
                type=FieldType.RADIO,
                required=True,
                section="lesion",
                order=23,
                grid_columns=6,
                options=[
                    {"value": "si", "label": "Sí"},
                    {"value": "no", "label": "No"}
                ]
            ),
            
            # Sección 4: Investigación
            FormField(
                id="causas_inmediatas",
                name="causas_inmediatas",
                label="Causas Inmediatas",
                type=FieldType.TEXTAREA,
                required=True,
                section="investigacion",
                order=30,
                grid_columns=12,
                help_text="Actos y condiciones inseguras que causaron directamente el accidente",
                placeholder="Puede usar IA para ayudar con el análisis"
            ),
            FormField(
                id="causas_basicas",
                name="causas_basicas",
                label="Causas Básicas",
                type=FieldType.TEXTAREA,
                required=True,
                section="investigacion",
                order=31,
                grid_columns=12,
                help_text="Factores personales y de trabajo que permitieron que existieran las causas inmediatas"
            ),
            FormField(
                id="acciones_correctivas",
                name="acciones_correctivas",
                label="Acciones Correctivas",
                type=FieldType.TEXTAREA,
                required=True,
                section="investigacion",
                order=32,
                grid_columns=12,
                placeholder="Acciones para prevenir que vuelva a ocurrir"
            ),
            FormField(
                id="responsable_accion",
                name="responsable_accion",
                label="Responsable de Implementar Acciones",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                section="investigacion",
                order=33,
                grid_columns=6,
                autocomplete_from="EMPLEADO"
            ),
            FormField(
                id="fecha_implementacion",
                name="fecha_implementacion",
                label="Fecha Límite de Implementación",
                type=FieldType.DATE,
                required=True,
                section="investigacion",
                order=34,
                grid_columns=6,
                validations=[
                    ValidationRule(
                        type="date_range",
                        value={"min": "today"},
                        message="Debe ser una fecha futura"
                    )
                ]
            ),
        ],
        
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "EVENTO",
                    "mapping": {
                        "id_empleado": "id_empleado",
                        "Fecha_Evento": "fecha_accidente",
                        "Lugar_Evento": "lugar_accidente",
                        "Descripcion_Evento": "descripcion",
                        "Tipo_Evento": "'Accidente de Trabajo'",
                        "Parte_Cuerpo_Afectada": "parte_cuerpo",
                        "Naturaleza_Lesion": "tipo_lesion",
                        "Dias_Incapacidad": "dias_incapacidad",
                        "Causas_Inmediatas": "causas_inmediatas",
                        "Causas_Basicas": "causas_basicas"
                    }
                },
                order=1
            ),
            WorkflowAction(
                action="create_task",
                params={
                    "tipo_tarea": "Investigación de Accidente",
                    "descripcion": "Completar investigación del accidente y verificar implementación de acciones correctivas",
                    "prioridad": "Alta",
                    "assign_to_field": "responsable_accion",
                    "due_date_field": "fecha_implementacion"
                },
                order=2
            ),
            WorkflowAction(
                action="send_notification",
                params={
                    "recipients": ["coordinador_sst", "ceo"],
                    "template": "accidente_trabajo",
                    "subject": "ALERTA: Accidente de Trabajo Reportado"
                },
                order=3
            ),
            WorkflowAction(
                action="update_indicators",
                params={
                    "indicators": ["IFA", "ISA", "ILI"]
                },
                order=4
            ),
        ],
        
        allow_save_draft=True,
        allow_attachments=True,
        max_attachments=5,
        generate_pdf=True,
        send_notifications=True,
        version="1.0"
    )


# ============================================================
# 2. INCIDENTE
# ============================================================

def get_incidente_form() -> SmartFormDefinition:
    """Incident Report Form"""
    return SmartFormDefinition(
        id="form_incidente",
        name="Incidente",
        title="Reporte de Incidente",
        description="Formulario para reportar incidentes sin lesión",
        category="eventos",
        legal_reference=["Decreto 1072 de 2015"],
        
        sections=[
            FormSection(name="datos_evento", title="1. Datos del Evento", order=1),
            FormSection(name="analisis", title="2. Análisis", order=2),
        ],
        
        fields=[
            FormField(
                id="fecha_incidente",
                name="fecha",
                label="Fecha y Hora del Incidente",
                type=FieldType.DATETIME,
                required=True,
                section="datos_evento",
                order=1,
                grid_columns=6
            ),
            FormField(
                id="reportado_por",
                name="reportado_por",
                label="Reportado Por",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                section="datos_evento",
                order=2,
                grid_columns=6,
                autocomplete_from="EMPLEADO"
            ),
            FormField(
                id="lugar_incidente",
                name="lugar",
                label="Lugar del Incidente",
                type=FieldType.TEXT,
                required=True,
                section="datos_evento",
                order=3,
                grid_columns=12
            ),
            FormField(
                id="descripcion",
                name="descripcion",
                label="Descripción del Incidente",
                type=FieldType.TEXTAREA,
                required=True,
                section="datos_evento",
                order=4,
                grid_columns=12,
                validations=[
                    ValidationRule(type="min", value=30, message="Mínimo 30 caracteres")
                ]
            ),
            FormField(
                id="tipo_incidente",
                name="tipo",
                label="Tipo de Incidente",
                type=FieldType.SELECT,
                required=True,
                section="datos_evento",
                order=5,
                grid_columns=6,
                options=[
                    {"value": "Incidente", "label": "Casi Accidente (Incidente)"},
                    {"value": "Condición Insegura", "label": "Condición Insegura"},
                    {"value": "Acto Inseguro", "label": "Acto Inseguro"},
                    {"value": "Incidente", "label": "Otro"}
                ]
            ),
            FormField(
                id="acciones_inmediatas",
                name="acciones_inmediatas",
                label="Acciones Inmediatas Tomadas",
                type=FieldType.TEXTAREA,
                required=True,
                section="analisis",
                order=10,
                grid_columns=12
            ),
        ],
        
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "EVENTO",
                    "mapping": {
                        "Fecha_Evento": "fecha_incidente",
                        "id_empleado": "reportado_por",
                        "Lugar_Evento": "lugar_incidente",
                        "Descripcion_Evento": "descripcion",
                        "Tipo_Evento": "tipo_incidente",
                        "Causas_Inmediatas": "acciones_inmediatas"
                    }
                },
                order=1
            ),
            WorkflowAction(
                action="create_task",
                params={
                    "tipo_tarea": "Investigación de Incidente",
                    "descripcion": "Investigar y cerrar incidente reportado",
                    "prioridad": "Media",
                    "assign_to_role": "Coordinador SST",
                    "due_date": "+3 days"
                },
                order=2
            ),
            WorkflowAction(
                action="send_notification",
                params={"recipients": ["coordinador_sst"]},
                order=3
            ),
        ],
        
        allow_save_draft=True,
        allow_attachments=True,
        generate_pdf=True,
        version="1.0"
    )


# ============================================================
# 3. ENFERMEDAD LABORAL
# ============================================================

def get_enfermedad_laboral_form() -> SmartFormDefinition:
    """Occupational Disease Report Form"""
    return SmartFormDefinition(
        id="form_enfermedad_laboral",
        name="Enfermedad Laboral",
        title="Reporte de Enfermedad Laboral",
        description="Formulario para reportar enfermedades laborales",
        category="eventos",
        legal_reference=["Decreto 1477 de 2014", "Decreto 1072 de 2015"],
        
        fields=[
            FormField(
                id="id_empleado",
                name="empleado",
                label="Trabajador",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                order=1,
                grid_columns=6,
                autocomplete_from="EMPLEADO"
            ),
            FormField(
                id="fecha_diagnostico",
                name="fecha_diagnostico",
                label="Fecha de Diagnóstico",
                type=FieldType.DATE,
                required=True,
                order=2,
                grid_columns=6
            ),
            FormField(
                id="diagnostico",
                name="diagnostico",
                label="Diagnóstico Médico",
                type=FieldType.TEXT,
                required=True,
                order=3,
                grid_columns=12
            ),
            FormField(
                id="sintomas",
                name="sintomas",
                label="Síntomas",
                type=FieldType.TEXTAREA,
                required=True,
                order=4,
                grid_columns=12
            ),
            FormField(
                id="factor_riesgo",
                name="factor_riesgo",
                label="Factor de Riesgo Asociado",
                type=FieldType.SELECT,
                required=True,
                order=5,
                grid_columns=6,
                options=[
                    {"value": "biomechanical", "label": "Biomecánico"},
                    {"value": "chemical", "label": "Químico"},
                    {"value": "physical", "label": "Físico (Ruido, Vibración)"},
                    {"value": "biological", "label": "Biológico"},
                    {"value": "psychosocial", "label": "Psicosocial"},
                    {"value": "otro", "label": "Otro"}
                ]
            ),
            FormField(
                id="dias_incapacidad",
                name="dias_incapacidad",
                label="Días de Incapacidad",
                type=FieldType.NUMBER,
                required=False,
                order=6,
                grid_columns=6
            ),
        ],
        
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={"table": "EVENTO"},
                order=1
            ),
            WorkflowAction(
                action="send_notification",
                params={"recipients": ["arl", "eps", "coordinador_sst"]},
                order=2
            ),
        ],
        
        allow_save_draft=True,
        generate_pdf=True,
        send_notifications=True,
        version="1.0"
    )


# ============================================================
# 4. ENTREGA DE EPP
# ============================================================

def get_entrega_epp_form() -> SmartFormDefinition:
    """PPE Delivery Form"""
    return SmartFormDefinition(
        id="form_entrega_epp",
        name="Entrega de EPP",
        title="Acta de Entrega de Elementos de Protección Personal",
        description="Registro de entrega de EPP a trabajadores",
        category="epp",
        legal_reference=["Resolución 2400 de 1979"],
        
        fields=[
            FormField(
                id="id_empleado",
                name="empleado",
                label="Trabajador",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                order=1,
                grid_columns=6,
                autocomplete_from="EMPLEADO"
            ),
            FormField(
                id="fecha_entrega",
                name="fecha_entrega",
                label="Fecha de Entrega",
                type=FieldType.DATE,
                required=True,
                order=2,
                grid_columns=6,
                default_value="today"
            ),
            FormField(
                id="tipo_epp",
                name="tipo_epp",
                label="Tipo de EPP",
                type=FieldType.SELECT,
                required=True,
                order=3,
                grid_columns=6,
                autocomplete_from="EPP",
                autocomplete_field="Tipo_EPP"
            ),
            FormField(
                id="descripcion_epp",
                name="descripcion",
                label="Descripción del EPP",
                type=FieldType.TEXT,
                required=True,
                order=4,
                grid_columns=6
            ),
            FormField(
                id="cantidad",
                name="cantidad",
                label="Cantidad",
                type=FieldType.NUMBER,
                required=True,
                order=5,
                grid_columns=4,
                default_value=1,
                validations=[
                    ValidationRule(type="min", value=1, message="Mínimo 1")
                ]
            ),
            FormField(
                id="talla",
                name="talla",
                label="Talla",
                type=FieldType.SELECT,
                required=False,
                order=6,
                grid_columns=4,
                options=[
                    {"value": "XS", "label": "XS"},
                    {"value": "S", "label": "S"},
                    {"value": "M", "label": "M"},
                    {"value": "L", "label": "L"},
                    {"value": "XL", "label": "XL"},
                    {"value": "XXL", "label": "XXL"},
                    {"value": "NA", "label": "N/A"}
                ]
            ),
            FormField(
                id="vida_util_meses",
                name="vida_util",
                label="Vida Útil (meses)",
                type=FieldType.NUMBER,
                required=True,
                order=7,
                grid_columns=4,
                default_value=6
            ),
            FormField(
                id="firma_empleado",
                name="firma",
                label="Firma del Empleado",
                type=FieldType.SIGNATURE,
                required=True,
                order=8,
                grid_columns=12,
                help_text="El empleado confirma haber recibido el EPP en buen estado"
            ),
        ],
        
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "ENTREGA_EPP",
                    "mapping": {
                        "id_empleado": "id_empleado",
                        "id_epp": "id_epp",
                        "Fecha_Entrega": "fecha_entrega",
                        "Cantidad": "cantidad",
                        "Vida_Util_Meses": "vida_util",
                        "Entregado_Por": "entregado_por",
                        "Firma_Recibido": "firma"
                    }
                },
                order=1
            ),
            WorkflowAction(
                action="create_task",
                params={
                    "tipo_tarea": "Reposición de EPP",
                    "descripcion": "Programar reposición de EPP",
                    "due_date": "calculated_from_vida_util"
                },
                order=2
            ),
        ],
        
        allow_save_draft=True,
        generate_pdf=True,
        version="1.0"
    )


# ============================================================
# 5. AUTOEVALUACIÓN RESOLUCIÓN 0312
# ============================================================

def get_autoevaluacion_form() -> SmartFormDefinition:
    """Self-Assessment Resolution 0312 Form"""
    return SmartFormDefinition(
        id="form_autoevaluacion_0312",
        name="Autoevaluación Resolución 0312",
        title="Autoevaluación de Estándares Mínimos SG-SST",
        description="Evaluación anual según Resolución 0312 de 2019",
        category="reportes",
        legal_reference=["Resolución 0312 de 2019"],
        
        sections=[
            FormSection(name="recursos", title="I. Recursos", order=1),
            FormSection(name="gestion", title="II. Gestión Integral", order=2),
            FormSection(name="verificacion", title="III. Verificación", order=3),
            FormSection(name="mejoramiento", title="IV. Mejoramiento", order=4),
        ],
        
        fields=[
            # Simplificado - en realidad son 60+ campos
            FormField(
                id="fecha_evaluacion",
                name="fecha",
                label="Fecha de Evaluación",
                type=FieldType.DATE,
                required=True,
                order=1,
                grid_columns=6
            ),
            FormField(
                id="evaluador",
                name="evaluador",
                label="Evaluador",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                order=2,
                grid_columns=6,
                autocomplete_from="EMPLEADO"
            ),
            # ... más campos según estándares mínimos
        ],
        
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={"table": "RESULTADO_INDICADOR"},
                order=1
            ),
            WorkflowAction(
                action="create_task",
                params={
                    "tipo_tarea": "Plan de Mejora",
                    "descripcion": "Elaborar plan de mejora según brechas identificadas"
                },
                order=2,
                condition={"field": "puntaje_total", "operator": "lt", "value": 85}
            ),
        ],
        
        allow_save_draft=True,
        generate_pdf=True,
        send_notifications=True,
        version="1.0"
    )


# ============================================================
# 6. EXAMEN MÉDICO OCUPACIONAL (EMO)
# ============================================================

def get_examen_medico_form() -> SmartFormDefinition:
    """Occupational Medical Exam Form"""
    return SmartFormDefinition(
        id="form_examen_medico",
        name="Examen Médico Ocupacional",
        title="Registro de Examen Médico Ocupacional",
        description="Registro del concepto de aptitud médica laboral",
        category="salud",
        legal_reference=["Resolución 2346 de 2007"],
        
        fields=[
            FormField(
                id="id_empleado",
                name="empleado",
                label="Trabajador",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                order=1,
                grid_columns=6,
                autocomplete_from="EMPLEADO"
            ),
            FormField(
                id="tipo_examen",
                name="tipo_examen",
                label="Tipo de Examen",
                type=FieldType.SELECT,
                required=True,
                order=2,
                grid_columns=6,
                options=[
                    {"value": "ingreso", "label": "Ingreso (Pre-ocupacional)"},
                    {"value": "periodico", "label": "Periódico"},
                    {"value": "retiro", "label": "Retiro (Egreso)"},
                    {"value": "post_incapacidad", "label": "Post-Incapacidad"}
                ]
            ),
            FormField(
                id="fecha_examen",
                name="fecha_examen",
                label="Fecha del Examen",
                type=FieldType.DATE,
                required=True,
                order=3,
                grid_columns=6,
                default_value="today"
            ),
            FormField(
                id="concepto_aptitud",
                name="concepto",
                label="Concepto de Aptitud",
                type=FieldType.SELECT,
                required=True,
                order=4,
                grid_columns=6,
                options=[
                    {"value": "apto", "label": "Apto sin Restricciones"},
                    {"value": "apto_restricciones", "label": "Apto con Restricciones"},
                    {"value": "aplazado", "label": "Aplazado"},
                    {"value": "no_apto", "label": "No Apto"}
                ]
            ),
            FormField(
                id="restricciones",
                name="restricciones",
                label="Restricciones y Recomendaciones",
                type=FieldType.TEXTAREA,
                required=True,
                order=5,
                grid_columns=12,
                placeholder="Detalle las restricciones laborales o recomendaciones médicas..."
            ),
            FormField(
                id="certificado_adjunto",
                name="certificado",
                label="Certificado de Aptitud (PDF)",
                type=FieldType.FILE,
                required=True,
                order=6,
                grid_columns=12,
                help_text="Adjunte el certificado emitido por la IPS"
            ),
        ],
        
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "EXAMEN_MEDICO",
                    "mapping": {
                        "id_empleado": "id_empleado",
                        "Tipo_Examen": "tipo_examen",
                        "Fecha_Realizacion": "fecha_examen",
                        "Fecha_Vencimiento": "fecha_vencimiento",
                        "EntidadRealizadora": "entidad_realizadora",
                        "MedicoEvaluador": "medico_evaluador",
                        "Apto_Para_Cargo": "concepto_aptitud",
                        "Restricciones": "restricciones"
                    }
                },
                order=1
            ),
            WorkflowAction(
                action="complete_task",
                params={},
                order=2
            ),
        ],
        
        allow_save_draft=True,
        allow_attachments=True,
        version="1.0"
    )


# ============================================================
# 7. INSPECCIONES DE SEGURIDAD
# ============================================================

def get_inspeccion_extintor_form() -> SmartFormDefinition:
    """Extinguisher Inspection Form"""
    return SmartFormDefinition(
        id="form_inspeccion_extintor",
        name="Inspección de Extintores",
        title="Lista de Chequeo de Extintores",
        category="inspecciones",
        fields=[
            FormField(id="ubicacion", name="ubicacion", label="Ubicación", type=FieldType.TEXT, required=True, order=1),
            FormField(id="tipo_extintor", name="tipo", label="Tipo", type=FieldType.SELECT, required=True, order=2,
                      options=[{"value": "ABC", "label": "ABC"}, {"value": "CO2", "label": "CO2"}, {"value": "Solkaflam", "label": "Solkaflam"}]),
            FormField(id="presion", name="presion", label="Presión Adecuada", type=FieldType.RADIO, required=True, order=3,
                      options=[{"value": "si", "label": "Sí"}, {"value": "no", "label": "No"}]),
            FormField(id="acceso", name="acceso", label="Acceso Libre", type=FieldType.RADIO, required=True, order=4,
                      options=[{"value": "si", "label": "Sí"}, {"value": "no", "label": "No"}]),
            FormField(id="observaciones", name="observaciones", label="Observaciones", type=FieldType.TEXTAREA, order=5)
        ],
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "INSPECCION",
                    "mapping": {
                        "Tipo_Inspeccion": "'Extintor'",
                        "Area_Inspeccionada": "ubicacion",
                        "Fecha_Inspeccion": "'today'",
                        "HallazgosEncontrados": "observaciones",
                        "Estado": "'Realizada'"
                    }
                },
                order=1
            ),
            WorkflowAction(action="complete_task", params={}, order=2)
        ]
    )

def get_inspeccion_botiquin_form() -> SmartFormDefinition:
    """First Aid Kit Inspection Form"""
    return SmartFormDefinition(
        id="form_inspeccion_botiquin",
        name="Inspección de Botiquín",
        title="Lista de Chequeo de Botiquín",
        category="inspecciones",
        fields=[
            FormField(id="ubicacion", name="ubicacion", label="Ubicación", type=FieldType.TEXT, required=True, order=1),
            FormField(id="elementos_completos", name="elementos", label="Elementos Completos", type=FieldType.RADIO, required=True, order=2,
                      options=[{"value": "si", "label": "Sí"}, {"value": "no", "label": "No"}]),
            FormField(id="fechas_vencimiento", name="vencimiento", label="Fechas de Vencimiento Vigentes", type=FieldType.RADIO, required=True, order=3,
                      options=[{"value": "si", "label": "Sí"}, {"value": "no", "label": "No"}]),
            FormField(id="observaciones", name="observaciones", label="Observaciones", type=FieldType.TEXTAREA, order=4)
        ],
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "INSPECCION",
                    "mapping": {
                        "Tipo_Inspeccion": "'Botiquín'",
                        "Area_Inspeccionada": "ubicacion",
                        "Fecha_Inspeccion": "'today'",
                        "HallazgosEncontrados": "observaciones",
                        "Estado": "'Realizada'"
                    }
                },
                order=1
            ),
            WorkflowAction(action="complete_task", params={}, order=2)
        ]
    )

def get_inspeccion_locativa_form() -> SmartFormDefinition:
    """Facility Inspection Form"""
    return SmartFormDefinition(
        id="form_inspeccion_locativa",
        name="Inspección Locativa",
        title="Inspección de Instalaciones",
        category="inspecciones",
        fields=[
            FormField(id="area", name="area", label="Área Inspeccionada", type=FieldType.TEXT, required=True, order=1),
            FormField(id="iluminacion", name="iluminacion", label="Iluminación", type=FieldType.SELECT, required=True, order=2,
                      options=[{"value": "buena", "label": "Buena"}, {"value": "regular", "label": "Regular"}, {"value": "mala", "label": "Mala"}]),
            FormField(id="orden_aseo", name="orden", label="Orden y Aseo", type=FieldType.SELECT, required=True, order=3,
                      options=[{"value": "bueno", "label": "Bueno"}, {"value": "regular", "label": "Regular"}, {"value": "malo", "label": "Malo"}]),
            FormField(id="riesgos_electricos", name="electricos", label="Riesgos Eléctricos", type=FieldType.RADIO, required=True, order=4,
                      options=[{"value": "si", "label": "Sí"}, {"value": "no", "label": "No"}]),
            FormField(id="observaciones", name="observaciones", label="Hallazgos", type=FieldType.TEXTAREA, order=5)
        ],
        on_submit=[
            WorkflowAction(
                action="save_to_table", 
                params={
                    "table": "INSPECCION",
                    "mapping": {
                        "Tipo_Inspeccion": "'Locativa'",
                        "Area_Inspeccionada": "area",
                        "Fecha_Inspeccion": "'today'",
                        "HallazgosEncontrados": "observaciones",
                        "Estado": "'Realizada'"
                    }
                }, 
                order=1
            ),
            WorkflowAction(action="complete_task", params={}, order=2)
        ]
    )


# ============================================================
# 8. CAPACITACIÓN Y ENTRENAMIENTO
# ============================================================

def get_registro_capacitacion_form() -> SmartFormDefinition:
    """Training Attendance Form"""
    return SmartFormDefinition(
        id="form_registro_capacitacion",
        name="Registro de Capacitación",
        title="Control de Asistencia a Capacitación",
        category="capacitacion",
        fields=[
            FormField(id="tema", name="tema", label="Tema", type=FieldType.TEXT, required=True, order=1),
            FormField(id="facilitador", name="facilitador", label="Facilitador", type=FieldType.TEXT, required=True, order=2),
            FormField(id="fecha", name="fecha", label="Fecha", type=FieldType.DATE, required=True, order=3, default_value="today"),
            FormField(id="asistentes", name="asistentes", label="Asistentes", type=FieldType.EMPLOYEE_SELECT, required=True, order=4,
                      grid_columns=12, help_text="Seleccione los empleados asistentes"),
            FormField(id="evaluacion", name="evaluacion", label="Evaluación de Eficacia", type=FieldType.TEXTAREA, order=5)
        ],
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "CAPACITACION",
                    "mapping": {
                        "Tema": "tema",
                        "Facilitador": "facilitador",
                        "Fecha_Programada": "fecha",
                        "Descripcion": "evaluacion",
                        "Estado": "'Realizada'"
                    }
                },
                order=1
            ),
            WorkflowAction(action="complete_task", params={}, order=2)
        ]
    )


# ============================================================
# 9. PERMISOS DE TRABAJO
# ============================================================

def get_permiso_alturas_form() -> SmartFormDefinition:
    """Work at Heights Permit Form"""
    return SmartFormDefinition(
        id="form_permiso_alturas",
        name="Permiso de Trabajo en Alturas",
        title="Permiso para Trabajo en Alturas",
        category="permisos",
        fields=[
            FormField(id="trabajador", name="trabajador", label="Trabajador Autorizado", type=FieldType.EMPLOYEE_SELECT, required=True, order=1),
            FormField(id="altura_aprox", name="altura", label="Altura Aproximada (m)", type=FieldType.NUMBER, required=True, order=2),
            FormField(id="equipos_proteccion", name="epp", label="EPP Requeridos", type=FieldType.MULTISELECT, required=True, order=3,
                      options=[{"value": "arnes", "label": "Arnés"}, {"value": "casco", "label": "Casco con Barbuquejo"}, {"value": "eslinga", "label": "Eslinga"}]),
            FormField(id="puntos_anclaje", name="anclaje", label="Puntos de Anclaje Verificados", type=FieldType.RADIO, required=True, order=4,
                      options=[{"value": "si", "label": "Sí"}, {"value": "no", "label": "No"}]),
            FormField(id="autorizado_por", name="autorizador", label="Autorizado Por", type=FieldType.TEXT, required=True, order=5)
        ],
        on_submit=[
            WorkflowAction(action="save_to_table", params={"table": "PERMISO_ALTURAS"}, order=1),
            WorkflowAction(action="complete_task", params={}, order=2)
        ]
    )


# ============================================================
# 10. ACCIONES CORRECTIVAS (ACPM)
# ============================================================

def get_accion_correctiva_form() -> SmartFormDefinition:
    """Corrective Action Form"""
    return SmartFormDefinition(
        id="form_accion_correctiva",
        name="Acción Correctiva/Preventiva",
        title="Registro de Acción Correctiva/Preventiva",
        category="gestion",
        fields=[
            FormField(id="origen", name="origen", label="Origen", type=FieldType.SELECT, required=True, order=1,
                      options=[{"value": "inspeccion", "label": "Inspección"}, {"value": "accidente", "label": "Accidente"}, {"value": "auditoria", "label": "Auditoría"}]),
            FormField(id="descripcion_hallazgo", name="hallazgo", label="Descripción del Hallazgo", type=FieldType.TEXTAREA, required=True, order=2),
            FormField(id="analisis_causas", name="causas", label="Análisis de Causas", type=FieldType.TEXTAREA, required=True, order=3),
            FormField(id="plan_accion", name="plan", label="Plan de Acción", type=FieldType.TEXTAREA, required=True, order=4),
            FormField(id="responsable", name="responsable", label="Responsable", type=FieldType.EMPLOYEE_SELECT, required=True, order=5),
            FormField(id="fecha_cierre", name="fecha_cierre", label="Fecha de Cierre Estimada", type=FieldType.DATE, required=True, order=6)
        ],
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "ACCION_CORRECTIVA",
                    "mapping": {
                        "TipoAccion": "origen",
                        "Descripcion": "plan_accion",
                        "ResponsableEjecucion": "responsable",
                        "FechaCompromiso": "fecha_cierre",
                        "Estado": "'Abierta'"
                    }
                },
                order=1
            ),
            WorkflowAction(action="complete_task", params={}, order=2)
        ]
    )


# ============================================================
# 11. MANTENIMIENTO
# ============================================================

def get_registro_mantenimiento_form() -> SmartFormDefinition:
    """Maintenance Record Form"""
    return SmartFormDefinition(
        id="form_registro_mantenimiento",
        name="Registro de Mantenimiento",
        title="Informe de Mantenimiento de Equipos",
        category="mantenimiento",
        fields=[
            FormField(id="equipo", name="equipo", label="Equipo", type=FieldType.TEXT, required=True, order=1),
            FormField(id="tipo_mantenimiento", name="tipo", label="Tipo", type=FieldType.SELECT, required=True, order=2,
                      options=[{"value": "preventivo", "label": "Preventivo"}, {"value": "correctivo", "label": "Correctivo"}]),
            FormField(id="fecha", name="fecha", label="Fecha Realización", type=FieldType.DATE, required=True, order=3, default_value="today"),
            FormField(id="descripcion", name="descripcion", label="Descripción del Trabajo", type=FieldType.TEXTAREA, required=True, order=4),
            FormField(id="repuestos", name="repuestos", label="Repuestos Utilizados", type=FieldType.TEXTAREA, order=5),
            FormField(id="proximo_mantenimiento", name="proximo", label="Fecha Próximo Mantenimiento", type=FieldType.DATE, required=True, order=6)
        ],
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "MANTENIMIENTO_EQUIPO",
                    "mapping": {
                        "id_equipo": "equipo",
                        "TipoMantenimiento": "tipo_mantenimiento",
                        "FechaMantenimiento": "fecha",
                        "ProximoMantenimiento": "proximo_mantenimiento",
                        "DescripcionActividades": "descripcion"
                    }
                },
                order=1
            ),
            WorkflowAction(action="complete_task", params={}, order=2)
        ]
    )


# ============================================================
# 12. GESTIÓN DE RIESGOS
# ============================================================

def get_evaluacion_riesgo_form() -> SmartFormDefinition:
    """Risk Assessment Form"""
    return SmartFormDefinition(
        id="form_evaluacion_riesgo",
        name="Evaluación de Riesgo",
        title="Evaluación y Valoración de Riesgos",
        category="gestion",
        fields=[
            FormField(id="proceso", name="proceso", label="Proceso", type=FieldType.TEXT, required=True, order=1),
            FormField(id="actividad", name="actividad", label="Actividad", type=FieldType.TEXT, required=True, order=2),
            FormField(id="peligro", name="peligro", label="Peligro Identificado", type=FieldType.TEXTAREA, required=True, order=3),
            FormField(id="nivel_riesgo", name="nivel", label="Nivel de Riesgo", type=FieldType.SELECT, required=True, order=4,
                      options=[{"value": "bajo", "label": "Bajo"}, {"value": "medio", "label": "Medio"}, {"value": "alto", "label": "Alto"}, {"value": "critico", "label": "Crítico"}]),
            FormField(id="controles", name="controles", label="Controles Existentes", type=FieldType.TEXTAREA, required=True, order=5),
            FormField(id="nuevos_controles", name="nuevos_controles", label="Nuevos Controles Propuestos", type=FieldType.TEXTAREA, required=True, order=6)
        ],
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "EVALUACION_RIESGO",
                    "mapping": {
                        "Descripcion": "proceso",
                        "Estado": "'Realizada'"
                    }
                },
                order=1
            ),
            WorkflowAction(action="complete_task", params={}, order=2)
        ]
    )


# ============================================================
# 13. COMITÉS (COPASST / CONVIVENCIA)
# ============================================================

def get_acta_reunion_form() -> SmartFormDefinition:
    """Meeting Minutes Form"""
    return SmartFormDefinition(
        id="form_acta_reunion",
        name="Acta de Reunión",
        title="Acta de Reunión de Comité",
        category="gestion",
        fields=[
            FormField(id="comite", name="comite", label="Comité", type=FieldType.SELECT, required=True, order=1,
                      options=[{"value": "copasst", "label": "COPASST"}, {"value": "convivencia", "label": "Convivencia Laboral"}, {"value": "brigada", "label": "Brigada de Emergencia"}]),
            FormField(id="fecha", name="fecha", label="Fecha", type=FieldType.DATE, required=True, order=2, default_value="today"),
            FormField(id="asistentes", name="asistentes", label="Asistentes", type=FieldType.EMPLOYEE_SELECT, required=True, order=3, grid_columns=12),
            FormField(id="temas", name="temas", label="Temas Tratados", type=FieldType.TEXTAREA, required=True, order=4),
            FormField(id="compromisos", name="compromisos", label="Compromisos y Tareas", type=FieldType.TEXTAREA, required=True, order=5),
            FormField(id="proxima_reunion", name="proxima", label="Fecha Próxima Reunión", type=FieldType.DATE, required=True, order=6)
        ],
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "REUNION_COMITE",
                    "mapping": {
                        "id_comite": "comite",
                        "FechaReunion": "fecha",
                        "TipoReunion": "comite",
                        "Asistentes": "asistentes",
                        "TemasDiscutidos": "temas",
                        "Acuerdos": "compromisos",
                        "ProximaReunion": "proxima_reunion"
                    }
                },
                order=1
            ),
            WorkflowAction(action="complete_task", params={}, order=2)
        ]
    )
