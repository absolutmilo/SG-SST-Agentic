/**
 * Composable for Smart Forms
 * Handles form loading, validation, submission, and workflow
 */

import { ref, computed, watch } from 'vue'
import api from '../services/api'

export function useSmartForm(formId, context = {}) {
    const formDefinition = ref(null)
    const formData = ref({})
    const errors = ref({})
    const loading = ref(false)
    const saving = ref(false)
    const submitting = ref(false)
    const visibleFields = ref(new Set())

    // Update visible fields based on conditional rules
    const updateVisibleFields = () => {
        if (!formDefinition.value) return

        const visible = new Set()

        formDefinition.value.fields.forEach(field => {
            let isVisible = field.visible !== false

            // Evaluate conditional rules
            if (field.conditional_rules && field.conditional_rules.length > 0) {
                field.conditional_rules.forEach(rule => {
                    const fieldValue = formData.value[rule.field]
                    const ruleMatches = evaluateCondition(rule.operator, fieldValue, rule.value)

                    if (ruleMatches) {
                        if (rule.action === 'hide') isVisible = false
                        if (rule.action === 'show') isVisible = true
                    }
                })
            }

            if (isVisible) {
                visible.add(field.id)
            }
        })

        visibleFields.value = visible
    }

    // Load form definition
    const loadForm = async () => {
        loading.value = true
        try {
            const response = await api.get(`/smart-forms/forms/${formId}`)
            formDefinition.value = response.data

            // Initialize form data with default values
            formDefinition.value.fields.forEach(field => {
                if (field.default_value !== null && field.default_value !== undefined) {
                    formData.value[field.id] = field.default_value
                }
            })

            // Initialize visible fields
            updateVisibleFields()

        } catch (error) {
            console.error('Error loading form:', error)
            throw error
        } finally {
            loading.value = false
        }
    }

    // Pre-fill form data
    const prefillData = async () => {
        try {
            const contextParam = JSON.stringify(context)
            const response = await api.get(`/smart-forms/forms/${formId}/prefill`, {
                params: { context: contextParam }
            })

            // Merge prefill data with existing form data
            formData.value = { ...formData.value, ...response.data }


            const visible = new Set()

            formDefinition.value.fields.forEach(field => {
                let isVisible = field.visible !== false

                // Evaluate conditional rules
                if (field.conditional_rules && field.conditional_rules.length > 0) {
                    field.conditional_rules.forEach(rule => {
                        const fieldValue = formData.value[rule.field]
                        const ruleMatches = evaluateCondition(rule.operator, fieldValue, rule.value)

                        if (ruleMatches) {
                            if (rule.action === 'hide') isVisible = false
                            if (rule.action === 'show') isVisible = true
                        }
                    })
                }

                if (isVisible) {
                    visible.add(field.id)
                }
            })

            visibleFields.value = visible
        } catch (error) {
            console.error('Error prefilling form:', error)
        }
    }

    // Evaluate conditional operator
    const evaluateCondition = (operator, fieldValue, ruleValue) => {
        switch (operator) {
            case 'equals':
                return fieldValue === ruleValue
            case 'not_equals':
                return fieldValue !== ruleValue
            case 'contains':
                return String(fieldValue).includes(ruleValue)
            case 'gt':
                return Number(fieldValue) > Number(ruleValue)
            case 'lt':
                return Number(fieldValue) < Number(ruleValue)
            case 'in':
                return Array.isArray(ruleValue) && ruleValue.includes(fieldValue)
            default:
                return false
        }
    }

    // Validate a single field
    const validateField = (fieldId, value) => {
        const field = formDefinition.value?.fields.find(f => f.id === fieldId)
        if (!field) return true

        // Clear previous error
        delete errors.value[fieldId]

        // Check required
        if (field.required && !value) {
            errors.value[fieldId] = `${field.label} is required`
            return false
        }

        // Run validations
        for (const validation of field.validations) {
            const isValid = runValidation(validation, value, field)
            if (!isValid) {
                errors.value[fieldId] = validation.message
                return false
            }
        }

        return true
    }

    // Run a validation rule
    const runValidation = (validation, value, field) => {
        switch (validation.type) {
            case 'min':
                if (field.type === 'number') {
                    return Number(value) >= validation.value
                } else {
                    return String(value).length >= validation.value
                }

            case 'max':
                if (field.type === 'number') {
                    return Number(value) <= validation.value
                } else {
                    return String(value).length <= validation.value
                }

            case 'pattern':
                return new RegExp(validation.value).test(value)

            case 'email':
                return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)

            case 'phone':
                return /^[\d\s\-\+\(\)]+$/.test(value)

            case 'date_range':
                const date = new Date(value)
                if (validation.value.min) {
                    const minDate = validation.value.min === 'today' ? new Date() : new Date(validation.value.min)
                    if (date < minDate) return false
                }
                if (validation.value.max) {
                    const maxDate = validation.value.max === 'today' ? new Date() : new Date(validation.value.max)
                    if (date > maxDate) return false
                }
                return true

            default:
                return true
        }
    }

    // Validate entire form
    const validateForm = () => {
        errors.value = {}
        let isValid = true

        formDefinition.value.fields.forEach(field => {
            // Only validate visible fields
            if (!visibleFields.value.has(field.id)) return

            const fieldValid = validateField(field.id, formData.value[field.id])
            if (!fieldValid) isValid = false
        })
        return isValid
    }

    // Submit form
    const submitForm = async () => {
        // Validate first
        if (!validateForm()) {
            return false
        }

        submitting.value = true
        try {
            const submission = {
                form_id: formId,
                form_version: formDefinition.value.version,
                data: formData.value,
                submitted_by: 0, // Will be set by backend from current_user
                attachments: [],
                context: context // Pass context (e.g., taskId) to backend
            }

            const response = await api.post(`/smart-forms/forms/${formId}/submit`, submission)
            return true
        } catch (error) {
            console.error('Error submitting form:', error)

            // Handle validation errors from backend
            if (error.response?.data?.detail?.errors) {
                error.response.data.detail.errors.forEach(err => {
                    errors.value[err.field_id] = err.message
                })
            }

            return false
        } finally {
            submitting.value = false
        }
    }

    // Load draft
    const loadDraft = async () => {
        try {
            // Try to load from localStorage first (faster/offline)
            const draftKey = `form_draft_${formId}`
            const savedDraft = localStorage.getItem(draftKey)

            if (savedDraft) {
                const parsed = JSON.parse(savedDraft)
                // Check if draft is for this form
                if (parsed.formId === formId) {
                    console.log('Loaded draft from localStorage')
                    formData.value = { ...formData.value, ...parsed.data }
                    return true
                }
            }

            // If no local draft, try backend
            try {
                const response = await api.get(`/smart-forms/forms/${formId}/draft`)
                if (response.data && Object.keys(response.data).length > 0) {
                    console.log('Loaded draft from backend')
                    formData.value = { ...formData.value, ...response.data }
                    return true
                }
            } catch (error) {
                // Ignore 404s for drafts
                if (error.response?.status !== 404) {
                    console.error('Error loading backend draft:', error)
                }
            }

            return false
        } catch (error) {
            console.error('Error loading draft:', error)
            return false
        }
    }

    // Save draft
    const saveDraft = async () => {
        saving.value = true
        try {
            // Save to localStorage for now (can be changed to API later)
            const draftKey = `form_draft_${formId}`
            localStorage.setItem(draftKey, JSON.stringify({
                formId: formId,
                data: formData.value,
                savedAt: new Date().toISOString()
            }))

            // Also try to save to backend
            try {
                await api.post(`/smart-forms/forms/${formId}/draft`, formData.value)
            } catch (error) {
                // Ignore backend errors, localStorage is enough
                console.log('Backend draft save failed, using localStorage only')
            }

            return true
        } catch (error) {
            console.error('Error saving draft:', error)
            return false
        } finally {
            saving.value = false
        }
    }

    // Watch form data for changes (for conditional rules)
    watch(formData, () => {
        updateVisibleFields()
    }, { deep: true })

    // Auto-save draft every 30 seconds
    let autoSaveInterval = null

    // Watch formDefinition to start auto-save when loaded
    watch(formDefinition, (newDef) => {
        if (newDef?.allow_save_draft) {
            // Clear existing interval if any
            if (autoSaveInterval) clearInterval(autoSaveInterval)

            // Start new interval
            autoSaveInterval = setInterval(() => {
                if (Object.keys(formData.value).length > 0) {
                    saveDraft()
                }
            }, 30000)
        }
    })

    // Cleanup
    const cleanup = () => {
        if (autoSaveInterval) {
            clearInterval(autoSaveInterval)
        }
    }

    return {
        formDefinition,
        formData,
        errors,
        loading,
        saving,
        submitting,
        visibleFields,
        loadForm,
        prefillData,
        loadDraft,
        validateField,
        validateForm,
        submitForm,
        saveDraft,
        cleanup
    }
}
