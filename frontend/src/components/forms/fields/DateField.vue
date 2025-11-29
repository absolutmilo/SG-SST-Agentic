<template>
  <div class="form-field" :class="{ 'has-error': error }">
    <label v-if="field.label" :for="field.id" class="field-label">
      {{ field.label }}
      <span v-if="field.required" class="required">*</span>
    </label>
    
    <input
      :id="field.id"
      :type="getInputType"
      :value="modelValue"
      @input="$emit('update', $event.target.value)"
      @blur="$emit('blur')"
      :required="field.required"
      :disabled="field.disabled"
      class="field-input"
    />
    
    <p v-if="field.help_text" class="help-text">{{ field.help_text }}</p>
    <p v-if="error" class="error-text">{{ error }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  field: {
    type: Object,
    required: true
  },
  modelValue: {
    type: String,
    default: ''
  },
  error: {
    type: String,
    default: ''
  }
})

defineEmits(['update', 'blur'])

const getInputType = computed(() => {
  return props.field.type === 'datetime' ? 'datetime-local' : 'date'
})
</script>

<style scoped>
.form-field {
  margin-bottom: 1.25rem;
}

.field-label {
  display: block;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-main);
  margin-bottom: 0.5rem;
}

.required {
  color: #ef4444;
  margin-left: 0.25rem;
}

.field-input {
  width: 100%;
  padding: 0.625rem 0.875rem;
  border-radius: var(--radius-md);
  border: 1px solid #e2e8f0;
  font-size: 0.875rem;
  transition: var(--transition);
  background: white;
}

.field-input:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.field-input:disabled {
  background: #f8fafc;
  cursor: not-allowed;
}

.has-error .field-input {
  border-color: #ef4444;
}

.help-text {
  font-size: 0.75rem;
  color: var(--text-muted);
  margin-top: 0.25rem;
}

.error-text {
  font-size: 0.75rem;
  color: #ef4444;
  margin-top: 0.25rem;
}
</style>
