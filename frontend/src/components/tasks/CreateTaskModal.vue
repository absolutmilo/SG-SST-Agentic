<template>
  <div class="modal-overlay" @click="$emit('close')">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h3 class="h3">Nueva Tarea</h3>
        <button @click="$emit('close')" class="close-btn">✕</button>
      </div>
      
      <form @submit.prevent="handleSubmit" class="modal-body">
        <div class="form-group">
          <label class="form-label">Descripción *</label>
          <textarea
            v-model="formData.descripcion"
            class="form-textarea"
            rows="3"
            required
            placeholder="Describe la tarea..."
          ></textarea>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label class="form-label">Tipo de Tarea *</label>
            <select v-model="formData.tipo_tarea" class="form-select" required>
              <option value="">Seleccione...</option>
              <option value="Registro Empleado">Registro Empleado</option>
              <option value="Examen Médico">Examen Médico</option>
              <option value="Capacitación">Capacitación</option>
              <option value="Inspección">Inspección</option>
              <option value="Auditoría">Auditoría</option>
              <option value="Reporte Incidente">Reporte Incidente</option>
              <option value="Entrega EPP">Entrega EPP</option>
              <option value="Otro">Otro</option>
            </select>
          </div>

          <div class="form-group">
            <label class="form-label">Prioridad *</label>
            <select v-model="formData.prioridad" class="form-select" required>
              <option value="">Seleccione...</option>
              <option value="Alta">Alta</option>
              <option value="Media">Media</option>
              <option value="Baja">Baja</option>
            </select>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label class="form-label">Asignar a *</label>
            <select v-model="formData.id_responsable" class="form-select" required>
              <option value="">Seleccione usuario...</option>
              <option
                v-for="user in users"
                :key="user.id_usuario"
                :value="user.id_usuario"
              >
                {{ user.nombre_completo }} ({{ user.nivel_acceso }})
              </option>
            </select>
          </div>

          <div class="form-group">
            <label class="form-label">Fecha de Vencimiento *</label>
            <input
              v-model="formData.fecha_vencimiento"
              type="date"
              class="form-input"
              required
              :min="today"
            />
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Observaciones</label>
          <textarea
            v-model="formData.observaciones"
            class="form-textarea"
            rows="2"
            placeholder="Notas adicionales (opcional)..."
          ></textarea>
        </div>

        <div class="modal-footer">
          <button type="button" @click="$emit('close')" class="btn btn-secondary">
            Cancelar
          </button>
          <button type="submit" class="btn btn-primary" :disabled="loading">
            {{ loading ? 'Creando...' : 'Crear Tarea' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import taskService from '../../services/taskService'

const emit = defineEmits(['close', 'task-created'])

const loading = ref(false)
const users = ref([])
const today = new Date().toISOString().split('T')[0]

const formData = ref({
  descripcion: '',
  tipo_tarea: '',
  prioridad: '',
  id_responsable: '',
  fecha_vencimiento: '',
  observaciones: ''
})

const loadUsers = async () => {
  try {
    const data = await taskService.getAssignableUsers()
    users.value = data.users
  } catch (error) {
    console.error('Error loading users:', error)
  }
}

const handleSubmit = async () => {
  loading.value = true
  try {
    await taskService.createTask(formData.value)
    emit('task-created')
    emit('close')
  } catch (error) {
    console.error('Error creating task:', error)
    alert('Error al crear la tarea: ' + (error.response?.data?.detail || error.message))
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadUsers()
})
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: var(--radius-lg);
  max-width: 600px;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #e2e8f0;
}

.close-btn {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: var(--text-muted);
  transition: color 0.2s;
}

.close-btn:hover {
  color: var(--text-main);
}

.modal-body {
  padding: 1.5rem;
}

.form-group {
  margin-bottom: 1.25rem;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.form-label {
  display: block;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-main);
  margin-bottom: 0.5rem;
}

.form-input,
.form-select,
.form-textarea {
  width: 100%;
  padding: 0.625rem 0.875rem;
  border-radius: var(--radius-md);
  border: 1px solid #e2e8f0;
  font-size: 0.875rem;
  transition: var(--transition);
}

.form-input:focus,
.form-select:focus,
.form-textarea:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.form-textarea {
  resize: vertical;
  font-family: inherit;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
  padding-top: 1rem;
  border-top: 1px solid #e2e8f0;
  margin-top: 1rem;
}

@media (max-width: 640px) {
  .form-row {
    grid-template-columns: 1fr;
  }
}
</style>
