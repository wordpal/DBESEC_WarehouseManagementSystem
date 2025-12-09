package com.warehouse.dao.impl;

import com.warehouse.dao.InventoryDAO;
import com.warehouse.beans.Inventory;
import com.warehouse.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryDAOImpl implements InventoryDAO {
    
    @Override
    public boolean insert(Inventory inventory) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO inventory (product_id, location_id, quantity) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, inventory.getProductId());
            pstmt.setInt(2, inventory.getLocationId());
            pstmt.setInt(3, inventory.getQuantity());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean update(Inventory inventory) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE inventory SET quantity = ? WHERE product_id = ? AND location_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, inventory.getQuantity());
            pstmt.setInt(2, inventory.getProductId());
            pstmt.setInt(3, inventory.getLocationId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean delete(int id) {
        // Inventory表使用复合主键，这里不能直接用单个ID删除
        // 实际应该使用deleteByProductAndLocation方法
        return false;
    }
    
    public boolean deleteByProductAndLocation(int productId, int locationId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM inventory WHERE product_id = ? AND location_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            pstmt.setInt(2, locationId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public Inventory getById(int id) {
        // Inventory表使用复合主键，这里不能直接用单个ID查询
        // 实际应该使用getByProductAndLocation方法
        return null;
    }
    
    @Override
    public List<Inventory> getAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Inventory> inventories = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT i.*, p.product_name, p.sku, p.safety_stock, " +
                        "l.location_code, w.warehouse_name " +
                        "FROM inventory i " +
                        "JOIN product p ON i.product_id = p.product_id " +
                        "JOIN storage_location l ON i.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "ORDER BY w.warehouse_name, l.location_code";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                inventories.add(mapResultSetToInventory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return inventories;
    }
    
    @Override
    public Inventory getByProductAndLocation(int productId, int locationId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT i.*, p.product_name, p.sku, p.safety_stock, " +
                        "l.location_code, w.warehouse_name " +
                        "FROM inventory i " +
                        "JOIN product p ON i.product_id = p.product_id " +
                        "JOIN storage_location l ON i.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE i.product_id = ? AND i.location_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            pstmt.setInt(2, locationId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToInventory(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    @Override
    public List<Inventory> getByProduct(int productId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Inventory> inventories = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT i.*, p.product_name, p.sku, p.safety_stock, " +
                        "l.location_code, w.warehouse_name " +
                        "FROM inventory i " +
                        "JOIN product p ON i.product_id = p.product_id " +
                        "JOIN storage_location l ON i.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE i.product_id = ? " +
                        "ORDER BY w.warehouse_name, l.location_code";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                inventories.add(mapResultSetToInventory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return inventories;
    }
    
    @Override
    public List<Inventory> getByLocation(int locationId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Inventory> inventories = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT i.*, p.product_name, p.sku, p.safety_stock, " +
                        "l.location_code, w.warehouse_name " +
                        "FROM inventory i " +
                        "JOIN product p ON i.product_id = p.product_id " +
                        "JOIN storage_location l ON i.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE i.location_id = ? " +
                        "ORDER BY p.product_name";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, locationId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                inventories.add(mapResultSetToInventory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return inventories;
    }
    
    @Override
    public List<Inventory> getByWarehouse(int warehouseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Inventory> inventories = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT i.*, p.product_name, p.sku, p.safety_stock, " +
                        "l.location_code, w.warehouse_name " +
                        "FROM inventory i " +
                        "JOIN product p ON i.product_id = p.product_id " +
                        "JOIN storage_location l ON i.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE w.warehouse_id = ? " +
                        "ORDER BY p.product_name, l.location_code";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, warehouseId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                inventories.add(mapResultSetToInventory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return inventories;
    }
    
    @Override
    public List<Inventory> getLowStockInventory() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Inventory> inventories = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            // 库存数量 ≤ 安全库存的为低库存
            String sql = "SELECT i.*, p.product_name, p.sku, p.safety_stock, " +
                        "l.location_code, w.warehouse_name " +
                        "FROM inventory i " +
                        "JOIN product p ON i.product_id = p.product_id " +
                        "JOIN storage_location l ON i.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE i.quantity <= p.safety_stock AND i.quantity > 0 " +
                        "ORDER BY (i.quantity * 1.0 / p.safety_stock) ASC"; // 按库存比例排序
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                inventories.add(mapResultSetToInventory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return inventories;
    }
    
    @Override
    public List<Inventory> getEmptyInventory() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Inventory> inventories = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            // 零库存
            String sql = "SELECT i.*, p.product_name, p.sku, p.safety_stock, " +
                        "l.location_code, w.warehouse_name " +
                        "FROM inventory i " +
                        "JOIN product p ON i.product_id = p.product_id " +
                        "JOIN storage_location l ON i.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE i.quantity = 0 " +
                        "ORDER BY w.warehouse_name, p.product_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                inventories.add(mapResultSetToInventory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return inventories;
    }
    
    @Override
    public boolean updateQuantity(int productId, int locationId, int quantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE inventory SET quantity = ? WHERE product_id = ? AND location_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, locationId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean addQuantity(int productId, int locationId, int quantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            // 先检查是否存在记录
            Inventory existing = getByProductAndLocation(productId, locationId);
            if (existing != null) {
                // 更新现有记录
                int newQuantity = existing.getQuantity() + quantity;
                return updateQuantity(productId, locationId, newQuantity);
            } else {
                // 插入新记录
                String sql = "INSERT INTO inventory (product_id, location_id, quantity) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, productId);
                pstmt.setInt(2, locationId);
                pstmt.setInt(3, quantity);
                return pstmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean reduceQuantity(int productId, int locationId, int quantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            // 先检查库存是否足够
            Inventory existing = getByProductAndLocation(productId, locationId);
            if (existing == null || existing.getQuantity() < quantity) {
                System.out.println("库存不足！现有库存: " + (existing != null ? existing.getQuantity() : 0) + ", 需要: " + quantity);
                return false;
            }
            
            int newQuantity = existing.getQuantity() - quantity;
            return updateQuantity(productId, locationId, newQuantity);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public int getTotalQuantityByProduct(int productId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT SUM(quantity) as total FROM inventory WHERE product_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return 0;
    }
    
    @Override
    public int getTotalQuantityByWarehouse(int warehouseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT SUM(i.quantity) as total " +
                        "FROM inventory i " +
                        "JOIN storage_location l ON i.location_id = l.location_id " +
                        "WHERE l.warehouse_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, warehouseId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return 0;
    }
    
    @Override
    public List<Inventory> searchWithConditions(Integer productId, Integer warehouseId, Integer locationId, Integer minQuantity, Integer maxQuantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Inventory> inventories = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            StringBuilder sqlBuilder = new StringBuilder(
                "SELECT i.*, p.product_name, p.sku, p.safety_stock, " +
                "l.location_code, w.warehouse_name " +
                "FROM inventory i " +
                "JOIN product p ON i.product_id = p.product_id " +
                "JOIN storage_location l ON i.location_id = l.location_id " +
                "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                "WHERE 1=1 "
            );
            
            List<Object> params = new ArrayList<>();
            
            if (productId != null) {
                sqlBuilder.append("AND i.product_id = ? ");
                params.add(productId);
            }
            
            if (warehouseId != null) {
                sqlBuilder.append("AND w.warehouse_id = ? ");
                params.add(warehouseId);
            }
            
            if (locationId != null) {
                sqlBuilder.append("AND i.location_id = ? ");
                params.add(locationId);
            }
            
            if (minQuantity != null) {
                sqlBuilder.append("AND i.quantity >= ? ");
                params.add(minQuantity);
            }
            
            if (maxQuantity != null) {
                sqlBuilder.append("AND i.quantity <= ? ");
                params.add(maxQuantity);
            }
            
            sqlBuilder.append("ORDER BY w.warehouse_name, p.product_name, l.location_code");
            
            pstmt = conn.prepareStatement(sqlBuilder.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            rs = pstmt.executeQuery();
            while (rs.next()) {
                inventories.add(mapResultSetToInventory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return inventories;
    }
    
    @Override
    public List<Inventory> getByPage(int pageNum, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Inventory> inventories = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT i.*, p.product_name, p.sku, p.safety_stock, " +
                        "l.location_code, w.warehouse_name " +
                        "FROM inventory i " +
                        "JOIN product p ON i.product_id = p.product_id " +
                        "JOIN storage_location l ON i.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "ORDER BY w.warehouse_name, l.location_code " +
                        "LIMIT ?, ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, (pageNum - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                inventories.add(mapResultSetToInventory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return inventories;
    }
    
    @Override
    public int getTotalCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT COUNT(*) as total FROM inventory";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return 0;
    }
    
    // 辅助方法：将ResultSet映射到Inventory对象
    private Inventory mapResultSetToInventory(ResultSet rs) throws SQLException {
        Inventory inventory = new Inventory();
        inventory.setProductId(rs.getInt("product_id"));
        inventory.setLocationId(rs.getInt("location_id"));
        inventory.setQuantity(rs.getInt("quantity"));
        
        // 设置关联对象信息（虽然不是完整的对象，但包含关键信息）
        // 这里可以扩展为获取完整的关联对象
        
        return inventory;
    }
}