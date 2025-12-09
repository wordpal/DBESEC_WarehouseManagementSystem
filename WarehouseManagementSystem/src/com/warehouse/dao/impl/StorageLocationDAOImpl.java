package com.warehouse.dao.impl;

import com.warehouse.dao.StorageLocationDAO;
import com.warehouse.beans.StorageLocation;
import com.warehouse.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StorageLocationDAOImpl implements StorageLocationDAO {
    
    @Override
    public boolean insert(StorageLocation location) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO storage_location (location_code, warehouse_id) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, location.getLocationCode());
            pstmt.setInt(2, location.getWarehouseId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean update(StorageLocation location) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE storage_location SET location_code=?, warehouse_id=?, status=? WHERE location_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, location.getLocationCode());
            pstmt.setInt(2, location.getWarehouseId());
            pstmt.setInt(3, location.getStatus());
            pstmt.setInt(4, location.getLocationId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean delete(int locationId) {
        // 注意：货位如果有库存不能删除，这里先检查
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            // 检查是否有库存
            String checkSql = "SELECT COUNT(*) FROM inventory WHERE location_id = ? AND quantity > 0";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, locationId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                System.out.println("货位有库存，不能删除");
                return false;
            }
            pstmt.close();
            
            // 删除货位
            String sql = "DELETE FROM storage_location WHERE location_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, locationId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public StorageLocation getById(int locationId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM storage_location WHERE location_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, locationId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToLocation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    @Override
    public List<StorageLocation> getAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<StorageLocation> locations = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM storage_location ORDER BY warehouse_id, location_code";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                locations.add(mapResultSetToLocation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return locations;
    }
    
    @Override
    public StorageLocation getByCode(String locationCode) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM storage_location WHERE location_code = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, locationCode);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToLocation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    @Override
    public List<StorageLocation> getByWarehouse(int warehouseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<StorageLocation> locations = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM storage_location WHERE warehouse_id = ? ORDER BY location_code";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, warehouseId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                locations.add(mapResultSetToLocation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return locations;
    }
    
    @Override
    public List<StorageLocation> getAvailableLocations(int warehouseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<StorageLocation> locations = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM storage_location WHERE warehouse_id = ? AND status = 0 ORDER BY location_code";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, warehouseId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                locations.add(mapResultSetToLocation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return locations;
    }
    
    @Override
    public List<StorageLocation> getOccupiedLocations(int warehouseId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<StorageLocation> locations = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM storage_location WHERE warehouse_id = ? AND status = 1 ORDER BY location_code";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, warehouseId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                locations.add(mapResultSetToLocation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return locations;
    }
    
    @Override
    public boolean updateStatus(int locationId, int status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE storage_location SET status = ? WHERE location_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, status);
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
    public List<StorageLocation> getByPage(int pageNum, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<StorageLocation> locations = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT * FROM storage_location ORDER BY location_id LIMIT ?, ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, (pageNum - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                locations.add(mapResultSetToLocation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return locations;
    }
    
    @Override
    public List<StorageLocation> getByPageWithWarehouse(int pageNum, int pageSize, Integer warehouseId, Integer status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<StorageLocation> locations = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM storage_location WHERE 1=1 ");
            List<Object> params = new ArrayList<>();
            
            if (warehouseId != null) {
                sqlBuilder.append("AND warehouse_id = ? ");
                params.add(warehouseId);
            }
            
            if (status != null) {
                sqlBuilder.append("AND status = ? ");
                params.add(status);
            }
            
            sqlBuilder.append("ORDER BY location_id LIMIT ?, ?");
            params.add((pageNum - 1) * pageSize);
            params.add(pageSize);
            
            pstmt = conn.prepareStatement(sqlBuilder.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            rs = pstmt.executeQuery();
            while (rs.next()) {
                locations.add(mapResultSetToLocation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return locations;
    }
    
    @Override
    public int getTotalCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT COUNT(*) as total FROM storage_location";
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
    
    @Override
    public int getCountWithWarehouse(Integer warehouseId, Integer status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) as total FROM storage_location WHERE 1=1 ");
            List<Object> params = new ArrayList<>();
            
            if (warehouseId != null) {
                sqlBuilder.append("AND warehouse_id = ? ");
                params.add(warehouseId);
            }
            
            if (status != null) {
                sqlBuilder.append("AND status = ? ");
                params.add(status);
            }
            
            pstmt = conn.prepareStatement(sqlBuilder.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
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
    
    // 辅助方法：将ResultSet映射到StorageLocation对象
    private StorageLocation mapResultSetToLocation(ResultSet rs) throws SQLException {
        StorageLocation location = new StorageLocation();
        location.setLocationId(rs.getInt("location_id"));
        location.setLocationCode(rs.getString("location_code"));
        location.setWarehouseId(rs.getInt("warehouse_id"));
        location.setStatus(rs.getInt("status"));
        return location;
    }
}