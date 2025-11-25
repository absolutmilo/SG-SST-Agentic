import api from './api'

export default {
    async login(username, password) {
        const formData = new FormData()
        formData.append('username', username)
        formData.append('password', password)

        const response = await api.post('/auth/token', formData, {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        })
        return response.data
    },

    async getMe() {
        const response = await api.get('/auth/me')
        return response.data
    }
}
