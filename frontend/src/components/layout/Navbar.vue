<template>
  <div class="navbar">
    <div class="navbar-left">
      <div class="navbar-brand">
        <h1>
          <i class="fas fa-robot"></i>
          <span class="brand-text">SG-SST Agent</span>
        </h1>
      </div>

      <!-- Navigation Tabs -->
      <nav class="nav-tabs">
        <router-link 
          v-for="item in navItems" 
          :key="item.path" 
          :to="item.path"
          class="nav-tab"
          active-class="active"
        >
          <i :class="item.icon"></i>
          <span>{{ item.name }}</span>
        </router-link>
      </nav>
    </div>

    <div class="navbar-actions">
      <div class="notification-wrapper" ref="notificationWrapper">
        <button class="notification-btn" @click="toggleNotifications" :class="{ active: showNotifications }">
          <i class="fas fa-bell"></i>
          <span v-if="unreadCount > 0" class="badge">{{ unreadCount }}</span>
        </button>

        <!-- Notification Dropdown/Modal -->
        <div v-if="showNotifications" class="notification-dropdown">
          <div class="dropdown-header">
            <h3>Notificaciones</h3>
            <button v-if="unreadCount > 0" @click="markAllRead" class="mark-read-btn">
              Marcar todo como leído
            </button>
          </div>
          
          <div class="notification-list">
            <div v-if="notifications.length === 0" class="empty-state">
              <i class="fas fa-bell-slash"></i>
              <p>No tienes notificaciones nuevas</p>
            </div>
            
            <div 
              v-for="notification in notifications" 
              :key="notification.id" 
              class="notification-item"
              :class="{ unread: !notification.read }"
              @click="markAsRead(notification)"
            >
              <div class="notification-icon" :class="notification.type">
                <i :class="getNotificationIcon(notification.type)"></i>
              </div>
              <div class="notification-content">
                <p class="notification-text">{{ notification.message }}</p>
                <span class="notification-time">{{ formatTime(notification.timestamp) }}</span>
              </div>
            </div>
          </div>
          
          <div class="dropdown-footer">
            <button @click="viewAllNotifications">Ver todas</button>
          </div>
        </div>
      </div>
      
      <div class="user-profile" ref="userProfileWrapper">
        <div class="user-menu-trigger" @click="toggleUserMenu">
          <div class="avatar">
            <span>{{ userInitials }}</span>
          </div>
          <div class="user-info">
            <span class="user-name">{{ user.name }}</span>
            <i class="fas fa-chevron-down" :class="{ 'rotate': showUserMenu }"></i>
          </div>
        </div>
        
        <!-- User Dropdown Menu -->
        <div v-if="showUserMenu" class="user-dropdown">
          <div class="user-dropdown-header">
            <div class="avatar-large">
              <span>{{ userInitials }}</span>
            </div>
            <div class="user-details">
              <p class="user-full-name">{{ user.name }}</p>
              <p class="user-email">{{ user.email || 'usuario@empresa.com' }}</p>
            </div>
          </div>
          
          <div class="user-dropdown-menu">
            <button @click="goToProfile" class="menu-item">
              <i class="fas fa-user"></i>
              <span>Mi Perfil</span>
            </button>
            <button @click="goToSettings" class="menu-item">
              <i class="fas fa-cog"></i>
              <span>Configuración</span>
            </button>
            <div class="menu-divider"></div>
            <button @click="handleLogout" class="menu-item logout">
              <i class="fas fa-sign-out-alt"></i>
              <span>Cerrar Sesión</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Navbar',
  props: {
    user: {
      type: Object,
      default: () => ({ name: 'Usuario' })
    }
  },
  data() {
    return {
      showNotifications: false,
      showUserMenu: false,
      navItems: [
        { name: 'Dashboard', path: '/', icon: 'fas fa-chart-line' },
        { name: 'Tareas', path: '/tasks', icon: 'fas fa-tasks' },
        { name: 'Formularios', path: '/forms', icon: 'fas fa-clipboard-list' },
        { name: 'Reportes', path: '/reports', icon: 'fas fa-file-alt' },
        { name: 'Empleados', path: '/employees', icon: 'fas fa-users' },
        { name: 'Agentes IA', path: '/agentic', icon: 'fas fa-robot' }
      ],
      notifications: [
        {
          id: 1,
          type: 'alert',
          message: 'Alerta: Extintores vencidos en Área de Producción',
          timestamp: new Date(Date.now() - 1000 * 60 * 30), // 30 mins ago
          read: false
        },
        {
          id: 2,
          type: 'task',
          message: 'Nueva tarea asignada: Revisión de matriz de riesgos',
          timestamp: new Date(Date.now() - 1000 * 60 * 60 * 2), // 2 hours ago
          read: false
        },
        {
          id: 3,
          type: 'info',
          message: 'El reporte mensual ha sido generado exitosamente',
          timestamp: new Date(Date.now() - 1000 * 60 * 60 * 24), // 1 day ago
          read: true
        }
      ]
    }
  },
  computed: {
    unreadCount() {
      return this.notifications.filter(n => !n.read).length
    },
    userInitials() {
      if (!this.user || !this.user.name) return 'U'
      return this.user.name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase()
    }
  },
  mounted() {
    document.addEventListener('click', this.handleClickOutside)
  },
  beforeUnmount() {
    document.removeEventListener('click', this.handleClickOutside)
  },
  methods: {
    toggleNotifications() {
      this.showNotifications = !this.showNotifications
      this.showUserMenu = false
    },
    toggleUserMenu() {
      this.showUserMenu = !this.showUserMenu
      this.showNotifications = false
    },
    handleClickOutside(event) {
      if (this.$refs.notificationWrapper && !this.$refs.notificationWrapper.contains(event.target)) {
        this.showNotifications = false
      }
      if (this.$refs.userProfileWrapper && !this.$refs.userProfileWrapper.contains(event.target)) {
        this.showUserMenu = false
      }
    },
    markAsRead(notification) {
      notification.read = true
    },
    markAllRead() {
      this.notifications.forEach(n => n.read = true)
    },
    viewAllNotifications() {
      this.showNotifications = false
      this.$router.push('/alerts')
    },
    goToProfile() {
      this.showUserMenu = false
      this.$router.push('/profile')
    },
    goToSettings() {
      this.showUserMenu = false
      this.$router.push('/settings')
    },
    handleLogout() {
      this.showUserMenu = false
      // Clear auth token
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      // Redirect to login
      this.$router.push('/login')
    },
    getNotificationIcon(type) {
      const icons = {
        alert: 'fas fa-exclamation-circle',
        task: 'fas fa-tasks',
        info: 'fas fa-info-circle',
        success: 'fas fa-check-circle'
      }
      return icons[type] || 'fas fa-bell'
    },
    formatTime(date) {
      const now = new Date()
      const diff = now - date
      
      if (diff < 1000 * 60) return 'Hace un momento'
      if (diff < 1000 * 60 * 60) return `Hace ${Math.floor(diff / (1000 * 60))} min`
      if (diff < 1000 * 60 * 60 * 24) return `Hace ${Math.floor(diff / (1000 * 60 * 60))} h`
      return date.toLocaleDateString()
    }
  }
}
</script>

