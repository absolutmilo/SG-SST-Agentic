<template>
  <div class="container py-8 animate-fade-in">
    <!-- Header -->
    <div class="flex items-center justify-between mb-6">
      <div>
        <h1 class="h1 mb-2">Mis Tareas</h1>
        <p class="text-muted">Gestiona tus tareas pendientes y en curso</p>
      </div>
      <div class="flex items-center gap-4">
        <button 
          v-if="authStore.isAdmin"
          @click="showCreateModal = true" 
          class="btn btn-primary"
        >
          ➕ Nueva Tarea
        </button>
        <button @click="viewMode = 'kanban'" :class="['view-btn', { active: viewMode === 'kanban' }]">
          📋 Kanban
        </button>
        <button @click="viewMode = 'list'" :class="['view-btn', { active: viewMode === 'list' }]">
          📝 Lista
        </button>
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
      <StatCard
        title="Pendientes"
        :value="taskStore.stats.pending"
        icon="⏳"
        variant="primary"
      />
      <StatCard
        title="En Curso"
        :value="taskStore.stats.in_progress"
        icon="▶️"
        variant="warning"
      />
      <StatCard
        title="Completadas"
        :value="taskStore.stats.completed"
        icon="✅"
        variant="success"
      />
      <StatCard
        title="Vencidas"
        :value="taskStore.stats.overdue"
        icon="⚠️"
        variant="danger"
      />
    </div>

    <!-- Filters -->
    <TaskFilters
      :filters="taskStore.filters"
      @update:filters="handleFilterUpdate"
      @clear="taskStore.clearFilters()"
    />

    <!-- Loading State -->
    <div v-if="taskStore.loading" class="text-center py-12">
      <div class="loader mx-auto mb-4"></div>
      <p class="text-muted">Cargando tareas...</p>
    </div>

    <!-- Kanban View -->
    <div v-else-if="viewMode === 'kanban'" class="kanban-board">
      <div class="kanban-column">
        <div class="column-header">
          <h3 class="column-title">Pendiente</h3>
          <span class="task-count">{{ taskStore.pendingTasks.length }}</span>
        </div>
        <div class="column-content">
          <TaskCard
            v-for="task in taskStore.pendingTasks"
            :key="task.id_tarea"
            :task="task"
            @update-status="handleStatusUpdate"
            @view-details="viewTaskDetails"
            @execute-form="handleExecuteForm"
          />
          <div v-if="taskStore.pendingTasks.length === 0" class="empty-state">
            <p class="text-muted text-sm">No hay tareas pendientes</p>
          </div>
        </div>
      </div>

      <div class="kanban-column">
        <div class="column-header">
          <h3 class="column-title">En Curso</h3>
          <span class="task-count">{{ taskStore.inProgressTasks.length }}</span>
        </div>
        <div class="column-content">
          <TaskCard
            v-for="task in taskStore.inProgressTasks"
            :key="task.id_tarea"
            :task="task"
            @update-status="handleStatusUpdate"
            @view-details="viewTaskDetails"
            @execute-form="handleExecuteForm"
          />
          <div v-if="taskStore.inProgressTasks.length === 0" class="empty-state">
            <p class="text-muted text-sm">No hay tareas en curso</p>
          </div>
        </div>
      </div>

      <div class="kanban-column">
        <div class="column-header">
          <h3 class="column-title">Completadas</h3>
          <span class="task-count">{{ taskStore.completedTasks.length }}</span>
        </div>
        <div class="column-content">
          <TaskCard
            v-for="task in taskStore.completedTasks"
            :key="task.id_tarea"
            :task="task"
            @view-details="viewTaskDetails"
          />
          <div v-if="taskStore.completedTasks.length === 0" class="empty-state">
            <p class="text-muted text-sm">No hay tareas completadas</p>
          </div>
        </div>
      </div>
    </div>

    <!-- List View -->
    <div v-else class="list-view">
      <div class="card">
        <TaskCard
          v-for="task in taskStore.myTasks"
          :key="task.id_tarea"
          :task="task"
          @update-status="handleStatusUpdate"
          @view-details="viewTaskDetails"
          @execute-form="handleExecuteForm"
        />
        <div v-if="taskStore.myTasks.length === 0" class="empty-state py-12">
          <p class="text-muted">No hay tareas para mostrar</p>
        </div>
      </div>
    </div>

    <!-- Task Details Modal (Simple for now) -->
    <div v-if="selectedTask" class="modal-overlay" @click="selectedTask = null">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3 class="h3">Detalles de la Tarea</h3>
          <button @click="selectedTask = null" class="close-btn">✕</button>
        </div>
        <div class="modal-body">
          <div class="detail-row">
            <strong>Descripción:</strong>
            <p>{{ selectedTask.descripcion }}</p>
          </div>
          <div class="detail-row">
            <strong>Tipo:</strong>
            <p>{{ selectedTask.tipo_tarea }}</p>
          </div>
          <div class="detail-row">
            <strong>Estado:</strong>
            <p>{{ selectedTask.estado }}</p>
          </div>
          <div class="detail-row">
            <strong>Prioridad:</strong>
            <p>{{ selectedTask.prioridad }}</p>
          </div>
          <div class="detail-row">
            <strong>Responsable:</strong>
            <p>{{ selectedTask.responsable }}</p>
          </div>
          <div class="detail-row">
            <strong>Fecha de Vencimiento:</strong>
            <p>{{ formatDate(selectedTask.fecha_vencimiento) }}</p>
          </div>
          <div v-if="selectedTask.observaciones" class="detail-row">
            <strong>Observaciones:</strong>
            <p>{{ selectedTask.observaciones }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Create Task Modal -->
    <CreateTaskModal
      v-if="showCreateModal"
      @close="showCreateModal = false"
      @task-created="handleTaskCreated"
    />

    <!-- Smart Form Modal -->
    <SmartFormModal
      v-if="showFormModal"
      :formId="selectedFormId"
      :context="selectedFormContext"
      @close="showFormModal = false"
      @submit-success="handleFormSubmitted"
    />
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useTaskStore } from '../stores/tasks'
import { useAuthStore } from '../stores/auth'
import TaskCard from '../components/tasks/TaskCard.vue'
import TaskFilters from '../components/tasks/TaskFilters.vue'
import StatCard from '../components/ui/StatCard.vue'
import CreateTaskModal from '../components/tasks/CreateTaskModal.vue'
import SmartFormModal from '../components/forms/SmartFormModal.vue'

