"""
Email Communication Prompts

Prompt templates for email generation and notifications.
"""

from typing import Dict, Any, Optional


class EmailPrompts:
    """Prompt templates for email agent"""
    
    TASK_ASSIGNMENT = """Genera un correo profesional para notificar la asignación de una tarea:

Destinatario: {recipient_name}
Tarea: {task_title}
Descripción: {task_description}
Prioridad: {priority}
Fecha límite: {due_date}
Asignado por: {assigned_by}

El correo debe:
- Tener un saludo personalizado
- Explicar claramente la tarea
- Indicar la prioridad y fecha límite
- Incluir un llamado a la acción
- Tener un cierre profesional
- Incluir enlace al sistema (si aplica)

Tono: Profesional pero cercano"""
    
    DEADLINE_REMINDER = """Genera un recordatorio de vencimiento:

Destinatario: {recipient_name}
Tarea/Actividad: {item}
Fecha límite: {deadline}
Días restantes: {days_remaining}
Estado actual: {current_status}

El correo debe:
- Ser cortés pero urgente si es necesario
- Recordar la importancia de la tarea
- Ofrecer ayuda si la necesitan
- Incluir próximos pasos

Tono: {tone} (urgente/recordatorio amable)"""
    
    COMPLIANCE_ALERT = """Genera una alerta de cumplimiento:

Destinatario: {recipient_name}
Tipo de incumplimiento: {compliance_type}
Requisito: {requirement}
Normativa: {regulation}
Plazo para corrección: {correction_deadline}
Consecuencias: {consequences}

El correo debe:
- Ser claro sobre el incumplimiento
- Citar la normativa específica
- Indicar acciones correctivas requeridas
- Establecer plazos claros
- Ofrecer soporte

Tono: Formal y serio pero constructivo"""
    
    TRAINING_INVITATION = """Genera una invitación a capacitación:

Destinatarios: {recipients}
Tema de capacitación: {training_topic}
Fecha y hora: {datetime}
Duración: {duration}
Lugar/Modalidad: {location}
Instructor: {instructor}
Objetivos: {objectives}
Requisitos previos: {prerequisites}

El correo debe:
- Ser motivador y claro
- Explicar la importancia de la capacitación
- Incluir todos los detalles logísticos
- Solicitar confirmación de asistencia
- Incluir agenda si está disponible

Tono: Profesional y motivador"""
    
    INCIDENT_NOTIFICATION = """Genera una notificación de incidente:

Destinatarios: {recipients}
Tipo de incidente: {incident_type}
Fecha y hora: {datetime}
Ubicación: {location}
Gravedad: {severity}
Personas afectadas: {affected_people}
Acciones inmediatas tomadas: {immediate_actions}
Estado actual: {current_status}

El correo debe:
- Ser factual y objetivo
- Incluir todos los detalles relevantes
- Indicar acciones tomadas
- Solicitar información adicional si es necesario
- Mantener confidencialidad apropiada

Tono: Formal y objetivo"""
    
    PERIODIC_REPORT = """Genera un correo con reporte periódico:

Destinatarios: {recipients}
Período: {period}
Tipo de reporte: {report_type}
Indicadores clave: {kpis}
Logros: {achievements}
Pendientes: {pending_items}
Próximos pasos: {next_steps}

El correo debe:
- Resumir los puntos clave
- Usar formato claro (listas, tablas)
- Destacar logros y áreas de mejora
- Incluir gráficos si están disponibles
- Invitar a feedback

Tono: Profesional e informativo"""
    
    @classmethod
    def format_task_assignment(
        cls,
        recipient_name: str,
        task_title: str,
        task_description: str,
        priority: str,
        due_date: str,
        assigned_by: str
    ) -> str:
        """Format task assignment email prompt"""
        return cls.TASK_ASSIGNMENT.format(
            recipient_name=recipient_name,
            task_title=task_title,
            task_description=task_description,
            priority=priority,
            due_date=due_date,
            assigned_by=assigned_by
        )
    
    @classmethod
    def format_deadline_reminder(
        cls,
        recipient_name: str,
        item: str,
        deadline: str,
        days_remaining: int,
        current_status: str,
        urgent: bool = False
    ) -> str:
        """Format deadline reminder email prompt"""
        tone = "urgente" if urgent or days_remaining <= 2 else "recordatorio amable"
        
        return cls.DEADLINE_REMINDER.format(
            recipient_name=recipient_name,
            item=item,
            deadline=deadline,
            days_remaining=days_remaining,
            current_status=current_status,
            tone=tone
        )
    
    @classmethod
    def format_compliance_alert(
        cls,
        recipient_name: str,
        compliance_type: str,
        requirement: str,
        regulation: str,
        correction_deadline: str,
        consequences: str
    ) -> str:
        """Format compliance alert email prompt"""
        return cls.COMPLIANCE_ALERT.format(
            recipient_name=recipient_name,
            compliance_type=compliance_type,
            requirement=requirement,
            regulation=regulation,
            correction_deadline=correction_deadline,
            consequences=consequences
        )
    
    @classmethod
    def format_training_invitation(
        cls,
        recipients: str,
        training_topic: str,
        datetime: str,
        duration: str,
        location: str,
        instructor: str,
        objectives: str,
        prerequisites: Optional[str] = None
    ) -> str:
        """Format training invitation email prompt"""
        return cls.TRAINING_INVITATION.format(
            recipients=recipients,
            training_topic=training_topic,
            datetime=datetime,
            duration=duration,
            location=location,
            instructor=instructor,
            objectives=objectives,
            prerequisites=prerequisites or "Ninguno"
        )
