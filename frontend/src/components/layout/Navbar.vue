<template>
  <header class="h-16 bg-white border-b border-gray-100 flex items-center justify-between px-8 fixed top-0 right-0 left-64 z-10">
    <!-- Page Title / Breadcrumbs -->
    <div>
      <h2 class="text-xl font-semibold text-gray-800">{{ currentRouteName }}</h2>
    </div>

    <!-- Right Actions -->
    <div class="flex items-center space-x-4">
      <button class="p-2 text-gray-400 hover:text-primary transition-colors relative">
        <span class="text-xl">🔔</span>
        <span class="absolute top-1 right-1 w-2 h-2 bg-danger rounded-full"></span>
      </button>
      
      <div class="h-6 w-px bg-gray-200"></div>
      
      <button @click="handleLogout" class="text-sm font-medium text-muted hover:text-danger transition-colors">
        Cerrar Sesión
      </button>
    </div>
  </header>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '../../stores/auth'

const route = useRoute()
const authStore = useAuthStore()

const currentRouteName = computed(() => {
  // Map route names to display names
  const names = {
    'dashboard': 'Panel de Control',
    'tasks': 'Gestión de Tareas',
    'alerts': 'Centro de Alertas',
    'reports': 'Reportes y Analítica',
    'employees': 'Directorio de Empleados',
    'assistant': 'Asistente Inteligente'
  }
  return names[route.name] || 'SG-SST'
})

const handleLogout = () => {
  authStore.logout()
}
</script>