const taskStore = useTaskStore()
const authStore = useAuthStore()
const viewMode = ref('kanban')
const selectedTask = ref(null)
const showCreateModal = ref(false)
const showFormModal = ref(false)
const selectedFormId = ref('')
const selectedFormContext = ref({})

const handleFilterUpdate = (filters) => {
  taskStore.filters = filters
  taskStore.fetchMyTasks()
}

const handleStatusUpdate = async (task, newStatus) => {
  const success = await taskStore.updateTaskStatus(task.id_tarea, newStatus)
  if (success) {
    // Optionally show success message
    console.log('Task updated successfully')
  }
}

const viewTaskDetails = (task) => {
  selectedTask.value = task
}

const handleTaskCreated = () => {
  // Refresh tasks after creating a new one
  taskStore.fetchMyTasks()
  taskStore.fetchStats()
}

const handleExecuteForm = (task) => {
  selectedFormId.value = task.id_formulario
  selectedFormContext.value = {
    taskId: task.id_tarea,
    employeeId: task.id_empleado_responsable,
    description: task.descripcion
  }
  showFormModal.value = true
}

const handleFormSubmitted = () => {
  showFormModal.value = false
  // Refresh tasks to show updated status (if form submission updates task)
  taskStore.fetchMyTasks()
  taskStore.fetchStats()
}

const formatDate = (dateString) => {
  if (!dateString) return 'Sin fecha'
  const date = new Date(dateString)
  return date.toLocaleDateString('es-CO', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  })
}

onMounted(() => {
  taskStore.fetchMyTasks()
  taskStore.fetchStats()
})
</script>

<style scoped>
.view-btn {
  padding: 0.5rem 1rem;
  border-radius: var(--radius-md);
  border: 1px solid #e2e8f0;
  background: white;
  color: var(--text-muted);
  font-size: 0.875rem;
  cursor: pointer;
  transition: var(--transition);
}

.view-btn:hover {
  border-color: var(--primary);
  color: var(--primary);
}

.view-btn.active {
  background: var(--primary);
  color: white;
  border-color: var(--primary);
}

.kanban-board {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
  min-height: 500px;
}

.kanban-column {
  background: #f8fafc;
  border-radius: var(--radius-lg);
  padding: 1rem;
}

.column-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding-bottom: 0.75rem;
  border-bottom: 2px solid #e2e8f0;
}

.column-title {
  font-size: 1rem;
  font-weight: 600;
  color: var(--text-main);
}

.task-count {
  background: var(--primary);
  color: white;
  font-size: 0.75rem;
  font-weight: 600;
  padding: 0.25rem 0.5rem;
  border-radius: var(--radius-sm);
}

.column-content {
  min-height: 400px;
}

.empty-state {
  text-align: center;
  padding: 2rem 1rem;
}

.loader {
  width: 3rem;
  height: 3rem;
  border: 3px solid #e2e8f0;
  border-top-color: var(--primary);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

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
  max-height: 80vh;
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

.detail-row {
  margin-bottom: 1rem;
}

.detail-row strong {
  display: block;
  font-size: 0.875rem;
  color: var(--text-muted);
  margin-bottom: 0.25rem;
}

.detail-row p {
  font-size: 1rem;
  color: var(--text-main);
}

@media (max-width: 1024px) {
  .kanban-board {
    grid-template-columns: 1fr;
  }
}
</style>
