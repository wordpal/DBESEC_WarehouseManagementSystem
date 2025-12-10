package com.warehouse.util;

public class TestConnection {
    public static void main(String[] args) {
        System.out.println("=== 开始测试数据库连接 ===");
        DatabaseUtil.testConnection();
        System.out.println("=== 测试完成 ===");
    }
}