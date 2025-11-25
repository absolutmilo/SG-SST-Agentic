import { defineStore } from 'pinia'
import authService from '../services/authService'

export const useAuthStore = defineStore('auth', {
    state: () => ({
        user: null,
        token: localStorage.getItem('token') || null,
        loading: false,
        error: null
    }),

    getters: {
        isAuthenticated: (state) => !!state.token,
        isAdmin: (state) => state.user?.Nivel_Acceso === 'CEO' || state.user?.Nivel_Acceso === 'Coordinador SST'
    },

    actions: {
        async login(username, password) {
            this.loading = true
            this.error = null
            try {
                const data = await authService.login(username, password)
                this.token = data.access_token
                localStorage.setItem('token', data.access_token)

                // Get user details
                await this.fetchUser()
                return true
            } catch (err) {
                this.error = err.response?.data?.detail || 'Login failed'
                return false
            } finally {
                this.loading = false
            }
        },

        async fetchUser() {
            try {
                const user = await authService.getMe()
                this.user = user
            } catch (err) {
                this.logout()
            }
        },

        logout() {
            this.user = null
            this.token = null
            localStorage.removeItem('token')
            window.location.href = '/login'
        }
    }
})
