<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { orderApi } from '@/api/order'
import type { OrderVO } from '@/types/api'

const router = useRouter()
const orders = ref<OrderVO[]>([])
const loading = ref(false)
const statusFilter = ref<number>()
const pageNum = ref(1)
const pageSize = 10
const total = ref(0)

const statusOptions = [
  { value: undefined, label: '全部' },
  { value: 0, label: '待支付' },
  { value: 1, label: '已支付' },
  { value: 2, label: '已发货' },
  { value: 3, label: '已完成' },
  { value: 4, label: '已取消' },
]

async function fetchOrders() {
  loading.value = true
  try {
    const res = await orderApi.getPage({
      pageNum: pageNum.value,
      pageSize,
      status: statusFilter.value,
    })
    orders.value = res.records
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function filterByStatus(status?: number) {
  statusFilter.value = status
  pageNum.value = 1
  fetchOrders()
}

const statusMap: Record<number, string> = {
  0: '待支付',
  1: '已支付',
  2: '已发货',
  3: '已完成',
  4: '已取消',
}

const statusTypeMap: Record<number, string> = {
  0: 'warning',
  1: 'success',
  2: 'primary',
  3: 'info',
  4: 'danger',
}

onMounted(fetchOrders)
</script>

<template>
  <div class="orders-page">
    <div class="page-header">
      <h2 class="page-title">
        <span class="page-title-icon">📋</span>
        我的订单
      </h2>
    </div>

    <div class="status-tabs">
      <el-tag
        v-for="opt in statusOptions"
        :key="opt.value ?? 'all'"
        :type="statusFilter === opt.value ? 'primary' : 'info'"
        class="status-tag"
        @click="filterByStatus(opt.value)"
      >
        {{ opt.label }}
      </el-tag>
    </div>

    <div v-loading="loading">
      <div v-for="order in orders" :key="order.id" class="order-card" @click="router.push(`/orders/${order.id}`)">
        <div class="order-header">
          <span class="order-no">订单号: {{ order.orderNo }}</span>
          <el-tag :type="statusTypeMap[order.status] || 'info'" size="small">
            {{ order.statusDesc }}
          </el-tag>
        </div>
        <div class="order-items">
          <div v-for="item in order.items" :key="item.id" class="order-item">
            <img :src="item.productImage" class="item-img" @error="($event.target as HTMLImageElement).src = 'data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%2260%22 height=%2260%22%3E%3Crect fill=%22%23f0f0f0%22 width=%2260%22 height=%2260%22/%3E%3C/svg%3E'" />
            <div class="item-info">
              <p class="item-name">{{ item.productName }}</p>
              <p class="item-price">¥{{ item.price }} × {{ item.quantity }}</p>
            </div>
          </div>
        </div>
        <div class="order-footer">
          <span class="order-total">合计: ¥{{ order.totalAmount }}</span>
          <span class="order-time">{{ order.createdAt }}</span>
        </div>
      </div>
    </div>

    <div v-if="!loading && orders.length === 0" class="empty">
      暂无订单
    </div>

    <div class="pagination" v-if="total > pageSize">
      <el-pagination
        v-model:current-page="pageNum"
        :page-size="pageSize"
        :total="total"
        layout="prev, pager, next"
        @current-change="fetchOrders"
      />
    </div>
  </div>
</template>

<style scoped>
.orders-page {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
}
.page-title {
  margin-bottom: 20px;
}
.status-tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
}
.status-tag {
  cursor: pointer;
}
.order-card {
  border: 1px solid #eee;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 16px;
  cursor: pointer;
  transition: box-shadow 0.2s;
}
.order-card:hover {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}
.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}
.order-no {
  font-size: 14px;
  color: #666;
}
.order-items {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 12px;
}
.order-item {
  display: flex;
  align-items: center;
  gap: 12px;
}
.item-img {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 4px;
}
.item-info {
  flex: 1;
}
.item-name {
  font-size: 14px;
  margin-bottom: 4px;
}
.item-price {
  font-size: 13px;
  color: #999;
}
.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid #f0f0f0;
}
.order-total {
  font-weight: bold;
  color: #e74c3c;
}
.order-time {
  color: #999;
  font-size: 13px;
}
.empty {
  text-align: center;
  padding: 60px 0;
  color: #999;
}
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}
</style>
