<template>
  <div v-if="safety" :class="['safety-indicator', `safety-${safety.status}`]">
    <span class="safety-icon">{{ safety.icon }}</span>
    <span class="safety-message">{{ safety.message }}</span>
  </div>
</template>

<script setup>
import { computed, defineProps } from 'vue';
import { getSafetyStatus } from '../utils/FormValidationRules';

const props = defineProps({
  fieldId: {
    type: String,
    required: true
  },
  value: {
    type: [String, Number],
    default: null
  }
});

const safety = computed(() => {
  return getSafetyStatus(props.fieldId, props.value);
});
</script>

<style scoped>
.safety-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  border-radius: 6px;
  font-size: 0.875rem;
  margin-top: 4px;
  animation: fadeIn 0.3s ease-out;
}

.safety-icon {
  font-size: 1.25rem;
}

.safety-message {
  font-weight: 500;
}

.safety-safe {
  background-color: #d1fae5;
  color: #065f46;
  border: 1px solid #10b981;
}

.safety-warning {
  background-color: #fef3c7;
  color: #92400e;
  border: 1px solid #f59e0b;
}

.safety-danger {
  background-color: #fee2e2;
  color: #991b1b;
  border: 1px solid #dc2626;
  font-weight: 600;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-4px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
