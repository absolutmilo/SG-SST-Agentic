<template>
  <div class="form-field" :class="{ 'has-error': error }">
    <label v-if="field.label" class="field-label">
      {{ field.label }}
      <span v-if="field.required" class="required">*</span>
    </label>
    
    <div class="file-upload-area">
      <input
        :id="field.id"
        type="file"
        @change="handleFileChange"
        :required="field.required"
        :disabled="field.disabled"
        :accept="acceptedTypes"
        class="file-input"
        ref="fileInput"
      />
      
      <label :for="field.id" class="file-upload-label">
        <div class="upload-icon">📁</div>
        <div class="upload-text">
          <span v-if="!fileName">Click para seleccionar archivo</span>
          <span v-else class="file-name">{{ fileName }}</span>
        </div>
      </label>
      
      <button
        v-if="fileName"
        @click="clearFile"
        type="button"
        class="clear-file-btn"
      >
        ✕ Eliminar
      </button>
    </div>
    
    <p v-if="field.help_text" class="help-text">{{ field.help_text }}</p>
    <p v-if="error" class="error-text">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  field: {
    type: Object,
    required: true
  },
  modelValue: {
    type: [File, String],
    default: null
  },
  error: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update', 'blur'])

const fileInput = ref(null)
const fileName = ref('')

const acceptedTypes = computed(() => {
  if (props.field.allowed_file_types) {
    return props.field.allowed_file_types.map(type => `.${type}`).join(',')
  }
  return '*'
})

const handleFileChange = (event) => {
  const file = event.target.files[0]
  if (file) {
    fileName.value = file.name
    emit('update', file)
  }
}

const clearFile = () => {
  fileName.value = ''
  if (fileInput.value) {
    fileInput.value.value = ''
  }
  emit('update', null)
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

.file-upload-area {
  position: relative;
}

.file-input {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

.file-upload-label {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  border: 2px dashed #e2e8f0;
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: var(--transition);
  background: #f8fafc;
}

.file-upload-label:hover {
  border-color: var(--primary);
  background: #f0f9ff;
}

.upload-icon {
  font-size: 2rem;
}

.upload-text {
  flex: 1;
  font-size: 0.875rem;
  color: var(--text-muted);
}

.file-name {
  color: var(--text-main);
  font-weight: 500;
}

.clear-file-btn {
  margin-top: 0.5rem;
  padding: 0.5rem 1rem;
  background: #fee2e2;
  color: #ef4444;
  border: none;
  border-radius: var(--radius-md);
  font-size: 0.875rem;
  cursor: pointer;
  transition: var(--transition);
}

.clear-file-btn:hover {
  background: #fecaca;
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
