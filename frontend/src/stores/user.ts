import { defineStore } from 'pinia'
import { computed, ref } from 'vue'
import type { UserVO } from '@/types/api'
import { userApi } from '@/api/user'

export const useUserStore = defineStore('user', () => {
  const user = ref<UserVO | null>(null)

  const isAdmin = computed(() => user.value?.role === 'admin')
  const isMerchant = computed(() => user.value?.role === 'merchant')
  const isBuyer = computed(() => user.value?.role === 'buyer')
  const roleLabel = computed(() => {
    const map: Record<string, string> = { admin: '管理员', merchant: '商家', buyer: '买家' }
    return user.value ? map[user.value.role] || user.value.role : ''
  })

  async function fetchUser() {
    try {
      user.value = await userApi.getProfile()
    } catch {
      user.value = null
    }
  }

  function setUser(data: UserVO) {
    user.value = data
  }

  function logout() {
    user.value = null
    localStorage.removeItem('token')
  }

  return { user, isAdmin, isMerchant, isBuyer, roleLabel, fetchUser, setUser, logout }
})
