export interface Result<T> {
  code: number
  message: string
  data: T
}

export interface PageResult<T> {
  records: T[]
  total: number
  pageNum: number
  pageSize: number
}

export interface UserVO {
  id: number
  username: string
  email: string
  phone: string
  avatar: string
  role: string
  createdAt: string
}

export interface LoginVO {
  token: string
  user: UserVO
}

export interface Category {
  id: number
  name: string
  image: string
}

export interface ProductVO {
  id: number
  name: string
  description: string
  image: string
  images: string[]
  price: number
  stock: number
  sales: number
  categoryId: number
  categoryName: string
  userId: number
  userName: string
  createdAt: string
}

export interface CartVO {
  id: number
  productId: number
  productName: string
  productImage: string
  price: number
  quantity: number
  stock: number
}

export interface OrderVO {
  id: number
  orderNo: string
  totalAmount: number
  status: number
  statusDesc: string
  address: string
  remark: string
  items: OrderItemVO[]
  createdAt: string
}

export interface OrderItemVO {
  id: number
  productId: number
  productName: string
  productImage: string
  price: number
  quantity: number
}
