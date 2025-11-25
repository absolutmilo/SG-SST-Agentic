<template>
  <div class="container py-8 animate-fade-in">
    <!-- Welcome Section -->
    <div class="mb-8">
      <h1 class="h1 mb-2">¡Bienvenido, {{ userName }}! 👋</h1>
      <p class="text-muted">Aquí está el resumen de tu sistema SG-SST</p>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      <StatCard
        title="Tareas Pendientes"
        :value="stats.pendingTasks"
        icon="✅"
        variant="primary"
        :trend="stats.tasksTrend"
      />
      <StatCard
        title="Alertas Activas"
        :value="stats.activeAlerts"
        icon="🔔"
        variant="warning"
        :trend="stats.alertsTrend"
      />
      <StatCard
        title="Empleados Activos"
        :value="stats.activeEmployees"
        icon="👥"
        variant="success"
      />
      <StatCard
        title="Cumplimiento"
        :value="`${stats.compliance}%`"
        icon="📊"
        variant="success"
        subtitle="Resolución 0312"
      />
    </div>

    <!-- Charts Row -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
      <!-- Accident Indicators Chart -->
      <div class="card">
        <h3 class="h4 mb-4">Indicadores de Siniestralidad</h3>
        <div v-if="loadingIndicators" class="text-center py-8 text-muted">
          Cargando datos...
        </div>
        <div v-else-if="indicatorsData" class="h-64">
          <canvas ref="indicatorsChart"></canvas>
        </div>
        <div v-else class="text-center py-8 text-muted">
          No hay datos disponibles
        </div>
      </div>

      <!-- Tasks by Status -->
      <div class="card">
        <h3 class="h4 mb-4">Tareas por Estado</h3>
        <div class="h-64">
          <canvas ref="tasksChart"></canvas>
        </div>
      </div>
    </div>

    <!-- Recent Alerts -->
    <div class="card">
      <div class="flex items-center justify-between mb-4">
        <h3 class="h4">Alertas Recientes</h3>
        <router-link to="/alerts" class="text-sm text-primary font-medium hover:underline">
          Ver todas →
        </router-link>
      </div>
      <div v-if="loadingAlerts" class="text-center py-4 text-muted">
        Cargando alertas...
      </div>
      <div v-else-if="recentAlerts.length > 0" class="space-y-3">
        <div
          v-for="alert in recentAlerts"
          :key="alert.id_alerta"
          class="flex items-start p-3 rounded-lg bg-gray-50 hover:bg-gray-100 transition-colors"
        >
          <span class="text-xl mr-3">{{ getAlertIcon(alert.prioridad) }}</span>
          <div class="flex-1">
            <p class="font-medium text-sm">{{ alert.descripcion }}</p>
            <p class="text-xs text-muted mt-1">{{ formatDate(alert.fecha_generacion) }}</p>
          </div>
          <span :class="getPriorityBadge(alert.prioridad)" class="text-xs px-2 py-1 rounded-full">
            {{ alert.prioridad }}
          </span>
        </div>
      </div>
      <div v-else class="text-center py-8 text-muted">
        No hay alertas recientes
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useAuthStore } from '../stores/auth'
import api from '../services/api'
import StatCard from '../components/ui/StatCard.vue'
import { Chart, registerables } from 'chart.js'

Chart.register(...registerables)

const authStore = useAuthStore()
const userName = computed(() => authStore.user?.NombreCompleto || 'Usuario')

// Stats
const stats = ref({
  pendingTasks: 0,
  activeAlerts: 0,
  activeEmployees: 0,
  compliance: 95,
  tasksTrend: '+12%',
  alertsTrend: '-8%'
})

// Charts
const indicatorsChart = ref(null)
const tasksChart = ref(null)
const indicatorsData = ref(null)
const loadingIndicators = ref(true)

// Alerts
const recentAlerts = ref([])
const loadingAlerts = ref(true)

// Fetch accident indicators
const fetchIndicators = async () => {
  try {
    const currentYear = new Date().getFullYear()
    const response = await api.get(`/procedures/accident-indicators/${currentYear}`)
    indicatorsData.value = response.data
    loadingIndicators.value = false
    
    // Render chart after data is loaded
    setTimeout(renderIndicatorsChart, 100)
  } catch (error) {
    console.error('Error fetching indicators:', error)
    loadingIndicators.value = false
  }
}

// Fetch recent alerts
const fetchAlerts = async () => {
  try {
    const response = await api.get('/procedures/pending-alerts')
    recentAlerts.value = response.data.alerts.slice(0, 5) // Show only 5
    stats.value.activeAlerts = response.data.total
    loadingAlerts.value = false
  } catch (error) {
    console.error('Error fetching alerts:', error)
    loadingAlerts.value = false
  }
}

// Render Indicators Chart
const renderIndicatorsChart = () => {
  if (!indicatorsChart.value || !indicatorsData.value) return
  
  new Chart(indicatorsChart.value, {
    type: 'bar',
    data: {
      labels: ['Índice Frecuencia', 'Índice Severidad', 'ILI'],
      datasets: [{
        label: 'Indicadores',
        data: [
          indicatorsData.value.indice_frecuencia || 0,
          indicatorsData.value.indice_severidad || 0,
          indicatorsData.value.indice_lesion_incapacitante || 0
        ],
        backgroundColor: [
          'rgba(37, 99, 235, 0.8)',
          'rgba(245, 158, 11, 0.8)',
          'rgba(239, 68, 68, 0.8)'
        ],
        borderRadius: 8
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false }
      },
      scales: {
        y: { beginAtZero: true }
      }
    }
  })
}

// Render Tasks Chart
const renderTasksChart = () => {
  if (!tasksChart.value) return
  
  new Chart(tasksChart.value, {
    type: 'doughnut',
    data: {
      labels: ['Pendientes', 'En Curso', 'Completadas', 'Vencidas'],
      datasets: [{
        data: [25, 15, 45, 5],
        backgroundColor: [
          'rgba(37, 99, 235, 0.8)',
          'rgba(245, 158, 11, 0.8)',
          'rgba(16, 185, 129, 0.8)',
          'rgba(239, 68, 68, 0.8)'
        ],
        borderWidth: 0
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'bottom'
        }
      }
    }
  })
}

// Utility functions
const getAlertIcon = (priority) => {
  const icons = {
    'Alta': '🔴',
    'Media': '🟡',
    'Baja': '🟢'
  }
  return icons[priority] || '⚪'
}

const getPriorityBadge = (priority) => {
  const classes = {
    'Alta': 'bg-red-100 text-red-700',
    'Media': 'bg-yellow-100 text-yellow-700',
    'Baja': 'bg-green-100 text-green-700'
  }
  return classes[priority] || 'bg-gray-100 text-gray-700'
}

const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('es-CO', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

onMounted(() => {
  fetchIndicators()
  fetchAlerts()
  renderTasksChart()
})
</script>

<style scoped>
.bg-red-100 { background-color: rgba(239, 68, 68, 0.1); }
.text-red-700 { color: rgb(185, 28, 28); }
.bg-yellow-100 { background-color: rgba(245, 158, 11, 0.1); }
.text-yellow-700 { color: rgb(161, 98, 7); }
.bg-green-100 { background-color: rgba(16, 185, 129, 0.1); }
.text-green-700 { color: rgb(4, 120, 87); }
.bg-gray-100 { background-color: rgba(0, 0, 0, 0.05); }
.text-gray-700 { color: rgb(55, 65, 81); }
</style>
