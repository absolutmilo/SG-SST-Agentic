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
        :required="field.required && !modelValue" 
        :disabled="field.disabled || uploading"
        :accept="acceptedTypes"
        class="file-input"
        ref="fileInput"
      />
      
      <label :for="field.id" class="file-upload-label" :class="{ 'uploading': uploading }">
        <div class="upload-icon">
             <span v-if="uploading">⏳</span>
             <span v-else>📁</span>
        </div>
        <div class="upload-text">
          <span v-if="uploading">Subiendo archivo...</span>
          <span v-else-if="!fileName && !modelValue">Click para seleccionar archivo</span>
          <span v-else class="file-name">{{ fileName || (typeof modelValue === 'string' ? 'Archivo Adjunto' : '') }}</span>
        </div>
      </label>
      
      <button
        v-if="fileName || modelValue"
        @click="clearFile"
        type="button"
        class="clear-file-btn"
        :disabled="uploading"
      >
        ✕ Eliminar
      </button>
    </div>
    
    <p v-if="field.help_text" class="help-text">{{ field.help_text }}</p>
    <p v-if="uploadError" class="error-text">{{ uploadError }}</p>
    <p v-if="error" class="error-text">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import api from '../../../services/api'

const props = defineProps({
  field: {
    type: Object,
    required: true
  },
  modelValue: {
    type: [File, String, Object], // File during select, String after upload
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
const uploading = ref(false)
const uploadError = ref('')

const acceptedTypes = computed(() => {
  if (props.field.allowed_file_types) {
    return props.field.allowed_file_types.map(type => `.${type}`).join(',')
  }
  return '*'
})

const handleFileChange = async (event) => {
  const file = event.target.files[0]
  if (file) {
    fileName.value = file.name
    uploading.value = true
    uploadError.value = ''
    
    try {
      // Create FormData
      const formData = new FormData()
      formData.append('file', file)
      formData.append('nombre', file.name)
      formData.append('tipo', 'SoporteFormulario')
      formData.append('categoria', props.field.category || 'formularios')
      formData.append('descripcion', `Soporte para campo ${props.field.label}`)

      console.log('Uploading file...', file.name)

      // Upload to backend
      const response = await api.post('/documents/upload', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      })

      console.log('Upload success:', response.data)
      
      // Emit the file path (or ID) returned by backend
      // Assuming response.data contains the document record
      // We'll use RutaArchivo relative path
      const filePath = response.data.RutaArchivo || response.data.path
      
      emit('update', filePath) // Emit string path
      
    } catch (err) {
      console.error('Upload failed:', err)
      uploadError.value = 'Error al subir archivo. Intente nuevamente.'
      emit('update', null)
    } finally {
      uploading.value = false
    }
  }
}

const clearFile = () => {
  fileName.value = ''
  uploadError.value = ''
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
