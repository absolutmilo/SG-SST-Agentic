<template>
  <div class="min-h-screen bg-body">
    <Navbar />
    
    <!-- Main Content Area -->
    <main class="pt-4 min-h-screen transition-all duration-300">
      <div class="p-8 max-w-7xl mx-auto">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </div>
    </main>
  </div>
</template>

<script setup>
import Navbar from '../components/layout/Navbar.vue'
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
