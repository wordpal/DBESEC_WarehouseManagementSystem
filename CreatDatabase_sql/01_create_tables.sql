-- Warehouse Management System - Database Schema
CREATE DATABASE IF NOT EXISTS warehouse_ms DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE warehouse_ms;

-- Warehouse table
CREATE TABLE `warehouse` (
  `warehouse_id` INT AUTO_INCREMENT PRIMARY KEY,
  `warehouse_code` VARCHAR(20) NOT NULL UNIQUE,
  `warehouse_name` VARCHAR(50) NOT NULL,
  `country` VARCHAR(50) NOT NULL,
  `address` VARCHAR(200),
  `is_active` TINYINT(1) NOT NULL DEFAULT 1
);

-- Storage location table
CREATE TABLE `storage_location` (
  `location_id` INT AUTO_INCREMENT PRIMARY KEY,
  `location_code` VARCHAR(20) NOT NULL UNIQUE,
  `warehouse_id` INT NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0-available, 1-occupied',
  FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse`(`warehouse_id`) ON DELETE CASCADE
);

-- Product table
CREATE TABLE `product` (
  `product_id` INT AUTO_INCREMENT PRIMARY KEY,
  `sku` VARCHAR(50) NOT NULL UNIQUE,
  `product_name` VARCHAR(100) NOT NULL,
  `category` VARCHAR(50),
  `specification` VARCHAR(200),
  `length` DECIMAL(10,2),
  `width` DECIMAL(10,2),
  `height` DECIMAL(10,2),
  `weight` DECIMAL(10,2),
  `safety_stock` INT NOT NULL DEFAULT 0,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1
);

-- Inventory table (core table)
CREATE TABLE `inventory` (
  `product_id` INT NOT NULL,
  `location_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`product_id`, `location_id`),
  FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`) ON DELETE CASCADE,
  FOREIGN KEY (`location_id`) REFERENCES `storage_location`(`location_id`) ON DELETE CASCADE
);

-- Inbound order table
CREATE TABLE `inbound_order` (
  `order_id` INT AUTO_INCREMENT PRIMARY KEY,
  `order_code` VARCHAR(50) NOT NULL UNIQUE,
  `product_id` INT NOT NULL,
  `location_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `order_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operator` VARCHAR(50),
  FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`),
  FOREIGN KEY (`location_id`) REFERENCES `storage_location`(`location_id`)
);

-- Outbound order table
CREATE TABLE `outbound_order` (
  `order_id` INT AUTO_INCREMENT PRIMARY KEY,
  `order_code` VARCHAR(50) NOT NULL UNIQUE,
  `product_id` INT NOT NULL,
  `location_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `order_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operator` VARCHAR(50),
  FOREIGN KEY (`product_id`) REFERENCES `product`(`product_id`),
  FOREIGN KEY (`location_id`) REFERENCES `storage_location`(`location_id`)
);

-- Performance indexes
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_inventory_location ON inventory(location_id);
CREATE INDEX idx_product_category ON product(category);
CREATE INDEX idx_product_sku ON product(sku);
CREATE INDEX idx_warehouse_country ON warehouse(country);
CREATE INDEX idx_inbound_order_time ON inbound_order(order_time);
CREATE INDEX idx_outbound_order_time ON outbound_order(order_time);
CREATE INDEX idx_storage_location_warehouse ON storage_location(warehouse_id);
CREATE INDEX idx_inbound_order_location ON inbound_order(location_id);
CREATE INDEX idx_outbound_order_location ON outbound_order(location_id);
CREATE INDEX idx_outbound_order_product ON outbound_order(product_id);