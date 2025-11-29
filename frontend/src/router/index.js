import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/Login.vue'
import Dashboard from '../views/Dashboard.vue'
import Tasks from '../views/Tasks.vue'
import Alerts from '../views/Alerts.vue'
import Reports from '../views/Reports.vue'
import Employees from '../views/Employees.vue'
import Assistant from '../views/Assistant.vue'
import Forms from '../views/Forms.vue'
import AgenticConsole from '../views/AgenticConsole.vue'
import DashboardLayout from '../layouts/DashboardLayout.vue'

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
        {
            path: '/login',
            name: 'login',
            component: Login,
            meta: { guest: true }
        },
        {
            path: '/',
            component: DashboardLayout,
            meta: { requiresAuth: true },
            children: [
                {
                    path: '',
                    name: 'dashboard',
                    component: Dashboard
                },
                {
                    path: 'tasks',
                    name: 'tasks',
                    component: Tasks
                },
                {
                    path: 'alerts',
                    name: 'alerts',
                    component: Alerts
                },
                {
                    path: 'reports',
                    name: 'reports',
                    component: Reports
                },
                {
                    path: 'employees',
                    name: 'employees',
                    component: Employees
                },
                {
                    path: 'assistant',
                    name: 'assistant',
                    component: Assistant
                },
                {
                    path: 'forms',
                    name: 'forms',
                    component: Forms
                },
                {
                    path: 'agentic',
                    name: 'agentic',
                    component: AgenticConsole,
                    meta: { title: 'Consola Agentic' }
                }
            ]
        }
    ]
})

router.beforeEach((to, from, next) => {
    const token = localStorage.getItem('token')

    if (to.matched.some(record => record.meta.requiresAuth)) {
        if (!token) {
            next({ name: 'login' })
        } else {
            next()
        }
    } else if (to.matched.some(record => record.meta.guest)) {
        if (token) {
            next({ name: 'dashboard' })
        } else {
            next()
        }
    } else {
        next()
    }
})

export default router
