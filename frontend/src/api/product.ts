import http from '@/utils/http'
import type { PageResult, ProductVO, Category } from '@/types/api'

export interface ProductSaveDTO {
  name: string
  description?: string
  image?: string
  images?: string
  price: number
  stock: number
  categoryId?: number
}

export const productApi = {
  getCategories() {
    return http.get<Category[]>('/categories')
  },
  getPage(params: { pageNum?: number; pageSize?: number; categoryId?: number; keyword?: string; sortBy?: string }) {
    return http.get<PageResult<ProductVO>>('/products/page', { params })
  },
  getDetail(id: number) {
    return http.get<ProductVO>(`/products/detail/${id}`)
  },
  getManagePage(params: { pageNum?: number; pageSize?: number }) {
    return http.get<PageResult<ProductVO>>('/products/manage/page', { params })
  },
  create(data: ProductSaveDTO) {
    return http.post<number>('/products/manage', data)
  },
  update(id: number, data: ProductSaveDTO) {
    return http.put<void>(`/products/manage/${id}`, data)
  },
  delete(id: number) {
    return http.delete<void>(`/products/manage/${id}`)
  },
}
