<template>
  <div class="container py-8 animate-fade-in">
    <!-- Header -->
    <div class="mb-6">
      <h1 class="h1 mb-2">Formularios Inteligentes</h1>
      <p class="text-muted">Sistema de formularios dinámicos para SG-SST</p>
    </div>
    
    <!-- Form Selection (if no form selected) -->
    <div v-if="!selectedFormId" class="forms-grid">
      <div
        v-for="form in availableForms"
        :key="form.id"
        @click="selectForm(form.id)"
        class="form-card"
      >
        <div class="form-icon">{{ getFormIcon(form.category) }}</div>
        <h3 class="form-name">{{ form.name }}</h3>
        <p class="form-description">{{ form.description }}</p>
        <div class="form-meta">
          <span class="form-category">{{ form.category }}</span>
        </div>
      </div>
    </div>
    
    <!-- Form Renderer -->
    <div v-else>
      <button @click="selectedFormId = null" class="btn btn-secondary mb-4">
        ← Volver a la lista
      </button>
      
      <SmartFormRenderer :formId="selectedFormId" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import SmartFormRenderer from '../components/forms/SmartFormRenderer.vue'
import api from '../services/api'

const selectedFormId = ref(null)
const availableForms = ref([])
const loading = ref(false)

const formIcons = {
  'eventos': '🚨',
  'examenes': '🏥',
  'capacitaciones': '📚',
  'inspecciones': '🔍',
  'epp': '🦺',
  'comites': '👥',
  'vigilancia': '📈',
  'auditorias': '✅',
  'reportes': '📊',
  'base': '📋'
}

const getFormIcon = (category) => {
  return formIcons[category] || '📄'
}

const loadForms = async () => {
  loading.value = true
  try {
    const response = await api.get('/smart-forms/forms')
    availableForms.value = response.data
  } catch (error) {
    console.error('Error loading forms:', error)
    // Fallback mock data
    availableForms.value = [
      { id: 1, name: 'Reporte de Incidentes', description: 'Formulario para reportar incidentes y accidentes de trabajo', category: 'eventos' },
      { id: 2, name: 'Inspección de Extintores', description: 'Lista de chequeo mensual para extintores', category: 'inspecciones' },
      { id: 3, name: 'Entrega de EPP', description: 'Registro de entrega de Elementos de Protección Personal', category: 'epp' },
      { id: 4, name: 'Evaluación de Capacitación', description: 'Evaluación de conocimientos post-capacitación', category: 'capacitaciones' }
    ]
  } finally {
    loading.value = false
  }
}

const selectForm = (formId) => {
  selectedFormId.value = formId
}

onMounted(() => {
  loadForms()
})
</script>

<style scoped>
.forms-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}

.form-card {
  background: white;
  border-radius: var(--radius-lg);
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: var(--transition);
  border: 2px solid transparent;
}

.form-card:hover {
  border-color: var(--primary);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.form-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.form-name {
  font-size: 1.125rem;
  font-weight: 600;
  color: var(--text-main);
  margin-bottom: 0.5rem;
}

.form-description {
  font-size: 0.875rem;
  color: var(--text-muted);
  margin-bottom: 1rem;
  line-height: 1.5;
}

.form-meta {
  display: flex;
  gap: 0.5rem;
}

.form-category {
  background: #f0f9ff;
  color: #0369a1;
  padding: 0.25rem 0.75rem;
  border-radius: var(--radius-sm);
  font-size: 0.75rem;
  font-weight: 500;
  text-transform: capitalize;
}
</style>
