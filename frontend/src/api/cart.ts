import http from '@/utils/http'
import type { CartVO } from '@/types/api'

export const cartApi = {
  getList() {
    return http.get<CartVO[]>('/cart')
  },
  add(data: { productId: number; quantity?: number }) {
    return http.post<CartVO>('/cart', data)
  },
  update(id: number, data: { quantity: number }) {
    return http.put<CartVO>(`/cart/${id}`, data)
  },
  remove(id: number) {
    return http.delete(`/cart/${id}`)
  },
}
