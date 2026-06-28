<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { productApi } from '@/api/product'
import { cartApi } from '@/api/cart'
import { useCartStore } from '@/stores/cart'
import type { ProductVO } from '@/types/api'

const route = useRoute()
const router = useRouter()
const cartStore = useCartStore()

const product = ref<ProductVO | null>(null)
const quantity = ref(1)
const loading = ref(false)

async function fetchDetail() {
  loading.value = true
  try {
    product.value = await productApi.getDetail(Number(route.params.id))
  } finally {
    loading.value = false
  }
}

async function addCart() {
  if (!product.value) return
  try {
    await cartApi.add({ productId: product.value.id, quantity: quantity.value })
    await cartStore.fetchCart()
    ElMessage.success('已加入购物车')
  } catch {
    // handled
  }
}

function buyNow() {
  if (!product.value) return
  cartApi.add({ productId: product.value.id, quantity: quantity.value }).then(() => {
    cartStore.fetchCart()
    router.push('/cart')
  })
}

onMounted(fetchDetail)
</script>

<template>
  <div class="product-detail" v-loading="loading">
    <div class="breadcrumb">
      <span class="breadcrumb-link" @click="router.push('/home')">首页</span>
      <span class="breadcrumb-sep">/</span>
      <span class="breadcrumb-link" @click="router.go(-1)">商品</span>
      <span class="breadcrumb-sep">/</span>
      <span class="breadcrumb-current">{{ product?.name }}</span>
    </div>

    <div v-if="product" class="detail-content">
      <div class="detail-images">
        <div class="image-frame">
          <el-image :src="product.image" fit="contain" class="main-image">
            <template #error>
              <div class="image-placeholder">暂无图片</div>
            </template>
          </el-image>
        </div>
      </div>
      <div class="detail-info">
        <div class="info-header">
          <h1 class="detail-name">{{ product.name }}</h1>
          <el-tag v-if="product.sales > 0" size="small" type="danger" class="hot-tag">热卖</el-tag>
        </div>
        <p class="detail-desc">{{ product.description }}</p>

        <div class="price-card">
          <div class="price-main">
            <span class="price-symbol">¥</span>
            <span class="price-value">{{ product.price }}</span>
          </div>
          <div class="price-original" v-if="product.price > 100">¥{{ (product.price * 1.2).toFixed(0) }}</div>
        </div>

        <div class="detail-meta">
          <div class="meta-item">
            <span class="meta-icon">📦</span>
            <span>库存 <em>{{ product.stock }}</em></span>
          </div>
          <div class="meta-item">
            <span class="meta-icon">🔥</span>
            <span>已售 <em>{{ product.sales }}</em></span>
          </div>
          <div class="meta-item">
            <span class="meta-icon">🏷️</span>
            <span>{{ product.categoryName }}</span>
          </div>
        </div>

        <div class="quantity-selector">
          <span class="label">数量</span>
          <el-input-number v-model="quantity" :min="1" :max="product.stock" size="large" />
          <span class="stock-hint">库存 {{ product.stock }} 件</span>
        </div>

        <div class="detail-actions">
          <el-button type="primary" size="large" class="action-btn add-cart" @click="addCart">
            🛒 加入购物车
          </el-button>
          <el-button type="danger" size="large" class="action-btn buy-now" @click="buyNow">
            ⚡ 立即购买
          </el-button>
        </div>

        <div class="safe-badge">
          <span>🔒 安全交易</span>
          <span>🚚 极速发货</span>
          <span>💯 正品保障</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.product-detail {
  background: var(--bg-white);
  border-radius: var(--radius-lg);
  padding: 28px;
  box-shadow: var(--shadow-sm);
}
.breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 24px;
  font-size: 13px;
}
.breadcrumb-link {
  color: var(--text-muted);
  cursor: pointer;
  transition: color 0.2s;
}
.breadcrumb-link:hover {
  color: var(--primary);
}
.breadcrumb-sep {
  color: #ddd;
}
.breadcrumb-current {
  color: var(--text-secondary);
  font-weight: 500;
}
.detail-content {
  display: flex;
  gap: 48px;
}
.detail-images {
  flex: 1;
  max-width: 480px;
}
.image-frame {
  background: linear-gradient(135deg, #f8f9ff, #f0f2f8);
  border-radius: var(--radius-lg);
  overflow: hidden;
  border: 1px solid var(--border-color);
}
.main-image {
  width: 100%;
  height: 400px;
}
.detail-info {
  flex: 1;
  max-width: 520px;
}
.info-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 8px;
}
.detail-name {
  font-size: 24px;
  font-weight: 700;
  line-height: 1.3;
}
.hot-tag {
  flex-shrink: 0;
}
.detail-desc {
  color: var(--text-muted);
  font-size: 15px;
  line-height: 1.7;
  margin-bottom: 20px;
}
.price-card {
  display: inline-flex;
  align-items: baseline;
  gap: 12px;
  background: linear-gradient(135deg, #fff5f5, #fff0f0);
  border-radius: var(--radius-md);
  padding: 16px 24px;
  margin-bottom: 20px;
}
.price-main {
  color: var(--accent);
}
.price-symbol {
  font-size: 18px;
  font-weight: 600;
}
.price-value {
  font-size: 36px;
  font-weight: 800;
}
.price-original {
  color: #ccc;
  font-size: 18px;
  text-decoration: line-through;
}
.detail-meta {
  display: flex;
  gap: 24px;
  margin-bottom: 24px;
}
.meta-item {
  display: flex;
  align-items: center;
  gap: 6px;
  color: var(--text-secondary);
  font-size: 14px;
  background: var(--bg-hover);
  padding: 8px 16px;
  border-radius: 8px;
}
.meta-icon {
  font-size: 16px;
}
.meta-item em {
  font-style: normal;
  font-weight: 600;
  color: var(--text-primary);
}
.quantity-selector {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 28px;
  padding: 16px 0;
  border-top: 1px solid var(--border-color);
  border-bottom: 1px solid var(--border-color);
}
.label {
  color: var(--text-secondary);
  font-weight: 600;
  font-size: 14px;
}
.stock-hint {
  color: var(--text-muted);
  font-size: 13px;
}
.detail-actions {
  display: flex;
  gap: 16px;
  margin-bottom: 20px;
}
.action-btn {
  flex: 1;
  height: 52px !important;
  font-size: 16px !important;
  font-weight: 600 !important;
  border-radius: 12px !important;
  letter-spacing: 0.5px;
}
.add-cart {
  background: #fff !important;
  color: var(--primary) !important;
  border: 2px solid var(--primary) !important;
  transition: all 0.25s ease !important;
}
.add-cart:hover {
  background: rgba(102, 126, 234, 0.06) !important;
  box-shadow: none !important;
  transform: none !important;
}
.buy-now {
  background: var(--gradient-accent) !important;
}
.safe-badge {
  display: flex;
  gap: 24px;
  padding: 12px 16px;
  background: var(--bg-hover);
  border-radius: 8px;
  font-size: 13px;
  color: var(--text-muted);
}
.image-placeholder {
  width: 100%;
  height: 400px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
  color: #ccc;
  font-size: 16px;
}
</style>
