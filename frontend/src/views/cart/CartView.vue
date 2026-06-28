<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { cartApi } from '@/api/cart'
import { useCartStore } from '@/stores/cart'
import type { CartVO } from '@/types/api'

const router = useRouter()
const cartStore = useCartStore()

const items = ref<CartVO[]>([])
const loading = ref(false)
const selectedIds = ref<number[]>([])

const totalAmount = computed(() => {
  return items.value
    .filter((item) => selectedIds.value.includes(item.id))
    .reduce((sum, item) => sum + item.price * item.quantity, 0)
})

async function fetchCart() {
  loading.value = true
  try {
    items.value = await cartApi.getList()
    cartStore.count = items.value.length
    selectedIds.value = items.value.map((i) => i.id)
  } finally {
    loading.value = false
  }
}

async function updateQuantity(item: CartVO) {
  try {
    await cartApi.update(item.id, { quantity: item.quantity })
    await cartStore.fetchCart()
    fetchCart()
  } catch {
    fetchCart()
  }
}

async function removeItem(id: number) {
  try {
    await cartApi.remove(id)
    await cartStore.fetchCart()
    fetchCart()
    ElMessage.success('已删除')
  } catch {
    // handled
  }
}

function toggleSelectAll(checked: boolean) {
  selectedIds.value = checked ? items.value.map((i) => i.id) : []
}

function isAllSelected() {
  return items.value.length > 0 && selectedIds.value.length === items.value.length
}

function goCheckout() {
  if (selectedIds.value.length === 0) {
    ElMessage.warning('请选择要结算的商品')
    return
  }
  router.push({ name: 'Checkout' })
}

onMounted(fetchCart)
</script>

<template>
  <div class="cart-page">
    <div class="page-header">
      <h2 class="page-title">
        <span class="page-title-icon">🛒</span>
        购物车
      </h2>
      <span class="page-count" v-if="items.length > 0">{{ items.length }} 件商品</span>
    </div>

    <div v-if="items.length === 0" class="empty-cart">
      <span class="empty-icon">🛒</span>
      <p>购物车是空的</p>
      <el-button type="primary" @click="router.push('/home')">去逛逛</el-button>
    </div>

    <template v-else>
      <div class="cart-toolbar">
        <el-checkbox :model-value="isAllSelected()" @change="toggleSelectAll" class="select-all">
          全选 ({{ selectedIds.length }}/{{ items.length }})
        </el-checkbox>
        <span class="toolbar-hint">点击图片或名称查看商品详情</span>
      </div>

      <div class="cart-items">
        <div v-for="item in items" :key="item.id" class="cart-item" :class="{ selected: selectedIds.includes(item.id) }">
          <el-checkbox v-model="selectedIds" :value="item.id" class="item-checkbox" />
          <div class="item-img-wrap" @click="router.push(`/products/${item.productId}`)">
            <img :src="item.productImage" class="item-img"
              @error="($event.target as HTMLImageElement).src = 'data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%2280%22 height=%2280%22%3E%3Crect fill=%22%23f0f0f0%22 width=%2280%22 height=%2280%22/%3E%3C/svg%3E'" />
          </div>
          <div class="item-info" @click="router.push(`/products/${item.productId}`)">
            <p class="item-name">{{ item.productName }}</p>
            <p class="item-price-tag">¥{{ item.price }}</p>
          </div>
          <div class="item-qty">
            <el-input-number v-model="item.quantity" :min="1" :max="item.stock" size="small" @change="updateQuantity(item)" />
          </div>
          <div class="item-subtotal">
            <span class="subtotal-label">小计</span>
            <span class="subtotal-value">¥{{ (item.price * item.quantity).toFixed(2) }}</span>
          </div>
          <button class="item-remove" @click="removeItem(item.id)">
            <span>✕</span>
          </button>
        </div>
      </div>

      <div class="cart-footer">
        <div class="footer-left">
          <el-checkbox :model-value="isAllSelected()" @change="toggleSelectAll">
            全选
          </el-checkbox>
          <span class="selected-info">已选 {{ selectedIds.length }} 件</span>
        </div>
        <div class="footer-right">
          <div class="total-wrap">
            <span class="total-label">合计：</span>
            <span class="total-value">¥{{ totalAmount.toFixed(2) }}</span>
          </div>
          <el-button type="primary" size="large" class="checkout-btn" :disabled="selectedIds.length === 0" @click="goCheckout">
            立即结算
          </el-button>
        </div>
      </div>
    </template>
  </div>
