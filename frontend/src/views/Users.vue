<template>
  <div class="users-container p-4">
    <div class="header flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold text-gray-800">Gestión de Usuarios</h1>
      <button 
        @click="openCreateModal"
        class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded transition-colors"
      >
        <i class="fas fa-plus mr-2"></i> Crear Usuario
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="text-center py-8">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
      <p class="mt-2 text-gray-600">Cargando usuarios...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6" role="alert">
      <p>{{ error }}</p>
    </div>

    <!-- Users Table -->
    <div v-else class="bg-white shadow-md rounded-lg overflow-hidden">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Usuario</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Rol</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Registro</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-for="user in users" :key="user.id_autorizado" class="hover:bg-gray-50">
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="flex items-center">
                <div class="flex-shrink-0 h-10 w-10 bg-gray-200 rounded-full flex items-center justify-center">
                   <span class="text-gray-500 font-bold">{{ getInitials(user.Nombre_Persona) }}</span>
                </div>
                <div class="ml-4">
                  <div class="text-sm font-medium text-gray-900">{{ user.Nombre_Persona }}</div>
                  <div class="text-sm text-gray-500">{{ user.Correo_Electronico }}</div>
                </div>
              </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                {{ user.Nivel_Acceso || 'Sin Rol' }}
              </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span 
                class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full"
                :class="user.Estado ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'"
              >
                {{ user.Estado ? 'Activo' : 'Inactivo' }}
              </span>
            </td>
             <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{ formatDate(user.FechaRegistro) }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Create User Modal -->
    <div v-if="showModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full flex items-center justify-center z-50">
      <div class="bg-white p-8 rounded-lg shadow-xl w-full max-w-md">
        <div class="flex justify-between items-center mb-6">
          <h2 class="text-xl font-bold text-gray-900">Nuevo Usuario</h2>
          <button @click="closeModal" class="text-gray-500 hover:text-gray-700">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <form @submit.prevent="createUser" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Nombre Completo</label>
            <input 
              v-model="newUser.full_name" 
              type="text" 
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Correo Electrónico</label>
            <input 
              v-model="newUser.email" 
              type="email" 
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
          </div>
          
           <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Rol</label>
            <select
              v-model="newUser.role_id"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500"
            >
                <option v-for="role in roles" :key="role.id_rol" :value="role.id_rol">
                    {{ role.NombreRol }}
                </option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Contraseña</label>
            <input 
              v-model="newUser.password" 
              type="password" 
              required
              minlength="6"
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-1 focus:ring-blue-500"
            />
          </div>

          <div class="flex justify-end pt-4 space-x-3">
            <button 
              type="button" 
              @click="closeModal"
              class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300 transition-colors"
            >
              Cancelar
            </button>
            <button 
              type="submit" 
              :disabled="creating"
              class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors disabled:opacity-50"
            >
              {{ creating ? 'Creando...' : 'Crear Usuario' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { useToast } from 'vue-toastification'

const toast = useToast()

// State
const users = ref([])
const roles = ref([])
const loading = ref(true)
const error = ref(null)
const showModal = ref(false)
const creating = ref(false)

const newUser = ref({
    full_name: '',
    email: '',
    role_id: null,
    password: ''
})

// Lifecycle
onMounted(async () => {
    await fetchInitialData()
})

// Methods
const getInitials = (name) => {
    return name ? name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase() : 'U'
}

const formatDate = (dateString) => {
    if (!dateString) return 'N/A'
    return new Date(dateString).toLocaleDateString()
}

const fetchInitialData = async () => {
    loading.value = true
    error.value = null
    try {
        const token = localStorage.getItem('token')
        const config = { headers: { Authorization: `Bearer ${token}` } }
        
        // Fetch Users and Roles in parallel
        const [usersResponse, rolesResponse] = await Promise.all([
             axios.get('/api/v1/users', config),
             axios.get('/api/v1/users/roles', config)
        ])
        
        users.value = usersResponse.data
        roles.value = rolesResponse.data
        
        // Select first role by default
        if (roles.value.length > 0) {
            newUser.value.role_id = roles.value[0].id_rol
        }

    } catch (err) {
        console.error("Error loading data:", err)
        error.value = "No tienes permisos para ver esta página o hubo un error de conexión."
    } finally {
        loading.value = false
    }
}

const openCreateModal = () => {
    showModal.value = true
}

const closeModal = () => {
    showModal.value = false
    resetForm()
}

const resetForm = () => {
    newUser.value = {
        full_name: '',
        email: '',
        role_id: roles.value.length > 0 ? roles.value[0].id_rol : null,
        password: ''
    }
}

const createUser = async () => {
    creating.value = true
    try {
        const token = localStorage.getItem('token')
        
        await axios.post('/api/v1/users/', newUser.value, {
            headers: { Authorization: `Bearer ${token}` }
        })
        
        toast.success("Usuario creado exitosamente")
        await fetchInitialData() // Refresh list
        closeModal()
        
    } catch (err) {
        console.error("Error creating user:", err)
        toast.error(err.response?.data?.detail || "Error al crear usuario")
    } finally {
        creating.value = false
    }
}
</script>

<style scoped>
/* Scoped styles if needed */
</style>
