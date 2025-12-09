package com.warehouse.dao.impl;

import com.warehouse.dao.InboundOrderDAO;
import com.warehouse.beans.InboundOrder;
import com.warehouse.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class InboundOrderDAOImpl implements InboundOrderDAO {
    
    @Override
    public boolean insert(InboundOrder order) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO inbound_order (order_code, product_id, location_id, quantity, operator) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, order.getOrderCode());
            pstmt.setInt(2, order.getProductId());
            pstmt.setInt(3, order.getLocationId());
            pstmt.setInt(4, order.getQuantity());
            pstmt.setString(5, order.getOperator());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean update(InboundOrder order) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE inbound_order SET order_code=?, product_id=?, location_id=?, quantity=?, operator=? WHERE order_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, order.getOrderCode());
            pstmt.setInt(2, order.getProductId());
            pstmt.setInt(3, order.getLocationId());
            pstmt.setInt(4, order.getQuantity());
            pstmt.setString(5, order.getOperator());
            pstmt.setInt(6, order.getOrderId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean delete(int orderId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "DELETE FROM inbound_order WHERE order_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public InboundOrder getById(int orderId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT io.*, p.product_name, p.sku, l.location_code, w.warehouse_name " +
                        "FROM inbound_order io " +
                        "JOIN product p ON io.product_id = p.product_id " +
                        "JOIN storage_location l ON io.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE io.order_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    @Override
    public List<InboundOrder> getAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT io.*, p.product_name, p.sku, l.location_code, w.warehouse_name " +
                        "FROM inbound_order io " +
                        "JOIN product p ON io.product_id = p.product_id " +
                        "JOIN storage_location l ON io.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "ORDER BY io.order_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return orders;
    }
    
    @Override
    public InboundOrder getByOrderCode(String orderCode) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT io.*, p.product_name, p.sku, l.location_code, w.warehouse_name " +
                        "FROM inbound_order io " +
                        "JOIN product p ON io.product_id = p.product_id " +
                        "JOIN storage_location l ON io.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE io.order_code = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, orderCode);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    @Override
    public List<InboundOrder> getByProduct(int productId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT io.*, p.product_name, p.sku, l.location_code, w.warehouse_name " +
                        "FROM inbound_order io " +
                        "JOIN product p ON io.product_id = p.product_id " +
                        "JOIN storage_location l ON io.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE io.product_id = ? " +
                        "ORDER BY io.order_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return orders;
    }
    
    @Override
    public List<InboundOrder> getByLocation(int locationId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT io.*, p.product_name, p.sku, l.location_code, w.warehouse_name " +
                        "FROM inbound_order io " +
                        "JOIN product p ON io.product_id = p.product_id " +
                        "JOIN storage_location l ON io.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE io.location_id = ? " +
                        "ORDER BY io.order_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, locationId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return orders;
    }
    
    @Override
    public List<InboundOrder> getByDateRange(Date startDate, Date endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT io.*, p.product_name, p.sku, l.location_code, w.warehouse_name " +
                        "FROM inbound_order io " +
                        "JOIN product p ON io.product_id = p.product_id " +
                        "JOIN storage_location l ON io.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE io.order_time BETWEEN ? AND ? " +
                        "ORDER BY io.order_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setTimestamp(1, new Timestamp(startDate.getTime()));
            pstmt.setTimestamp(2, new Timestamp(endDate.getTime()));
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return orders;
    }
    
    @Override
    public List<InboundOrder> getByOperator(String operator) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT io.*, p.product_name, p.sku, l.location_code, w.warehouse_name " +
                        "FROM inbound_order io " +
                        "JOIN product p ON io.product_id = p.product_id " +
                        "JOIN storage_location l ON io.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "WHERE io.operator LIKE ? " +
                        "ORDER BY io.order_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + operator + "%");
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return orders;
    }
    
    @Override
    public List<InboundOrder> getRecentOrders(int limit) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT io.*, p.product_name, p.sku, l.location_code, w.warehouse_name " +
                        "FROM inbound_order io " +
                        "JOIN product p ON io.product_id = p.product_id " +
                        "JOIN storage_location l ON io.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "ORDER BY io.order_time DESC LIMIT ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return orders;
    }
    
    @Override
    public List<InboundOrder> getByPage(int pageNum, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT io.*, p.product_name, p.sku, l.location_code, w.warehouse_name " +
                        "FROM inbound_order io " +
                        "JOIN product p ON io.product_id = p.product_id " +
                        "JOIN storage_location l ON io.location_id = l.location_id " +
                        "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                        "ORDER BY io.order_time DESC LIMIT ?, ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, (pageNum - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return orders;
    }
    
    @Override
    public List<InboundOrder> getByPageWithConditions(int pageNum, int pageSize, Integer productId, Integer locationId, String operator, Date startDate, Date endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<InboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            StringBuilder sqlBuilder = new StringBuilder(
                "SELECT io.*, p.product_name, p.sku, l.location_code, w.warehouse_name " +
                "FROM inbound_order io " +
                "JOIN product p ON io.product_id = p.product_id " +
                "JOIN storage_location l ON io.location_id = l.location_id " +
                "JOIN warehouse w ON l.warehouse_id = w.warehouse_id " +
                "WHERE 1=1 "
            );
            
            List<Object> params = new ArrayList<>();
            
            if (productId != null) {
                sqlBuilder.append("AND io.product_id = ? ");
                params.add(productId);
            }
            
            if (locationId != null) {
                sqlBuilder.append("AND io.location_id = ? ");
                params.add(locationId);
            }
            
            if (operator != null && !operator.trim().isEmpty()) {
                sqlBuilder.append("AND io.operator LIKE ? ");
                params.add("%" + operator + "%");
            }
            
            if (startDate != null) {
                sqlBuilder.append("AND io.order_time >= ? ");
                params.add(new Timestamp(startDate.getTime()));
            }
            
            if (endDate != null) {
                sqlBuilder.append("AND io.order_time <= ? ");
                params.add(new Timestamp(endDate.getTime()));
            }
            
            sqlBuilder.append("ORDER BY io.order_time DESC LIMIT ?, ?");
            params.add((pageNum - 1) * pageSize);
            params.add(pageSize);
            
            pstmt = conn.prepareStatement(sqlBuilder.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            rs = pstmt.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DatabaseUtil.close(conn, pstmt, rs);
        }
        return orders;
    }
    
    @Override
    public int getTotalCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT COUNT(*) as total FROM inbound_order";
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
    public int getCountWithConditions(Integer productId, Integer locationId, String operator, Date startDate, Date endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) as total FROM inbound_order WHERE 1=1 ");
            List<Object> params = new ArrayList<>();
            
            if (productId != null) {
                sqlBuilder.append("AND product_id = ? ");
                params.add(productId);
            }
            
            if (locationId != null) {
                sqlBuilder.append("AND location_id = ? ");
                params.add(locationId);
            }
            
            if (operator != null && !operator.trim().isEmpty()) {
                sqlBuilder.append("AND operator LIKE ? ");
                params.add("%" + operator + "%");
            }
            
            if (startDate != null) {
                sqlBuilder.append("AND order_time >= ? ");
                params.add(new Timestamp(startDate.getTime()));
            }
            
            if (endDate != null) {
                sqlBuilder.append("AND order_time <= ? ");
                params.add(new Timestamp(endDate.getTime()));
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
    
    @Override
    public double getTotalInboundValue(Date startDate, Date endDate) {
        // 简化实现：这里需要产品价格表，暂时返回0
        return 0.0;
    }
    
    // 辅助方法：将ResultSet映射到InboundOrder对象
    private InboundOrder mapResultSetToOrder(ResultSet rs) throws SQLException {
        InboundOrder order = new InboundOrder();
        order.setOrderId(rs.getInt("order_id"));
        order.setOrderCode(rs.getString("order_code"));
        order.setProductId(rs.getInt("product_id"));
        order.setLocationId(rs.getInt("location_id"));
        order.setQuantity(rs.getInt("quantity"));
        order.setOrderTime(rs.getTimestamp("order_time"));
        order.setOperator(rs.getString("operator"));
        return order;
    }
}