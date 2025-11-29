"""
Assistant Prompts

Prompt templates for general assistant agent.
"""


class AssistantPrompts:
    """Prompt templates for assistant agent"""
    
    GENERAL_QUERY = """Responde la siguiente pregunta sobre SG-SST:

Pregunta: {question}
Contexto del usuario: {user_context}

Proporciona una respuesta:
- Clara y concisa
- Basada en normativas colombianas cuando sea relevante
- Con ejemplos prácticos si es útil
- Que sugiera próximos pasos si aplica

Si la pregunta requiere un agente especializado, indícalo."""
    
    PROCESS_EXPLANATION = """Explica el siguiente proceso de SG-SST:

Proceso: {process_name}
Nivel de detalle: {detail_level}

La explicación debe incluir:
1. Objetivo del proceso
2. Pasos principales
3. Responsables típicos
4. Documentos relacionados
5. Normativa aplicable
6. Mejores prácticas

Formato: Paso a paso, fácil de seguir"""
    
    NAVIGATION_HELP = """Ayuda al usuario a navegar el sistema:

Usuario quiere: {user_goal}
Ubicación actual: {current_location}
Rol del usuario: {user_role}

Proporciona:
1. Pasos específicos para lograr el objetivo
2. Rutas alternativas si existen
3. Permisos necesarios
4. Tips útiles

Tono: Amigable y claro"""
    
    TROUBLESHOOTING = """Ayuda a resolver el siguiente problema:

Problema: {problem_description}
Contexto: {context}
Intentos previos: {previous_attempts}

Proporciona:
1. Diagnóstico del problema
2. Soluciones paso a paso
3. Soluciones alternativas
4. Cuándo escalar a soporte técnico

Formato: Claro y accionable"""
    
    BEST_PRACTICES = """Proporciona mejores prácticas para:

Tema: {topic}
Contexto organizacional: {org_context}

Incluye:
1. Mejores prácticas reconocidas
2. Ejemplos de implementación
3. Errores comunes a evitar
4. Recursos adicionales
5. Referencias normativas

Tono: Educativo y práctico"""
    
    REGULATION_EXPLANATION = """Explica la siguiente normativa:

Normativa: {regulation}
Aspecto específico: {specific_aspect}

Proporciona:
1. Resumen de la normativa
2. Requisitos principales
3. Aplicabilidad
4. Plazos y fechas importantes
5. Consecuencias de incumplimiento
6. Pasos para cumplir

Nota: Incluye disclaimer de que no es asesoría legal"""
    
    TASK_GUIDANCE = """Guía al usuario para completar la siguiente tarea:

Tarea: {task_name}
Descripción: {task_description}
Dificultad del usuario: {user_difficulty}

Proporciona:
1. Desglose de la tarea en pasos
2. Recursos necesarios
3. Tiempo estimado
4. Puntos de verificación
5. Dónde obtener ayuda adicional

Tono: Motivador y de apoyo"""
    
    @classmethod
    def format_general_query(
        cls,
        question: str,
        user_context: str = ""
    ) -> str:
        """Format general query prompt"""
        return cls.GENERAL_QUERY.format(
            question=question,
            user_context=user_context or "No especificado"
        )
    
    @classmethod
    def format_process_explanation(
        cls,
        process_name: str,
        detail_level: str = "medio"
    ) -> str:
        """Format process explanation prompt"""
        return cls.PROCESS_EXPLANATION.format(
            process_name=process_name,
            detail_level=detail_level
        )
    
    @classmethod
    def format_navigation_help(
        cls,
        user_goal: str,
        current_location: str,
        user_role: str
    ) -> str:
        """Format navigation help prompt"""
        return cls.NAVIGATION_HELP.format(
            user_goal=user_goal,
            current_location=current_location,
            user_role=user_role
        )
    
    @classmethod
    def format_troubleshooting(
        cls,
        problem_description: str,
        context: str = "",
        previous_attempts: str = ""
    ) -> str:
        """Format troubleshooting prompt"""
        return cls.TROUBLESHOOTING.format(
            problem_description=problem_description,
            context=context or "No especificado",
            previous_attempts=previous_attempts or "Ninguno"
        )
    
    @classmethod
    def format_best_practices(
        cls,
        topic: str,
        org_context: str = ""
    ) -> str:
        """Format best practices prompt"""
        return cls.BEST_PRACTICES.format(
            topic=topic,
            org_context=org_context or "Organización general"
        )
    
    @classmethod
    def format_regulation_explanation(
        cls,
        regulation: str,
        specific_aspect: str = ""
    ) -> str:
        """Format regulation explanation prompt"""
        return cls.REGULATION_EXPLANATION.format(
            regulation=regulation,
            specific_aspect=specific_aspect or "General"
        )