</template>

<style scoped>
.cart-page {
  background: var(--bg-white);
  border-radius: var(--radius-lg);
  padding: 28px;
  box-shadow: var(--shadow-sm);
}
.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
}
.page-title {
  font-size: 22px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 10px;
}
.page-title-icon {
  font-size: 24px;
}
.page-count {
  color: var(--text-muted);
  font-size: 14px;
}
.empty-cart {
  text-align: center;
  padding: 80px 0;
  color: var(--text-muted);
}
.empty-icon {
  font-size: 64px;
  display: block;
  margin-bottom: 16px;
  opacity: 0.3;
}
.empty-cart p {
  font-size: 16px;
  margin-bottom: 16px;
}

/* Toolbar */
.cart-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
  padding: 0 4px;
}
.select-all {
  font-size: 14px;
  font-weight: 500;
}
.toolbar-hint {
  color: var(--text-muted);
  font-size: 12px;
}

/* Cart Items */
.cart-items {
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  overflow: hidden;
}
.cart-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px 20px;
  border-bottom: 1px solid var(--border-color);
  transition: background 0.2s;
}
.cart-item:last-child {
  border-bottom: none;
}
.cart-item:hover {
  background: var(--bg-hover);
}
.cart-item.selected {
  background: rgba(102, 126, 234, 0.03);
}
.item-checkbox {
  flex-shrink: 0;
}
.item-img-wrap {
  width: 80px;
  height: 80px;
  border-radius: 10px;
  overflow: hidden;
  flex-shrink: 0;
  cursor: pointer;
  background: #f8f9ff;
  border: 1px solid var(--border-color);
}
.item-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}
.item-img-wrap:hover .item-img {
  transform: scale(1.08);
}
.item-info {
  flex: 1;
  cursor: pointer;
  min-width: 0;
}
.item-name {
  font-size: 15px;
  font-weight: 600;
  margin-bottom: 6px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: var(--text-primary);
}
.item-price-tag {
  color: var(--accent);
  font-size: 16px;
  font-weight: 700;
}
.item-qty {
  flex-shrink: 0;
}
.item-subtotal {
  min-width: 100px;
  text-align: right;
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.subtotal-label {
  font-size: 11px;
  color: var(--text-muted);
}
.subtotal-value {
  font-size: 16px;
  font-weight: 700;
  color: var(--accent);
}
.item-remove {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  border: none;
  background: transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #ccc;
  transition: all 0.2s;
  flex-shrink: 0;
  font-size: 14px;
}
.item-remove:hover {
  background: rgba(245, 87, 108, 0.1);
  color: var(--accent);
}

/* Footer */
.cart-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  padding: 20px 24px;
  background: var(--bg-hover);
  border-radius: var(--radius-md);
}
.footer-left {
  display: flex;
  align-items: center;
  gap: 16px;
}
.selected-info {
  color: var(--text-muted);
  font-size: 13px;
}
.footer-right {
  display: flex;
  align-items: center;
  gap: 24px;
}
.total-wrap {
  display: flex;
  align-items: baseline;
  gap: 4px;
}
.total-label {
  font-size: 15px;
  color: var(--text-secondary);
}
.total-value {
  font-size: 28px;
  font-weight: 800;
  color: var(--accent);
}
.checkout-btn {
  height: 48px !important;
  padding: 0 36px !important;
  font-size: 16px !important;
  font-weight: 600 !important;
  border-radius: 12px !important;
}
</style>
