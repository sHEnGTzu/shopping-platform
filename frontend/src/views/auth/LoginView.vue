<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { authApi } from '@/api/auth'
import { useUserStore } from '@/stores/user'
import { useCartStore } from '@/stores/cart'

const router = useRouter()
const userStore = useUserStore()
const cartStore = useCartStore()

const form = ref({ username: '', password: '' })
const loading = ref(false)

async function handleLogin() {
  if (!form.value.username || !form.value.password) {
    ElMessage.warning('请填写用户名和密码')
    return
  }
  loading.value = true
  try {
    const data = await authApi.login(form.value)
    localStorage.setItem('token', data.token)
    userStore.setUser(data.user)
    await cartStore.fetchCart()
    ElMessage.success('登录成功')
    router.push('/home')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="auth-page">
    <div class="auth-bg-decoration"></div>
    <div class="auth-card-wrap">
      <div class="auth-brand">
        <span class="brand-icon">◆</span>
        <span class="brand-text">优品商城</span>
      </div>
      <div class="auth-card">
        <h2 class="auth-title">欢迎回来</h2>
        <p class="auth-desc">登录您的账户继续购物</p>
        <el-form label-position="top" @submit.prevent="handleLogin" class="auth-form">
          <el-form-item label="用户名">
            <el-input v-model="form.username" placeholder="请输入用户名" prefix-icon="User" size="large" />
          </el-form-item>
          <el-form-item label="密码">
            <el-input v-model="form.password" type="password" show-password placeholder="请输入密码" prefix-icon="Lock" size="large" />
          </el-form-item>
          <el-button type="primary" :loading="loading" class="auth-btn" size="large" @click="handleLogin">
            登录
          </el-button>
        </el-form>
        <div class="auth-footer">
          还没有账号？<router-link to="/auth/register">立即注册 →</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.auth-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 112px);
  position: relative;
  overflow: hidden;
}
.auth-bg-decoration {
  position: absolute;
  top: -200px;
  left: -200px;
  width: 500px;
  height: 500px;
  border-radius: 50%;
  background: var(--gradient-primary);
  opacity: 0.05;
  pointer-events: none;
}
.auth-bg-decoration::after {
  content: '';
  position: absolute;
  bottom: -300px;
  right: -200px;
  width: 400px;
  height: 400px;
  border-radius: 50%;
  background: var(--gradient-accent);
  opacity: 0.05;
}
.auth-card-wrap {
  width: 420px;
  position: relative;
}
.auth-brand {
  text-align: center;
  margin-bottom: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}
.brand-icon {
  font-size: 32px;
  color: var(--primary);
}
.brand-text {
  font-size: 26px;
  font-weight: 800;
  background: var(--gradient-primary);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.auth-card {
  background: var(--bg-white);
  border-radius: var(--radius-xl);
  padding: 40px 36px;
  box-shadow: var(--shadow-lg);
  border: 1px solid rgba(232, 236, 244, 0.6);
}
.auth-title {
  font-size: 24px;
  font-weight: 700;
  text-align: center;
  margin-bottom: 6px;
}
.auth-desc {
  color: var(--text-muted);
  text-align: center;
  font-size: 14px;
  margin-bottom: 28px;
}
.auth-form {
  margin-bottom: 4px;
}
.auth-form :deep(.el-form-item__label) {
  font-weight: 600;
  color: var(--text-secondary);
  font-size: 13px;
  padding-bottom: 4px;
}
.auth-form :deep(.el-input__wrapper) {
  border-radius: 10px;
  padding: 4px 16px;
}
.auth-form :deep(.el-input__inner) {
  height: 44px;
}
.auth-btn {
  width: 100%;
  height: 46px !important;
  border-radius: 10px !important;
  font-size: 16px !important;
  font-weight: 600 !important;
  margin-top: 8px;
}
.auth-footer {
  text-align: center;
  margin-top: 24px;
  font-size: 14px;
  color: var(--text-muted);
}
.auth-footer a {
  color: var(--primary);
  text-decoration: none;
  font-weight: 600;
  transition: color 0.2s;
}
.auth-footer a:hover {
  color: var(--secondary);
}
</style>
