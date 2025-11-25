<template>
  <div class="flex min-h-screen bg-body">
    <!-- Left Side - Form -->
    <div class="flex flex-col justify-center w-full md:w-1/2 lg:w-1/3 px-8 py-12 bg-white shadow-lg z-10">
      <div class="w-full max-w-sm mx-auto">
        <!-- Logo Placeholder -->
        <div class="mb-8 text-center">
          <div class="inline-flex items-center justify-center w-16 h-16 rounded-xl bg-primary/10 text-primary mb-4">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
            </svg>
          </div>
          <h1 class="h2 text-primary mb-2">SG-SST Agente</h1>
          <p class="text-muted">Sistema de Gestión de Seguridad y Salud</p>
        </div>

        <form @submit.prevent="handleLogin" class="space-y-6">
          <BaseInput
            id="email"
            v-model="email"
            type="email"
            label="Correo Electrónico"
            placeholder="usuario@empresa.com"
            required
            :error="authStore.error && !password ? authStore.error : ''"
          />

          <BaseInput
            id="password"
            v-model="password"
            type="password"
            label="Contraseña"
            placeholder="••••••••"
            required
            :error="authStore.error ? 'Credenciales inválidas' : ''"
          />

          <div class="flex items-center justify-between text-sm">
            <label class="flex items-center text-muted cursor-pointer">
              <input type="checkbox" class="mr-2 rounded border-gray-300 text-primary focus:ring-primary">
              Recordarme
            </label>
            <a href="#" class="text-primary font-medium hover:underline">¿Olvidaste tu contraseña?</a>
          </div>

          <BaseButton 
            type="submit" 
            class="w-full justify-center py-3 text-lg shadow-lg shadow-primary/20" 
            :loading="authStore.loading"
          >
            Iniciar Sesión
          </BaseButton>
        </form>

        <div class="mt-8 text-center text-sm text-muted">
          <p>¿No tienes acceso? <a href="#" class="text-primary font-medium hover:underline">Contactar soporte</a></p>
        </div>
      </div>
    </div>

    <!-- Right Side - Image/Brand -->
    <div class="hidden md:flex w-1/2 lg:w-2/3 bg-primary relative overflow-hidden items-center justify-center">
      <div class="absolute inset-0 bg-gradient-to-br from-primary-dark to-primary opacity-90"></div>
      
      <!-- Decorative Circles -->
      <div class="absolute top-0 left-0 w-full h-full overflow-hidden">
        <div class="absolute -top-24 -left-24 w-96 h-96 rounded-full bg-white opacity-5"></div>
        <div class="absolute bottom-0 right-0 w-128 h-128 rounded-full bg-white opacity-5"></div>
      </div>

      <div class="relative z-10 text-white max-w-lg text-center px-8">
        <h2 class="text-4xl font-bold mb-6">Cumplimiento Normativo Simplificado</h2>
        <p class="text-lg text-blue-100 leading-relaxed">
          Gestiona riesgos, reportes y cumplimiento legal con la potencia de la Inteligencia Artificial. 
          100% alineado con el Decreto 1072 y la Resolución 0312.
        </p>
        
        <div class="mt-12 grid grid-cols-3 gap-8 text-center">
          <div>
            <div class="text-3xl font-bold mb-1">24/7</div>
            <div class="text-blue-200 text-sm">Monitoreo</div>
          </div>
          <div>
            <div class="text-3xl font-bold mb-1">100%</div>
            <div class="text-blue-200 text-sm">Cumplimiento</div>
          </div>
          <div>
            <div class="text-3xl font-bold mb-1">AI</div>
            <div class="text-blue-200 text-sm">Asistente</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import BaseInput from '../components/ui/BaseInput.vue'
import BaseButton from '../components/ui/BaseButton.vue'

const router = useRouter()
const authStore = useAuthStore()

const email = ref('')
const password = ref('')

const handleLogin = async () => {
  const success = await authStore.login(email.value, password.value)
  if (success) {
    router.push('/')
  }
}
</script>

<style scoped>
.bg-primary\/10 {
  background-color: rgba(37, 99, 235, 0.1);
}
.shadow-primary\/20 {
  box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.2);
}
</style>
