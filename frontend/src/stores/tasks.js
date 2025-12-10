import { defineStore } from 'pinia'
import taskService from '../services/taskService'

export const useTaskStore = defineStore('tasks', {
    state: () => ({
        myTasks: [],
        allTasks: [],
        stats: {
            pending: 0,
            in_progress: 0,
            completed: 0,
            overdue: 0,
            total: 0
        },
        filters: {
            status: null,
            priority: null,
            area: null
        },
        loading: false,
        error: null
    }),

    getters: {
        tasksByStatus: (state) => (status) => {
            return state.myTasks.filter(task => task.estado?.trim() === status)
        },

        tasksByPriority: (state) => (priority) => {
            return state.myTasks.filter(task => task.prioridad === priority)
        },

        overdueTasks: (state) => {
            const today = new Date().toISOString().split('T')[0]
            return state.myTasks.filter(
                task => task.estado?.trim() !== 'Cerrada' && task.fecha_vencimiento < today
            )
        },

        pendingTasks: (state) => {
            return state.myTasks.filter(task => task.estado?.trim() === 'Pendiente')
        },

        inProgressTasks: (state) => {
            return state.myTasks.filter(task => task.estado?.trim() === 'En Curso')
        },

        completedTasks: (state) => {
            return state.myTasks.filter(task => task.estado?.trim() === 'Cerrada')
        }
    },

    actions: {
        async fetchMyTasks() {
            this.loading = true
            this.error = null
            try {
                const data = await taskService.getMyTasks(this.filters)
                this.myTasks = data.tasks
            } catch (err) {
                this.error = err.response?.data?.detail || 'Error fetching tasks'
                console.error('Error fetching tasks:', err)
            } finally {
                this.loading = false
            }
        },

        async fetchAllTasks(pagination = {}) {
            this.loading = true
            this.error = null
            try {
                const data = await taskService.getAllTasks(this.filters, pagination)
                this.allTasks = data.tasks
            } catch (err) {
                this.error = err.response?.data?.detail || 'Error fetching all tasks'
                console.error('Error fetching all tasks:', err)
            } finally {
                this.loading = false
            }
        },

        async fetchStats() {
            try {
                const data = await taskService.getTaskStats()
                this.stats = data
            } catch (err) {
                console.error('Error fetching stats:', err)
            }
        },

        async updateTaskStatus(taskId, newStatus, observaciones = null) {
            try {
                await taskService.updateTaskStatus(taskId, newStatus, observaciones)
                // Refresh tasks after update
                await this.fetchMyTasks()
                await this.fetchStats()
                return true
            } catch (err) {
                this.error = err.response?.data?.detail || 'Error updating task'
                console.error('Error updating task:', err)
                return false
            }
        },

        async assignTask(taskId, userId) {
            try {
                await taskService.assignTask(taskId, userId)
                // Refresh tasks after assignment
                await this.fetchMyTasks()
                return true
            } catch (err) {
                this.error = err.response?.data?.detail || 'Error assigning task'
                console.error('Error assigning task:', err)
                return false
            }
        },

        setFilter(filterType, value) {
            this.filters[filterType] = value
            this.fetchMyTasks()
        },

        clearFilters() {
            this.filters = {
                status: null,
                priority: null,
                area: null
            }
            this.fetchMyTasks()
        }
    }
})
