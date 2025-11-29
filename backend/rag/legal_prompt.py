"""
Legal and Compliance Prompts

Prompts with legal constraints and disclaimers for SG-SST system.
"""

from typing import Dict, Any


class LegalPromptTemplate:
    """Templates for legally compliant prompts"""
    
    DISCLAIMER = """
IMPORTANTE: Esta información es generada por IA y tiene propósitos informativos únicamente.
No constituye asesoría legal ni reemplaza la consulta con profesionales certificados en SST.
Siempre verifique con las normativas vigentes y consulte con expertos cuando sea necesario.
"""
    
    COMPLIANCE_NOTICE = """
Las recomendaciones se basan en:
- Decreto 1072 de 2015 (Sistema de Gestión de SST)
- Resolución 0312 de 2019 (Estándares mínimos)
- GTC 45 (Guía para identificación de peligros)

Última actualización de normativas: Consulte fuentes oficiales
"""
    
    @classmethod
    def wrap_with_disclaimer(cls, prompt: str) -> str:
        """Wrap a prompt with legal disclaimer"""
        return f"{prompt}\n\n{cls.DISCLAIMER}"
    
    @classmethod
    def add_compliance_notice(cls, prompt: str) -> str:
        """Add compliance notice to prompt"""
        return f"{prompt}\n\n{cls.COMPLIANCE_NOTICE}"
    
    @classmethod
    def get_safe_prompt(cls, base_prompt: str, include_compliance: bool = True) -> str:
        """Get a legally safe version of a prompt"""
        safe_prompt = cls.wrap_with_disclaimer(base_prompt)
        
        if include_compliance:
            safe_prompt = cls.add_compliance_notice(safe_prompt)
        
        return safe_prompt


class RestrictedContentFilter:
    """Filter to prevent generation of restricted content"""
    
    RESTRICTED_TOPICS = [
        "medical diagnosis",
        "legal advice",
        "financial advice",
        "personal health information"
    ]
    
    SAFETY_GUIDELINES = """
NO debes:
- Proporcionar diagnósticos médicos
- Dar asesoría legal específica
- Tomar decisiones críticas de seguridad sin supervisión humana
- Garantizar cumplimiento normativo sin auditoría profesional
- Procesar información personal sensible sin autorización

SÍ debes:
- Proporcionar información general basada en normativas
- Sugerir mejores prácticas de SST
- Recomendar consultar con profesionales cuando sea apropiado
- Indicar claramente cuando algo requiere verificación experta
- Proteger la privacidad y confidencialidad de datos
"""
    
    @classmethod
    def add_safety_guidelines(cls, prompt: str) -> str:
        """Add safety guidelines to prompt"""
        return f"{prompt}\n\n{cls.SAFETY_GUIDELINES}"
    
    @classmethod
    def check_content(cls, text: str) -> Dict[str, Any]:
        """Check if content contains restricted topics"""
        text_lower = text.lower()
        
        violations = []
        for topic in cls.RESTRICTED_TOPICS:
            if topic.lower() in text_lower:
                violations.append(topic)
        
        return {
            "is_safe": len(violations) == 0,
            "violations": violations
        }


def get_rag_system_prompt() -> str:
    """Get system prompt for RAG-based responses"""
    base_prompt = """Eres un asistente experto en Seguridad y Salud en el Trabajo (SG-SST) en Colombia.

Tu función es responder preguntas basándote ÚNICAMENTE en el contexto proporcionado de documentos oficiales.

Reglas importantes:
1. Solo usa información del contexto proporcionado
2. Si la información no está en el contexto, indícalo claramente
3. Cita las fuentes cuando sea posible
4. No inventes ni asumas información
5. Si algo requiere verificación profesional, indícalo
6. Mantén un tono profesional pero accesible
7. Estructura tus respuestas de forma clara y concisa

Formato de respuesta:
- Respuesta directa a la pregunta
- Explicación basada en el contexto
- Referencias a las fuentes utilizadas
- Recomendaciones adicionales si aplica"""
    
    return LegalPromptTemplate.get_safe_prompt(
        RestrictedContentFilter.add_safety_guidelines(base_prompt)
    )
