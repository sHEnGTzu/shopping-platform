<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { productApi, type ProductSaveDTO } from '@/api/product'
import type { ProductVO, Category } from '@/types/api'

const products = ref<ProductVO[]>([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const editingId = ref<number | null>(null)
const categories = ref<Category[]>([])
const form = ref<ProductSaveDTO>({ name: '', price: 0, stock: 0, description: '', image: '', categoryId: undefined })
const loading = ref(false)

async function loadData() {
  loading.value = true
  try {
    const res = await productApi.getManagePage({ pageNum: pageNum.value, pageSize: pageSize.value })
    products.value = res.records
    total.value = res.total
  } finally {
    loading.value = false
  }
}

function openCreate() {
  editingId.value = null
  form.value = { name: '', price: 0, stock: 0, description: '', image: '', categoryId: undefined }
  dialogVisible.value = true
}

function openEdit(row: ProductVO) {
  editingId.value = row.id
  form.value = {
    name: row.name,
    price: row.price,
    stock: row.stock,
    description: row.description,
    image: row.image,
    categoryId: row.categoryId,
  }
  dialogVisible.value = true
}

async function handleSave() {
  if (!form.value.name || form.value.price <= 0) {
    ElMessage.warning('请填写完整信息')
    return
  }
  try {
    if (editingId.value) {
      await productApi.update(editingId.value, form.value)
      ElMessage.success('更新成功')
    } else {
      await productApi.create(form.value)
      ElMessage.success('创建成功')
    }
    dialogVisible.value = false
    loadData()
  } catch {
    // error already handled by http interceptor
  }
}

async function handleDelete(id: number) {
  try {
    await ElMessageBox.confirm('确定删除该商品吗？')
    await productApi.delete(id)
    ElMessage.success('删除成功')
    loadData()
  } catch {
    // cancelled or error
  }
}

onMounted(async () => {
  try {
    categories.value = await productApi.getCategories()
  } catch { /* ignore */ }
  loadData()
})
</script>

<template>
  <div class="manage-page">
    <div class="page-header">
      <h2>商品管理</h2>
      <el-button type="primary" @click="openCreate">新增商品</el-button>
    </div>

    <el-table :data="products" v-loading="loading" stripe style="width: 100%">
      <el-table-column prop="id" label="ID" width="60" />
      <el-table-column prop="name" label="名称" min-width="160" />
      <el-table-column prop="price" label="价格" width="100">
        <template #default="{ row }">¥{{ row.price }}</template>
      </el-table-column>
      <el-table-column prop="stock" label="库存" width="80" />
      <el-table-column prop="sales" label="销量" width="80" />
      <el-table-column prop="categoryName" label="分类" width="100" />
      <el-table-column label="拥有者" width="100">
        <template #default="{ row }">
          <span>{{ row.userName || '未知' }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="160" fixed="right">
        <template #default="{ row }">
          <el-button size="small" @click="openEdit(row)">编辑</el-button>
          <el-button size="small" type="danger" @click="handleDelete(row.id)">删除</el-button>
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

    <el-dialog v-model="dialogVisible" :title="editingId ? '编辑商品' : '新增商品'" width="600px">
      <el-form label-position="top">
        <el-form-item label="商品名称" required>
          <el-input v-model="form.name" placeholder="请输入名称" />
        </el-form-item>
        <el-form-item label="价格" required>
          <el-input-number v-model="form.price" :min="0.01" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item label="库存" required>
          <el-input-number v-model="form.stock" :min="0" style="width: 100%" />
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="form.categoryId" placeholder="选择分类" clearable style="width: 100%">
            <el-option v-for="c in categories" :key="c.id" :label="c.name" :value="c.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="商品描述">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入描述" />
        </el-form-item>
        <el-form-item label="图片URL">
          <el-input v-model="form.image" placeholder="请输入图片地址" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.manage-page {
  max-width: 1200px;
  margin: 24px auto;
  padding: 0 20px;
}
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.pagination-wrap {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}
</style>
