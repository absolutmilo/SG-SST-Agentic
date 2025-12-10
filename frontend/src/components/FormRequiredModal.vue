<template>
  <Teleport to="body">
    <Transition name="modal">
      <div v-if="isOpen" class="modal-overlay" @click="handleClose">
        <div class="modal-content" @click.stop>
          <div class="modal-header">
            <div class="modal-icon error">
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none">
                <path d="M12 9v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" 
                      stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
            </div>
            <h2>Formulario Requerido</h2>
          </div>
          
          <div class="modal-body">
            <p>
              No se puede cerrar esta tarea sin completar el formulario requerido.
            </p>
            <p class="modal-subtitle">
              Por favor, complete el formulario antes de cerrar la tarea para garantizar
              la integridad de los datos y el cumplimiento normativo.
            </p>
            
            <div v-if="formId" class="form-info">
              <strong>Formulario:</strong> {{ formatFormName(formId) }}
            </div>
          </div>
          
          <div class="modal-footer">
            <button class="btn btn-secondary" @click="handleClose">
              Cancelar
            </button>
            <button class="btn btn-primary" @click="handleNavigate">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" 
                      stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Ir al Formulario
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue';

const props = defineProps({
  isOpen: {
    type: Boolean,
    required: true
  },
  formId: {
    type: String,
    default: null
  },
  taskId: {
    type: Number,
    default: null
  }
});

const emit = defineEmits(['close', 'navigate']);

const handleClose = () => {
  emit('close');
};

const handleNavigate = () => {
  emit('navigate', { formId: props.formId, taskId: props.taskId });
};

const formatFormName = (formId) => {
  if (!formId) return '';
  return formId.replace('form_', '').replace(/_/g, ' ');
};
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 12px;
  max-width: 500px;
  width: 90%;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

.modal-header {
  padding: 24px;
  text-align: center;
  border-bottom: 1px solid #e5e7eb;
}

.modal-icon {
  width: 64px;
  height: 64px;
  margin: 0 auto 16px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-icon.error {
  background-color: #fee2e2;
  color: #dc2626;
}

.modal-header h2 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
  color: #111827;
}

.modal-body {
  padding: 24px;
}

.modal-body p {
  margin: 0 0 12px;
  color: #374151;
  line-height: 1.5;
}

.modal-subtitle {
  font-size: 0.875rem;
  color: #6b7280;
}

.form-info {
  margin-top: 16px;
  padding: 12px;
  background-color: #f3f4f6;
  border-radius: 6px;
  font-size: 0.875rem;
  text-transform: capitalize;
}

.modal-footer {
  padding: 16px 24px;
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  border-top: 1px solid #e5e7eb;
}

.btn {
  padding: 10px 20px;
  border-radius: 6px;
  font-weight: 500;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s;
}

.btn-secondary {
  background-color: #f3f4f6;
  color: #374151;
}

.btn-secondary:hover {
  background-color: #e5e7eb;
}

.btn-primary {
  background-color: #3b82f6;
  color: white;
}

.btn-primary:hover {
  background-color: #2563eb;
}

/* Transition animations */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-active .modal-content,
.modal-leave-active .modal-content {
  transition: transform 0.3s ease;
}

.modal-enter-from .modal-content,
.modal-leave-to .modal-content {
  transform: translateY(20px);
}
</style>
