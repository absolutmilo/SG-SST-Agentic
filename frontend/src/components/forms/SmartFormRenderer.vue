<template>
  <div class="smart-form-container">
    <!-- Loading State -->
    <div v-if="loading" class="loading-state">
      <div class="loader"></div>
      <p>Cargando formulario...</p>
    </div>
    
    <!-- Form -->
    <form v-else-if="formDefinition" @submit.prevent="handleSubmit" class="smart-form">
      <!-- Form Header -->
      <div class="form-header">
        <h2 class="form-title">{{ formDefinition.title }}</h2>
        <p v-if="formDefinition.description" class="form-description">
          {{ formDefinition.description }}
        </p>
        <div v-if="formDefinition.legal_reference.length > 0" class="legal-references">
          <span class="legal-label">Marco Legal:</span>
          <span v-for="(ref, index) in formDefinition.legal_reference" :key="index" class="legal-ref">
            {{ ref }}
          </span>
        </div>
      </div>
      
      <!-- Form Sections -->
      <div v-for="section in sections" :key="section.name" class="form-section">
        <h3 v-if="section.title" class="section-title">{{ section.title }}</h3>
        <p v-if="section.description" class="section-description">{{ section.description }}</p>
        
        <div class="form-grid">
          <div
            v-for="field in section.fields"
            :key="field.id"
            :class="`grid-col-${field.grid_columns}`"
            v-show="visibleFields.has(field.id)"
          >
            <component
              :is="getFieldComponent(field.type)"
              :field="field"
              :modelValue="formData[field.id]"
              :error="errors[field.id]"
              @update="updateField(field.id, $event)"
              @blur="validateField(field.id, formData[field.id])"
            />
            
            <!-- Safety Indicator for Petrochemical Fields -->
            <SafetyIndicator 
              v-if="getSafetyType(field.id)"
              :fieldId="getSafetyType(field.id)"
              :value="formData[field.id]"
              class="mt-2"
            />
          </div>
        </div>
      </div>
      
      <!-- Form Actions -->
      <div class="form-actions">
        <button
          v-if="formDefinition.allow_save_draft"
          type="button"
          @click="handleSaveDraft"
          class="btn btn-secondary"
          :disabled="saving"
        >
          {{ saving ? '💾 Guardando...' : '💾 Guardar Borrador' }}
        </button>
        
        <button
          type="submit"
          class="btn btn-primary"
          :disabled="submitting"
        >
          {{ submitting ? '⏳ Enviando...' : '✅ Enviar Formulario' }}
        </button>
      </div>
      
      <!-- Success Message -->
      <div v-if="submitSuccess" class="success-message">
        ✅ Formulario enviado exitosamente
      </div>
    </form>
    
    <!-- Error State -->
    <div v-else class="error-state">
      <p>❌ Error al cargar el formulario</p>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useSmartForm } from '../../composables/useSmartForm'

// Field Components
import TextField from './fields/TextField.vue'
import DateField from './fields/DateField.vue'
import SelectField from './fields/SelectField.vue'
import TextareaField from './fields/TextareaField.vue'
import FileUploadField from './fields/FileUploadField.vue'
import SignatureField from './fields/SignatureField.vue'
import EmployeeSelectField from './fields/EmployeeSelectField.vue'
import SafetyIndicator from '../SafetyIndicator.vue'

const props = defineProps({
  formId: {
    type: String,
    required: true
  },
  context: {
    type: Object,
    default: () => ({})
  }
})

const getSafetyType = (fieldId) => {
  if (!fieldId) return null
  const lowerId = fieldId.toLowerCase()
  if (lowerId.includes('oxigeno')) return 'oxigeno'
  if (lowerId.includes('lel')) return 'lel'
  if (lowerId.includes('h2s')) return 'h2s'
  if (lowerId.includes('co') && !lowerId.includes('control') && !lowerId.includes('correo')) return 'co' // Avoid false positives
  return null
}

const router = useRouter()
const submitSuccess = ref(false)

const {
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
} = useSmartForm(props.formId, props.context)

// Field component mapping
const fieldComponents = {
  text: TextField,
  number: TextField,
  email: TextField,
  phone: TextField,
  date: DateField,
  datetime: DateField,
  select: SelectField,
  multiselect: SelectField,
  radio: SelectField,
  checkbox: SelectField,
  textarea: TextareaField,
  file: FileUploadField,
  signature: SignatureField,
  employee_select: EmployeeSelectField,
  autocomplete: SelectField
}

