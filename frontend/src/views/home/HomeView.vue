<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { productApi } from '@/api/product'
import { cartApi } from '@/api/cart'
import { useCartStore } from '@/stores/cart'
import type { Category, ProductVO } from '@/types/api'

const router = useRouter()
const cartStore = useCartStore()

const categories = ref<Category[]>([])
const products = ref<ProductVO[]>([])
const currentCategory = ref<number>()
const keyword = ref('')
const loading = ref(false)
const total = ref(0)
const pageNum = ref(1)
const pageSize = 12

async function fetchCategories() {
  try {
    categories.value = await productApi.getCategories()
  } catch {
    // ignore
  }
}

async function fetchProducts() {
  loading.value = true
  try {
    const res = await productApi.getPage({
      pageNum: pageNum.value,
      pageSize,
      categoryId: currentCategory.value,
      keyword: keyword.value || undefined,
    })
    products.value = res.records
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function onSearch() {
  pageNum.value = 1
  fetchProducts()
}

function selectCategory(id?: number) {
  currentCategory.value = id
  pageNum.value = 1
  fetchProducts()
}

async function addCart(productId: number) {
  try {
    await cartApi.add({ productId, quantity: 1 })
    await cartStore.fetchCart()
    ElMessage.success('已加入购物车')
  } catch {
    // handled by interceptor
  }
}

function categoryEmoji(name: string): string {
  const map: Record<string, string> = {
    '电子产品': '💻', '服装鞋帽': '👗', '食品饮料': '🍵', '图书音像': '📚', '家居用品': '🛋️'
  }
  return map[name] || '📦'
}

onMounted(() => {
  fetchCategories()
  fetchProducts()
})
</script>

<template>
  <div class="home">
    <!-- Hero Search Section -->
    <div class="hero-section">
      <div class="hero-content">
        <h1 class="hero-title">发现好物，品质生活</h1>
        <p class="hero-subtitle">精选优质商品，一站式购物体验</p>
        <div class="search-bar">
          <div class="search-wrapper">
            <span class="search-icon">🔍</span>
            <el-input v-model="keyword" placeholder="搜一搜你想要的商品…" class="search-input" clearable @keyup.enter="onSearch" />
          </div>
          <el-button type="primary" class="search-btn" @click="onSearch">搜索</el-button>
        </div>
      </div>
    </div>

    <!-- Categories -->
    <div class="section">
      <div class="section-header">
        <h2 class="section-title">
          <span class="title-accent">商品分类</span>
        </h2>
        <span class="section-count">{{ categories.length }} 个分类</span>
      </div>
      <div class="categories">
        <div
          class="category-item"
          :class="{ active: currentCategory === undefined }"
          @click="selectCategory()"
        >
          <span class="category-emoji">🎯</span>
          <span class="category-name">全部</span>
        </div>
        <div
          v-for="cat in categories" :key="cat.id"
          class="category-item"
          :class="{ active: currentCategory === cat.id }"
          @click="selectCategory(cat.id)"
        >
          <span class="category-emoji">{{ categoryEmoji(cat.name) }}</span>
          <span class="category-name">{{ cat.name }}</span>
        </div>
      </div>
    </div>

    <!-- Products -->
    <div class="section">
      <div class="section-header">
        <h2 class="section-title">
          <span class="title-accent">{{ currentCategory ? (categories.find(c => c.id === currentCategory)?.name || '商品') : '全部商品' }}</span>
        </h2>
        <span class="section-count">共 {{ total }} 件</span>
      </div>

      <el-row :gutter="20" v-loading="loading">
        <el-col v-for="product in products" :key="product.id" :xs="12" :sm="8" :md="6" :lg="6" class="product-col">
          <div class="product-card" @click="router.push(`/products/${product.id}`)">
            <div class="product-img-wrap">
              <img :src="product.image" class="product-img" loading="lazy"
                @error="($event.target as HTMLImageElement).src = 'data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23f0f0f0%22 width=%22200%22 height=%22200%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 text-anchor=%22middle%22 dy=%22.3em%22 fill=%22%23ccc%22 font-size=%2214%22%3E暂无图片%3C/text%3E%3C/svg%3E'" />
              <div class="product-overlay">
                <span class="overlay-btn">查看详情</span>
              </div>
            </div>
            <div class="product-info">
              <h3 class="product-name">{{ product.name }}</h3>
              <div class="product-meta">
                <span class="product-price">
                  <span class="price-symbol">¥</span>{{ product.price }}
                </span>
                <span class="product-sales">已售 {{ product.sales }}</span>
              </div>
            </div>
            <button class="add-cart-btn" @click.stop="addCart(product.id)">
              <span class="btn-icon">+</span>
            </button>
          </div>
        </el-col>
      </el-row>

      <div v-if="!loading && products.length === 0" class="empty">
        <span class="empty-icon">📭</span>
        <p>暂无商品</p>
        <el-button text @click="selectCategory()">查看全部商品</el-button>
      </div>

      <div class="pagination" v-if="total > pageSize">
        <el-pagination
          v-model:current-page="pageNum"
          :page-size="pageSize"
          :total="total"
          layout="prev, pager, next"
          @current-change="fetchProducts"
          background
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Hero Section */
.hero-section {
  background: var(--gradient-primary);
  border-radius: var(--radius-lg);
  padding: 48px 40px;
  margin-bottom: 28px;
  position: relative;
  overflow: hidden;
}
.hero-section::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -20%;
  width: 500px;
  height: 500px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.06);
}
.hero-section::after {
  content: '';
  position: absolute;
  bottom: -30%;
  left: 10%;
  width: 300px;
  height: 300px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.04);
}
.hero-content {
  position: relative;
  z-index: 1;
}
.hero-title {
  color: #fff;
  font-size: 32px;
  font-weight: 800;
  margin-bottom: 8px;
}
.hero-subtitle {
  color: rgba(255, 255, 255, 0.7);
  font-size: 16px;
  margin-bottom: 28px;
}
.search-bar {
  display: flex;
  gap: 12px;
  max-width: 600px;
}
.search-wrapper {
  flex: 1;
  display: flex;
  align-items: center;
  background: #fff;
  border-radius: 12px;
  padding: 0 16px;
  gap: 8px;
}
.search-icon {
  font-size: 18px;
}
.search-input {
  flex: 1;
}
.search-input :deep(.el-input__wrapper) {
  border: none !important;
  box-shadow: none !important;
  background: transparent !important;
  padding: 0 !important;
}
.search-input :deep(.el-input__inner) {
  height: 48px;
  font-size: 15px;
}
.search-btn {
  height: 48px !important;
  padding: 0 32px !important;
  font-size: 15px !important;
  border-radius: 12px !important;
  background: rgba(255, 255, 255, 0.2) !important;
  backdrop-filter: blur(10px);
  color: #fff !important;
  font-weight: 600;
}
.search-btn:hover {
  background: rgba(255, 255, 255, 0.3) !important;
  box-shadow: none !important;
  transform: none !important;
}

