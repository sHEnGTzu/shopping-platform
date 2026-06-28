import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { CartVO } from '@/types/api'
import { cartApi } from '@/api/cart'

export const useCartStore = defineStore('cart', () => {
  const items = ref<CartVO[]>([])
  const count = ref(0)

  async function fetchCart() {
    try {
      items.value = await cartApi.getList()
      count.value = items.value.length
    } catch {
      items.value = []
      count.value = 0
    }
  }

  return { items, count, fetchCart }
})
