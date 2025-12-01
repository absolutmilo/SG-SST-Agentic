<template>
  <div class="agentic-console">
    <div class="console-container">
      <!-- Sidebar with agent selection -->
      <div class="agents-sidebar">
        <h3>Agentes Disponibles</h3>
        
        <div v-if="loadingAgents" class="loading">
          <i class="fas fa-spinner fa-spin"></i>
          Cargando agentes...
        </div>

        <div v-else class="agents-list">
          <div
            v-for="agent in availableAgents"
            :key="agent.name"
            class="agent-card"
            :class="{ active: selectedAgent === agent.name }"
            @click="selectAgent(agent.name)"
          >
            <div class="agent-icon">
              <i :class="getAgentIcon(agent.name)"></i>
            </div>
            <div class="agent-info">
              <h4>{{ getAgentDisplayName(agent.name) }}</h4>
              <p>{{ agent.description }}</p>
            </div>
          </div>
        </div>

        <!-- Workflows section -->
        <div class="workflows-section">
          <h3>Workflows</h3>
          <button
            v-for="workflow in workflows"
            :key="workflow.name"
            class="workflow-btn"
            @click="startWorkflow(workflow.name)"
          >
            <i class="fas fa-project-diagram"></i>
            {{ workflow.description }}
          </button>
        </div>
      </div>

      <!-- Main chat area -->
      <div class="chat-area">
        <div class="chat-messages" ref="chatMessages">
          <div
            v-for="(message, index) in messages"
            :key="index"
            class="message"
            :class="message.role"
          >
            <div class="message-avatar">
              <i :class="message.role === 'user' ? 'fas fa-user' : 'fas fa-robot'"></i>
            </div>
            <div class="message-content">
              <div class="message-header">
                <span class="message-sender">
                  {{ message.role === 'user' ? 'Tú' : getAgentDisplayName(message.agent) }}
                </span>
                <span class="message-time">{{ formatTime(message.timestamp) }}</span>
              </div>
              <div class="message-text" v-html="formatMessage(message.text)"></div>
              
              <!-- Sources for RAG responses -->
              <div v-if="message.sources && message.sources.length > 0" class="message-sources">
                <details>
                  <summary>
                    <i class="fas fa-book"></i>
                    Fuentes ({{ message.sources.length }})
                  </summary>
                  <div class="sources-list">
                    <div v-for="(source, idx) in message.sources" :key="idx" class="source-item">
                      <strong>{{ source.source }}</strong>
                      <p>{{ source.text_snippet }}</p>
                    </div>
                  </div>
                </details>
              </div>

              <!-- Confidence score -->
              <div v-if="message.confidence !== undefined" class="confidence-bar">
                <span>Confianza:</span>
                <div class="bar">
                  <div
                    class="fill"
                    :style="{ width: (message.confidence * 100) + '%' }"
                    :class="getConfidenceClass(message.confidence)"
                  ></div>
                </div>
                <span>{{ (message.confidence * 100).toFixed(0) }}%</span>
              </div>
            </div>
          </div>

          <!-- Typing indicator -->
          <div v-if="isTyping" class="message assistant typing-indicator">
            <div class="message-avatar">
              <i class="fas fa-robot"></i>
            </div>
            <div class="message-content">
              <div class="typing-dots">
                <span></span>
                <span></span>
                <span></span>
              </div>
            </div>
          </div>
        </div>

        <!-- Input area -->
        <div class="chat-input-area">
          <div class="input-controls">
            <button
              class="control-btn"
              @click="showRAGSearch = !showRAGSearch"
              :class="{ active: showRAGSearch }"
              title="Búsqueda RAG"
            >
              <i class="fas fa-search"></i>
            </button>
            <button
              class="control-btn"
              @click="clearChat"
              title="Limpiar chat"
            >
              <i class="fas fa-trash"></i>
            </button>
          </div>

          <div class="input-wrapper">
            <textarea
              v-model="userInput"
              @keydown.enter.exact.prevent="sendMessage"
              @keydown.enter.shift.exact="userInput += '\n'"
              placeholder="Escribe tu mensaje... (Enter para enviar, Shift+Enter para nueva línea)"
              rows="3"
              :disabled="isTyping"
            ></textarea>
            <button
              class="send-btn"
              @click="sendMessage"
              :disabled="!userInput.trim() || isTyping"
            >
              <i class="fas fa-paper-plane"></i>
            </button>
          </div>
        </div>
      </div>

      <!-- Right panel with agent tools -->
      <div class="tools-panel">
        <AgentTools
          :selectedAgent="selectedAgent"
          :agentCapabilities="currentAgentCapabilities"
          @execute-tool="executeTool"
        />
      </div>
    </div>
  </div>
