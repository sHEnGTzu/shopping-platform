# 优品商城 (Shopping Platform)

基于 B2B2C 模式的在线购物平台，支持管理员、商家、买家三种角色协同运作。

## 技术栈

| 层级   | 技术                                            |
|--------|-------------------------------------------------|
| 后端   | Spring Boot 3.2.5 + MyBatis-Plus + JWT + MySQL |
| 前端   | Vue 3 + TypeScript + Element Plus + Vite        |
| 数据库 | MySQL 8.0+ / MariaDB 11.x                       |

## 项目结构

```
shopping-platform/
├── backend/          # 后端项目（Spring Boot + Maven）
├── frontend/         # 前端项目（Vue 3 + Vite）
├── docs/             # 项目文档与设计图
├── init.sql          # 数据库初始化脚本（含演示数据）
├── .gitignore
└── README.md
```

## 快速启动

### 1. 创建数据库

```bash
mysql -u root -p < init.sql
```

### 2. 启动后端

```bash
cd backend
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

后端默认运行在 http://localhost:8080/api

### 3. 启动前端

```bash
cd frontend
npm install
npm run dev
```

前端默认运行在 http://localhost:5173

## 演示账号

| 角色   | 用户名   | 密码   |
|--------|----------|--------|
| 管理员 | testuser | 123456 |
| 商家   | 数码陈哥 | 123456 |
| 买家   | 张三     | 123456 |
