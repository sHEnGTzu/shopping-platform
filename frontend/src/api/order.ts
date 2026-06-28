import http from '@/utils/http'
import type { PageResult, OrderVO } from '@/types/api'

export const orderApi = {
  create(data: { cartItemIds: number[]; address: string; remark?: string }) {
    return http.post<OrderVO>('/orders', data)
  },
  getPage(params: { pageNum?: number; pageSize?: number; status?: number }) {
    return http.get<PageResult<OrderVO>>('/orders', { params })
  },
  getDetail(id: number) {
    return http.get<OrderVO>(`/orders/${id}`)
  },
  cancel(id: number) {
    return http.put(`/orders/${id}/cancel`)
  },
  pay(id: number) {
    return http.put(`/orders/${id}/pay`)
  },
  confirmReceipt(id: number) {
    return http.put(`/orders/${id}/confirm`)
  },
  getAdminPage(params: { pageNum?: number; pageSize?: number; status?: number }) {
    return http.get<PageResult<OrderVO>>('/orders/admin/page', { params })
  },
  getAdminDetail(id: number) {
    return http.get<OrderVO>(`/orders/admin/${id}`)
  },
  updateStatus(id: number, status: number) {
    return http.put(`/orders/admin/${id}/status`, null, { params: { status } })
  },
  getMerchantPage(params: { pageNum?: number; pageSize?: number; status?: number }) {
    return http.get<PageResult<OrderVO>>('/orders/merchant/page', { params })
  },
  getMerchantDetail(id: number) {
    return http.get<OrderVO>(`/orders/merchant/${id}`)
  },
  ship(id: number) {
    return http.put(`/orders/merchant/${id}/ship`)
  },
}
