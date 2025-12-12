import api from './api'

const documentService = {
    // Get list of documents with optional filters
    async getDocuments(filters = {}) {
        const params = new URLSearchParams()
        if (filters.type) params.append('type', filters.type)
        if (filters.category) params.append('category', filters.category)
        if (filters.search) params.append('search', filters.search)

        const response = await api.get(`/documents/?${params.toString()}`)
        return response.data
    },

    // Upload a new document
    async uploadDocument(formData) {
        const response = await api.post('/documents/upload', formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        })
        return response.data
    },

    // Download a document
    async downloadDocument(id, filename) {
        const response = await api.get(`/documents/${id}/download`, {
            responseType: 'blob'
        })

        // Create download link
        const url = window.URL.createObjectURL(new Blob([response.data]))
        const link = document.createElement('a')
        link.href = url
        link.setAttribute('download', filename || `document_${id}`)
        document.body.appendChild(link)
        link.click()
        link.remove()
        window.URL.revokeObjectURL(url)
    },

    // Delete a document
    async deleteDocument(id) {
        const response = await api.delete(`/documents/${id}`)
        return response.data
    }
}

export default documentService
