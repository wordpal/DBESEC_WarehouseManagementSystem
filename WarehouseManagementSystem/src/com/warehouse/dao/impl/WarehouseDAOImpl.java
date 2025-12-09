package com.warehouse.dao.impl;

import com.warehouse.dao.WarehouseDAO;
import com.warehouse.beans.Warehouse;
import com.warehouse.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WarehouseDAOImpl implements WarehouseDAO {
    
    @Override
    public boolean insert(Warehouse warehouse) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO warehouse (warehouse_code, warehouse_name, country, address) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, warehouse.getWarehouseCode());
            pstmt.setString(2, warehouse.getWarehouseName());
            pstmt.setString(3, warehouse.getCountry());
            pstmt.setString(4, warehouse.getAddress());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean update(Warehouse warehouse) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE warehouse SET warehouse_code=?, warehouse_name=?, country=?, address=?, is_active=? WHERE warehouse_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, warehouse.getWarehouseCode());
            pstmt.setString(2, warehouse.getWarehouseName());
            pstmt.setString(3, warehouse.getCountry());
            pstmt.setString(4, warehouse.getAddress());
            pstmt.setBoolean(5, warehouse.isActive());
            pstmt.setInt(6, warehouse.getWarehouseId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean delete(int warehouseId) {
        // 逻辑删除，不是物理删除
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE warehouse SET is_active = 0 WHERE warehouse_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, warehouseId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public Warehouse getById(int warehouseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM warehouse WHERE warehouse_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, warehouseId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToWarehouse(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    @Override
    public List<Warehouse> getAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Warehouse> warehouses = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM warehouse ORDER BY warehouse_id";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                warehouses.add(mapResultSetToWarehouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return warehouses;
    }
    
    @Override
    public Warehouse getByCode(String warehouseCode) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM warehouse WHERE warehouse_code = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, warehouseCode);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToWarehouse(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    @Override
    public List<Warehouse> getActiveWarehouses() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Warehouse> warehouses = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM warehouse WHERE is_active = 1 ORDER BY warehouse_id";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                warehouses.add(mapResultSetToWarehouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return warehouses;
    }
    
    @Override
    public List<Warehouse> getByCountry(String country) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Warehouse> warehouses = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM warehouse WHERE country = ? AND is_active = 1 ORDER BY warehouse_id";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, country);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                warehouses.add(mapResultSetToWarehouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return warehouses;
    }
    
    @Override
    public boolean deactivateWarehouse(int warehouseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE warehouse SET is_active = 0 WHERE warehouse_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, warehouseId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean activateWarehouse(int warehouseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE warehouse SET is_active = 1 WHERE warehouse_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, warehouseId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public List<Warehouse> getByPage(int pageNum, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Warehouse> warehouses = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM warehouse ORDER BY warehouse_id LIMIT ?, ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, (pageNum - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                warehouses.add(mapResultSetToWarehouse(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return warehouses;
    }
    
    @Override
    public int getTotalCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT COUNT(*) as total FROM warehouse";
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
    
    // 辅助方法：将ResultSet映射到Warehouse对象
    private Warehouse mapResultSetToWarehouse(ResultSet rs) throws SQLException {
        Warehouse warehouse = new Warehouse();
        warehouse.setWarehouseId(rs.getInt("warehouse_id"));
        warehouse.setWarehouseCode(rs.getString("warehouse_code"));
        warehouse.setWarehouseName(rs.getString("warehouse_name"));
        warehouse.setCountry(rs.getString("country"));
        warehouse.setAddress(rs.getString("address"));
        warehouse.setActive(rs.getBoolean("is_active"));
        return warehouse;
    }
}