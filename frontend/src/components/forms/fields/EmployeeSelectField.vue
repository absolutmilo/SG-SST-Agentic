<template>
  <div class="form-field" :class="{ 'has-error': error }">
    <label v-if="field.label" class="field-label">
      {{ field.label }}
      <span v-if="field.required" class="required">*</span>
    </label>
    
    <div class="employee-select-wrapper">
      <input
        v-model="searchQuery"
        type="text"
        :placeholder="field.placeholder || 'Buscar empleado...'"
        @input="handleSearch"
        @focus="showDropdown = true"
        class="field-input"
      />
      
      <div v-if="showDropdown && filteredEmployees.length > 0" class="dropdown">
        <div
          v-for="employee in filteredEmployees"
          :key="employee.id_empleado"
          @click="selectEmployee(employee)"
          class="dropdown-item"
        >
          <div class="employee-info">
            <span class="employee-name">{{ employee.nombre_completo }}</span>
            <span class="employee-role">{{ employee.cargo }}</span>
          </div>
        </div>
      </div>
      
      <div v-if="selectedEmployee" class="selected-employee">
        <span>{{ selectedEmployee.nombre_completo }}</span>
        <button @click="clearSelection" type="button" class="clear-btn">✕</button>
      </div>
    </div>
    
    <p v-if="field.help_text" class="help-text">{{ field.help_text }}</p>
    <p v-if="error" class="error-text">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import api from '../../../services/api'

const props = defineProps({
  field: {
    type: Object,
    required: true
  },
  modelValue: {
    type: [String, Number],
    default: ''
  },
  error: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update', 'blur'])

const searchQuery = ref('')
const employees = ref([])
const selectedEmployee = ref(null)
const showDropdown = ref(false)
const loading = ref(false)

const filteredEmployees = computed(() => {
  if (!searchQuery.value) return employees.value.slice(0, 10)
  
  const query = searchQuery.value.toLowerCase()
  return employees.value.filter(emp => {
    // Handle different field name variations from CRUD
    const nombre = emp.nombre_completo || emp.NombreCompleto || emp.Nombre || ''
    return nombre.toLowerCase().includes(query)
  }).slice(0, 10)
})

const loadEmployees = async () => {
  loading.value = true
  try {
    // Use generic CRUD endpoint instead of specific employees endpoint
    const response = await api.get('/crud/EMPLEADO', {
      params: {
        skip: 0,
        limit: 1000 // Load all employees for autocomplete
      }
    })
    
    // Map CRUD response to expected format
    employees.value = (response.data.items || []).map(emp => {
      // Concatenate Nombre + Apellidos for full name
      const nombre = emp.Nombre || emp.nombre || ''
      const apellidos = emp.Apellidos || emp.apellidos || ''
      const nombreCompleto = `${nombre} ${apellidos}`.trim() || 
                            emp.NombreCompleto || 
                            emp.nombre_completo || 
                            'Sin nombre'
      
      return {
        id_empleado: emp.Id_Empleado || emp.id_empleado,
        nombre_completo: nombreCompleto,
        cargo: emp.Cargo || emp.cargo || 'N/A',
        area: emp.Area || emp.area || 'N/A',
        estado: emp.Estado || emp.estado
      }
    })
  } catch (error) {
    console.error('Error loading employees:', error)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  showDropdown.value = true
}

const selectEmployee = (employee) => {
  selectedEmployee.value = employee
  searchQuery.value = employee.nombre_completo
  showDropdown.value = false
  emit('update', employee.id_empleado)
}

const clearSelection = () => {
  selectedEmployee.value = null
  searchQuery.value = ''
  emit('update', null)
}

onMounted(() => {
  loadEmployees()
  
  // Close dropdown when clicking outside
  document.addEventListener('click', (e) => {
    if (!e.target.closest('.employee-select-wrapper')) {
      showDropdown.value = false
    }
  })
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

.employee-select-wrapper {
  position: relative;
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

.dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  margin-top: 0.25rem;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: var(--radius-md);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  max-height: 200px;
  overflow-y: auto;
  z-index: 10;
}

.dropdown-item {
  padding: 0.75rem;
  cursor: pointer;
  transition: background 0.2s;
}

.dropdown-item:hover {
  background: #f8fafc;
}

.employee-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.employee-name {
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-main);
}

.employee-role {
  font-size: 0.75rem;
  color: var(--text-muted);
}

.selected-employee {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 0.5rem;
  padding: 0.5rem 0.75rem;
  background: #f0f9ff;
  border: 1px solid #bae6fd;
  border-radius: var(--radius-md);
  font-size: 0.875rem;
}

.clear-btn {
  background: none;
  border: none;
  color: var(--text-muted);
  cursor: pointer;
  font-size: 1rem;
  padding: 0;
  transition: color 0.2s;
}

.clear-btn:hover {
  color: var(--text-main);
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
