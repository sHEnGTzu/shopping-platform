<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { cartApi } from '@/api/cart'
import { orderApi } from '@/api/order'
import { useCartStore } from '@/stores/cart'
import type { CartVO } from '@/types/api'

const router = useRouter()
const cartStore = useCartStore()

const items = ref<CartVO[]>([])
const loading = ref(false)
const submitting = ref(false)
const address = ref('')
const remark = ref('')

const totalAmount = computed(() => {
  return items.value.reduce((sum, item) => sum + item.price * item.quantity, 0)
})

async function fetchCheckedItems() {
  loading.value = true
  try {
    const all = await cartApi.getList()
    items.value = all
    if (items.value.length === 0) {
      ElMessage.warning('购物车为空')
      router.replace('/cart')
    }
  } finally {
    loading.value = false
  }
}

async function submitOrder() {
  if (!address.value.trim()) {
    ElMessage.warning('请填写收货地址')
    return
  }
  submitting.value = true
  try {
    const cartItemIds = items.value.map((i) => i.id)
    await orderApi.create({ cartItemIds, address: address.value.trim(), remark: remark.value || undefined })
    ElMessage.success('下单成功！')
    await cartStore.fetchCart()
    router.push('/orders')
  } finally {
    submitting.value = false
  }
}

onMounted(fetchCheckedItems)
</script>

<template>
  <div class="checkout-page">
    <div class="page-header">
      <h2 class="page-title">
        <span class="page-title-icon">📝</span>
        确认订单
      </h2>
    </div>

    <div v-if="loading" class="loading-wrap">
      <el-skeleton :rows="3" animated />
    </div>

    <template v-else-if="items.length > 0">
      <el-card class="section" shadow="never">
        <template #header><span>收货地址</span></template>
        <el-input
          v-model="address"
          type="textarea"
          :rows="2"
          placeholder="请输入收货地址（必填）"
        />
      </el-card>

      <el-card class="section" shadow="never">
        <template #header><span>商品信息</span></template>
        <div v-for="item in items" :key="item.id" class="checkout-item">
          <img
            :src="item.productImage"
            class="item-img"
            @error="($event.target as HTMLImageElement).src = 'data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%2260%22 height=%2260%22%3E%3Crect fill=%22%23f0f0f0%22 width=%2260%22 height=%2260%22/%3E%3C/svg%3E'"
          />
          <div class="item-info">
            <p class="item-name">{{ item.productName }}</p>
            <p class="item-price">¥{{ item.price }} × {{ item.quantity }}</p>
          </div>
          <p class="item-subtotal">¥{{ (item.price * item.quantity).toFixed(2) }}</p>
        </div>
      </el-card>

      <el-card class="section" shadow="never">
        <template #header><span>备注</span></template>
        <el-input v-model="remark" placeholder="选填：订单备注信息" />
      </el-card>

      <div class="checkout-footer">
        <div class="total">合计：<em>¥{{ totalAmount.toFixed(2) }}</em></div>
        <div class="actions">
          <el-button @click="router.back()">返回购物车</el-button>
          <el-button type="primary" size="large" :loading="submitting" @click="submitOrder">
            提交订单
          </el-button>
        </div>
      </div>
    </template>
  </div>
</template>

<style scoped>
.checkout-page {
  max-width: 800px;
  margin: 0 auto;
}
.page-title {
  margin-bottom: 20px;
}
.section {
  margin-bottom: 16px;
}
.loading-wrap {
  padding: 40px;
}
.checkout-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
  border-top: 1px solid #f5f5f5;
}
.checkout-item:first-child {
  border-top: none;
}
.item-img {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 4px;
  flex-shrink: 0;
}
.item-info {
  flex: 1;
  min-width: 0;
}
.item-name {
  font-size: 14px;
  margin-bottom: 4px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.item-price {
  font-size: 13px;
  color: #999;
}
.item-subtotal {
  font-weight: bold;
  color: #e74c3c;
  font-size: 15px;
  flex-shrink: 0;
}
.checkout-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  padding: 20px 24px;
  background: #fff;
  border-radius: 8px;
  border: 1px solid #eee;
}
.total {
  font-size: 16px;
}
.total em {
  font-size: 24px;
  font-style: normal;
  color: #e74c3c;
  font-weight: bold;
}
.actions {
  display: flex;
  gap: 12px;
}
</style>
