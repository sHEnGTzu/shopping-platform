import http from '@/utils/http'
import type { LoginVO, UserVO } from '@/types/api'

export const authApi = {
  login(data: { username: string; password: string }) {
    return http.post<LoginVO>('/auth/login', data)
  },
  register(data: { username: string; password: string; email?: string; phone?: string; role?: string }) {
    return http.post<UserVO>('/auth/register', data)
  },
}
