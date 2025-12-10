"""
Petrochemical Industry Forms
Forms specific to petrochemical sector compliance
"""

from ..models.smart_forms import (
    SmartFormDefinition,
    FormField,
    FormSection,
    FieldType,
    ValidationRule,
    WorkflowAction
)


# ============================================================
# PERMISO DE TRABAJO EN CALIENTE
# ============================================================

def get_permiso_caliente_form() -> SmartFormDefinition:
    """Hot Work Permit Form - Resolución 1409/2012"""
    return SmartFormDefinition(
        id="form_permiso_caliente",
        name="Permiso de Trabajo en Caliente",
        title="Permiso para Trabajo en Caliente",
        description="Soldadura, corte, esmerilado en áreas con atmósferas inflamables",
        category="permisos",
        legal_reference=["Resolución 1409/2012", "Decreto 1072/2015"],
        
        sections=[
            FormSection(name="datos_trabajo", title="1. Datos del Trabajo", order=1),
            FormSection(name="mediciones", title="2. Mediciones de Seguridad", order=2),
            FormSection(name="controles", title="3. Controles de Seguridad", order=3),
        ],
        
        fields=[
            # Datos del Trabajo
            FormField(
                id="numero_permiso",
                name="numero_permiso",
                label="Número de Permiso",
                type=FieldType.TEXT,
                required=True,
                section="datos_trabajo",
                order=1,
                grid_columns=6,
                default_value="TC-{YEAR}-{AUTO}"
            ),
            FormField(
                id="descripcion_trabajo",
                name="descripcion",
                label="Descripción del Trabajo",
                type=FieldType.TEXTAREA,
                required=True,
                section="datos_trabajo",
                order=2,
                grid_columns=12
            ),
            FormField(
                id="ubicacion",
                name="ubicacion",
                label="Ubicación / Área",
                type=FieldType.TEXT,
                required=True,
                section="datos_trabajo",
                order=3,
                grid_columns=6
            ),
            FormField(
                id="fecha_inicio",
                name="fecha_inicio",
                label="Fecha y Hora de Inicio",
                type=FieldType.DATETIME,
                required=True,
                section="datos_trabajo",
                order=4,
                grid_columns=6
            ),
            FormField(
                id="vigencia_horas",
                name="vigencia",
                label="Vigencia (horas)",
                type=FieldType.NUMBER,
                required=True,
                section="datos_trabajo",
                order=5,
                grid_columns=6,
                default_value=4,
                validations=[
                    ValidationRule(type="min", value=1, message="Mínimo 1 hora"),
                    ValidationRule(type="max", value=12, message="Máximo 12 horas")
                ]
            ),
            FormField(
                id="id_ejecutor",
                name="ejecutor",
                label="Ejecutor del Trabajo",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                section="datos_trabajo",
                order=6,
                grid_columns=6
            ),
            FormField(
                id="id_supervisor",
                name="supervisor",
                label="Supervisor Responsable",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                section="datos_trabajo",
                order=7,
                grid_columns=6
            ),
            
            # Mediciones de Seguridad
            FormField(
                id="nivel_lel",
                name="lel",
                label="Nivel LEL (%)",
                type=FieldType.NUMBER,
                required=True,
                section="mediciones",
                order=8,
                grid_columns=4,
                help_text="Límite Explosivo Inferior - Debe ser 0%",
                validations=[
                    ValidationRule(type="max", value=10, message="LEL debe ser < 10% para autorizar")
                ]
            ),
            FormField(
                id="nivel_oxigeno",
                name="oxigeno",
                label="Nivel de Oxígeno (%)",
                type=FieldType.NUMBER,
                required=True,
                section="mediciones",
                order=9,
                grid_columns=4,
                help_text="Rango seguro: 19.5% - 23.5%",
                validations=[
                    ValidationRule(type="min", value=19.5, message="Oxígeno insuficiente"),
                    ValidationRule(type="max", value=23.5, message="Oxígeno excesivo")
                ]
            ),
            FormField(
                id="hora_medicion",
                name="hora_medicion",
                label="Hora de Medición",
                type=FieldType.TEXT,
                required=True,
                section="mediciones",
                order=10,
                grid_columns=4,
                help_text="Formato: HH:MM"
            ),
            
            # Controles de Seguridad
            FormField(
                id="requiere_aislamiento",
                name="aislamiento",
                label="¿Requiere Aislamiento de Área?",
                type=FieldType.RADIO,
                required=True,
                section="controles",
                order=11,
                grid_columns=6,
                options=[
                    {"value": "1", "label": "Sí"},
                    {"value": "0", "label": "No"}
                ]
            ),
            FormField(
                id="requiere_ventilacion",
                name="ventilacion",
                label="¿Requiere Ventilación Forzada?",
                type=FieldType.RADIO,
                required=True,
                section="controles",
                order=12,
                grid_columns=6,
                options=[
                    {"value": "1", "label": "Sí"},
                    {"value": "0", "label": "No"}
                ]
            ),
            FormField(
                id="requiere_extintor",
                name="extintor",
                label="¿Extintor a menos de 10m?",
                type=FieldType.RADIO,
                required=True,
                section="controles",
                order=13,
                grid_columns=6,
                options=[
                    {"value": "1", "label": "Sí"},
                    {"value": "0", "label": "No"}
                ]
            ),
            FormField(
                id="requiere_vigia",
                name="vigia",
                label="¿Requiere Vigía Permanente?",
                type=FieldType.RADIO,
                required=True,
                section="controles",
                order=14,
                grid_columns=6,
                options=[
                    {"value": "1", "label": "Sí"},
                    {"value": "0", "label": "No"}
                ]
            ),
            FormField(
                id="epp_requerido",
                name="epp",
                label="EPP Requerido",
                type=FieldType.MULTISELECT,
                required=True,
                section="controles",
                order=15,
                grid_columns=12,
                options=[
                    {"value": "careta_soldar", "label": "Careta de Soldar"},
                    {"value": "guantes_carnaza", "label": "Guantes de Carnaza"},
                    {"value": "mandil_cuero", "label": "Mandil de Cuero"},
                    {"value": "botas_seguridad", "label": "Botas de Seguridad"},
                    {"value": "respirador", "label": "Respirador con Filtro"},
                    {"value": "proteccion_auditiva", "label": "Protección Auditiva"}
                ]
            ),
            FormField(
                id="riesgos_identificados",
                name="riesgos",
                label="Riesgos Identificados",
                type=FieldType.TEXTAREA,
                required=True,
                section="controles",
                order=16,
                grid_columns=12
            ),
            FormField(
                id="medidas_control",
                name="medidas",
                label="Medidas de Control",
                type=FieldType.TEXTAREA,
                required=True,
                section="controles",
                order=17,
                grid_columns=12
            ),
        ],
        
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "PERMISO_TRABAJO",
                    "mapping": {
                        "TipoPermiso": "'Trabajo en Caliente'",
                        "NumeroPermiso": "numero_permiso",
                        "DescripcionTrabajo": "descripcion",
                        "Ubicacion": "ubicacion",
                        "FechaInicio": "fecha_inicio",
                        "FechaFin": "calculated_from_vigencia",
                        "Vigencia": "vigencia",
                        "id_ejecutor": "ejecutor",
                        "id_supervisor": "supervisor",
                        "id_autorizador": "current_user_id",
                        "NivelLEL": "lel",
                        "NivelOxigeno": "oxigeno",
                        "RequiereAislamiento": "aislamiento",
                        "RequiereVentilacion": "ventilacion",
                        "RequiereExtintor": "extintor",
                        "RequiereVigia": "vigia",
                        "EPPRequerido": "epp",
                        "RiesgosIdentificados": "riesgos",
                        "MedidasControl": "medidas",
                        "Estado": "'Autorizado'"
                    }
                },
                order=1
            ),
            WorkflowAction(
                action="send_notification",
                params={
                    "recipients": ["ejecutor", "supervisor"],
                    "template": "permiso_autorizado"
                },
                order=2
            ),
            WorkflowAction(
                action="complete_task",
                params={},
                order=3
            ),
        ],
        
        allow_save_draft=True,
        generate_pdf=True,
        version="1.0"
    )


