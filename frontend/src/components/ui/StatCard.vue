<template>
  <div :class="['card', 'stat-card', colorClass]">
    <div class="flex items-center justify-between">
      <div>
        <p class="text-sm text-muted mb-1">{{ title }}</p>
        <h3 class="h2 font-bold">{{ value }}</h3>
        <p v-if="subtitle" class="text-xs text-muted mt-1">{{ subtitle }}</p>
      </div>
      <div :class="['stat-icon', iconBgClass]">
        <span class="text-2xl">{{ icon }}</span>
      </div>
    </div>
    <div v-if="trend" class="mt-3 flex items-center text-sm">
      <span :class="trendClass">{{ trend }}</span>
      <span class="text-muted ml-2">vs mes anterior</span>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  title: String,
  value: [String, Number],
  subtitle: String,
  icon: String,
  trend: String,
  variant: {
    type: String,
    default: 'primary',
    validator: (v) => ['primary', 'success', 'warning', 'danger'].includes(v)
  }
})

const colorClass = computed(() => `stat-card-${props.variant}`)
const iconBgClass = computed(() => `stat-icon-${props.variant}`)
const trendClass = computed(() => {
  if (!props.trend) return ''
  return props.trend.startsWith('+') ? 'text-success font-medium' : 'text-danger font-medium'
})
</script>

<style scoped>
.stat-card {
  transition: transform 0.2s, box-shadow 0.2s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

.stat-icon {
  width: 3.5rem;
  height: 3.5rem;
  border-radius: var(--radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-icon-primary {
  background-color: rgba(37, 99, 235, 0.1);
  color: var(--primary);
}

.stat-icon-success {
  background-color: rgba(16, 185, 129, 0.1);
  color: var(--success);
}

.stat-icon-warning {
  background-color: rgba(245, 158, 11, 0.1);
  color: var(--warning);
}

.stat-icon-danger {
  background-color: rgba(239, 68, 68, 0.1);
  color: var(--danger);
}
</style>
