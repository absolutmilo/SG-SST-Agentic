<template>
  <div class="form-field" :class="{ 'has-error': error }">
    <label v-if="field.label" class="field-label">
      {{ field.label }}
      <span v-if="field.required" class="required">*</span>
    </label>
    
    <div class="signature-pad-container">
      <canvas
        ref="canvas"
        @mousedown="startDrawing"
        @mousemove="draw"
        @mouseup="stopDrawing"
        @mouseleave="stopDrawing"
        @touchstart="startDrawing"
        @touchmove="draw"
        @touchend="stopDrawing"
        class="signature-canvas"
      ></canvas>
      
      <button
        @click="clearSignature"
        type="button"
        class="clear-signature-btn"
      >
        🗑️ Limpiar Firma
      </button>
    </div>
    
    <p v-if="field.help_text" class="help-text">{{ field.help_text }}</p>
    <p v-if="error" class="error-text">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const props = defineProps({
  field: {
    type: Object,
    required: true
  },
  modelValue: {
    type: String,
    default: ''
  },
  error: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update', 'blur'])

const canvas = ref(null)
let ctx = null
let isDrawing = false
let lastX = 0
let lastY = 0

onMounted(() => {
  if (canvas.value) {
    ctx = canvas.value.getContext('2d')
    canvas.value.width = canvas.value.offsetWidth
    canvas.value.height = 150
    
    // Set drawing style
    ctx.strokeStyle = '#000'
    ctx.lineWidth = 2
    ctx.lineCap = 'round'
    ctx.lineJoin = 'round'
  }
})

const getCoordinates = (e) => {
  const rect = canvas.value.getBoundingClientRect()
  const clientX = e.touches ? e.touches[0].clientX : e.clientX
  const clientY = e.touches ? e.touches[0].clientY : e.clientY
  
  return {
    x: clientX - rect.left,
    y: clientY - rect.top
  }
}

const startDrawing = (e) => {
  e.preventDefault()
  isDrawing = true
  const coords = getCoordinates(e)
  lastX = coords.x
  lastY = coords.y
}

const draw = (e) => {
  if (!isDrawing) return
  e.preventDefault()
  
  const coords = getCoordinates(e)
  
  ctx.beginPath()
  ctx.moveTo(lastX, lastY)
  ctx.lineTo(coords.x, coords.y)
  ctx.stroke()
  
  lastX = coords.x
  lastY = coords.y
  
  // Emit signature data as base64
  const signatureData = canvas.value.toDataURL()
  emit('update', signatureData)
}

const stopDrawing = () => {
  isDrawing = false
}

const clearSignature = () => {
  ctx.clearRect(0, 0, canvas.value.width, canvas.value.height)
  emit('update', '')
}
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

.signature-pad-container {
  border: 1px solid #e2e8f0;
  border-radius: var(--radius-md);
  padding: 1rem;
  background: white;
}

.signature-canvas {
  width: 100%;
  height: 150px;
  border: 1px dashed #cbd5e1;
  border-radius: var(--radius-md);
  cursor: crosshair;
  background: #fafafa;
}

.clear-signature-btn {
  margin-top: 0.75rem;
  padding: 0.5rem 1rem;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: var(--radius-md);
  font-size: 0.875rem;
  cursor: pointer;
  transition: var(--transition);
}

.clear-signature-btn:hover {
  background: #f1f5f9;
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
