<template>
  <div class="form-field" :class="{ 'has-error': error }">
    <label v-if="field.label" :for="field.id" class="field-label">
      {{ field.label }}
      <span v-if="field.required" class="required">*</span>
    </label>
    
    <!-- Select/Multiselect -->
    <select
      v-if="field.type === 'select' || field.type === 'multiselect'"
      :id="field.id"
      :value="modelValue"
      @change="$emit('update', $event.target.value)"
      @blur="$emit('blur')"
      :required="field.required"
      :disabled="field.disabled"
      :multiple="field.type === 'multiselect'"
      class="field-select"
    >
      <option value="">Seleccione...</option>
      <option
        v-for="option in field.options"
        :key="option.value"
        :value="option.value"
      >
        {{ option.label }}
      </option>
    </select>
    
    <!-- Radio buttons -->
    <div v-else-if="field.type === 'radio'" class="radio-group">
      <label
        v-for="option in field.options"
        :key="option.value"
        class="radio-label"
      >
        <input
          type="radio"
          :name="field.id"
          :value="option.value"
          :checked="modelValue === option.value"
          @change="$emit('update', option.value)"
          :required="field.required"
          :disabled="field.disabled"
          class="radio-input"
        />
        <span>{{ option.label }}</span>
      </label>
    </div>
    
    <!-- Checkboxes -->
    <div v-else-if="field.type === 'checkbox'" class="checkbox-group">
      <label
        v-for="option in field.options"
        :key="option.value"
        class="checkbox-label"
      >
        <input
          type="checkbox"
          :value="option.value"
          :checked="isChecked(option.value)"
          @change="handleCheckboxChange(option.value)"
          :disabled="field.disabled"
          class="checkbox-input"
        />
        <span>{{ option.label }}</span>
      </label>
    </div>
    
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
    type: [String, Array],
    default: ''
  },
  error: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update', 'blur'])

const isChecked = (value) => {
  if (Array.isArray(props.modelValue)) {
    return props.modelValue.includes(value)
  }
  return false
}

const handleCheckboxChange = (value) => {
  let newValue = Array.isArray(props.modelValue) ? [...props.modelValue] : []
  
  if (newValue.includes(value)) {
    newValue = newValue.filter(v => v !== value)
  } else {
    newValue.push(value)
  }
  
  emit('update', newValue)
}
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

.field-select {
  width: 100%;
  padding: 0.625rem 0.875rem;
  border-radius: var(--radius-md);
  border: 1px solid #e2e8f0;
  font-size: 0.875rem;
  transition: var(--transition);
  background: white;
  cursor: pointer;
}

.field-select:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.field-select:disabled {
  background: #f8fafc;
  cursor: not-allowed;
}

.radio-group,
.checkbox-group {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.radio-label,
.checkbox-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
  font-size: 0.875rem;
}

.radio-input,
.checkbox-input {
  width: 1rem;
  height: 1rem;
  cursor: pointer;
}

.has-error .field-select {
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
