package com.warehouse.util;

import java.sql.*;

public class DatabaseUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/warehouse_ms?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "050320";  // 你的MySQL密码
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL驱动加载成功！");
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL驱动加载失败！");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
    
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // 测试数据库连接
    public static void testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            System.out.println("数据库连接测试成功！");
        } catch (SQLException e) {
            System.out.println("数据库连接测试失败：" + e.getMessage());
            e.printStackTrace();
        } finally {
            close(conn, null, null);
        }
    }
}