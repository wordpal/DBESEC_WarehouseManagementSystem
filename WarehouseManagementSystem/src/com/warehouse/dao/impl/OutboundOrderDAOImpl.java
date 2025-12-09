package com.warehouse.dao.impl;

import com.warehouse.dao.OutboundOrderDAO;
import com.warehouse.beans.OutboundOrder;
import com.warehouse.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OutboundOrderDAOImpl implements OutboundOrderDAO {
    
    @Override
    public boolean insert(OutboundOrder order) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "INSERT INTO outbound_order (order_code, product_id, quantity, operator) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, order.getOrderCode());
            pstmt.setInt(2, order.getProductId());
            pstmt.setInt(3, order.getQuantity());
            pstmt.setString(4, order.getOperator());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DatabaseUtil.close(conn, pstmt, null);
        }
    }
    
    @Override
    public boolean update(OutboundOrder order) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "UPDATE outbound_order SET order_code=?, product_id=?, quantity=?, operator=? WHERE order_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, order.getOrderCode());
            pstmt.setInt(2, order.getProductId());
            pstmt.setInt(3, order.getQuantity());
            pstmt.setString(4, order.getOperator());
            pstmt.setInt(5, order.getOrderId());
            
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
            String sql = "DELETE FROM outbound_order WHERE order_id = ?";
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
    public OutboundOrder getById(int orderId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT oo.*, p.product_name, p.sku " +
                        "FROM outbound_order oo " +
                        "JOIN product p ON oo.product_id = p.product_id " +
                        "WHERE oo.order_id = ?";
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
    public List<OutboundOrder> getAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<OutboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT oo.*, p.product_name, p.sku " +
                        "FROM outbound_order oo " +
                        "JOIN product p ON oo.product_id = p.product_id " +
                        "ORDER BY oo.order_time DESC";
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
    public OutboundOrder getByOrderCode(String orderCode) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT oo.*, p.product_name, p.sku " +
                        "FROM outbound_order oo " +
                        "JOIN product p ON oo.product_id = p.product_id " +
                        "WHERE oo.order_code = ?";
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
    public List<OutboundOrder> getByProduct(int productId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<OutboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT oo.*, p.product_name, p.sku " +
                        "FROM outbound_order oo " +
                        "JOIN product p ON oo.product_id = p.product_id " +
                        "WHERE oo.product_id = ? " +
                        "ORDER BY oo.order_time ASC"; // FIFO需要按时间升序
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
    public List<OutboundOrder> getByDateRange(Date startDate, Date endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<OutboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT oo.*, p.product_name, p.sku " +
                        "FROM outbound_order oo " +
                        "JOIN product p ON oo.product_id = p.product_id " +
                        "WHERE oo.order_time BETWEEN ? AND ? " +
                        "ORDER BY oo.order_time DESC";
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
    public List<OutboundOrder> getByOperator(String operator) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<OutboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT oo.*, p.product_name, p.sku " +
                        "FROM outbound_order oo " +
                        "JOIN product p ON oo.product_id = p.product_id " +
                        "WHERE oo.operator LIKE ? " +
                        "ORDER BY oo.order_time DESC";
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
    public List<OutboundOrder> getRecentOrders(int limit) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<OutboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT oo.*, p.product_name, p.sku " +
                        "FROM outbound_order oo " +
                        "JOIN product p ON oo.product_id = p.product_id " +
                        "ORDER BY oo.order_time DESC LIMIT ?";
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
    public List<OutboundOrder> getFIFOOrders(int productId) {
        // 获取某产品的所有出库单，按时间升序（FIFO：先进先出）
        return getByProduct(productId); // 已经在getByProduct中按时间升序
    }
    
    @Override
    public List<OutboundOrder> getByPage(int pageNum, int pageSize) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<OutboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            String sql = "SELECT oo.*, p.product_name, p.sku " +
                        "FROM outbound_order oo " +
                        "JOIN product p ON oo.product_id = p.product_id " +
                        "ORDER BY oo.order_time DESC LIMIT ?, ?";
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
    public List<OutboundOrder> getByPageWithConditions(int pageNum, int pageSize, Integer productId, String operator, Date startDate, Date endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<OutboundOrder> orders = new ArrayList<>();
        
        try {
            conn = DatabaseUtil.getConnection();
            StringBuilder sqlBuilder = new StringBuilder(
                "SELECT oo.*, p.product_name, p.sku " +
                "FROM outbound_order oo " +
                "JOIN product p ON oo.product_id = p.product_id " +
                "WHERE 1=1 "
            );
            
            List<Object> params = new ArrayList<>();
            
            if (productId != null) {
                sqlBuilder.append("AND oo.product_id = ? ");
                params.add(productId);
            }
            
            if (operator != null && !operator.trim().isEmpty()) {
                sqlBuilder.append("AND oo.operator LIKE ? ");
                params.add("%" + operator + "%");
            }
            
            if (startDate != null) {
                sqlBuilder.append("AND oo.order_time >= ? ");
                params.add(new Timestamp(startDate.getTime()));
            }
            
            if (endDate != null) {
                sqlBuilder.append("AND oo.order_time <= ? ");
                params.add(new Timestamp(endDate.getTime()));
            }
            
            sqlBuilder.append("ORDER BY oo.order_time DESC LIMIT ?, ?");
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
            String sql = "SELECT COUNT(*) as total FROM outbound_order";
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
    public int getCountWithConditions(Integer productId, String operator, Date startDate, Date endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) as total FROM outbound_order WHERE 1=1 ");
            List<Object> params = new ArrayList<>();
            
            if (productId != null) {
                sqlBuilder.append("AND product_id = ? ");
                params.add(productId);
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
    public double getTotalOutboundValue(Date startDate, Date endDate) {
        // 简化实现：这里需要产品价格表，暂时返回0
        return 0.0;
    }
    
    // 辅助方法：将ResultSet映射到OutboundOrder对象
    private OutboundOrder mapResultSetToOrder(ResultSet rs) throws SQLException {
        OutboundOrder order = new OutboundOrder();
        order.setOrderId(rs.getInt("order_id"));
        order.setOrderCode(rs.getString("order_code"));
        order.setProductId(rs.getInt("product_id"));
        order.setQuantity(rs.getInt("quantity"));
        order.setOrderTime(rs.getTimestamp("order_time"));
        order.setOperator(rs.getString("operator"));
        return order;
    }
}