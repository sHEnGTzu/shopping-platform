import http from '@/utils/http'
import type { UserVO } from '@/types/api'

export const userApi = {
  getProfile() {
    return http.get<UserVO>('/users/me')
  },
  updateProfile(data: { email?: string; phone?: string; avatar?: string }) {
    return http.put<UserVO>('/users/me', data)
  },
}
