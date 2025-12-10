/**
 * Form Validation Composable (Vue 3)
 * Provides reactive form validation with safety checks
 */

import { ref, computed, watch } from 'vue';
import { validateField, getSafetyStatus } from '../utils/FormValidationRules';

export function useFormValidation(formSchema, formData) {
    const errors = ref({});
    const touched = ref({});
    const safetyStatus = ref({});

    // Validate single field
    const validateSingleField = (fieldId, value) => {
        const field = formSchema.value?.fields?.find(f => f.id === fieldId);
        if (!field) return [];

        const fieldErrors = validateField(field, value);

        // Check safety status for petrochemical fields
        const safety = getSafetyStatus(fieldId, value);
        if (safety) {
            safetyStatus.value[fieldId] = safety;
        }

        return fieldErrors;
    };

    // Validate entire form
    const validateForm = () => {
        const newErrors = {};
        let formIsValid = true;

        formSchema.value?.fields?.forEach(field => {
            const value = formData.value[field.id];
            const fieldErrors = validateSingleField(field.id, value);

            if (fieldErrors.length > 0) {
                newErrors[field.id] = fieldErrors;
                formIsValid = false;
            }
        });

        errors.value = newErrors;
        return formIsValid;
    };

    // Mark field as touched
    const markFieldTouched = (fieldId) => {
        touched.value[fieldId] = true;
    };

    // Handle field change
    const handleFieldChange = (fieldId, value) => {
        const fieldErrors = validateSingleField(fieldId, value);
        errors.value[fieldId] = fieldErrors;
    };

    // Computed property for form validity
    const isValid = computed(() => {
        return Object.keys(errors.value).length === 0;
    });

    // Watch formData for changes
    watch(formData, () => {
        if (Object.keys(touched.value).length > 0) {
            validateForm();
        }
    }, { deep: true });

    return {
        errors,
        touched,
        isValid,
        safetyStatus,
        validateSingleField,
        validateForm,
        markFieldTouched,
        handleFieldChange
    };
}
