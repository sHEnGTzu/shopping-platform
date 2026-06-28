<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { orderApi } from '@/api/order'
import type { OrderVO } from '@/types/api'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const orders = ref<OrderVO[]>([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const statusFilter = ref<number | undefined>()
const loading = ref(false)

const isMerchantMode = computed(() => route.name === 'MerchantOrders')
const pageTitle = computed(() => isMerchantMode.value ? '销售订单' : '订单管理')

const statusOptions = [
  { value: undefined, label: '全部' },
  { value: 0, label: '待支付' },
  { value: 1, label: '已支付' },
  { value: 2, label: '已发货' },
  { value: 3, label: '已完成' },
  { value: 4, label: '已取消' },
]

async function loadData() {
  loading.value = true
  try {
    let res
    if (isMerchantMode.value) {
      res = await orderApi.getMerchantPage({ pageNum: pageNum.value, pageSize: pageSize.value, status: statusFilter.value })
    } else {
      res = await orderApi.getAdminPage({ pageNum: pageNum.value, pageSize: pageSize.value, status: statusFilter.value })
    }
    orders.value = res.records
    total.value = res.total
  } finally {
    loading.value = false
  }
}

async function handleShip(order: OrderVO) {
  try {
    await ElMessageBox.confirm(`确认发货订单 ${order.orderNo}？`)
    await orderApi.ship(order.id)
    ElMessage.success('已标记为发货')
    loadData()
  } catch { /* cancelled */ }
}

async function handleUpdateStatus(order: OrderVO) {
  const nextStatus = order.status === 0 ? 1 : order.status === 1 ? 2 : order.status === 2 ? 3 : -1
  const labels: Record<number, string> = { 0: '待支付', 1: '已支付', 2: '已发货', 3: '已完成', '-1': '已取消' }
  if (!isMerchantMode.value && order.status < 3 && order.status >= 0) {
    const nextLabel = labels[nextStatus]
    try {
      await ElMessageBox.confirm(`确认将订单 ${order.orderNo} 状态更新为「${nextLabel}」？`)
      await orderApi.updateStatus(order.id, nextStatus)
      ElMessage.success('状态更新成功')
      loadData()
    } catch { /* cancelled */ }
  }
}

onMounted(loadData)
</script>

<template>
  <div class="order-manage">
    <div class="page-title">
      <span class="page-title-icon">{{ route.name === 'MerchantOrders' ? '📊' : '🔧' }}</span>
      <h2>{{ pageTitle }}</h2>
      <div style="flex:1"></div>
      <el-select v-model="statusFilter" placeholder="订单状态" clearable style="width: 140px" @change="loadData">
        <el-option v-for="opt in statusOptions" :key="String(opt.value)" :label="opt.label" :value="opt.value" />
      </el-select>
    </div>

    <el-table :data="orders" v-loading="loading" stripe style="width: 100%">
      <el-table-column prop="orderNo" label="订单号" width="200" />
      <el-table-column label="金额" width="120">
        <template #default="{ row }">¥{{ row.totalAmount }}</template>
      </el-table-column>
      <el-table-column prop="statusDesc" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 4 ? 'danger' : row.status === 0 ? 'warning' : row.status === 3 ? 'success' : 'primary'">
            {{ row.statusDesc }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="商品" min-width="200">
        <template #default="{ row }">
          <div v-for="item in row.items" :key="item.id" class="order-item-info">
            {{ item.productName }} × {{ item.quantity }}
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="createdAt" label="创建时间" width="180" />
      <el-table-column label="操作" width="140" fixed="right">
        <template #default="{ row }">
          <!-- 商家：已支付可发货 -->
          <el-button v-if="isMerchantMode && row.status === 1" size="small" type="primary" @click="handleShip(row)">
            发货
          </el-button>
          <!-- 管理员：按流程更新状态 -->
          <el-button v-if="!isMerchantMode && row.status < 3 && row.status >= 0" size="small" type="primary" @click="handleUpdateStatus(row)">
            更新状态
          </el-button>
          <el-button v-if="isMerchantMode && row.status >= 1" size="small" @click="router.push(`/merchant/orders-detail/${row.id}`)">
            查看
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <div class="pagination-wrap">
      <el-pagination
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :total="total"
        layout="prev, pager, next"
        @current-change="loadData"
      />
    </div>
  </div>
</template>

<style scoped>
.order-manage {
  background: var(--bg-white);
  border-radius: var(--radius-lg);
  padding: 28px;
  box-shadow: var(--shadow-sm);
}
.page-title {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 24px;
}
.page-title h2 {
  font-size: 22px;
  font-weight: 700;
}
.page-title-icon {
  font-size: 24px;
}
.pagination-wrap {
  margin-top: 24px;
  display: flex;
  justify-content: center;
}
.order-item-info {
  font-size: 13px;
  color: var(--text-muted);
  line-height: 1.6;
}
</style>
