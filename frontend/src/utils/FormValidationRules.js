/**
 * Form Validation Rules
 * Centralized validation rules for all form types
 */

export const PETROCHEMICAL_SAFETY_LIMITS = {
    oxigeno: {
        min: 19.5,
        max: 23.5,
        unit: '%',
        critical: true,
        errorMsg: 'PELIGRO: Oxígeno fuera de rango seguro (19.5-23.5%)',
        warningThreshold: 0.5 // Warning if within 0.5% of limits
    },
    lel: {
        min: 0,
        max: 10,
        unit: '%',
        critical: true,
        errorMsg: 'PELIGRO: LEL debe ser < 10%',
        warningThreshold: 2 // Warning if > 8%
    },
    h2s: {
        min: 0,
        max: 10,
        unit: 'ppm',
        critical: true,
        errorMsg: 'PELIGRO: H2S debe ser < 10 ppm',
        warningThreshold: 2 // Warning if > 8 ppm
    },
    co: {
        min: 0,
        max: 35,
        unit: 'ppm',
        critical: true,
        errorMsg: 'PELIGRO: CO debe ser < 35 ppm',
        warningThreshold: 5 // Warning if > 30 ppm
    }
};

export const VALIDATION_RULES = {
    required: {
        validate: (value) => {
            if (value === null || value === undefined) return false;
            if (typeof value === 'string') return value.trim() !== '';
            if (Array.isArray(value)) return value.length > 0;
            return true;
        },
        errorMsg: 'Este campo es obligatorio'
    },

    email: {
        pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
        errorMsg: 'Correo electrónico inválido'
    },

    phone: {
        pattern: /^\+?[0-9]{10,15}$/,
        errorMsg: 'Teléfono inválido (10-15 dígitos)'
    },

    date: {
        validate: (value) => !isNaN(Date.parse(value)),
        errorMsg: 'Fecha inválida'
    },

    futureDate: {
        validate: (value) => new Date(value) > new Date(),
        errorMsg: 'La fecha debe ser futura'
    },

    pastDate: {
        validate: (value) => new Date(value) < new Date(),
        errorMsg: 'La fecha debe ser pasada'
    },

    number: {
        validate: (value) => !isNaN(parseFloat(value)),
        errorMsg: 'Debe ser un número válido'
    },

    integer: {
        validate: (value) => Number.isInteger(Number(value)),
        errorMsg: 'Debe ser un número entero'
    },

    url: {
        pattern: /^https?:\/\/.+/,
        errorMsg: 'URL inválida'
    }
};

/**
 * Validate a single field value
 */
export const validateField = (field, value) => {
    const errors = [];

    // Required validation
    if (field.required && !VALIDATION_RULES.required.validate(value)) {
        errors.push(VALIDATION_RULES.required.errorMsg);
    }

    // Skip other validations if empty and not required
    if (!value && !field.required) {
        return errors;
    }

    // Type-specific validations
    if (field.validations) {
        field.validations.forEach(rule => {
            if (rule.type === 'min' && parseFloat(value) < parseFloat(rule.value)) {
                errors.push(rule.message || `Valor mínimo: ${rule.value}`);
            }

            if (rule.type === 'max' && parseFloat(value) > parseFloat(rule.value)) {
                errors.push(rule.message || `Valor máximo: ${rule.value}`);
            }

            if (rule.type === 'pattern' && !new RegExp(rule.value).test(value)) {
                errors.push(rule.message || 'Formato inválido');
            }

            if (rule.type === 'minLength' && value.length < rule.value) {
                errors.push(rule.message || `Mínimo ${rule.value} caracteres`);
            }

            if (rule.type === 'maxLength' && value.length > rule.value) {
                errors.push(rule.message || `Máximo ${rule.value} caracteres`);
            }
        });
    }

    return errors;
};

/**
 * Get safety status for petrochemical values
 */
export const getSafetyStatus = (fieldId, value) => {
    const limits = PETROCHEMICAL_SAFETY_LIMITS[fieldId];
    if (!limits) return null;

    const numValue = parseFloat(value);
    if (isNaN(numValue)) return null;

    // Out of range - DANGER
    if (numValue < limits.min || numValue > limits.max) {
        return {
            status: 'danger',
            message: limits.errorMsg,
            icon: '🔴',
            color: '#dc2626'
        };
    }

    // Close to limits - WARNING
    const closeToMin = numValue < (limits.min + limits.warningThreshold);
    const closeToMax = numValue > (limits.max - limits.warningThreshold);

    if (closeToMin || closeToMax) {
        return {
            status: 'warning',
            message: `Advertencia: Valor cercano al límite ${closeToMin ? 'inferior' : 'superior'}`,
            icon: '⚠️',
            color: '#f59e0b'
        };
    }

    // Safe range
    return {
        status: 'safe',
        message: `Valor seguro (${limits.min}-${limits.max} ${limits.unit})`,
        icon: '✅',
        color: '#10b981'
    };
};

export default {
    PETROCHEMICAL_SAFETY_LIMITS,
    VALIDATION_RULES,
    validateField,
    getSafetyStatus
};
