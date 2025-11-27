-- Use warehouse management system database
USE warehouse_ms;

-- 1. Clear existing data (use with caution, for initialization only)
DELETE FROM outbound_order;
DELETE FROM inbound_order;
DELETE FROM inventory;
DELETE FROM storage_location;
DELETE FROM product;
DELETE FROM warehouse;

-- 2. Insert warehouse data
INSERT INTO warehouse (warehouse_code, warehouse_name, country, address) VALUES
('WH_BJ', 'Beijing Central Warehouse', 'China', 'No.1 Kejiyuan Road, Haidian District, Beijing'),
('WH_SH', 'Shanghai Branch Warehouse', 'China', 'Zhangjiang Hi-Tech Park, Pudong New Area, Shanghai'),
('WH_US', 'Los Angeles US Warehouse', 'USA', '1234 Commerce St, Los Angeles, CA');

-- 3. Insert storage location data
INSERT INTO storage_location (location_code, warehouse_id, status) VALUES
-- Beijing warehouse locations (10)
('BJ-A-01-01', 1, 0), ('BJ-A-01-02', 1, 0), ('BJ-A-01-03', 1, 0),
('BJ-A-02-01', 1, 0), ('BJ-A-02-02', 1, 0), ('BJ-B-01-01', 1, 0),
('BJ-B-01-02', 1, 0), ('BJ-B-02-01', 1, 0), ('BJ-B-02-02', 1, 0),
('BJ-C-01-01', 1, 0),
-- Shanghai warehouse locations (8)
('SH-A-01-01', 2, 0), ('SH-A-01-02', 2, 0), ('SH-A-02-01', 2, 0),
('SH-A-02-02', 2, 0), ('SH-B-01-01', 2, 0), ('SH-B-01-02', 2, 0),
('SH-B-02-01', 2, 0), ('SH-B-02-02', 2, 0),
-- US warehouse locations (6)
('US-A-01-01', 3, 0), ('US-A-01-02', 3, 0), ('US-A-02-01', 3, 0),
('US-A-02-02', 3, 0), ('US-B-01-01', 3, 0), ('US-B-01-02', 3, 0);

-- 4. Insert product data
INSERT INTO product (sku, product_name, category, specification, length, width, height, weight, safety_stock) VALUES
-- Electronics
('IPHONE14-BK', 'iPhone 14 Black', 'Mobile Phone', '128GB Black', 14.7, 7.15, 0.78, 0.172, 50),
('IPHONE14-WH', 'iPhone 14 White', 'Mobile Phone', '128GB White', 14.7, 7.15, 0.78, 0.172, 50),
('MBP-13-2023', 'MacBook Pro 13"', 'Laptop', 'M2 Chip 8GB 256GB', 30.41, 21.24, 1.56, 1.38, 30),
('AIRPODS-3', 'AirPods 3rd Gen', 'Headphones', 'Wireless Bluetooth', 5.4, 2.1, 1.8, 0.05, 100),
-- Office supplies
('DESK-A100', 'Office Desk A100', 'Furniture', '160*80cm Solid Wood', 160, 80, 75, 25, 10),
('CHAIR-C200', 'Office Chair C200', 'Furniture', 'Ergonomic Office Chair', 60, 60, 120, 15, 15),
-- Clothing
('TSHIRT-M-BK', 'T-Shirt Black M', 'Clothing', 'Cotton Black T-Shirt M', 30, 25, 2, 0.2, 200),
('TSHIRT-L-WH', 'T-Shirt White L', 'Clothing', 'Cotton White T-Shirt L', 32, 27, 2, 0.22, 200),
-- Low stock alert test data
('KEYBOARD-K1', 'Mechanical Keyboard K1', 'Peripheral', '87 Keys Blue Switch', 35, 12, 3, 0.8, 20),
('MONITOR-24', '24" Monitor', 'Monitor', '24" IPS Display', 55, 35, 15, 3.5, 5);

-- 5. Insert inventory data - show distribution across warehouses
INSERT INTO inventory (product_id, location_id, quantity) VALUES
-- Beijing warehouse inventory
(1, 1, 120),   -- iPhone 14 Black at BJ-A-01-01
(2, 2, 80),    -- iPhone 14 White at BJ-A-01-02
(3, 4, 45),    -- MacBook Pro at BJ-A-02-01
(4, 5, 200),   -- AirPods at BJ-A-02-02
-- Shanghai warehouse inventory
(1, 11, 60),   -- iPhone 14 Black at SH-A-01-01
(5, 12, 8),    -- Office Desk at SH-A-01-02 (below safety stock)
(6, 13, 20),   -- Office Chair at SH-A-02-01
-- US warehouse inventory
(1, 19, 40),   -- iPhone 14 Black at US-A-01-01
(7, 20, 150),  -- T-Shirt Black M at US-A-01-02
(8, 21, 180),  -- T-Shirt White L at US-A-02-01
-- Low stock test data
(9, 6, 5),     -- Mechanical Keyboard at BJ-B-01-01 (below safety stock)
(10, 7, 2);    -- Monitor at BJ-B-01-02 (below safety stock)

-- 6. Insert inbound order data - show receiving history
INSERT INTO inbound_order (order_code, product_id, location_id, quantity, operator) VALUES
('IN-20240115-001', 1, 1, 100, 'Zhang San'),
('IN-20240116-001', 2, 2, 80, 'Zhang San'),
('IN-20240117-001', 3, 4, 30, 'Li Si'),
('IN-20240118-001', 4, 5, 150, 'Li Si'),
('IN-20240120-001', 1, 1, 20, 'Wang Wu'),  -- Second replenishment
('IN-20240125-001', 9, 6, 5, 'Zhao Liu');  -- Low stock product inbound

-- 7. Insert outbound order data - show shipping history
INSERT INTO outbound_order (order_code, product_id, quantity, operator) VALUES
('OUT-20240120-001', 1, 50, 'Zhang San'),
('OUT-20240121-001', 2, 30, 'Zhang San'),
('OUT-20240122-001', 3, 15, 'Li Si'),
('OUT-20240123-001', 4, 80, 'Li Si'),
('OUT-20240126-001', 5, 2, 'Wang Wu'),   -- Caused office desk below safety stock
('OUT-20240127-001', 9, 10, 'Zhao Liu'); -- Caused keyboard below safety stock

-- 8. Update storage location status - auto-set based on inventory
UPDATE storage_location SET status = 1 
WHERE location_id IN (
    SELECT DISTINCT location_id FROM inventory WHERE quantity > 0
);

-- Show data insertion results
SELECT 'Data initialization completed!' AS 'Status';
SELECT 'Warehouse records: ' AS 'Statistics', COUNT(*) AS Count FROM warehouse
UNION SELECT 'Storage locations: ', COUNT(*) FROM storage_location  
UNION SELECT 'Product records: ', COUNT(*) FROM product
UNION SELECT 'Inventory records: ', COUNT(*) FROM inventory
UNION SELECT 'Inbound orders: ', COUNT(*) FROM inbound_order
UNION SELECT 'Outbound orders: ', COUNT(*) FROM outbound_order;