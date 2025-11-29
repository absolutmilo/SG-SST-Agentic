<template>
  <aside class="w-64 bg-sidebar text-white flex flex-col h-screen fixed left-0 top-0 z-20 transition-all duration-300">
    <!-- Logo -->
    <div class="h-16 flex items-center px-6 border-b border-gray-800">
      <div class="w-8 h-8 rounded-lg bg-primary flex items-center justify-center mr-3">
        <span class="font-bold text-white">S</span>
      </div>
      <span class="font-bold text-lg tracking-wide">SG-SST Agent</span>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 overflow-y-auto py-6 px-3 space-y-1">
      <router-link 
        v-for="item in navItems" 
        :key="item.path" 
        :to="item.path"
        class="flex items-center px-3 py-2.5 rounded-lg text-gray-400 hover:text-white hover:bg-white/5 transition-colors group"
        active-class="bg-primary text-white shadow-lg shadow-primary/20"
      >
        <span class="mr-3 text-xl group-hover:scale-110 transition-transform duration-200">{{ item.icon }}</span>
        <span class="font-medium">{{ item.name }}</span>
      </router-link>
    </nav>

    <!-- User Profile (Bottom) -->
    <div class="p-4 border-t border-gray-800">
      <div class="flex items-center">
        <div class="w-10 h-10 rounded-full bg-gray-700 flex items-center justify-center text-sm font-bold">
          {{ userInitials }}
        </div>
        <div class="ml-3">
          <p class="text-sm font-medium text-white">{{ userName }}</p>
          <p class="text-xs text-gray-500">{{ userRole }}</p>
        </div>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { computed } from 'vue'
import { useAuthStore } from '../../stores/auth'

const authStore = useAuthStore()

const navItems = [
  { name: 'Dashboard', path: '/', icon: '📊' },
  { name: 'Tareas', path: '/tasks', icon: '✅' },
  { name: 'Formularios', path: '/forms', icon: '📝' },
  { name: 'Alertas', path: '/alerts', icon: '🔔' },
  { name: 'Reportes', path: '/reports', icon: '📈' },
  { name: 'Empleados', path: '/employees', icon: '👥' },
  { name: 'Asistente IA', path: '/assistant', icon: '🤖' },
]

const userName = computed(() => authStore.user?.NombreCompleto || 'Usuario')
const userRole = computed(() => authStore.user?.Cargo || 'Invitado')
const userInitials = computed(() => {
  const name = userName.value
  return name.substring(0, 2).toUpperCase()
})
</script>
