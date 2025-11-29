<template>
  <div class="agent-tools">
    <h3>
      <i class="fas fa-tools"></i>
      Herramientas del Agente
    </h3>

    <div v-if="!selectedAgent" class="no-agent">
      <p>Selecciona un agente para ver sus herramientas</p>
    </div>

    <div v-else class="tools-content">
      <!-- Agent info -->
      <div class="agent-info-card">
        <h4>{{ getAgentName(selectedAgent) }}</h4>
        <p v-if="agentCapabilities">{{ agentCapabilities.description }}</p>
      </div>

      <!-- Quick actions based on agent type -->
      <div class="quick-actions">
        <h4>Acciones Rápidas</h4>
        
        <!-- Risk Agent Tools -->
        <div v-if="selectedAgent === 'risk_agent'" class="tool-group">
          <button class="tool-btn" @click="executeQuickAction('identify_hazards')">
            <i class="fas fa-search"></i>
            Identificar Peligros
          </button>
          <button class="tool-btn" @click="executeQuickAction('evaluate_risk')">
            <i class="fas fa-calculator"></i>
            Evaluar Riesgo
          </button>
          <button class="tool-btn" @click="executeQuickAction('generate_matrix')">
            <i class="fas fa-table"></i>
            Generar Matriz
          </button>
        </div>

        <!-- Document Agent Tools -->
        <div v-if="selectedAgent === 'document_agent'" class="tool-group">
          <button class="tool-btn" @click="executeQuickAction('summarize')">
            <i class="fas fa-file-alt"></i>
            Resumir Documento
          </button>
          <button class="tool-btn" @click="executeQuickAction('classify')">
            <i class="fas fa-tags"></i>
            Clasificar Documento
          </button>
          <button class="tool-btn" @click="executeQuickAction('verify_compliance')">
            <i class="fas fa-check-circle"></i>
            Verificar Cumplimiento
          </button>
        </div>

        <!-- Email Agent Tools -->
        <div v-if="selectedAgent === 'email_agent'" class="tool-group">
          <button class="tool-btn" @click="executeQuickAction('task_notification')">
            <i class="fas fa-tasks"></i>
            Notificación de Tarea
          </button>
          <button class="tool-btn" @click="executeQuickAction('deadline_reminder')">
            <i class="fas fa-clock"></i>
            Recordatorio de Vencimiento
          </button>
          <button class="tool-btn" @click="executeQuickAction('compliance_alert')">
            <i class="fas fa-exclamation-triangle"></i>
            Alerta de Cumplimiento
          </button>
        </div>

        <!-- Assistant Agent Tools -->
        <div v-if="selectedAgent === 'assistant_agent'" class="tool-group">
          <button class="tool-btn" @click="executeQuickAction('help')">
            <i class="fas fa-question-circle"></i>
            Ayuda General
          </button>
          <button class="tool-btn" @click="executeQuickAction('explain_process')">
            <i class="fas fa-book"></i>
            Explicar Proceso
          </button>
          <button class="tool-btn" @click="executeQuickAction('navigate')">
            <i class="fas fa-compass"></i>
            Navegación
          </button>
        </div>
      </div>

      <!-- Templates -->
      <div class="templates-section">
        <h4>Plantillas</h4>
        <div class="template-list">
          <div
            v-for="template in getTemplatesForAgent(selectedAgent)"
            :key="template.id"
            class="template-item"
            @click="useTemplate(template)"
          >
            <i :class="template.icon"></i>
            <span>{{ template.name }}</span>
          </div>
        </div>
      </div>

      <!-- Agent capabilities -->
      <div v-if="agentCapabilities" class="capabilities-section">
        <details>
          <summary>
            <i class="fas fa-info-circle"></i>
            Capacidades Técnicas
          </summary>
          <div class="capabilities-content">
            <div class="capability-item">
              <strong>Modelo:</strong>
              <span>{{ agentCapabilities.model }}</span>
            </div>
            <div class="capability-item">
              <strong>Temperatura:</strong>
              <span>{{ agentCapabilities.temperature }}</span>
            </div>
            <div v-if="agentCapabilities.tools" class="capability-item">
              <strong>Herramientas:</strong>
              <ul>
                <li v-for="tool in agentCapabilities.tools" :key="tool.name">
                  {{ tool.name }}
                </li>
              </ul>
            </div>
          </div>
        </details>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AgentTools',
  props: {
    selectedAgent: {
      type: String,
      default: null
    },
    agentCapabilities: {
      type: Object,
      default: null
    }
  },
  data() {
    return {
      templates: {
        risk_agent: [
          { id: 1, name: 'Matriz de Riesgos', icon: 'fas fa-table', prompt: 'Genera una matriz de riesgos para el área de producción' },
          { id: 2, name: 'Evaluación GTC 45', icon: 'fas fa-clipboard-check', prompt: 'Realiza una evaluación de riesgos según GTC 45' },
          { id: 3, name: 'Plan de Acción', icon: 'fas fa-tasks', prompt: 'Crea un plan de acción para los riesgos identificados' }
        ],
        document_agent: [
          { id: 1, name: 'Resumen Ejecutivo', icon: 'fas fa-file-alt', prompt: 'Genera un resumen ejecutivo del documento' },
          { id: 2, name: 'Verificación Decreto 1072', icon: 'fas fa-gavel', prompt: 'Verifica cumplimiento con Decreto 1072' },
          { id: 3, name: 'Extracción de Datos', icon: 'fas fa-database', prompt: 'Extrae información clave del documento' }
        ],
        email_agent: [
          { id: 1, name: 'Notificación de Tarea', icon: 'fas fa-envelope', prompt: 'Genera un correo de notificación de tarea' },
          { id: 2, name: 'Invitación a Capacitación', icon: 'fas fa-graduation-cap', prompt: 'Crea una invitación a capacitación' },
          { id: 3, name: 'Reporte Mensual', icon: 'fas fa-chart-line', prompt: 'Genera un correo con reporte mensual' }
        ],
        assistant_agent: [
          { id: 1, name: 'Guía de Proceso', icon: 'fas fa-route', prompt: 'Explica el proceso de evaluación de riesgos' },
          { id: 2, name: 'Normativa', icon: 'fas fa-book-open', prompt: 'Explica los requisitos de la Resolución 0312' },
          { id: 3, name: 'Mejores Prácticas', icon: 'fas fa-star', prompt: 'Proporciona mejores prácticas para SG-SST' }
        ]
      }
    }
  },
  methods: {
    executeQuickAction(action) {
      const prompts = {
        // Risk Agent
        identify_hazards: 'Identifica los peligros presentes en el área de trabajo',
        evaluate_risk: 'Evalúa el nivel de riesgo usando la matriz 5x5',
        generate_matrix: 'Genera una matriz de riesgos completa',
        
        // Document Agent
        summarize: 'Resume el documento en máximo 200 palabras',
        classify: 'Clasifica este documento según su tipo',
        verify_compliance: 'Verifica el cumplimiento normativo del documento',
        
        // Email Agent
        task_notification: 'Genera un correo de notificación de tarea',
        deadline_reminder: 'Crea un recordatorio de vencimiento',
        compliance_alert: 'Genera una alerta de cumplimiento',
        
        // Assistant Agent
        help: '¿Cómo puedo ayudarte con el SG-SST?',
        explain_process: 'Explica el proceso paso a paso',
        navigate: 'Ayúdame a navegar el sistema'
      }

      this.$emit('execute-tool', {
        action,
        prompt: prompts[action]
      })
    },

    useTemplate(template) {
      this.$emit('execute-tool', {
        action: 'template',
        prompt: template.prompt
      })
    },

    getTemplatesForAgent(agentName) {
      return this.templates[agentName] || []
    },

    getAgentName(agentName) {
      const names = {
        'risk_agent': 'Agente de Riesgos',
        'document_agent': 'Agente de Documentos',
        'email_agent': 'Agente de Correos',
        'assistant_agent': 'Asistente General'
      }
      return names[agentName] || agentName
    }
  }
}
</script>

