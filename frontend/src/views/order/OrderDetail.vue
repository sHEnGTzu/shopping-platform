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
const acting = ref(false)

async function fetchDetail() {
  loading.value = true
  try {
    order.value = await orderApi.getDetail(Number(route.params.id))
  } finally {
    loading.value = false
  }
}

async function cancelOrder() {
  try {
    await ElMessageBox.confirm('确定要取消该订单吗？')
    acting.value = true
    await orderApi.cancel(Number(route.params.id))
    ElMessage.success('订单已取消')
    fetchDetail()
  } catch {
    // cancelled or error
  } finally {
    acting.value = false
  }
}

async function payOrder() {
  try {
    await ElMessageBox.confirm('确认支付该订单吗？', '支付确认')
    acting.value = true
    await orderApi.pay(Number(route.params.id))
    ElMessage.success('支付成功！等待商家发货')
    fetchDetail()
  } catch {
    // cancelled or error
  } finally {
    acting.value = false
  }
}

async function confirmReceipt() {
  try {
    await ElMessageBox.confirm('确认收到货了吗？', '确认收货')
    acting.value = true
    await orderApi.confirmReceipt(Number(route.params.id))
    ElMessage.success('确认收货成功，感谢您的购买！')
    fetchDetail()
  } catch {
    // cancelled or error
  } finally {
    acting.value = false
  }
}

onMounted(fetchDetail)
</script>

<template>
  <div class="order-detail" v-loading="loading">
    <div class="breadcrumb">
      <span class="breadcrumb-link" @click="router.push('/home')">首页</span>
      <span class="breadcrumb-sep">/</span>
      <span class="breadcrumb-link" @click="router.push('/orders')">我的订单</span>
      <span class="breadcrumb-sep">/</span>
      <span class="breadcrumb-current">订单详情</span>
    </div>

    <div v-if="order" class="detail-card">
      <div class="detail-header">
        <h2>订单详情</h2>
        <el-tag :type="order.status === 0 ? 'warning' : order.status === 4 ? 'danger' : 'success'" size="large">
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

      <div class="action-section">
        <!-- 待支付：显示付款 + 取消 -->
        <template v-if="order.status === 0">
          <el-button type="danger" @click="cancelOrder" :disabled="acting">取消订单</el-button>
          <el-button type="primary" size="large" @click="payOrder" :loading="acting">立即付款</el-button>
        </template>
        <!-- 已支付：显示等待发货提示 -->
        <template v-if="order.status === 1">
          <el-tag type="warning" size="large">已支付，等待商家发货</el-tag>
        </template>
        <!-- 已发货：显示确认收货 -->
        <template v-if="order.status === 2">
          <el-button type="primary" size="large" @click="confirmReceipt" :loading="acting">确认收货</el-button>
        </template>
        <!-- 已完成 -->
        <template v-if="order.status === 3">
          <el-tag type="success" size="large">交易完成，感谢购买！</el-tag>
        </template>
        <!-- 已取消 -->
        <template v-if="order.status === 4">
          <el-tag type="danger" size="large">订单已取消</el-tag>
        </template>
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