<style scoped>
.navbar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 0 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  height: 70px;
  position: sticky;
  top: 0;
  z-index: 100;
}

.navbar-left {
  display: flex;
  align-items: center;
  gap: 3rem;
  height: 100%;
}

.navbar-brand h1 {
  margin: 0;
  font-size: 1.4rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.nav-tabs {
  display: flex;
  height: 100%;
}

.nav-tab {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0 1.25rem;
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  font-weight: 500;
  height: 100%;
  transition: all 0.2s;
  border-bottom: 3px solid transparent;
}

.nav-tab:hover {
  color: white;
  background: rgba(255, 255, 255, 0.1);
}

.nav-tab.active {
  color: white;
  border-bottom-color: #fff;
  background: rgba(255, 255, 255, 0.1);
}

.nav-tab i {
  font-size: 1rem;
}

.navbar-actions {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.notification-wrapper {
  position: relative;
}

.notification-btn {
  background: rgba(255, 255, 255, 0.2);
  border: none;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  color: white;
  cursor: pointer;
  position: relative;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
}

.notification-btn:hover, .notification-btn.active {
  background: rgba(255, 255, 255, 0.3);
  transform: scale(1.05);
}

.badge {
  position: absolute;
  top: -5px;
  right: -5px;
  background: #f56565;
  color: white;
  font-size: 0.7rem;
  font-weight: bold;
  padding: 2px 6px;
  border-radius: 10px;
  border: 2px solid #764ba2;
}

.notification-dropdown {
  position: absolute;
  top: 120%;
  right: -10px;
  width: 350px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
  color: #2d3748;
  z-index: 1000;
  overflow: hidden;
  animation: slideDown 0.2s ease-out;
}

@keyframes slideDown {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

.dropdown-header {
  padding: 1rem;
  border-bottom: 1px solid #e2e8f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dropdown-header h3 {
  margin: 0;
  font-size: 1rem;
  font-weight: 600;
}

.mark-read-btn {
  background: none;
  border: none;
  color: #667eea;
  font-size: 0.8rem;
  cursor: pointer;
}

.mark-read-btn:hover {
  text-decoration: underline;
}

.notification-list {
  max-height: 300px;
  overflow-y: auto;
}

.empty-state {
  padding: 2rem;
  text-align: center;
  color: #a0aec0;
}

.empty-state i {
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.notification-item {
  padding: 1rem;
  display: flex;
  gap: 1rem;
  border-bottom: 1px solid #f7fafc;
  cursor: pointer;
  transition: background 0.2s;
}

.notification-item:hover {
  background: #f7fafc;
}

.notification-item.unread {
  background: #ebf4ff;
}

.notification-icon {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.notification-icon.alert { background: #fed7d7; color: #e53e3e; }
.notification-icon.task { background: #bee3f8; color: #3182ce; }
.notification-icon.info { background: #e2e8f0; color: #718096; }
.notification-icon.success { background: #c6f6d5; color: #38a169; }

.notification-content {
  flex: 1;
}

.notification-text {
  margin: 0 0 0.25rem 0;
  font-size: 0.9rem;
  line-height: 1.4;
}

.notification-time {
  font-size: 0.75rem;
  color: #a0aec0;
}

.dropdown-footer {
  padding: 0.75rem;
  border-top: 1px solid #e2e8f0;
  text-align: center;
  background: #f7fafc;
}

.dropdown-footer button {
  background: none;
  border: none;
  color: #667eea;
  font-weight: 600;
  font-size: 0.9rem;
  cursor: pointer;
}

.user-profile {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  position: relative;
}

.user-menu-trigger {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  cursor: pointer;
  padding: 0.5rem;
  border-radius: 8px;
  transition: background 0.2s;
}

.user-menu-trigger:hover {
  background: rgba(255, 255, 255, 0.1);
}

.avatar {
  width: 36px;
  height: 36px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  border: 2px solid rgba(255, 255, 255, 0.4);
}

.user-info {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.user-name {
  font-size: 0.9rem;
  font-weight: 500;
}

.user-info i {
  font-size: 0.7rem;
  transition: transform 0.2s;
}

.user-info i.rotate {
  transform: rotate(180deg);
}

.user-dropdown {
  position: absolute;
  top: 120%;
  right: 0;
  width: 280px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
  color: #2d3748;
  z-index: 1000;
  overflow: hidden;
  animation: slideDown 0.2s ease-out;
}

.user-dropdown-header {
  padding: 1.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.avatar-large {
  width: 48px;
  height: 48px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 1.2rem;
  border: 2px solid rgba(255, 255, 255, 0.4);
}

.user-details {
  flex: 1;
}

.user-full-name {
  margin: 0;
  font-weight: 600;
  font-size: 1rem;
}

.user-email {
  margin: 0.25rem 0 0 0;
  font-size: 0.8rem;
  opacity: 0.9;
}

.user-dropdown-menu {
  padding: 0.5rem 0;
}

.menu-item {
  width: 100%;
  padding: 0.75rem 1.5rem;
  border: none;
  background: none;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  cursor: pointer;
  transition: background 0.2s;
  font-size: 0.9rem;
  color: #2d3748;
  text-align: left;
}

.menu-item:hover {
  background: #f7fafc;
}

.menu-item i {
  width: 20px;
  color: #718096;
}

.menu-item.logout {
  color: #e53e3e;
}

.menu-item.logout i {
  color: #e53e3e;
}

.menu-divider {
  height: 1px;
  background: #e2e8f0;
  margin: 0.5rem 0;
}
</style>