<style scoped>
.agent-tools {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.agent-tools h3 {
  margin: 0 0 1.5rem 0;
  font-size: 1.1rem;
  color: #2d3748;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.no-agent {
  text-align: center;
  padding: 2rem;
  color: #a0aec0;
}

.tools-content {
  flex: 1;
  overflow-y: auto;
}

.agent-info-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 1.25rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
}

.agent-info-card h4 {
  margin: 0 0 0.5rem 0;
  font-size: 1.1rem;
}

.agent-info-card p {
  margin: 0;
  font-size: 0.9rem;
  opacity: 0.9;
}

.quick-actions h4 {
  margin: 0 0 1rem 0;
  font-size: 0.95rem;
  color: #4a5568;
}

.tool-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin-bottom: 1.5rem;
}

.tool-btn {
  width: 100%;
  padding: 0.75rem 1rem;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  text-align: left;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: #4a5568;
  font-size: 0.9rem;
}

.tool-btn:hover {
  background: #f7fafc;
  border-color: #667eea;
  color: #667eea;
  transform: translateX(4px);
}

.tool-btn i {
  width: 20px;
  text-align: center;
}

.templates-section {
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid #e2e8f0;
}

.templates-section h4 {
  margin: 0 0 1rem 0;
  font-size: 0.95rem;
  color: #4a5568;
}

.template-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.template-item {
  padding: 0.75rem;
  background: #f7fafc;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 0.9rem;
  color: #4a5568;
}

.template-item:hover {
  background: white;
  border-color: #667eea;
  color: #667eea;
}

.template-item i {
  width: 20px;
  text-align: center;
}

.capabilities-section {
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid #e2e8f0;
}

.capabilities-section summary {
  cursor: pointer;
  font-weight: 600;
  color: #4a5568;
  padding: 0.5rem;
  border-radius: 4px;
  transition: background 0.2s;
}

.capabilities-section summary:hover {
  background: #f7fafc;
}

.capabilities-content {
  padding: 1rem 0.5rem;
}

.capability-item {
  margin-bottom: 0.75rem;
  font-size: 0.9rem;
}

.capability-item strong {
  display: block;
  color: #2d3748;
  margin-bottom: 0.25rem;
}

.capability-item span {
  color: #718096;
}

.capability-item ul {
  margin: 0.5rem 0 0 0;
  padding-left: 1.5rem;
  color: #718096;
}

.capability-item li {
  margin-bottom: 0.25rem;
}
</style>
