import api from './api'

export default {
    // Get tasks for current user
    async getMyTasks(filters = {}) {
        const params = new URLSearchParams()
        if (filters.status) params.append('status', filters.status)
        if (filters.priority) params.append('priority', filters.priority)

        const response = await api.get(`/tasks/my-tasks?${params}`)
        return response.data
    },

    // Get all tasks (admin only)
    async getAllTasks(filters = {}, pagination = {}) {
        const params = new URLSearchParams()
        if (filters.status) params.append('status', filters.status)
        if (filters.priority) params.append('priority', filters.priority)
        if (filters.area) params.append('area', filters.area)
        if (pagination.skip) params.append('skip', pagination.skip)
        if (pagination.limit) params.append('limit', pagination.limit)

        const response = await api.get(`/tasks/all?${params}`)
        return response.data
    },

    // Get task statistics
    async getTaskStats() {
        const response = await api.get('/tasks/stats')
        return response.data
    },

    // Update task status
    async updateTaskStatus(taskId, newStatus, observaciones = null) {
        const params = new URLSearchParams()
        params.append('new_status', newStatus)
        if (observaciones) params.append('observaciones', observaciones)

        const response = await api.put(`/tasks/${taskId}/status?${params}`)
        return response.data
    },

    // Assign task to user
    async assignTask(taskId, userId) {
        const params = new URLSearchParams()
        params.append('user_id', userId)

        const response = await api.put(`/tasks/${taskId}/assign?${params}`)
        return response.data
    },

    // Get assignable users (admin only)
    async getAssignableUsers() {
        const response = await api.get('/tasks/users')
        return response.data
    },

    // Create new task (admin only)
    async createTask(taskData) {
        const params = new URLSearchParams()
        params.append('descripcion', taskData.descripcion)
        params.append('tipo_tarea', taskData.tipo_tarea)
        params.append('prioridad', taskData.prioridad)
        params.append('fecha_vencimiento', taskData.fecha_vencimiento)
        params.append('id_responsable', taskData.id_responsable)
        if (taskData.observaciones) {
            params.append('observaciones', taskData.observaciones)
        }

        const response = await api.post(`/tasks/create?${params}`)
        return response.data
    }
}