const getFieldComponent = (type) => {
  return fieldComponents[type] || TextField
}

// Group fields by section
const sections = computed(() => {
  if (!formDefinition.value) return []
  
  if (formDefinition.value.sections && formDefinition.value.sections.length > 0) {
    return formDefinition.value.sections.map(section => ({
      ...section,
      fields: formDefinition.value.fields
        .filter(f => f.section === section.name)
        .sort((a, b) => a.order - b.order)
    }))
  }
  
  // If no sections defined, create a single default section
  return [{
    name: 'default',
    title: null,
    description: null,
    fields: formDefinition.value.fields.sort((a, b) => a.order - b.order)
  }]
})

const updateField = (fieldId, value) => {
  formData.value[fieldId] = value
}

const handleSaveDraft = async () => {
  const success = await saveDraft()
  if (success) {
    // Show temporary success message
    console.log('Draft saved')
  }
}

const handleSubmit = async () => {
  const success = await submitForm()
  if (success) {
    submitSuccess.value = true
    
    // Redirect after 2 seconds
    setTimeout(() => {
      router.push('/tasks')
    }, 2000)
  }
}

onMounted(async () => {
  await loadForm()
  await prefillData()
  await loadDraft()
})

onUnmounted(() => {
  cleanup()
})
</script>

<style scoped>
.smart-form-container {
  max-width: 900px;
  margin: 0 auto;
  padding: 2rem;
}

.loading-state,
.error-state {
  text-align: center;
  padding: 3rem;
}

.loader {
  width: 3rem;
  height: 3rem;
  border: 3px solid #e2e8f0;
  border-top-color: var(--primary);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.smart-form {
  background: white;
  border-radius: var(--radius-lg);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  padding: 2rem;
}

.form-header {
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid #e2e8f0;
}

.form-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: var(--text-main);
  margin-bottom: 0.5rem;
}

.form-description {
  font-size: 1rem;
  color: var(--text-muted);
  margin-bottom: 1rem;
}

.legal-references {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  align-items: center;
  font-size: 0.75rem;
}

.legal-label {
  font-weight: 600;
  color: var(--text-main);
}

.legal-ref {
  background: #f0f9ff;
  color: #0369a1;
  padding: 0.25rem 0.5rem;
  border-radius: var(--radius-sm);
}

.form-section {
  margin-bottom: 2.5rem;
}

.section-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: var(--text-main);
  margin-bottom: 0.5rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e2e8f0;
}

.section-description {
  font-size: 0.875rem;
  color: var(--text-muted);
  margin-bottom: 1rem;
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: 1rem;
}

.grid-col-1 { grid-column: span 1; }
.grid-col-2 { grid-column: span 2; }
.grid-col-3 { grid-column: span 3; }
.grid-col-4 { grid-column: span 4; }
.grid-col-5 { grid-column: span 5; }
.grid-col-6 { grid-column: span 6; }
.grid-col-7 { grid-column: span 7; }
.grid-col-8 { grid-column: span 8; }
.grid-col-9 { grid-column: span 9; }
.grid-col-10 { grid-column: span 10; }
.grid-col-11 { grid-column: span 11; }
.grid-col-12 { grid-column: span 12; }

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  margin-top: 2rem;
  padding-top: 1.5rem;
  border-top: 2px solid #e2e8f0;
}

.success-message {
  margin-top: 1rem;
  padding: 1rem;
  background: #d1fae5;
  color: #065f46;
  border-radius: var(--radius-md);
  text-align: center;
  font-weight: 500;
}

@media (max-width: 768px) {
  .smart-form-container {
    padding: 1rem;
  }
  
  .smart-form {
    padding: 1.5rem;
  }
  
  .form-grid {
    grid-template-columns: 1fr;
  }
  
  .grid-col-1,
  .grid-col-2,
  .grid-col-3,
  .grid-col-4,
  .grid-col-5,
  .grid-col-6,
  .grid-col-7,
  .grid-col-8,
  .grid-col-9,
  .grid-col-10,
  .grid-col-11,
  .grid-col-12 {
    grid-column: span 1;
  }
  
  .form-actions {
    flex-direction: column;
  }
}
</style>
