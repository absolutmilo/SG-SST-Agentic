<template>
  <div class="modal-overlay" @click="$emit('close')">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h3 class="h3">Ejecutar Formulario</h3>
        <button @click="$emit('close')" class="close-btn">✕</button>
      </div>
      <div class="modal-body">
        <SmartFormRenderer
          :formId="formId"
          :context="context"
          @submit-success="handleSubmitSuccess"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import SmartFormRenderer from './SmartFormRenderer.vue'

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

const emit = defineEmits(['close', 'submit-success'])

const handleSubmitSuccess = (data) => {
  emit('submit-success', data)
  // Optional: close modal after success or let the renderer handle redirect/feedback
  // For now, we emit success so parent can refresh tasks
}
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
  width: 95%;
  max-width: 1000px;
  max-height: 90vh;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #e2e8f0;
  background: white;
  position: sticky;
  top: 0;
  z-index: 10;
}

.modal-body {
  padding: 0;
  flex: 1;
  overflow-y: auto;
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
</style>
