"""
Output Validator

Validates agent outputs for completeness, consistency, and quality.
"""

from typing import Dict, Any, List, Optional
import logging
import re

logger = logging.getLogger(__name__)


class ValidationResult:
    """Result of a validation check"""
    
    def __init__(
        self,
        is_valid: bool,
        score: float,
        issues: List[str],
        suggestions: List[str]
    ):
        self.is_valid = is_valid
        self.score = score  # 0.0 to 1.0
        self.issues = issues
        self.suggestions = suggestions
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "is_valid": self.is_valid,
            "score": self.score,
            "issues": self.issues,
            "suggestions": self.suggestions
        }


class Validator:
    """
    Validates agent outputs for quality and completeness.
    
    Checks:
    - Completeness of required fields
    - Consistency of information
    - Format compliance
    - Quality metrics
    """
    
    def __init__(self):
        self.logger = logging.getLogger("review.validator")
    
    def validate(
        self,
        output: Dict[str, Any],
        schema: Optional[Dict[str, Any]] = None
    ) -> ValidationResult:
        """
        Validate agent output.
        
        Args:
            output: Agent output to validate
            schema: Optional schema to validate against
        
        Returns:
            ValidationResult
        """
        issues = []
        suggestions = []
        score = 1.0
        
        # Check basic structure
        if not isinstance(output, dict):
            issues.append("Output must be a dictionary")
            return ValidationResult(False, 0.0, issues, suggestions)
        
        # Check for required fields if schema provided
        if schema:
            required_fields = schema.get("required", [])
            for field in required_fields:
                if field not in output:
                    issues.append(f"Missing required field: {field}")
                    score -= 0.2
        
        # Check for empty values
        empty_fields = [k for k, v in output.items() if not v]
        if empty_fields:
            suggestions.append(f"Consider providing values for: {', '.join(empty_fields)}")
            score -= 0.1 * len(empty_fields)
        
        # Ensure score is within bounds
        score = max(0.0, min(1.0, score))
        
        is_valid = len(issues) == 0 and score >= 0.6
        
        self.logger.info(f"Validation complete: valid={is_valid}, score={score:.2f}")
        
        return ValidationResult(is_valid, score, issues, suggestions)
    
    def validate_risk_assessment(self, output: Dict[str, Any]) -> ValidationResult:
        """Validate risk assessment output"""
        issues = []
        suggestions = []
        score = 1.0
        
        required_fields = ["hazard", "probability", "severity", "risk_level", "controls"]
        
        for field in required_fields:
            if field not in output:
                issues.append(f"Missing required field: {field}")
                score -= 0.2
        
        # Validate probability and severity ranges
        if "probability" in output:
            prob = output["probability"]
            if not isinstance(prob, (int, float)) or not (1 <= prob <= 5):
                issues.append("Probability must be between 1 and 5")
                score -= 0.15
        
        if "severity" in output:
            sev = output["severity"]
            if not isinstance(sev, (int, float)) or not (1 <= sev <= 5):
                issues.append("Severity must be between 1 and 5")
                score -= 0.15
        
        # Check risk level consistency
        if "probability" in output and "severity" in output and "risk_level" in output:
            calc_risk = output["probability"] * output["severity"]
            stated_level = output["risk_level"]
            
            # Validate risk level matches calculation
            expected_levels = {
                range(1, 3): "minimal",
                range(3, 6): "low",
                range(6, 12): "medium",
                range(12, 20): "high",
                range(20, 26): "critical"
            }
            
            expected_level = None
            for r, level in expected_levels.items():
                if calc_risk in r:
                    expected_level = level
                    break
            
            if expected_level and stated_level != expected_level:
                issues.append(f"Risk level inconsistent with calculation (expected: {expected_level})")
                score -= 0.2
        
        score = max(0.0, min(1.0, score))
        is_valid = len(issues) == 0 and score >= 0.7
        
        return ValidationResult(is_valid, score, issues, suggestions)
    
    def validate_document_summary(self, output: Dict[str, Any]) -> ValidationResult:
        """Validate document summary output"""
        issues = []
        suggestions = []
        score = 1.0
        
        if "summary" not in output:
            issues.append("Missing summary field")
            score -= 0.3
        else:
            summary = output["summary"]
            
            # Check length
            if len(summary) < 50:
                suggestions.append("Summary seems too short")
                score -= 0.1
            elif len(summary) > 1000:
                suggestions.append("Summary might be too long")
                score -= 0.05
            
            # Check for key elements
            if "key_points" in output:
                if not isinstance(output["key_points"], list):
                    issues.append("key_points should be a list")
                    score -= 0.1
                elif len(output["key_points"]) == 0:
                    suggestions.append("Consider adding key points")
                    score -= 0.05
        
        score = max(0.0, min(1.0, score))
        is_valid = len(issues) == 0 and score >= 0.6
        
        return ValidationResult(is_valid, score, issues, suggestions)
    
    def validate_email(self, output: Dict[str, Any]) -> ValidationResult:
        """Validate email output"""
        issues = []
        suggestions = []
        score = 1.0
        
        required_fields = ["subject", "body"]
        
        for field in required_fields:
            if field not in output:
                issues.append(f"Missing required field: {field}")
                score -= 0.3
        
        # Validate subject
        if "subject" in output:
            subject = output["subject"]
            if len(subject) < 5:
                issues.append("Subject too short")
                score -= 0.1
            elif len(subject) > 100:
                suggestions.append("Subject might be too long")
                score -= 0.05
        
        # Validate body
        if "body" in output:
            body = output["body"]
            if len(body) < 20:
                issues.append("Email body too short")
                score -= 0.2
            
            # Check for greeting
            if not re.search(r'\b(hola|estimad[oa]|buen[oa]s?)\b', body, re.IGNORECASE):
                suggestions.append("Consider adding a greeting")
                score -= 0.05
            
            # Check for closing
            if not re.search(r'\b(saludos|atentamente|cordialmente)\b', body, re.IGNORECASE):
                suggestions.append("Consider adding a professional closing")
                score -= 0.05
        
        score = max(0.0, min(1.0, score))
        is_valid = len(issues) == 0 and score >= 0.7
        
        return ValidationResult(is_valid, score, issues, suggestions)
