import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    redirect: '/home',
  },
  {
    path: '/auth',
    redirect: '/auth/login',
    children: [
      {
        path: 'login',
        name: 'Login',
        component: () => import('@/views/auth/LoginView.vue'),
        meta: { title: '登录' },
      },
      {
        path: 'register',
        name: 'Register',
        component: () => import('@/views/auth/RegisterView.vue'),
        meta: { title: '注册' },
      },
    ],
  },
  {
    path: '/home',
    name: 'Home',
    component: () => import('@/views/home/HomeView.vue'),
    meta: { title: '首页' },
  },
  {
    path: '/products/:id',
    name: 'ProductDetail',
    component: () => import('@/views/product/ProductDetail.vue'),
    meta: { title: '商品详情' },
  },
  {
    path: '/cart',
    name: 'Cart',
    component: () => import('@/views/cart/CartView.vue'),
    meta: { title: '购物车' },
  },
  {
    path: '/checkout',
    name: 'Checkout',
    component: () => import('@/views/order/CheckoutView.vue'),
    meta: { title: '确认订单' },
  },
  {
    path: '/orders',
    name: 'Orders',
    component: () => import('@/views/order/OrderList.vue'),
    meta: { title: '我的订单' },
  },
  {
    path: '/orders/:id',
    name: 'OrderDetail',
    component: () => import('@/views/order/OrderDetail.vue'),
    meta: { title: '订单详情' },
  },
  {
    path: '/admin/products',
    name: 'ProductManage',
    component: () => import('@/views/admin/ProductManage.vue'),
    meta: { title: '商品管理' },
  },
  {
    path: '/admin/orders',
    name: 'AdminOrders',
    component: () => import('@/views/admin/OrderManage.vue'),
    meta: { title: '订单管理' },
  },
  {
    path: '/merchant/orders',
    name: 'MerchantOrders',
    component: () => import('@/views/admin/OrderManage.vue'),
    meta: { title: '商家订单' },
  },
  {
    path: '/merchant/orders-detail/:id',
    name: 'MerchantOrderDetail',
    component: () => import('@/views/admin/MerchantOrderDetail.vue'),
    meta: { title: '订单详情' },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

const publicPages = ['Login', 'Register', 'Home', 'ProductDetail']

router.beforeEach((to, _from, next) => {
  document.title = `${to.meta.title || '商城'} - 在线商城`
  const token = localStorage.getItem('token')
  if (!token && !publicPages.includes(to.name as string)) {
    next({ name: 'Login' })
  } else {
    next()
  }
})

export default router
