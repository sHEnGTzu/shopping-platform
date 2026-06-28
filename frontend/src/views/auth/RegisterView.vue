<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { authApi } from '@/api/auth'

const router = useRouter()
const form = ref({ username: '', password: '', confirmPassword: '', email: '', phone: '', role: 'buyer' })
const loading = ref(false)

async function handleRegister() {
  if (!form.value.username || !form.value.password) {
    ElMessage.warning('请填写用户名和密码')
    return
  }
  if (form.value.password !== form.value.confirmPassword) {
    ElMessage.warning('两次密码输入不一致')
    return
  }
  loading.value = true
  try {
    await authApi.register({
      username: form.value.username,
      password: form.value.password,
      email: form.value.email || undefined,
      phone: form.value.phone || undefined,
      role: form.value.role,
    })
    ElMessage.success('注册成功，请登录')
    router.push('/auth/login')
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
        <h2 class="auth-title">创建账号</h2>
        <p class="auth-desc">注册成为新用户，开启购物之旅</p>
        <el-form label-position="top" class="auth-form">
          <el-form-item label="用户名" required>
            <el-input v-model="form.username" placeholder="请输入用户名" prefix-icon="User" size="large" />
          </el-form-item>
          <el-form-item label="密码" required>
            <el-input v-model="form.password" type="password" show-password placeholder="请输入密码" prefix-icon="Lock" size="large" />
          </el-form-item>
          <el-form-item label="确认密码" required>
            <el-input v-model="form.confirmPassword" type="password" show-password placeholder="请确认密码" prefix-icon="Lock" size="large" />
          </el-form-item>
          <el-form-item label="注册角色">
            <div class="role-selector">
              <div class="role-option" :class="{ active: form.role === 'buyer' }" @click="form.role = 'buyer'">
                <span class="role-emoji">👤</span>
                <span class="role-label">买家</span>
                <span class="role-desc">购物消费</span>
              </div>
              <div class="role-option" :class="{ active: form.role === 'merchant' }" @click="form.role = 'merchant'">
                <span class="role-emoji">🏪</span>
                <span class="role-label">商家</span>
                <span class="role-desc">开店卖货</span>
              </div>
            </div>
          </el-form-item>
          <el-form-item label="邮箱">
            <el-input v-model="form.email" placeholder="请输入邮箱" prefix-icon="Message" size="large" />
          </el-form-item>
          <el-form-item label="手机号">
            <el-input v-model="form.phone" placeholder="请输入手机号" prefix-icon="Phone" size="large" />
          </el-form-item>
          <el-button type="primary" :loading="loading" class="auth-btn" size="large" @click="handleRegister">
            注册
          </el-button>
        </el-form>
        <div class="auth-footer">
          已有账号？<router-link to="/auth/login">立即登录 →</router-link>
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
  padding: 36px 32px;
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
  margin-bottom: 24px;
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
.role-selector {
  display: flex;
  gap: 12px;
}
.role-option {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 14px 12px;
  border-radius: var(--radius-md);
  border: 2px solid var(--border-color);
  cursor: pointer;
  transition: all 0.25s ease;
}
.role-option:hover {
  border-color: var(--primary-light);
  background: rgba(102, 126, 234, 0.04);
}
.role-option.active {
  border-color: var(--primary);
  background: rgba(102, 126, 234, 0.06);
}
.role-emoji {
  font-size: 26px;
}
.role-label {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
}
.role-desc {
  font-size: 11px;
  color: var(--text-muted);
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
  margin-top: 20px;
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
