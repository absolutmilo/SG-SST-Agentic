<template>
  <div :class="['task-card', `priority-${task.prioridad?.toLowerCase()}`]" @click="$emit('click', task)">
    <div class="task-header">
      <span class="task-type">{{ task.tipo_tarea }}</span>
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
      <button
        v-if="task.id_formulario && task.estado !== 'Cerrada'"
        @click="$emit('execute-form', task)"
        class="action-btn"
        title="Ejecutar Formulario"
      >
        📝
      </button>
      <button
        v-if="task.estado !== 'Cerrada'"
        @click="$emit('update-status', task, 'En Curso')"
        class="action-btn"
        title="Marcar en curso"
      >
        ▶️
      </button>
      <button
        v-if="task.estado !== 'Cerrada'"
        @click="$emit('update-status', task, 'Cerrada')"
        class="action-btn"
        title="Completar"
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

defineEmits(['click', 'update-status', 'view-details', 'execute-form'])

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
</style>
