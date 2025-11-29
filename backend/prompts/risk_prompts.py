"""
Risk Assessment Prompts

Prompt templates for risk evaluation and hazard identification.
"""

from typing import Dict, Any


class RiskPrompts:
    """Prompt templates for risk agent"""
    
    HAZARD_IDENTIFICATION = """Identifica los peligros presentes en el siguiente escenario:

Escenario: {scenario}

Para cada peligro identificado, proporciona:
1. Tipo de peligro (biológico, químico, físico, ergonómico, psicosocial, mecánico)
2. Descripción del peligro
3. Posibles consecuencias
4. Trabajadores expuestos

Formato de respuesta en JSON."""
    
    RISK_EVALUATION = """Evalúa el siguiente riesgo usando la metodología de probabilidad × severidad:

Peligro: {hazard}
Descripción: {description}
Trabajadores expuestos: {exposed_workers}
Controles existentes: {existing_controls}

Proporciona:
1. Probabilidad (1-5): {probability_criteria}
2. Severidad (1-5): {severity_criteria}
3. Nivel de riesgo resultante
4. Clasificación (bajo, medio, alto, crítico)
5. Acción requerida

Usa la matriz 5x5 estándar."""
    
    CONTROL_RECOMMENDATIONS = """Recomienda controles para el siguiente riesgo siguiendo la jerarquía de controles:

Riesgo: {risk}
Nivel actual: {risk_level}
Controles existentes: {existing_controls}

Proporciona recomendaciones en orden de prioridad:
1. Eliminación
2. Sustitución
3. Controles de ingeniería
4. Controles administrativos
5. Equipos de protección personal (EPP)

Para cada control recomendado, incluye:
- Descripción específica
- Efectividad esperada
- Costo estimado (bajo/medio/alto)
- Tiempo de implementación
- Responsable sugerido"""
    
    RISK_MATRIX_GENERATION = """Genera una matriz de riesgos para el área/proceso:

Área/Proceso: {area}
Peligros identificados: {hazards}

Crea una matriz que incluya:
- ID del riesgo
- Peligro
- Probabilidad
- Severidad
- Nivel de riesgo
- Controles existentes
- Controles recomendados
- Responsable
- Fecha límite de implementación

Formato: Tabla markdown"""
    
    INCIDENT_INVESTIGATION = """Analiza el siguiente incidente/accidente:

Descripción del incidente: {incident_description}
Fecha y hora: {datetime}
Lugar: {location}
Personas involucradas: {people}
Lesiones/daños: {injuries}

Proporciona:
1. Causas inmediatas
2. Causas básicas/raíz
3. Factores contribuyentes
4. Acciones correctivas recomendadas
5. Acciones preventivas
6. Lecciones aprendidas

Usa el método de los 5 porqués si es apropiado."""
    
    @classmethod
    def format_hazard_identification(cls, scenario: str) -> str:
        """Format hazard identification prompt"""
        return cls.HAZARD_IDENTIFICATION.format(scenario=scenario)
    
    @classmethod
    def format_risk_evaluation(
        cls,
        hazard: str,
        description: str,
        exposed_workers: str,
        existing_controls: str
    ) -> str:
        """Format risk evaluation prompt"""
        probability_criteria = """
        1 = Muy improbable (casi nunca ocurre)
        2 = Improbable (puede ocurrir raramente)
        3 = Posible (puede ocurrir ocasionalmente)
        4 = Probable (puede ocurrir frecuentemente)
        5 = Muy probable (ocurre regularmente)
        """
        
        severity_criteria = """
        1 = Insignificante (sin lesiones)
        2 = Menor (lesiones leves, primeros auxilios)
        3 = Moderado (lesiones que requieren atención médica)
        4 = Mayor (lesiones graves, incapacidad temporal)
        5 = Catastrófico (fatalidad o incapacidad permanente)
        """
        
        return cls.RISK_EVALUATION.format(
            hazard=hazard,
            description=description,
            exposed_workers=exposed_workers,
            existing_controls=existing_controls,
            probability_criteria=probability_criteria,
            severity_criteria=severity_criteria
        )
    
    @classmethod
    def format_control_recommendations(
        cls,
        risk: str,
        risk_level: str,
        existing_controls: str
    ) -> str:
        """Format control recommendations prompt"""
        return cls.CONTROL_RECOMMENDATIONS.format(
            risk=risk,
            risk_level=risk_level,
            existing_controls=existing_controls
        )
    
    @classmethod
    def format_risk_matrix(cls, area: str, hazards: list) -> str:
        """Format risk matrix generation prompt"""
        hazards_str = "\n".join(f"- {h}" for h in hazards)
        return cls.RISK_MATRIX_GENERATION.format(
            area=area,
            hazards=hazards_str
        )
    
    @classmethod
    def format_incident_investigation(
        cls,
        incident_description: str,
        datetime: str,
        location: str,
        people: str,
        injuries: str
    ) -> str:
        """Format incident investigation prompt"""
        return cls.INCIDENT_INVESTIGATION.format(
            incident_description=incident_description,
            datetime=datetime,
            location=location,
            people=people,
            injuries=injuries
        )
