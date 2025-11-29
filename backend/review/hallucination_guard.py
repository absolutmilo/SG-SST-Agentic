"""
Hallucination Guard

Detects and prevents hallucinations in LLM outputs.
"""

from typing import Dict, Any, List, Optional
import logging
import re

logger = logging.getLogger(__name__)


class HallucinationResult:
    """Result of hallucination detection"""
    
    def __init__(
        self,
        is_safe: bool,
        confidence: float,
        flags: List[str],
        evidence: List[str]
    ):
        self.is_safe = is_safe
        self.confidence = confidence
        self.flags = flags
        self.evidence = evidence
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "is_safe": self.is_safe,
            "confidence": self.confidence,
            "flags": self.flags,
            "evidence": self.evidence
        }


class HallucinationGuard:
    """
    Detects potential hallucinations in agent outputs.
    
    Detection methods:
    - Fact verification against source documents
    - Contradiction detection
    - Confidence scoring
    - Pattern matching for common hallucination indicators
    """
    
    # Patterns that may indicate hallucinations
    HALLUCINATION_PATTERNS = [
        r'\b(según estudios recientes|recent studies show)\b',  # Vague references
        r'\b(todos los expertos|all experts)\b',  # Overgeneralizations
        r'\b(siempre|nunca|always|never)\b',  # Absolutes
        r'\b(garantizado|guaranteed|100%)\b',  # Unrealistic guarantees
        r'\b(definitivamente|definitely|certainly)\b',  # Overconfidence
    ]
    
    # Patterns for unsupported claims
    UNSUPPORTED_CLAIM_PATTERNS = [
        r'\b(se ha demostrado que|it has been proven)\b',
        r'\b(la ciencia dice|science says)\b',
        r'\b(está comprobado|it is proven)\b'
    ]
    
    def __init__(self):
        self.logger = logging.getLogger("review.hallucination")
    
    def check(
        self,
        output: str,
        source_documents: Optional[List[str]] = None,
        context: Optional[str] = None
    ) -> HallucinationResult:
        """
        Check output for potential hallucinations.
        
        Args:
            output: Text output to check
            source_documents: Optional source documents for fact verification
            context: Optional context that was provided to the LLM
        
        Returns:
            HallucinationResult
        """
        flags = []
        evidence = []
        confidence = 1.0
        
        # Check for hallucination patterns
        for pattern in self.HALLUCINATION_PATTERNS:
            matches = re.findall(pattern, output, re.IGNORECASE)
            if matches:
                flags.append(f"Potential hallucination pattern: {pattern}")
                evidence.extend(matches)
                confidence -= 0.1
        
        # Check for unsupported claims
        for pattern in self.UNSUPPORTED_CLAIM_PATTERNS:
            matches = re.findall(pattern, output, re.IGNORECASE)
            if matches:
                flags.append(f"Unsupported claim pattern: {pattern}")
                evidence.extend(matches)
                confidence -= 0.15
        
        # Check for specific numbers without sources
        number_claims = re.findall(r'\b\d+%\b|\b\d+\s*(personas|trabajadores|casos)\b', output)
        if number_claims and not source_documents:
            flags.append("Specific statistics without source verification")
            evidence.extend(number_claims)
            confidence -= 0.2
        
        # Verify facts against source documents if provided
        if source_documents:
            fact_check_result = self._verify_facts(output, source_documents)
            if not fact_check_result["verified"]:
                flags.append("Facts not verified in source documents")
                confidence -= 0.3
        
        # Check for contradictions
        contradictions = self._detect_contradictions(output)
        if contradictions:
            flags.append("Internal contradictions detected")
            evidence.extend(contradictions)
            confidence -= 0.25
        
        # Ensure confidence is within bounds
        confidence = max(0.0, min(1.0, confidence))
        
        # Output is safe if confidence is high and no critical flags
        is_safe = confidence >= 0.7 and len(flags) < 3
        
        self.logger.info(
            f"Hallucination check: safe={is_safe}, confidence={confidence:.2f}, flags={len(flags)}"
        )
        
        return HallucinationResult(is_safe, confidence, flags, evidence)
    
    def _verify_facts(
        self,
        output: str,
        source_documents: List[str]
    ) -> Dict[str, Any]:
        """Verify facts in output against source documents"""
        # Simple keyword matching (can be enhanced with semantic similarity)
        output_words = set(output.lower().split())
        
        verified_count = 0
        total_claims = 0
        
        # Extract potential factual claims (sentences with specific patterns)
        claim_patterns = [
            r'el decreto \d+',
            r'la resolución \d+',
            r'artículo \d+',
            r'\d+%',
            r'\d+ (días|meses|años)'
        ]
        
        for pattern in claim_patterns:
            claims = re.findall(pattern, output, re.IGNORECASE)
            total_claims += len(claims)
            
            for claim in claims:
                # Check if claim appears in any source document
                for doc in source_documents:
                    if claim.lower() in doc.lower():
                        verified_count += 1
                        break
        
        verification_rate = verified_count / total_claims if total_claims > 0 else 1.0
        
        return {
            "verified": verification_rate >= 0.7,
            "verification_rate": verification_rate,
            "total_claims": total_claims,
            "verified_claims": verified_count
        }
    
    def _detect_contradictions(self, text: str) -> List[str]:
        """Detect internal contradictions in text"""
        contradictions = []
        
        # Split into sentences
        sentences = re.split(r'[.!?]+', text)
        
        # Look for contradictory patterns
        contradiction_pairs = [
            (r'\bsí\b', r'\bno\b'),
            (r'\bsiempre\b', r'\bnunca\b'),
            (r'\bobligatorio\b', r'\bopcional\b'),
            (r'\brequerido\b', r'\bno requerido\b')
        ]
        
        for sent1 in sentences:
            for sent2 in sentences:
                if sent1 != sent2:
                    for pos_pattern, neg_pattern in contradiction_pairs:
                        if re.search(pos_pattern, sent1, re.IGNORECASE) and \
                           re.search(neg_pattern, sent2, re.IGNORECASE):
                            contradictions.append(f"{sent1.strip()} <-> {sent2.strip()}")
        
        return contradictions[:3]  # Return max 3 contradictions
    
    def suggest_improvements(self, result: HallucinationResult) -> List[str]:
        """Suggest improvements based on hallucination check"""
        suggestions = []
        
        if not result.is_safe:
            suggestions.append("Consider rephrasing to be more specific and factual")
        
        if "Potential hallucination pattern" in str(result.flags):
            suggestions.append("Avoid overgeneralizations and absolute statements")
        
        if "Unsupported claim" in str(result.flags):
            suggestions.append("Provide sources or evidence for claims")
        
        if "statistics without source" in str(result.flags):
            suggestions.append("Cite sources for specific numbers and statistics")
        
        if "contradictions" in str(result.flags):
            suggestions.append("Review output for internal consistency")
        
        return suggestions
