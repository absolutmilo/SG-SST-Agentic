<template>
  <div class="modal-overlay" @click="$emit('close')">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h3 class="text-lg font-bold text-gray-900">Subir Documento</h3>
        <button @click="$emit('close')" class="text-gray-400 hover:text-gray-600">✕</button>
      </div>

      <form @submit.prevent="handleUpload" class="modal-body">
        <!-- Archivo Input -->
        <div class="mb-4">
          <label class="block text-sm font-medium text-gray-700 mb-1">Archivo</label>
          <div 
            class="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center hover:border-blue-500 transition-colors cursor-pointer"
            @click="$refs.fileInput.click()"
            @dragover.prevent
            @drop.prevent="handleDrop"
          >
            <input 
              type="file" 
              ref="fileInput" 
              class="hidden" 
              @change="handleFileSelect"
              accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.png"
            >
            <div v-if="selectedFile" class="text-sm">
              <span class="font-semibold text-blue-600">{{ selectedFile.name }}</span>
              <p class="text-gray-500 text-xs mt-1">{{ formatSize(selectedFile.size) }}</p>
            </div>
            <div v-else>
              <span class="text-4xl block mb-2">📄</span>
              <p class="text-gray-600">Arrastra un archivo aquí o haz clic para seleccionar</p>
              <p class="text-xs text-gray-400 mt-1">PDF, Word, Excel, Imagenes (Max 10MB)</p>
            </div>
          </div>
        </div>

        <!-- Metadatos -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Nombre del Documento *</label>
            <input 
              v-model="form.nombre" 
              type="text" 
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
              placeholder="Ej: Política de SST"
            >
          </div>

          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Tipo *</label>
            <select 
              v-model="form.tipo" 
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="Politica">Política</option>
              <option value="Acta">Acta</option>
              <option value="Procedimiento">Procedimiento</option>
              <option value="Registro">Registro</option>
              <option value="Matriz">Matriz</option>
              <option value="Externo">Externo</option>
              <option value="Otro">Otro</option>
            </select>
          </div>

          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Categoría</label>
            <select 
              v-model="form.categoria" 
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="">Seleccionar...</option>
              <option value="Legal">Legal</option>
              <option value="Tecnico">Técnico</option>
              <option value="Recursos Humanos">Recursos Humanos</option>
              <option value="Salud">Salud</option>
              <option value="Seguridad Industrial">Seguridad Industrial</option>
              <option value="Gestion">Gestión</option>
            </select>
          </div>

          <div class="mb-4">
             <label class="block text-sm font-medium text-gray-700 mb-1">Área</label>
             <input 
              v-model="form.area" 
              type="text" 
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
              placeholder="Ej: Operaciones"
            >
          </div>
        </div>

        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700 mb-1">Descripción</label>
          <textarea 
            v-model="form.descripcion" 
            rows="2"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
            placeholder="Breve descripción del contenido..."
          ></textarea>
        </div>

        <!-- Acciones -->
        <div class="flex justify-end gap-3 pt-4 border-t border-gray-100">
          <button 
            type="button" 
            @click="$emit('close')"
            class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
          >
            Cancelar
          </button>
          <button 
            type="submit" 
            :disabled="!selectedFile || uploading"
            class="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700 disabled:opacity-50 flex items-center gap-2"
          >
            <span v-if="uploading" class="loader-sm"></span>
            {{ uploading ? 'Subiendo...' : 'Subir Documento' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import documentService from '../../services/documentService'

const emit = defineEmits(['close', 'uploaded'])

const fileInput = ref(null)
const selectedFile = ref(null)
const uploading = ref(false)

const form = ref({
  nombre: '',
  tipo: 'Procedimiento',
  categoria: '',
  area: '',
  descripcion: '',
  version: 1
})

const handleFileSelect = (event) => {
  const file = event.target.files[0]
  if (file) processFile(file)
}

const handleDrop = (event) => {
  const file = event.dataTransfer.files[0]
  if (file) processFile(file)
}

const processFile = (file) => {
  if (file.size > 10 * 1024 * 1024) {
    alert('El archivo supera el límite de 10MB')
    return
  }
  selectedFile.value = file
  // Auto-fill name if empty
  if (!form.value.nombre) {
    form.value.nombre = file.name.split('.').slice(0, -1).join('.')
  }
}

const formatSize = (bytes) => {
  if (bytes === 0) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

const handleUpload = async () => {
  if (!selectedFile.value) return

  uploading.value = true
  try {
    const formData = new FormData()
    formData.append('file', selectedFile.value)
    formData.append('nombre', form.value.nombre)
    formData.append('tipo', form.value.tipo)
    formData.append('categoria', form.value.categoria || '')
    formData.append('area', form.value.area || '')
    formData.append('descripcion', form.value.descripcion || '')
    formData.append('version', form.value.version)

    await documentService.uploadDocument(formData)
    
    emit('uploaded')
    emit('close')
  } catch (error) {
    console.error('Upload failed:', error)
    alert('Error al subir documento: ' + (error.response?.data?.detail || error.message))
  } finally {
    uploading.value = false
  }
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
  z-index: 50;
}

.modal-content {
  background: white;
  border-radius: 0.75rem;
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.25rem;
  border-bottom: 1px solid #e5e7eb;
}

.modal-body {
  padding: 1.5rem;
}

.loader-sm {
  width: 14px;
  height: 14px;
  border: 2px solid white;
  border-bottom-color: transparent;
  border-radius: 50%;
  display: inline-block;
  animation: rotation 1s linear infinite;
}

@keyframes rotation {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
