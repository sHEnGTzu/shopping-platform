<script setup lang="ts">
import AppHeader from '@/layout/AppHeader.vue'
</script>

<template>
  <div class="app">
    <AppHeader />
    <main class="main-content">
      <router-view />
    </main>
  </div>
</template>

<style>
@import '@/assets/global.css';
.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 24px 20px 60px;
  min-height: calc(100vh - 64px);
  animation: fadeIn 0.4s ease;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(12px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>

