package com.warehouse.test;

import com.warehouse.dao.impl.WarehouseDAOImpl;
import com.warehouse.beans.Warehouse;
import java.util.List;

public class DatabaseTest {
    public static void main(String[] args) {
        System.out.println("========== 数据库层完整测试 ==========");
        
        testWarehouseDAO();
        
        System.out.println("\n========== 所有测试完成 ==========");
    }
    
    private static void testWarehouseDAO() {
        System.out.println("\n--- WarehouseDAO 测试 ---");
        WarehouseDAOImpl dao = new WarehouseDAOImpl();
        
        try {
            // 测试查询
            List<Warehouse> list = dao.getAll();
            System.out.println(" 查询测试成功！获取到 " + list.size() + " 条记录");
            
            if (list.size() > 0) {
                Warehouse wh = list.get(0);
                System.out.println(" 第一条记录: " + wh.getWarehouseName() + " - " + wh.getCountry());
                
                // 测试按ID查询
                Warehouse whById = dao.getById(wh.getWarehouseId());
                if (whById != null) {
                    System.out.println(" 按ID查询成功: " + whById.getWarehouseName());
                }
            }
            
            // 测试分页
            List<Warehouse> pageList = dao.getByPage(1, 5);
            System.out.println("分页查询成功: " + pageList.size() + " 条记录");
            
            // 测试统计
            int count = dao.getTotalCount();
            System.out.println(" 统计查询成功: " + count + " 条总记录");
            
        } catch (Exception e) {
            System.out.println("❌ 测试失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
}