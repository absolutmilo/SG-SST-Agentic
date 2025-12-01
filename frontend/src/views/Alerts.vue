<template>
  <div class="alerts-container">
    <div class="header">
      <h1>Centro de Notificaciones</h1>
      <div class="actions">
        <button class="btn-secondary" @click="markAllRead">
          <i class="fas fa-check-double"></i> Marcar todo como leído
        </button>
      </div>
    </div>

    <div class="filters">
      <button 
        v-for="filter in filters" 
        :key="filter.value"
        class="filter-btn"
        :class="{ active: currentFilter === filter.value }"
        @click="currentFilter = filter.value"
      >
        {{ filter.label }}
      </button>
    </div>

    <div class="notifications-list">
      <div v-if="filteredNotifications.length === 0" class="empty-state">
        <i class="fas fa-bell-slash"></i>
        <p>No hay notificaciones para mostrar</p>
      </div>

      <div 
        v-for="notification in filteredNotifications" 
        :key="notification.id"
        class="notification-card"
        :class="{ unread: !notification.read, [notification.type]: true }"
        @click="markAsRead(notification)"
      >
        <div class="icon-wrapper">
          <i :class="getIcon(notification.type)"></i>
        </div>
        <div class="content">
          <div class="top-row">
            <span class="type-badge">{{ getTypeLabel(notification.type) }}</span>
            <span class="time">{{ formatTime(notification.timestamp) }}</span>
          </div>
          <h3>{{ notification.title }}</h3>
          <p>{{ notification.message }}</p>
        </div>
        <div class="actions">
          <button class="btn-icon" title="Marcar como leído">
            <i class="fas" :class="notification.read ? 'fa-envelope-open' : 'fa-envelope'"></i>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Alerts',
  data() {
    return {
      currentFilter: 'all',
      filters: [
        { label: 'Todas', value: 'all' },
        { label: 'No leídas', value: 'unread' },
        { label: 'Alertas', value: 'alert' },
        { label: 'Tareas', value: 'task' }
      ],
      notifications: [
        {
          id: 1,
          type: 'alert',
          title: 'Extintores Vencidos',
          message: 'Se han detectado 3 extintores vencidos en el Área de Producción. Se requiere acción inmediata.',
          timestamp: new Date(Date.now() - 1000 * 60 * 30),
          read: false
        },
        {
          id: 2,
          type: 'task',
          title: 'Nueva Tarea Asignada',
          message: 'Se te ha asignado la tarea: "Revisión de matriz de riesgos - Q4". Fecha límite: 15/12/2024.',
          timestamp: new Date(Date.now() - 1000 * 60 * 60 * 2),
          read: false
        },
        {
          id: 3,
          type: 'info',
          title: 'Reporte Generado',
          message: 'El reporte mensual de accidentalidad ha sido generado exitosamente y enviado a tu correo.',
          timestamp: new Date(Date.now() - 1000 * 60 * 60 * 24),
          read: true
        },
        {
          id: 4,
          type: 'success',
          title: 'Capacitación Completada',
          message: 'Has completado exitosamente el módulo de "Primeros Auxilios".',
          timestamp: new Date(Date.now() - 1000 * 60 * 60 * 48),
          read: true
        }
      ]
    }
  },
  computed: {
    filteredNotifications() {
      if (this.currentFilter === 'all') return this.notifications
      if (this.currentFilter === 'unread') return this.notifications.filter(n => !n.read)
      return this.notifications.filter(n => n.type === this.currentFilter)
    }
  },
  methods: {
    markAsRead(notification) {
      notification.read = true
    },
    markAllRead() {
      this.notifications.forEach(n => n.read = true)
    },
    getIcon(type) {
      const icons = {
        alert: 'fas fa-exclamation-triangle',
        task: 'fas fa-tasks',
        info: 'fas fa-info-circle',
        success: 'fas fa-check-circle'
      }
      return icons[type] || 'fas fa-bell'
    },
    getTypeLabel(type) {
      const labels = {
        alert: 'Alerta',
        task: 'Tarea',
        info: 'Información',
        success: 'Éxito'
      }
      return labels[type] || type
    },
    formatTime(date) {
      return new Date(date).toLocaleString('es-CO', {
        day: '2-digit',
        month: 'short',
        hour: '2-digit',
        minute: '2-digit'
      })
    }
  }
}
</script>

<style scoped>
.alerts-container {
  padding: 2rem;
  max-width: 800px;
  margin: 0 auto;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.header h1 {
  font-size: 1.8rem;
  color: #2d3748;
  margin: 0;
}

.btn-secondary {
  background: white;
  border: 1px solid #e2e8f0;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  color: #4a5568;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-secondary:hover {
  background: #f7fafc;
  border-color: #cbd5e0;
}

.filters {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1.5rem;
  overflow-x: auto;
  padding-bottom: 0.5rem;
}

.filter-btn {
  padding: 0.5rem 1rem;
  border: none;
  background: white;
  border-radius: 20px;
  color: #718096;
  cursor: pointer;
  transition: all 0.2s;
  font-weight: 500;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.filter-btn.active {
  background: #667eea;
  color: white;
}

.notifications-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.notification-card {
  background: white;
  border-radius: 12px;
  padding: 1.25rem;
  display: flex;
  gap: 1.25rem;
  box-shadow: 0 2px 5px rgba(0,0,0,0.05);
  transition: all 0.2s;
  border-left: 4px solid transparent;
  cursor: pointer;
}

.notification-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.notification-card.unread {
  background: #fff;
  border-left-color: #667eea;
}

.notification-card.alert .icon-wrapper { background: #fed7d7; color: #e53e3e; }
.notification-card.task .icon-wrapper { background: #bee3f8; color: #3182ce; }
.notification-card.info .icon-wrapper { background: #e2e8f0; color: #718096; }
.notification-card.success .icon-wrapper { background: #c6f6d5; color: #38a169; }

.icon-wrapper {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
  flex-shrink: 0;
}

.content {
  flex: 1;
}

.top-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.25rem;
  font-size: 0.85rem;
}

.type-badge {
  font-weight: 600;
  text-transform: uppercase;
  font-size: 0.7rem;
  letter-spacing: 0.05em;
  color: #718096;
}

.time {
  color: #a0aec0;
}

.content h3 {
  margin: 0 0 0.5rem 0;
  font-size: 1.1rem;
  color: #2d3748;
}

.content p {
  margin: 0;
  color: #4a5568;
  line-height: 1.5;
}

.empty-state {
  text-align: center;
  padding: 3rem;
  color: #a0aec0;
}

.empty-state i {
  font-size: 3rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}
</style>
