<template>
  <div class="p-8 max-w-7xl mx-auto">
    <!-- Header Section -->
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
      <div>
        <h1 class="text-3xl font-extrabold text-gray-900 tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-blue-700 to-indigo-600">
          Gestión Documental
        </h1>
        <p class="mt-1 text-gray-500 font-medium">Repositorio centralizado del Sistema de Gestión SST</p>
      </div>
      <button 
        @click="showUploadModal = true"
        class="group relative inline-flex items-center justify-center px-6 py-3 text-base font-medium text-white transition-all duration-200 bg-blue-600 border border-transparent rounded-lg shadow-md hover:bg-blue-700 hover:shadow-lg focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
      >
        <span class="mr-2 text-xl leading-none">+</span>
        Subir Documento
      </button>
    </div>

    <!-- Filters & Search Bar -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5 mb-8 flex flex-col md:flex-row gap-4 items-center transition-all hover:shadow-md">
      <div class="relative flex-grow w-full md:w-auto">
        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
          <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
          </svg>
        </div>
        <input 
          v-model="filters.search" 
          @input="handleSearch"
          type="text" 
          placeholder="Buscar documentos..." 
          class="block w-full pl-10 pr-3 py-2.5 border border-gray-300 rounded-lg leading-5 bg-gray-50 placeholder-gray-500 focus:outline-none focus:bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-150 ease-in-out sm:text-sm"
        >
      </div>
      
      <div class="flex gap-4 w-full md:w-auto">
        <select 
          v-model="filters.type" 
          @change="loadDocuments"
          class="block w-full pl-3 pr-10 py-2.5 text-base border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-lg bg-gray-50 hover:bg-white transition-colors cursor-pointer"
        >
          <option value="">Tipo: Todos</option>
          <option value="Politica">Política</option>
          <option value="Acta">Acta</option>
          <option value="Procedimiento">Procedimiento</option>
          <option value="Registro">Registro</option>
          <option value="Matriz">Matriz</option>
          <option value="Externo">Externo</option>
        </select>

        <select 
          v-model="filters.category" 
          @change="loadDocuments"
          class="block w-full pl-3 pr-10 py-2.5 text-base border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-lg bg-gray-50 hover:bg-white transition-colors cursor-pointer"
        >
          <option value="">Categoría: Todas</option>
          <option value="Legal">Legal</option>
          <option value="Tecnico">Técnico</option>
          <option value="Recursos Humanos">RRHH</option>
          <option value="Salud">Salud</option>
          <option value="Seguridad Industrial">Seguridad</option>
        </select>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="flex flex-col justify-center items-center py-20">
      <div class="relative w-16 h-16">
        <div class="absolute top-0 left-0 w-full h-full border-4 border-blue-200 rounded-full opacity-25"></div>
        <div class="absolute top-0 left-0 w-full h-full border-4 border-blue-600 rounded-full border-t-transparent animate-spin"></div>
      </div>
      <p class="mt-4 text-gray-500 font-medium animate-pulse">Cargando repositorio...</p>
    </div>

    <!-- Empty State -->
    <div v-else-if="documents.length === 0" class="flex flex-col items-center justify-center py-24 bg-white rounded-2xl border-2 border-dashed border-gray-200 text-center hover:border-blue-300 transition-colors">
      <div class="p-4 bg-blue-50 rounded-full mb-4">
        <svg class="h-12 w-12 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 13h6m-3-3v6m5 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
      </div>
      <h3 class="mt-2 text-lg font-bold text-gray-900">No hay documentos aún</h3>
      <p class="mt-1 text-sm text-gray-500 max-w-sm">Comienza subiendo políticas, matrices o registros para popular el sistema.</p>
      <button 
        @click="showUploadModal = true"
        class="mt-6 px-4 py-2 text-sm font-medium text-blue-700 bg-blue-100 rounded-md hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
      >
        Subir primer documento
      </button>
    </div>

    <!-- Document Grid (Cards) -->
    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
      <div 
        v-for="doc in documents" 
        :key="doc.id_documento" 
        class="group bg-white rounded-xl shadow-sm hover:shadow-xl transition-all duration-300 border border-gray-100 flex flex-col overflow-hidden transform hover:-translate-y-1"
      >
        <!-- Card Top Gradient -->
        <div class="h-2 w-full bg-gradient-to-r from-blue-400 to-indigo-500"></div>
        
        <div class="p-5 flex-grow flex flex-col">
          <!-- Icon & Type Header -->
          <div class="flex justify-between items-start mb-4">
            <div class="p-3 bg-gray-50 rounded-lg group-hover:bg-blue-50 transition-colors">
              <span class="text-3xl filter drop-shadow-sm">{{ getFileIcon(doc.mime_type) }}</span>
            </div>
            <span :class="getStatusClass(doc.Estado)" class="px-2.5 py-0.5 rounded-full text-xs font-bold uppercase tracking-wide">
              {{ doc.Estado }}
            </span>
          </div>

          <!-- Content -->
          <h3 class="text-lg font-bold text-gray-900 mb-1 line-clamp-2 leading-tight group-hover:text-blue-700 transition-colors" :title="doc.Nombre">
            {{ doc.Nombre }}
          </h3>
          <p class="text-xs text-blue-600 font-medium mb-3 uppercase tracking-wider">
            {{ doc.Tipo }} • {{ doc.CategoriaSGSST || 'General' }}
          </p>
          <p class="text-sm text-gray-500 line-clamp-3 mb-4 flex-grow">
            {{ doc.descripcion || 'Sin descripción disponible para este documento.' }}
          </p>

          <!-- Footer Info -->
          <div class="pt-4 border-t border-gray-50 flex items-center justify-between text-xs text-gray-400 mt-auto">
            <div class="flex items-center">
              <span class="font-medium mr-2">v{{ doc.version }}</span>
              <span>{{ formatDate(doc.FechaCreacion) }}</span>
            </div>
            <span>{{ formatBytes(doc.tamano_bytes) }}</span>
          </div>
        </div>

        <!-- Actions Overlay (Always visible on mobile, hover on desktop) -->
        <div class="bg-gray-50 px-5 py-3 border-t border-gray-100 flex justify-between items-center group-hover:bg-blue-50 transition-colors">
          <div class="text-xs text-gray-500 font-medium">
             {{ doc.Area || 'Sede Principal' }}
          </div>
          <div class="flex gap-2">
            <button 
              @click="downloadDocument(doc)" 
              class="p-2 text-gray-500 hover:text-blue-600 hover:bg-blue-100 rounded-full transition-colors focus:ring-2 focus:ring-blue-500 focus:outline-none"
              title="Descargar"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
              </svg>
            </button>
            <button 
              @click="deleteDocument(doc)"
              class="p-2 text-gray-400 hover:text-red-600 hover:bg-red-100 rounded-full transition-colors focus:ring-2 focus:ring-red-500 focus:outline-none"
              title="Eliminar"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Upload Modal -->
    <DocumentUploadModal 
      v-if="showUploadModal" 
      @close="showUploadModal = false"
      @uploaded="handleUploadSuccess"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import documentService from '../services/documentService'