/* Sections */
.section {
  background: var(--bg-white);
  border-radius: var(--radius-lg);
  padding: 28px;
  margin-bottom: 24px;
  box-shadow: var(--shadow-sm);
}
.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}
.section-title {
  font-size: 18px;
  font-weight: 700;
}
.title-accent {
  position: relative;
}
.title-accent::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 100%;
  height: 3px;
  border-radius: 2px;
  background: var(--gradient-primary);
  opacity: 0.3;
}
.section-count {
  color: var(--text-muted);
  font-size: 13px;
}

/* Categories */
.categories {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}
.category-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  padding: 16px 24px;
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: all 0.3s ease;
  background: var(--bg-hover);
  min-width: 100px;
}
.category-item:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-sm);
}
.category-item.active {
  background: var(--gradient-primary);
  color: #fff;
}
.category-emoji {
  font-size: 24px;
}
.category-name {
  font-size: 13px;
  font-weight: 500;
  white-space: nowrap;
}

/* Product Cards */
.product-col {
  margin-bottom: 20px;
}
.product-card {
  background: var(--bg-white);
  border-radius: var(--radius-md);
  overflow: hidden;
  cursor: pointer;
  transition: all 0.35s ease;
  position: relative;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);
  border: 1px solid var(--border-color);
}
.product-card:hover {
  transform: translateY(-6px);
  box-shadow: var(--shadow-lg);
  border-color: transparent;
}
.product-img-wrap {
  position: relative;
  overflow: hidden;
  aspect-ratio: 1;
  background: #f8f9ff;
}
.product-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}
.product-card:hover .product-img {
  transform: scale(1.08);
}
.product-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.3);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}
.product-card:hover .product-overlay {
  opacity: 1;
}
.overlay-btn {
  background: rgba(255, 255, 255, 0.9);
  color: var(--text-primary);
  padding: 8px 20px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 600;
  backdrop-filter: blur(10px);
}
.product-info {
  padding: 14px 16px 16px;
}
.product-name {
  font-size: 14px;
  font-weight: 600;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-bottom: 8px;
  color: var(--text-primary);
}
.product-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.product-price {
  color: var(--accent);
  font-size: 20px;
  font-weight: 800;
}
.price-symbol {
  font-size: 13px;
}
.product-sales {
  color: var(--text-muted);
  font-size: 12px;
}
.add-cart-btn {
  position: absolute;
  top: 12px;
  right: 12px;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.25s ease;
  opacity: 0;
  transform: scale(0.8);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}
.product-card:hover .add-cart-btn {
  opacity: 1;
  transform: scale(1);
}
.add-cart-btn:hover {
  background: var(--gradient-primary);
  color: #fff;
  transform: scale(1.1) !important;
}
.btn-icon {
  font-size: 18px;
  font-weight: 600;
  line-height: 1;
}

/* Empty & Pagination */
.empty {
  text-align: center;
  padding: 60px 0;
  color: var(--text-muted);
}
.empty-icon {
  font-size: 48px;
  display: block;
  margin-bottom: 12px;
}
.empty p {
  font-size: 15px;
  margin-bottom: 8px;
}
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 24px;
}
</style>
