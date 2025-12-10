<template>
  <div :class="['task-card', `priority-${task.prioridad?.toLowerCase()}`]" @click="$emit('click', task)">
    <div class="task-header">
      <div class="header-left">
        <span class="task-type">{{ task.tipo_tarea }}</span>
        
        <!-- Form Badge -->
        <span v-if="task.requiere_formulario" 
              :class="['form-badge', task.formulario_diligenciado ? 'completed' : 'required']"
              :title="task.formulario_diligenciado ? 'Formulario Completado' : 'Requiere Formulario Obligatorio'">
          {{ task.formulario_diligenciado ? '✓ Formulario Listo' : '📝 Formulario Requerido' }}
        </span>
      </div>
      
      <span :class="['priority-badge', `priority-${task.prioridad?.toLowerCase()}`]">
        {{ task.prioridad }}
      </span>
    </div>
    
    <h4 class="task-title">{{ task.descripcion }}</h4>
    
    <div class="task-meta">
      <div class="meta-item">
        <span class="icon">👤</span>
        <span class="text">{{ task.responsable }}</span>
      </div>
      <div class="meta-item">
        <span class="icon">📅</span>
        <span :class="['text', { 'text-danger': isOverdue }]">
          {{ formatDate(task.fecha_vencimiento) }}
        </span>
      </div>
      <div v-if="task.area" class="meta-item">
        <span class="icon">🏢</span>
        <span class="text">{{ task.area }}</span>
      </div>
    </div>
    
    <div class="task-actions" @click.stop>
      <!-- Execute Form Button -->
      <button
        v-if="task.id_formulario && task.estado !== 'Cerrada' && !task.formulario_diligenciado"
        @click="$emit('execute-form', task)"
        class="action-btn form-btn-pulse"
        title="Diligenciar Formulario Requerido"
      >
        📝 Diligenciar
      </button>

      <!-- View Form Button (if submitted) -->
      <button
        v-if="task.formulario_diligenciado"
        class="action-btn form-completed-btn"
        title="Formulario Completado"
        disabled
      >
        ✅ Formulario OK
      </button>

      <!-- Update Status Button -->
      <button
        v-if="task.estado !== 'Cerrada'"
        @click="$emit('update-status', task, 'En Curso')"
        class="action-btn"
        title="Marcar en curso"
      >
        ▶️
      </button>
      
      <!-- Complete Task Button (Changes behavior if form missing) -->
      <button
        v-if="task.estado !== 'Cerrada'"
        @click="handleCompleteClick(task)"
        class="action-btn"
        :class="{ 'disabled-look': task.requiere_formulario && !task.formulario_diligenciado }"
        title="Completar Tarea"
      >
        ✅
      </button>
      
      <button
        @click="$emit('view-details', task)"
        class="action-btn"
        title="Ver detalles"
      >
        👁️
      </button>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  task: {
    type: Object,
    required: true
  }
})

const isOverdue = computed(() => {
  if (!props.task.fecha_vencimiento || props.task.estado === 'Cerrada') return false
  const today = new Date().toISOString().split('T')[0]
  return props.task.fecha_vencimiento < today
})

const formatDate = (dateString) => {
  if (!dateString) return 'Sin fecha'
  const date = new Date(dateString)
  return date.toLocaleDateString('es-CO', { month: 'short', day: 'numeric' })
}

const emit = defineEmits(['click', 'update-status', 'view-details', 'execute-form'])

const handleCompleteClick = (task) => {
  // If form is required but not submitted, we still emit 'update-status'
  // The parent component (Tasks.vue) handles the interception via modal
  // But we could also emit a specific event if we wanted local feedback
  emit('update-status', task, 'Cerrada')
}
</script>

<style scoped>
.task-card {
  background: white;
  border-radius: var(--radius-lg);
  padding: 1rem;
  margin-bottom: 0.75rem;
  border-left: 4px solid var(--primary);
  box-shadow: var(--shadow-sm);
  cursor: pointer;
  transition: var(--transition);
}

.task-card:hover {
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

.task-card.priority-alta {
  border-left-color: var(--danger);
}

.task-card.priority-media {
  border-left-color: var(--warning);
}

.task-card.priority-baja {
  border-left-color: var(--success);
}

.task-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.task-type {
  font-size: 0.75rem;
  color: var(--text-muted);
  text-transform: uppercase;
  font-weight: 600;
}

.priority-badge {
  font-size: 0.7rem;
  padding: 0.25rem 0.5rem;
  border-radius: var(--radius-sm);
  font-weight: 600;
}

.priority-badge.priority-alta {
  background-color: rgba(239, 68, 68, 0.1);
  color: var(--danger);
}

.priority-badge.priority-media {
  background-color: rgba(245, 158, 11, 0.1);
  color: var(--warning);
}

.priority-badge.priority-baja {
  background-color: rgba(16, 185, 129, 0.1);
  color: var(--success);
}

.task-title {
  font-size: 0.95rem;
  font-weight: 600;
  color: var(--text-main);
  margin-bottom: 0.75rem;
  line-height: 1.4;
}

.task-meta {
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
  margin-bottom: 0.75rem;
}

.meta-item {
  display: flex;
  align-items: center;
  font-size: 0.8rem;
  color: var(--text-muted);
}

.meta-item .icon {
  margin-right: 0.375rem;
  font-size: 0.9rem;
}

.meta-item .text {
  flex: 1;
}

.task-actions {
  display: flex;
  gap: 0.5rem;
  padding-top: 0.75rem;
  border-top: 1px solid rgba(0,0,0,0.05);
}

.action-btn {
  background: none;
  border: none;
  font-size: 1.1rem;
  cursor: pointer;
  padding: 0.25rem;
  opacity: 0.6;
  transition: opacity 0.2s, transform 0.2s;
}

.action-btn:hover {
  opacity: 1;
  transform: scale(1.1);
}

.header-left {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  align-items: flex-start;
}

.form-badge {
  font-size: 0.65rem;
  padding: 0.15rem 0.4rem;
  border-radius: 4px;
  font-weight: 700;
  display: inline-block;
  white-space: nowrap;
}

.form-badge.required {
  background-color: #FEF2F2;
  color: #DC2626;
  border: 1px solid #FECACA;
}

.form-badge.completed {
  background-color: #ECFDF5;
  color: #059669;
  border: 1px solid #A7F3D0;
}

.form-btn-pulse {
  background-color: #EFF6FF !important;
  color: #2563EB !important;
  border-radius: 4px;
  opacity: 1;
  font-weight: 600;
  font-size: 0.8rem;
  padding: 0.25rem 0.5rem;
  animation: pulse-border 2s infinite;
}

.form-completed-btn {
  background-color: #ECFDF5 !important;
  color: #059669 !important;
  font-size: 0.8rem;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  opacity: 1;
  cursor: default;
}

.form-completed-btn:hover {
  transform: none;
}

.disabled-look {
  opacity: 0.3;
  filter: grayscale(100%);
}

@keyframes pulse-border {
  0% { box-shadow: 0 0 0 0 rgba(37, 99, 235, 0.4); }
  70% { box-shadow: 0 0 0 4px rgba(37, 99, 235, 0); }
  100% { box-shadow: 0 0 0 0 rgba(37, 99, 235, 0); }
}
</style>
