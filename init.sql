-- ============================================================================
-- 优品商城 (shopping-platform) 完整数据库初始化脚本
-- 包含：创建数据库、建表、演示数据
-- 密码: 所有用户密码均为 123456
-- ============================================================================

CREATE DATABASE IF NOT EXISTS shopping_platform
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE shopping_platform;
/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: shopping_platform
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `carts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_carts_user` (`user_id`),
  KEY `idx_carts_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
/*!40000 ALTER TABLE `carts` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_categories_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES
(1,'电子产品',NULL,0,'2026-06-28 06:51:19','2026-06-28 06:51:19'),
(2,'服装鞋帽',NULL,0,'2026-06-28 06:51:19','2026-06-28 06:51:19'),
(3,'食品饮料',NULL,0,'2026-06-28 06:51:19','2026-06-28 06:51:19'),
(4,'图书音像',NULL,0,'2026-06-28 06:51:19','2026-06-28 06:51:19'),
(5,'家居用品',NULL,0,'2026-06-28 06:51:19','2026-06-28 06:51:19');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `product_name` varchar(200) NOT NULL,
  `product_image` varchar(500) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int(11) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_order_items_order` (`order_id`),
  KEY `idx_order_items_product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES
(1,1,1,'iPhone 16 Pro Max','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23667eea%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E📱%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3EiPhone 16 Pro Max%3C/text%3E%3C/svg%3E',9999.00,1,0,'2026-06-28 08:23:41'),
(2,1,2,'MacBook Pro 14英寸','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23f093fb%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E💻%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3EMacBook Pro 14%3C/text%3E%3C/svg%3E',14999.00,1,0,'2026-06-28 08:23:41'),
(3,2,3,'Sony WH-1000XM6 降噪耳机','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%234facfe%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🎧%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3ESony 降噪耳机%3C/text%3E%3C/svg%3E',2499.00,1,0,'2026-06-28 08:23:41'),
(4,2,6,'法式碎花连衣裙','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23fa709a%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E👗%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E法式碎花连衣裙%3C/text%3E%3C/svg%3E',399.00,1,0,'2026-06-28 08:23:41'),
(5,3,8,'Nike Air Max 运动鞋','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23fccb90%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E👟%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3ENike Air Max%3C/text%3E%3C/svg%3E',1299.00,1,0,'2026-06-28 08:23:41'),
(6,3,13,'云南普洱茶饼 357g','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23fccb90%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🍵%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E云南普洱茶%3C/text%3E%3C/svg%3E',298.00,1,0,'2026-06-28 08:23:41'),
(7,4,11,'深入理解Java虚拟机 第三版','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23f5576c%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E📘%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3EJVM虚拟机%3C/text%3E%3C/svg%3E',128.00,1,0,'2026-06-28 08:23:41'),
(8,4,12,'Spring实战 第7版','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23667eea%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🌱%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3ESpring实战%3C/text%3E%3C/svg%3E',99.00,1,0,'2026-06-28 08:23:41'),
(9,5,17,'智能扫地机器人','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%234facfe%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🤖%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E扫地机器人%3C/text%3E%3C/svg%3E',2999.00,1,0,'2026-06-28 08:23:41'),
(10,6,5,'iPad Air 13英寸','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%2343e97b%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E📟%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3EiPad Air 13%3C/text%3E%3C/svg%3E',4799.00,1,0,'2026-06-28 08:23:41'),
(11,6,7,'商务休闲西装外套','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23a18cd1%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🧥%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E商务西装外套%3C/text%3E%3C/svg%3E',899.00,1,0,'2026-06-28 08:23:41');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0:待支付 1:已支付 2:已发货 3:已完成 4:已取消',
  `address` varchar(500) NOT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_no` (`order_no`),
  KEY `idx_orders_user` (`user_id`),
  KEY `idx_orders_order_no` (`order_no`),
  KEY `idx_orders_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES
(1,'DEMO20260628001',7,24998.00,3,'北京市海淀区中关村大街1号','请放丰巢柜',0,'2026-06-21 08:23:41','2026-06-28 08:23:41'),
(2,'DEMO20260628002',8,2898.00,1,'上海市浦东新区陆家嘴金融中心','周末配送',0,'2026-06-25 08:23:41','2026-06-28 08:23:41'),
(3,'DEMO20260628003',9,1597.00,2,'广州市天河区体育西路100号',NULL,0,'2026-06-26 08:23:41','2026-06-28 08:23:41'),
(4,'DEMO20260628004',10,227.00,0,'深圳市南山区科技园南区','请尽快发货，急用',0,'2026-06-27 08:23:41','2026-06-28 08:23:41'),
(5,'DEMO20260628005',11,2999.00,4,'杭州市西湖区文三路500号',NULL,0,'2026-06-23 08:23:41','2026-06-28 08:23:41'),
(6,'DEMO20260628006',8,5698.00,0,'上海市浦东新区陆家嘴金融中心','同上地址',0,'2026-06-28 08:23:41','2026-06-28 08:23:41');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `images` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `stock` int(11) NOT NULL DEFAULT 0,
  `sales` int(11) NOT NULL DEFAULT 0,
  `category_id` bigint(20) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` bigint(20) DEFAULT NULL COMMENT '商家用户ID',
  PRIMARY KEY (`id`),
  KEY `idx_products_category` (`category_id`),
  KEY `idx_products_name` (`name`),
  KEY `idx_products_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES
(1,'iPhone 16 Pro Max','苹果最新旗舰手机，A18芯片，钛金属机身','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23667eea%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E📱%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3EiPhone 16 Pro Max%3C/text%3E%3C/svg%3E',NULL,9999.00,49,1,1,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',4),
(2,'MacBook Pro 14英寸','M4芯片，24GB内存，512GB存储','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23f093fb%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E💻%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3EMacBook Pro 14%3C/text%3E%3C/svg%3E',NULL,14999.00,29,1,1,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',4),
(3,'Sony WH-1000XM6 降噪耳机','业界顶级降噪，30小时续航','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%234facfe%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🎧%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3ESony 降噪耳机%3C/text%3E%3C/svg%3E',NULL,2499.00,99,1,1,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',4),
(4,'Apple Watch Ultra 3','户外探险智能手表，钛合金表壳','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23764ba2%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E⌚%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3EApple Watch Ultra%3C/text%3E%3C/svg%3E',NULL,5999.00,40,0,1,0,'2026-06-28 08:23:03','2026-06-28 08:23:03',4),
(5,'iPad Air 13英寸','M3芯片，超轻薄设计，适合学习和办公','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%2343e97b%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E📟%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3EiPad Air 13%3C/text%3E%3C/svg%3E',NULL,4799.00,59,1,1,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',4),
(6,'法式碎花连衣裙','春夏新款，轻盈雪纺面料，优雅气质','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23fa709a%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E👗%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E法式碎花连衣裙%3C/text%3E%3C/svg%3E',NULL,399.00,199,1,2,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',5),
(7,'商务休闲西装外套','高端面料，剪裁得体，适合通勤','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23a18cd1%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🧥%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E商务西装外套%3C/text%3E%3C/svg%3E',NULL,899.00,99,1,2,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',5),
(8,'Nike Air Max 运动鞋','气垫缓震，舒适透气，潮流百搭','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23fccb90%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E👟%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3ENike Air Max%3C/text%3E%3C/svg%3E',NULL,1299.00,149,1,2,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',5),
(9,'真皮单肩斜挎包','头层牛皮，精致五金，大容量','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23e0c3fc%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E👜%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E真皮单肩包%3C/text%3E%3C/svg%3E',NULL,699.00,80,0,2,0,'2026-06-28 08:23:03','2026-06-28 08:23:03',5),
(10,'纯棉基础款T恤','100%新疆长绒棉，亲肤透气，多色可选','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%2343e97b%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E👕%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E纯棉T恤%3C/text%3E%3C/svg%3E',NULL,129.00,500,0,2,0,'2026-06-28 08:23:03','2026-06-28 08:23:03',5),
(11,'深入理解Java虚拟机 第三版','周志明著，Java开发者必读经典','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23f5576c%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E📘%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3EJVM虚拟机%3C/text%3E%3C/svg%3E',NULL,128.00,299,1,4,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',6),
(12,'Spring实战 第7版','Spring Boot 3.x，全面覆盖企业级开发','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23667eea%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🌱%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3ESpring实战%3C/text%3E%3C/svg%3E',NULL,99.00,249,1,4,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',6),
(13,'云南普洱茶饼 357g','古树原料，陈香醇厚，收藏品饮皆宜','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23fccb90%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🍵%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E云南普洱茶%3C/text%3E%3C/svg%3E',NULL,298.00,99,1,3,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',6),
(14,'哥伦比亚精品咖啡豆 500g','中度烘焙，果香浓郁','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23e0c3fc%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E☕%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E精品咖啡豆%3C/text%3E%3C/svg%3E',NULL,168.00,200,0,3,0,'2026-06-28 08:23:03','2026-06-28 08:23:03',6),
(15,'算法导论 第四版','MIT经典教材，程序员必读','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%2343e97b%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E📚%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E算法导论%3C/text%3E%3C/svg%3E',NULL,198.00,180,0,4,0,'2026-06-28 08:23:03','2026-06-28 08:23:03',6),
(16,'日本抹茶粉 100g','茶道级抹茶，色泽翠绿','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23fa709a%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🍵%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E日本抹茶粉%3C/text%3E%3C/svg%3E',NULL,88.00,150,0,3,0,'2026-06-28 08:23:03','2026-06-28 08:23:03',6),
(17,'智能扫地机器人','激光导航，自动集尘，智能分区清扫','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%234facfe%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🤖%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E扫地机器人%3C/text%3E%3C/svg%3E',NULL,2999.00,41,0,5,0,'2026-06-28 08:23:03','2026-06-28 08:23:41',1),
(18,'记忆棉护颈枕','人体工学设计，慢回弹记忆棉，改善睡眠','data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23a18cd1%22 width=%22200%22 height=%22200%22 rx=%228%22/%3E%3Ctext x=%22100%22 y=%2290%22 text-anchor=%22middle%22 font-size=%2250%22%3E🛏️%3C/text%3E%3Ctext x=%22100%22 y=%22135%22 text-anchor=%22middle%22 fill=%22white%22 font-size=%2214%22%3E记忆棉护颈枕%3C/text%3E%3C/svg%3E',NULL,199.00,300,0,5,0,'2026-06-28 08:23:03','2026-06-28 08:23:03',1);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `role` varchar(20) NOT NULL DEFAULT 'buyer' COMMENT '角色: admin/merchant/buyer',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_users_username` (`username`),
  KEY `idx_users_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'testuser','123456','test@test.com',NULL,NULL,0,'2026-06-28 06:55:36','2026-06-28 07:18:28','admin'),
(4,'数码陈哥','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','chen@shop.com','13800001001',NULL,0,'2026-06-28 08:22:29','2026-06-28 08:22:29','merchant'),
(5,'时尚丽人','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','liren@shop.com','13800001002',NULL,0,'2026-06-28 08:22:29','2026-06-28 08:22:29','merchant'),
(6,'书香阁','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','shuxiang@shop.com','13800001003',NULL,0,'2026-06-28 08:22:29','2026-06-28 08:22:29','merchant'),
(7,'张三','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','zhangsan@mail.com','13900001001',NULL,0,'2026-06-28 08:22:29','2026-06-28 08:22:29','buyer'),
(8,'李四','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','lisi@mail.com','13900001002',NULL,0,'2026-06-28 08:22:29','2026-06-28 08:22:29','buyer'),
(9,'王五','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','wangwu@mail.com','13900001003',NULL,0,'2026-06-28 08:22:29','2026-06-28 08:22:29','buyer'),
(10,'赵六','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','zhaoliu@mail.com','13900001004',NULL,0,'2026-06-28 08:22:29','2026-06-28 08:22:29','buyer'),
(11,'孙七','$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy','sunqi@mail.com','13900001005',NULL,0,'2026-06-28 08:22:29','2026-06-28 08:22:29','buyer');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-06-28  8:39:15