# ============================================================
# PERMISO DE ESPACIOS CONFINADOS
# ============================================================

def get_permiso_espacio_confinado_form() -> SmartFormDefinition:
    """Confined Space Entry Permit - Resolución 0491/2020"""
    return SmartFormDefinition(
        id="form_permiso_espacio_confinado",
        name="Permiso de Espacios Confinados",
        title="Permiso para Ingreso a Espacios Confinados",
        description="Cumplimiento Resolución 0491/2020 - Espacios Confinados",
        category="permisos",
        legal_reference=["Resolución 0491/2020", "Decreto 1072/2015"],
        
        sections=[
            FormSection(name="datos_espacio", title="1. Identificación del Espacio", order=1),
            FormSection(name="atmosfera", title="2. Monitoreo Atmosférico", order=2),
            FormSection(name="controles", title="3. Controles y Rescate", order=3),
        ],
        
        fields=[
            FormField(
                id="numero_permiso",
                name="numero_permiso",
                label="Número de Permiso",
                type=FieldType.TEXT,
                required=True,
                section="datos_espacio",
                order=1,
                default_value="EC-{YEAR}-{AUTO}"
            ),
            FormField(
                id="tipo_espacio",
                name="tipo_espacio",
                label="Tipo de Espacio Confinado",
                type=FieldType.SELECT,
                required=True,
                section="datos_espacio",
                order=2,
                options=[
                    {"value": "tanque", "label": "Tanque de Almacenamiento"},
                    {"value": "reactor", "label": "Reactor"},
                    {"value": "tuberia", "label": "Tubería"},
                    {"value": "alcantarilla", "label": "Alcantarilla"},
                    {"value": "silo", "label": "Silo"},
                    {"value": "otro", "label": "Otro"}
                ]
            ),
            FormField(
                id="descripcion_trabajo",
                name="descripcion",
                label="Descripción del Trabajo",
                type=FieldType.TEXTAREA,
                required=True,
                section="datos_espacio",
                order=3
            ),
            FormField(
                id="ubicacion",
                name="ubicacion",
                label="Ubicación / Identificación",
                type=FieldType.TEXT,
                required=True,
                section="datos_espacio",
                order=4
            ),
            
            # Monitoreo Atmosférico (CRÍTICO - Res. 0491/2020)
            FormField(
                id="nivel_oxigeno",
                name="oxigeno",
                label="Oxígeno (%)",
                type=FieldType.NUMBER,
                required=True,
                section="atmosfera",
                order=5,
                help_text="Rango seguro: 19.5% - 23.5%",
                validations=[
                    ValidationRule(type="min", value=19.5, message="PELIGRO: Oxígeno insuficiente"),
                    ValidationRule(type="max", value=23.5, message="PELIGRO: Oxígeno excesivo")
                ]
            ),
            FormField(
                id="nivel_lel",
                name="lel",
                label="LEL (%)",
                type=FieldType.NUMBER,
                required=True,
                section="atmosfera",
                order=6,
                help_text="Debe ser 0% o < 10%",
                validations=[
                    ValidationRule(type="max", value=10, message="PELIGRO: Atmósfera inflamable")
                ]
            ),
            FormField(
                id="nivel_h2s",
                name="h2s",
                label="H2S (ppm)",
                type=FieldType.NUMBER,
                required=True,
                section="atmosfera",
                order=7,
                help_text="Límite: < 10 ppm",
                validations=[
                    ValidationRule(type="max", value=10, message="PELIGRO: H2S elevado")
                ]
            ),
            FormField(
                id="nivel_co",
                name="co",
                label="CO (ppm)",
                type=FieldType.NUMBER,
                required=True,
                section="atmosfera",
                order=8,
                help_text="Límite: < 35 ppm",
                validations=[
                    ValidationRule(type="max", value=35, message="PELIGRO: CO elevado")
                ]
            ),
            
            # Controles Obligatorios
            FormField(
                id="requiere_ventilacion",
                name="ventilacion",
                label="Ventilación Forzada Continua",
                type=FieldType.RADIO,
                required=True,
                section="controles",
                order=9,
                options=[
                    {"value": "1", "label": "Sí (Obligatorio)"},
                    {"value": "0", "label": "No"}
                ]
            ),
            FormField(
                id="requiere_vigia",
                name="vigia",
                label="Vigía Externo Permanente",
                type=FieldType.RADIO,
                required=True,
                section="controles",
                order=10,
                options=[
                    {"value": "1", "label": "Sí (Obligatorio)"},
                    {"value": "0", "label": "No"}
                ]
            ),
            FormField(
                id="equipo_rescate",
                name="rescate",
                label="Equipo de Rescate Disponible",
                type=FieldType.MULTISELECT,
                required=True,
                section="controles",
                order=11,
                options=[
                    {"value": "arnes", "label": "Arnés con Línea de Vida"},
                    {"value": "tripode", "label": "Trípode de Rescate"},
                    {"value": "winch", "label": "Winch/Malacate"},
                    {"value": "scba", "label": "Equipo SCBA"},
                    {"value": "detector", "label": "Detector Multigases"}
                ]
            ),
            FormField(
                id="id_ejecutor",
                name="ejecutor",
                label="Persona que Ingresa",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                section="controles",
                order=12
            ),
            FormField(
                id="id_vigia",
                name="vigia_empleado",
                label="Vigía Asignado",
                type=FieldType.EMPLOYEE_SELECT,
                required=True,
                section="controles",
                order=13
            ),
        ],
        
        on_submit=[
            WorkflowAction(
                action="save_to_table",
                params={
                    "table": "PERMISO_TRABAJO",
                    "mapping": {
                        "TipoPermiso": "'Espacios Confinados'",
                        "NumeroPermiso": "numero_permiso",
                        "DescripcionTrabajo": "descripcion",
                        "Ubicacion": "ubicacion",
                        "FechaInicio": "'now'",
                        "FechaFin": "calculated_6_hours",
                        "Vigencia": "6",
                        "id_ejecutor": "ejecutor",
                        "id_supervisor": "vigia_empleado",
                        "id_autorizador": "current_user_id",
                        "NivelOxigeno": "oxigeno",
                        "NivelLEL": "lel",
                        "NivelH2S": "h2s",
                        "NivelCO": "co",
                        "RequiereVentilacion": "ventilacion",
                        "RequiereVigia": "vigia",
                        "Estado": "'Autorizado'"
                    }
                },
                order=1
            ),
            WorkflowAction(
                action="send_notification",
                params={
                    "recipients": ["ejecutor", "vigia_empleado", "coordinador_sst"],
                    "template": "permiso_espacio_confinado",
                    "priority": "high"
                },
                order=2
            ),
            WorkflowAction(
                action="complete_task",
                params={},
                order=3
            ),
        ],
        
        allow_save_draft=False,  # No permitir borradores por seguridad
        generate_pdf=True,
        version="1.0"
    )
