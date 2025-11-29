import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'

import './style.css'

const pinia = createPinia()
const app = createApp(App)

app.use(pinia)
app.use(router)

// Initialize auth store and fetch user if token exists
import { useAuthStore } from './stores/auth'
const authStore = useAuthStore()
if (authStore.token) {
    authStore.fetchUser()
}

app.mount('#app')
