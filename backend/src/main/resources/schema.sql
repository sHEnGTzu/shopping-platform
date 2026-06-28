CREATE DATABASE IF NOT EXISTS shopping_platform
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE shopping_platform;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id         BIGINT       AUTO_INCREMENT PRIMARY KEY,
    username   VARCHAR(50)  NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    email      VARCHAR(100),
    phone      VARCHAR(20),
    avatar     VARCHAR(500),
    is_deleted TINYINT(1)   NOT NULL DEFAULT 0,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_username (username),
    INDEX idx_users_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 商品分类表
CREATE TABLE IF NOT EXISTS categories (
    id         BIGINT       AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(50)  NOT NULL,
    image      VARCHAR(500),
    is_deleted TINYINT(1)   NOT NULL DEFAULT 0,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_categories_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 商品表
CREATE TABLE IF NOT EXISTS products (
    id          BIGINT        AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(200)  NOT NULL,
    description TEXT,
    image       VARCHAR(500),
    images      TEXT,
    price       DECIMAL(10,2) NOT NULL DEFAULT 0,
    stock       INT           NOT NULL DEFAULT 0,
    sales       INT           NOT NULL DEFAULT 0,
    category_id BIGINT,
    is_deleted  TINYINT(1)    NOT NULL DEFAULT 0,
    created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_products_category (category_id),
    INDEX idx_products_name (name),
    INDEX idx_products_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 购物车表
CREATE TABLE IF NOT EXISTS carts (
    id         BIGINT       AUTO_INCREMENT PRIMARY KEY,
    user_id    BIGINT       NOT NULL,
    product_id BIGINT       NOT NULL,
    quantity   INT          NOT NULL DEFAULT 1,
    is_deleted TINYINT(1)   NOT NULL DEFAULT 0,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_carts_user (user_id),
    INDEX idx_carts_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 订单表
CREATE TABLE IF NOT EXISTS orders (
    id           BIGINT        AUTO_INCREMENT PRIMARY KEY,
    order_no     VARCHAR(32)   NOT NULL UNIQUE,
    user_id      BIGINT        NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    status       TINYINT       NOT NULL DEFAULT 0 COMMENT '0:待支付 1:已支付 2:已发货 3:已完成 4:已取消',
    address      VARCHAR(500)  NOT NULL,
    remark       VARCHAR(500),
    is_deleted   TINYINT(1)    NOT NULL DEFAULT 0,
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_orders_user (user_id),
    INDEX idx_orders_order_no (order_no),
    INDEX idx_orders_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 订单明细表
CREATE TABLE IF NOT EXISTS order_items (
    id           BIGINT        AUTO_INCREMENT PRIMARY KEY,
    order_id     BIGINT        NOT NULL,
    product_id   BIGINT        NOT NULL,
    product_name VARCHAR(200)  NOT NULL,
    product_image VARCHAR(500),
    price        DECIMAL(10,2) NOT NULL,
    quantity     INT           NOT NULL,
    is_deleted   TINYINT(1)    NOT NULL DEFAULT 0,
    created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_order_items_order (order_id),
    INDEX idx_order_items_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
