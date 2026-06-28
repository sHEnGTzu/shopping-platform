<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useCartStore } from '@/stores/cart'

const router = useRouter()
const userStore = useUserStore()
const cartStore = useCartStore()

onMounted(() => {
  if (localStorage.getItem('token')) {
    userStore.fetchUser()
    cartStore.fetchCart()
  }
})

function handleLogout() {
  userStore.logout()
  router.push('/auth/login')
}
</script>

<template>
  <header class="app-header">
    <div class="header-inner">
      <div class="logo" @click="router.push('/home')">
        <span class="logo-icon">◆</span>
        <span>优品商城</span>
      </div>
      <nav class="nav">
        <router-link to="/home">
          <span class="nav-icon">🏠</span> 首页
        </router-link>
        <router-link to="/cart">
          <span class="nav-icon">🛒</span> 购物车
          <span v-if="cartStore.count > 0" class="cart-badge">{{ cartStore.count > 99 ? '99+' : cartStore.count }}</span>
        </router-link>
        <router-link to="/orders">
          <span class="nav-icon">📋</span> 我的订单
        </router-link>
        <router-link v-if="userStore.isAdmin || userStore.isMerchant" to="/admin/products">
          <span class="nav-icon">📦</span> 商品管理
        </router-link>
        <router-link v-if="userStore.isAdmin" to="/admin/orders">
          <span class="nav-icon">🔧</span> 订单管理
        </router-link>
        <router-link v-if="userStore.isMerchant" to="/merchant/orders">
          <span class="nav-icon">📊</span> 销售订单
        </router-link>
      </nav>
      <div class="user-area">
        <template v-if="userStore.user">
          <div class="user-profile">
            <div class="avatar">{{ userStore.user.username.charAt(0) }}</div>
            <div class="user-info">
              <span class="username">{{ userStore.user.username }}</span>
              <el-tag size="small" :type="userStore.isAdmin ? 'warning' : userStore.isMerchant ? 'success' : 'info'"
                class="role-tag">
                {{ userStore.isAdmin ? '管理员' : userStore.isMerchant ? '商家' : '买家' }}
              </el-tag>
            </div>
          </div>
          <el-button class="logout-btn" text @click="handleLogout">退出</el-button>
        </template>
        <template v-else>
          <el-button class="header-btn" @click="router.push('/auth/login')">登录</el-button>
          <el-button class="header-btn primary" @click="router.push('/auth/register')">注册</el-button>
        </template>
      </div>
    </div>
  </header>
</template>

<style scoped>
.app-header {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(232, 236, 244, 0.8);
}
.header-inner {
  max-width: 1200px;
  margin: 0 auto;
  height: 64px;
  display: flex;
  align-items: center;
  padding: 0 24px;
}
.logo {
  font-size: 22px;
  font-weight: 800;
  cursor: pointer;
  margin-right: 48px;
  display: flex;
  align-items: center;
  gap: 10px;
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  user-select: none;
}
.logo-icon {
  font-size: 26px;
  -webkit-text-fill-color: initial;
  color: var(--primary);
}
.nav {
  flex: 1;
  display: flex;
  gap: 4px;
}
.nav a {
  color: var(--text-secondary);
  text-decoration: none;
  font-size: 14px;
  padding: 8px 16px;
  border-radius: 8px;
  transition: all 0.25s ease;
  position: relative;
  font-weight: 500;
}
.nav a:hover {
  color: var(--primary);
  background: rgba(102, 126, 234, 0.08);
}
.nav a.router-link-active {
  color: var(--primary);
  background: rgba(102, 126, 234, 0.1);
}
.nav-icon {
  font-size: 15px;
  margin-right: 4px;
}
.cart-badge {
  position: absolute;
  top: 2px;
  right: 4px;
  background: var(--accent);
  color: #fff;
  font-size: 11px;
  min-width: 18px;
  height: 18px;
  border-radius: 9px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 4px;
  font-weight: 600;
  box-shadow: 0 2px 6px rgba(245, 87, 108, 0.4);
}
.user-area {
  display: flex;
  align-items: center;
  gap: 12px;
}
.user-profile {
  display: flex;
  align-items: center;
  gap: 10px;
}
.avatar {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: var(--gradient-primary);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
}
.user-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.username {
  color: var(--text-primary);
  font-size: 13px;
  font-weight: 600;
  line-height: 1;
}
.role-tag {
  align-self: flex-start;
  font-size: 11px !important;
  padding: 0 6px !important;
  height: 18px !important;
  line-height: 18px !important;
}
.logout-btn {
  color: var(--text-muted) !important;
  font-size: 13px !important;
  padding: 6px 12px !important;
  border-radius: 6px !important;
  transition: all 0.2s !important;
}
.logout-btn:hover {
  color: var(--accent) !important;
  background: rgba(245, 87, 108, 0.08) !important;
}
.header-btn {
  border-radius: 8px !important;
  padding: 7px 20px !important;
  font-size: 14px !important;
  border: 1px solid var(--border-color) !important;
  color: var(--text-secondary) !important;
  transition: all 0.25s ease !important;
}
.header-btn:hover {
  border-color: var(--primary) !important;
  color: var(--primary) !important;
  background: rgba(102, 126, 234, 0.06) !important;
}
.header-btn.primary {
  background: var(--gradient-primary) !important;
  color: #fff !important;
  border: none !important;
}
.header-btn.primary:hover {
  box-shadow: var(--shadow-glow) !important;
  transform: translateY(-1px);
}
</style>
