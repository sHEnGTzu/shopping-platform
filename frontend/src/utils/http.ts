import axios from 'axios'
import type { AxiosResponse } from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import type { Result } from '@/types/api'

const instance = axios.create({
  baseURL: '/api',
  timeout: 15000,
})

instance.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

instance.interceptors.response.use(
  (response: AxiosResponse<Result<any>>) => {
    const res = response.data
    if (res.code !== 200) {
      ElMessage.error(res.message || '请求失败')
      if (res.code === 401) {
        localStorage.removeItem('token')
        router.push('/auth/login')
      }
      return Promise.reject(new Error(res.message))
    }
    return response
  },
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      router.push('/auth/login')
      ElMessage.error('登录已过期，请重新登录')
    } else {
      ElMessage.error(error.message || '网络错误')
    }
    return Promise.reject(error)
  },
)

const http = {
  get<T>(url: string, config?: { params?: Record<string, any> }) {
    return instance.get<Result<T>>(url, config).then((res) => res.data.data) as Promise<T>
  },
  post<T>(url: string, data?: any, config?: { params?: Record<string, any> }) {
    return instance.post<Result<T>>(url, data, config).then((res) => res.data.data) as Promise<T>
  },
  put<T>(url: string, data?: any, config?: { params?: Record<string, any> }) {
    return instance.put<Result<T>>(url, data, config).then((res) => res.data.data) as Promise<T>
  },
  delete<T = void>(url: string, config?: { params?: Record<string, any> }) {
    return instance.delete<Result<T>>(url, config).then((res) => res.data.data) as Promise<T>
  },
}

export default http
