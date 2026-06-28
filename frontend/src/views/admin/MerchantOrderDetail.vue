<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { orderApi } from '@/api/order'
import type { OrderVO } from '@/types/api'

const route = useRoute()
const router = useRouter()
const order = ref<OrderVO | null>(null)
const loading = ref(false)

async function fetchDetail() {
  loading.value = true
  try {
    order.value = await orderApi.getMerchantDetail(Number(route.params.id))
  } finally {
    loading.value = false
  }
}

async function handleShip() {
  try {
    await ElMessageBox.confirm('确认发货该订单？')
    await orderApi.ship(order.value!.id)
    ElMessage.success('已标记为发货')
    fetchDetail()
  } catch { /* cancelled */ }
}

onMounted(fetchDetail)
</script>

<template>
  <div class="order-detail" v-loading="loading">
    <div class="breadcrumb">
      <span class="breadcrumb-link" @click="router.push('/home')">首页</span>
      <span class="breadcrumb-sep">/</span>
      <span class="breadcrumb-link" @click="router.push('/merchant/orders')">销售订单</span>
      <span class="breadcrumb-sep">/</span>
      <span class="breadcrumb-current">订单详情</span>
    </div>

    <div v-if="order" class="detail-card">
      <div class="detail-header">
        <h2>订单详情</h2>
        <el-tag :type="order.status === 4 ? 'danger' : order.status === 0 ? 'warning' : order.status === 3 ? 'success' : 'primary'" size="large">
          {{ order.statusDesc }}
        </el-tag>
      </div>

      <div class="info-section">
        <h3>订单信息</h3>
        <p><span class="label">订单编号：</span>{{ order.orderNo }}</p>
        <p><span class="label">创建时间：</span>{{ order.createdAt }}</p>
        <p><span class="label">收货地址：</span>{{ order.address }}</p>
        <p v-if="order.remark"><span class="label">备注：</span>{{ order.remark }}</p>
      </div>

      <div class="items-section">
        <h3>商品信息</h3>
        <div v-for="item in order.items" :key="item.id" class="order-item">
          <img :src="item.productImage" class="item-img" @error="($event.target as HTMLImageElement).src = 'data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%2280%22 height=%2280%22%3E%3Crect fill=%22%23f0f0f0%22 width=%2280%22 height=%2280%22/%3E%3C/svg%3E'" />
          <div class="item-info">
            <p class="item-name">{{ item.productName }}</p>
            <p class="item-price">¥{{ item.price }} × {{ item.quantity }}</p>
          </div>
          <p class="item-subtotal">¥{{ (item.price * item.quantity).toFixed(2) }}</p>
        </div>
      </div>

      <div class="total-section">
        <span>合计：<em>¥{{ order.totalAmount }}</em></span>
      </div>

      <div v-if="order.status === 1" class="action-section">
        <el-button type="primary" size="large" @click="handleShip">发货</el-button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.order-detail {
  max-width: 800px;
}
.back-btn {
  margin-bottom: 16px;
}
.detail-card {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
}
.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 2px solid #eee;
}
.info-section {
  margin-bottom: 24px;
}
.info-section h3,
.items-section h3 {
  margin-bottom: 12px;
  font-size: 16px;
}
.info-section p {
  margin-bottom: 8px;
  color: #666;
  font-size: 14px;
}
.label {
  color: #999;
}
.order-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 12px 0;
  border-top: 1px solid #f0f0f0;
}
.item-img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 4px;
}
.item-info {
  flex: 1;
}
.item-name {
  font-size: 15px;
  margin-bottom: 4px;
}
.item-price {
  color: #999;
  font-size: 13px;
}
.item-subtotal {
  font-weight: bold;
  color: #e74c3c;
}
.total-section {
  text-align: right;
  padding: 16px 0;
  font-size: 16px;
}
.total-section em {
  font-size: 24px;
  font-style: normal;
  color: #e74c3c;
  font-weight: bold;
}
.action-section {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding-top: 16px;
  border-top: 1px solid #eee;
}
</style>