import DocumentUploadModal from '../components/documents/DocumentUploadModal.vue'

// Local debounce implementation to avoid dependency
const debounce = (fn, delay) => {
  let timeoutId
  return (...args) => {
    clearTimeout(timeoutId)
    timeoutId = setTimeout(() => fn(...args), delay)
  }
}

const documents = ref([])
const loading = ref(true)
const showUploadModal = ref(false)

const filters = ref({
  search: '',
  type: '',
  category: ''
})

const loadDocuments = async () => {
  loading.value = true
  try {
    documents.value = await documentService.getDocuments(filters.value)
  } catch (error) {
    console.error('Failed to load documents', error)
  } finally {
    loading.value = false
  }
}

const handleSearch = debounce(() => {
  loadDocuments()
}, 400)

const handleUploadSuccess = () => {
  loadDocuments()
}

const downloadDocument = async (doc) => {
  try {
    await documentService.downloadDocument(doc.id_documento, doc.Nombre)
  } catch (error) {
    alert('Error al descargar archivo')
  }
}

const deleteDocument = async (doc) => {
  if (!confirm(`¿Estás seguro de eliminar el documento "${doc.Nombre}"? Esta acción no se puede deshacer.`)) return
  
  try {
    await documentService.deleteDocument(doc.id_documento)
    loadDocuments()
  } catch (error) {
    alert('Error al eliminar documento')
  }
}

// Helpers
const formatDate = (dateString) => {
  if (!dateString) return ''
  return new Date(dateString).toLocaleDateString(undefined, {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const formatBytes = (bytes, decimals = 1) => {
  if (!bytes) return '0 B'
  const k = 1024
  const dm = decimals < 0 ? 0 : decimals
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]
}

const getStatusClass = (status) => {
  const map = {
    'Vigente': 'bg-green-100 text-green-700 border border-green-200',
    'Obsoleto': 'bg-red-50 text-red-600 border border-red-100',
    'En Revision': 'bg-amber-100 text-amber-700 border border-amber-200',
    'Borrador': 'bg-gray-100 text-gray-600 border border-gray-200'
  }
  return map[status] || 'bg-gray-50 text-gray-500'
}

const getFileIcon = (mimeType) => {
  if (!mimeType) return '📄'
  const type = mimeType.toLowerCase()
  if (type.includes('pdf')) return '📕'
  if (type.includes('word') || type.includes('officedocument.word') || type.includes('msword')) return '📘'
  if (type.includes('excel') || type.includes('spreadsheet') || type.includes('sheet')) return '📗'
  if (type.includes('powerpoint') || type.includes('presentation')) return '📙'
  if (type.includes('image')) return '🖼️'
  if (type.includes('zip') || type.includes('compressed')) return '📦'
  return '📄'
}

onMounted(() => {
  loadDocuments()
})
</script>

<style scoped>
/* Custom Scrollbar for better UX */
::-webkit-scrollbar {
  width: 8px;
}
::-webkit-scrollbar-track {
  background: #f1f1f1; 
}
::-webkit-scrollbar-thumb {
  background: #c1c1c1; 
  border-radius: 4px;
}
::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8; 
}

/* Enhancements for hover effects */
.hover-trigger .hover-target {
    display: none;
}
.hover-trigger:hover .hover-target {
    display: block;
}
</style>
