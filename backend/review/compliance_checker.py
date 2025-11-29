"""
Compliance Checker

Verifies outputs against SG-SST compliance requirements.
"""

from typing import Dict, Any, List
import logging

logger = logging.getLogger(__name__)


class ComplianceRequirement:
    """Represents a compliance requirement"""
    
    def __init__(
        self,
        requirement_id: str,
        description: str,
        regulation: str,
        mandatory: bool = True
    ):
        self.requirement_id = requirement_id
        self.description = description
        self.regulation = regulation
        self.mandatory = mandatory


class ComplianceResult:
    """Result of compliance check"""
    
    def __init__(
        self,
        is_compliant: bool,
        compliance_score: float,
        passed_requirements: List[str],
        failed_requirements: List[str],
        recommendations: List[str]
    ):
        self.is_compliant = is_compliant
        self.compliance_score = compliance_score
        self.passed_requirements = passed_requirements
        self.failed_requirements = failed_requirements
        self.recommendations = recommendations
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "is_compliant": self.is_compliant,
            "compliance_score": self.compliance_score,
            "passed_requirements": self.passed_requirements,
            "failed_requirements": self.failed_requirements,
            "recommendations": self.recommendations
        }


class ComplianceChecker:
    """
    Checks outputs for compliance with SG-SST regulations.
    
    Regulations covered:
    - Decreto 1072 de 2015
    - Resolución 0312 de 2019
    - GTC 45
    """
    
    # Compliance requirements database
    REQUIREMENTS = {
        "risk_matrix": [
            ComplianceRequirement(
                "RM-001",
                "Debe incluir identificación de peligros",
                "GTC 45",
                True
            ),
            ComplianceRequirement(
                "RM-002",
                "Debe evaluar probabilidad y severidad",
                "GTC 45",
                True
            ),
            ComplianceRequirement(
                "RM-003",
                "Debe proponer controles según jerarquía",
                "Decreto 1072",
                True
            ),
            ComplianceRequirement(
                "RM-004",
                "Debe asignar responsables",
                "Resolución 0312",
                True
            )
        ],
        "sst_policy": [
            ComplianceRequirement(
                "POL-001",
                "Debe estar firmada por alta dirección",
                "Decreto 1072",
                True
            ),
            ComplianceRequirement(
                "POL-002",
                "Debe incluir compromiso de mejora continua",
                "Decreto 1072",
                True
            ),
            ComplianceRequirement(
                "POL-003",
                "Debe ser específica y apropiada",
                "Decreto 1072",
                True
            )
        ],
        "training_record": [
            ComplianceRequirement(
                "CAP-001",
                "Debe registrar nombre del trabajador",
                "Resolución 0312",
                True
            ),
            ComplianceRequirement(
                "CAP-002",
                "Debe incluir tema y duración",
                "Resolución 0312",
                True
            ),
            ComplianceRequirement(
                "CAP-003",
                "Debe tener firma o evidencia de asistencia",
                "Resolución 0312",
                True
            )
        ]
    }
    
    def __init__(self):
        self.logger = logging.getLogger("review.compliance")
    
    def check_compliance(
        self,
        output: Dict[str, Any],
        document_type: str
    ) -> ComplianceResult:
        """
        Check compliance of output against requirements.
        
        Args:
            output: Output to check
            document_type: Type of document (risk_matrix, sst_policy, etc.)
        
        Returns:
            ComplianceResult
        """
        requirements = self.REQUIREMENTS.get(document_type, [])
        
        if not requirements:
            self.logger.warning(f"No compliance requirements defined for: {document_type}")
            return ComplianceResult(
                True, 1.0, [], [],
                [f"No compliance requirements defined for {document_type}"]
            )
        
        passed = []
        failed = []
        recommendations = []
        
        # Check each requirement
        for req in requirements:
            if self._check_requirement(output, req):
                passed.append(req.requirement_id)
            else:
                failed.append(req.requirement_id)
                if req.mandatory:
                    recommendations.append(
                        f"{req.requirement_id}: {req.description} ({req.regulation})"
                    )
        
        # Calculate compliance score
        total = len(requirements)
        score = len(passed) / total if total > 0 else 1.0
        
        # Check if compliant (all mandatory requirements passed)
        mandatory_reqs = [r for r in requirements if r.mandatory]
        mandatory_passed = all(
            r.requirement_id in passed for r in mandatory_reqs
        )
        
        is_compliant = mandatory_passed and score >= 0.8
        
        self.logger.info(
            f"Compliance check for {document_type}: "
            f"score={score:.2f}, compliant={is_compliant}"
        )
        
        return ComplianceResult(
            is_compliant, score, passed, failed, recommendations
        )
    
    def _check_requirement(
        self,
        output: Dict[str, Any],
        requirement: ComplianceRequirement
    ) -> bool:
        """Check if a specific requirement is met"""
        req_id = requirement.requirement_id
        
        # Simple keyword-based checking (can be enhanced with LLM)
        if req_id == "RM-001":
            return "hazard" in output or "peligro" in output
        elif req_id == "RM-002":
            return "probability" in output and "severity" in output
        elif req_id == "RM-003":
            return "controls" in output or "controles" in output
        elif req_id == "RM-004":
            return "responsible" in output or "responsable" in output
        elif req_id == "POL-001":
            return "signature" in output or "firma" in output
        elif req_id == "POL-002":
            return "mejora continua" in str(output).lower() or "continuous improvement" in str(output).lower()
        elif req_id == "POL-003":
            return len(str(output)) > 100  # Basic check for specificity
        elif req_id == "CAP-001":
            return "worker" in output or "trabajador" in output or "name" in output
        elif req_id == "CAP-002":
            return ("topic" in output or "tema" in output) and ("duration" in output or "duración" in output)
        elif req_id == "CAP-003":
            return "signature" in output or "firma" in output or "attendance" in output
        
        # Default: assume passed if not specifically checked
        return True
    
    def get_requirements(self, document_type: str) -> List[Dict[str, Any]]:
        """Get all requirements for a document type"""
        requirements = self.REQUIREMENTS.get(document_type, [])
        return [
            {
                "id": req.requirement_id,
                "description": req.description,
                "regulation": req.regulation,
                "mandatory": req.mandatory
            }
            for req in requirements
        ]
    
    def add_custom_requirement(
        self,
        document_type: str,
        requirement: ComplianceRequirement
    ):
        """Add a custom compliance requirement"""
        if document_type not in self.REQUIREMENTS:
            self.REQUIREMENTS[document_type] = []
        
        self.REQUIREMENTS[document_type].append(requirement)
        self.logger.info(f"Added custom requirement {requirement.requirement_id} for {document_type}")