</template>

<script>
import AgentTools from '@/components/AgentTools.vue'
import axios from 'axios'
import { marked } from 'marked'
import { useAuthStore } from '@/stores/auth'

export default {
  name: 'AgenticConsole',
  components: {
    AgentTools
  },
  setup() {
    const authStore = useAuthStore()
    return { authStore }
  },
  data() {
    return {
      selectedAgent: 'assistant_agent',
      availableAgents: [],
      loadingAgents: true,
      messages: [],
      userInput: '',
      isTyping: false,
      showRAGSearch: false,
      currentAgentCapabilities: null,
      workflows: [
        { name: 'risk_assessment', description: 'Evaluación de Riesgos' },
        { name: 'document_processing', description: 'Procesamiento de Documentos' },
        { name: 'employee_onboarding', description: 'Incorporación de Empleado' }
      ]
    }
  },
  mounted() {
    this.loadAvailableAgents()
    this.addWelcomeMessage()
  },
  methods: {
    async loadAvailableAgents() {
      try {
        const userId = this.authStore.user?.id_empleado || 1
        const response = await axios.get(`/api/agent/list?user_id=${userId}`)
        this.availableAgents = response.data.agents
        this.loadingAgents = false

        // Load capabilities for selected agent
        if (this.selectedAgent) {
          await this.loadAgentCapabilities(this.selectedAgent)
        }
      } catch (error) {
        console.error('Error loading agents:', error)
        this.loadingAgents = false
        // Don't show toast if not available
        if (this.$toast) {
          this.$toast.error('Error al cargar agentes disponibles')
        }
      }
    },

    async loadAgentCapabilities(agentName) {
      try {
        const response = await axios.get(`/api/agent/capabilities/${agentName}`)
        this.currentAgentCapabilities = response.data
      } catch (error) {
        console.error('Error loading agent capabilities:', error)
      }
    },

    selectAgent(agentName) {
      this.selectedAgent = agentName
      this.loadAgentCapabilities(agentName)
      this.addSystemMessage(`Agente ${this.getAgentDisplayName(agentName)} seleccionado`)
    },

    async sendMessage() {
      if (!this.userInput.trim() || this.isTyping) return

      const message = this.userInput.trim()
      this.userInput = ''

      // Add user message
      this.messages.push({
        role: 'user',
        text: message,
        timestamp: new Date()
      })

      this.scrollToBottom()
      this.isTyping = true

      try {
        const userId = this.authStore.user?.id_empleado || 1

        let response
        if (this.showRAGSearch) {
          // Use RAG query
          response = await axios.post('/api/rag/query', {
            question: message,
            user_id: userId,
            return_sources: true
          })

          this.messages.push({
            role: 'assistant',
            agent: 'rag',
            text: response.data.answer,
            confidence: response.data.confidence,
            sources: response.data.sources,
            timestamp: new Date()
          })
        } else {
          // Use selected agent
          response = await axios.post('/api/agent/run', {
            agent_name: this.selectedAgent,
            task: message,
            user_id: userId
          })

          this.messages.push({
            role: 'assistant',
            agent: this.selectedAgent,
            text: response.data.result?.response || 'Tarea completada',
            timestamp: new Date()
          })
        }

        this.scrollToBottom()
      } catch (error) {
        console.error('Error sending message:', error)
        this.messages.push({
          role: 'assistant',
          agent: 'system',
          text: `Error: ${error.response?.data?.detail || error.message}`,
          timestamp: new Date()
        })
      } finally {
        this.isTyping = false
      }
    },

    async startWorkflow(workflowName) {
      this.addSystemMessage(`Iniciando workflow: ${workflowName}...`)
      
      try {
        const userId = this.authStore.user?.id_empleado || 1
        
        // TODO: Collect workflow parameters from user
        const params = this.getDefaultWorkflowParams(workflowName)
        
        const response = await axios.post('/api/workflow/start', {
          template_name: workflowName,
          params: params,
          user_id: userId
        })

        this.addSystemMessage(`✅ Workflow iniciado: ${response.data.workflow_id}`)
        this.addSystemMessage(`Total de pasos: ${response.data.total_steps}`)
      } catch (error) {
        console.error('Error starting workflow:', error)
        this.addSystemMessage(`❌ Error al iniciar workflow: ${error.response?.data?.detail || error.message}`)
      }
    },

    getDefaultWorkflowParams(workflowName) {
      // Default parameters for testing
      const defaults = {
        risk_assessment: {
          area: 'Área de Producción',
          process: 'Manejo de Materiales'
        },
        document_processing: {
          file_path: './documents/policies/politica_sst_ejemplo.txt',
          doc_type: 'policy'
        },
        employee_onboarding: {
          employee_name: 'Nuevo Empleado',
          position: 'Operario',
          department: 'Producción'
        }
      }
      return defaults[workflowName] || {}
    },

    executeTool(toolData) {
      // Execute a specific agent tool
      this.userInput = toolData.prompt || ''
      this.sendMessage()
    },

    clearChat() {
      this.messages = []
      this.addWelcomeMessage()
    },

    addWelcomeMessage() {
      this.messages.push({
        role: 'assistant',
        agent: 'system',
        text: '¡Bienvenido a Agentes IA! Selecciona un agente y comienza a interactuar.',
        timestamp: new Date()
      })
    },

    addSystemMessage(text) {
      this.messages.push({
        role: 'assistant',
        agent: 'system',
        text,
        timestamp: new Date()
      })
    },

    scrollToBottom() {
      this.$nextTick(() => {
        const container = this.$refs.chatMessages
        if (container) {
          container.scrollTop = container.scrollHeight
        }
      })
    },

    formatMessage(text) {
      return marked(text)
    },

    formatTime(date) {
      return new Date(date).toLocaleTimeString('es-CO', {
        hour: '2-digit',
        minute: '2-digit'
      })
    },

    getAgentDisplayName(agentName) {
      const names = {
        'risk_agent': 'Agente de Riesgos',
        'document_agent': 'Agente de Documentos',
        'email_agent': 'Agente de Correos',
        'assistant_agent': 'Asistente General',
        'rag': 'Búsqueda RAG',
        'system': 'Sistema'
      }
      return names[agentName] || agentName
    },

    getAgentIcon(agentName) {
      const icons = {
        'risk_agent': 'fas fa-exclamation-triangle',
        'document_agent': 'fas fa-file-alt',
        'email_agent': 'fas fa-envelope',
        'assistant_agent': 'fas fa-user-tie'
      }
      return icons[agentName] || 'fas fa-robot'
    },

    getConfidenceClass(confidence) {
      if (confidence >= 0.8) return 'high'
      if (confidence >= 0.6) return 'medium'
      return 'low'
    }
  }
}
</script>

