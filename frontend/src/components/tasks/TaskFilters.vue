<template>
  <div class="task-filters">
    <div class="filter-group">
      <label class="filter-label">Estado</label>
      <select v-model="localFilters.status" @change="applyFilters" class="filter-select">
        <option :value="null">Todos</option>
        <option value="Pendiente">Pendiente</option>
        <option value="En Curso">En Curso</option>
        <option value="Cerrada">Cerrada</option>
      </select>
    </div>

    <div class="filter-group">
      <label class="filter-label">Prioridad</label>
      <select v-model="localFilters.priority" @change="applyFilters" class="filter-select">
        <option :value="null">Todas</option>
        <option value="Alta">Alta</option>
        <option value="Media">Media</option>
        <option value="Baja">Baja</option>
      </select>
    </div>

    <button @click="clearFilters" class="btn btn-secondary btn-sm">
      Limpiar Filtros
    </button>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  filters: {
    type: Object,
    default: () => ({})
  }
})

const emit = defineEmits(['update:filters', 'clear'])

const localFilters = ref({
  status: props.filters.status || null,
  priority: props.filters.priority || null
})

watch(() => props.filters, (newFilters) => {
  localFilters.value = { ...newFilters }
}, { deep: true })

const applyFilters = () => {
  emit('update:filters', localFilters.value)
}

const clearFilters = () => {
  localFilters.value = {
    status: null,
    priority: null
  }
  emit('clear')
}
</script>

<style scoped>
.task-filters {
  display: flex;
  gap: 1rem;
  align-items: flex-end;
  padding: 1rem;
  background: white;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  margin-bottom: 1.5rem;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
}

.filter-label {
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-main);
}

.filter-select {
  padding: 0.5rem 0.75rem;
  border-radius: var(--radius-md);
  border: 1px solid #e2e8f0;
  background-color: white;
  color: var(--text-main);
  font-size: 0.875rem;
  min-width: 150px;
  transition: var(--transition);
}

.filter-select:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.btn-sm {
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
}
</style>