<style scoped>
.agentic-console {
  height: calc(100vh - 80px);
  flex: 1;
  overflow: hidden;
}

.console-container {
  display: grid;
  grid-template-columns: 280px 1fr 320px;
  gap: 1.5rem;
  height: 100%;
  padding: 1.5rem;
  overflow: hidden;
}

/* Agents Sidebar */
.agents-sidebar {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  overflow-y: auto;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.agents-sidebar h3 {
  margin: 0 0 1rem 0;
  font-size: 1.1rem;
  color: #2d3748;
}

.agent-card {
  padding: 1rem;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  margin-bottom: 0.75rem;
  cursor: pointer;
  transition: all 0.2s;
}

.agent-card:hover {
  border-color: #667eea;
  transform: translateY(-2px);
}

.agent-card.active {
  border-color: #667eea;
  background: #f7fafc;
}

.agent-icon {
  font-size: 1.5rem;
  color: #667eea;
  margin-bottom: 0.5rem;
}

.agent-info h4 {
  margin: 0 0 0.25rem 0;
  font-size: 0.95rem;
  color: #2d3748;
}

.agent-info p {
  margin: 0;
  font-size: 0.8rem;
  color: #718096;
}

/* Workflows */
.workflows-section {
  margin-top: 2rem;
  padding-top: 1.5rem;
  border-top: 1px solid #e2e8f0;
}

.workflow-btn {
  width: 100%;
  padding: 0.75rem;
  margin-bottom: 0.5rem;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  text-align: left;
}

.workflow-btn:hover {
  background: #f7fafc;
  border-color: #667eea;
}

/* Chat Area */
.chat-area {
  background: white;
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 1.5rem;
}

.message {
  display: flex;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.message-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.message.user .message-avatar {
  background: #667eea;
  color: white;
}

.message.assistant .message-avatar {
  background: #48bb78;
  color: white;
}

.message-content {
  flex: 1;
}

.message-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5rem;
}

.message-sender {
  font-weight: 600;
  color: #2d3748;
}

.message-time {
  font-size: 0.85rem;
  color: #a0aec0;
}

.message-text {
  color: #4a5568;
  line-height: 1.6;
}

/* Typing indicator */
.typing-dots {
  display: flex;
  gap: 4px;
  padding: 1rem;
}

.typing-dots span {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #cbd5e0;
  animation: typing 1.4s infinite;
}

.typing-dots span:nth-child(2) {
  animation-delay: 0.2s;
}

.typing-dots span:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes typing {
  0%, 60%, 100% {
    transform: translateY(0);
  }
  30% {
    transform: translateY(-10px);
  }
}

/* Sources */
.message-sources {
  margin-top: 1rem;
  padding: 1rem;
  background: #f7fafc;
  border-radius: 6px;
}

.message-sources summary {
  cursor: pointer;
  font-weight: 600;
  color: #4a5568;
}

.sources-list {
  margin-top: 0.75rem;
}

.source-item {
  padding: 0.75rem;
  background: white;
  border-radius: 4px;
  margin-bottom: 0.5rem;
}

/* Confidence bar */
.confidence-bar {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.75rem;
  font-size: 0.85rem;
}

.confidence-bar .bar {
  flex: 1;
  height: 6px;
  background: #e2e8f0;
  border-radius: 3px;
  overflow: hidden;
}

.confidence-bar .fill {
  height: 100%;
  transition: width 0.3s;
}

.confidence-bar .fill.high {
  background: #48bb78;
}

.confidence-bar .fill.medium {
  background: #ed8936;
}

.confidence-bar .fill.low {
  background: #f56565;
}

/* Input Area */
.chat-input-area {
  border-top: 1px solid #e2e8f0;
  padding: 1rem;
}

.input-controls {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 0.75rem;
}

.control-btn {
  padding: 0.5rem 1rem;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
}

.control-btn:hover {
  background: #f7fafc;
}

.control-btn.active {
  background: #667eea;
  color: white;
  border-color: #667eea;
}

.input-wrapper {
  display: flex;
  gap: 0.75rem;
}

.input-wrapper textarea {
  flex: 1;
  padding: 0.75rem;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  resize: none;
  font-family: inherit;
}

.send-btn {
  padding: 0.75rem 1.5rem;
  background: #667eea;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.send-btn:hover:not(:disabled) {
  background: #5a67d8;
}

.send-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Tools Panel */
.tools-panel {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  overflow-y: auto;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
</style>
