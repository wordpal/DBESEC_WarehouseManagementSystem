package com.warehouse.dao.impl;

import com.warehouse.beans.Warehouse;
import java.util.List;

public class WarehouseDAOTest {
    public static void main(String[] args) {
        System.out.println("=== 开始测试 WarehouseDAO ===");
        
        WarehouseDAOImpl warehouseDAO = new WarehouseDAOImpl();
        
        // 测试1：获取所有仓库
        System.out.println("\n1. 测试获取所有仓库：");
        List<Warehouse> allWarehouses = warehouseDAO.getAll();
        System.out.println("仓库总数: " + allWarehouses.size());
        for (Warehouse w : allWarehouses) {
            System.out.println("  - " + w.getWarehouseName() + " (" + w.getCountry() + ")");
        }
        
        // 测试2：按ID获取单个仓库
        System.out.println("\n2. 测试按ID获取仓库：");
        if (allWarehouses.size() > 0) {
            Warehouse firstWarehouse = warehouseDAO.getById(allWarehouses.get(0).getWarehouseId());
            System.out.println("获取到的仓库: " + firstWarehouse.getWarehouseName());
        }
        
        // 测试3：按编码获取仓库
        System.out.println("\n3. 测试按编码获取仓库：");
        Warehouse whByCode = warehouseDAO.getByCode("WH_BJ");
        if (whByCode != null) {
            System.out.println("找到仓库: " + whByCode.getWarehouseName());
        } else {
            System.out.println("未找到仓库 WH_BJ");
        }
        
        // 测试4：获取活跃仓库
        System.out.println("\n4. 测试获取活跃仓库：");
        List<Warehouse> activeWarehouses = warehouseDAO.getActiveWarehouses();
        System.out.println("活跃仓库数量: " + activeWarehouses.size());
        
        // 测试5：测试分页
        System.out.println("\n5. 测试分页查询：");
        List<Warehouse> pageWarehouses = warehouseDAO.getByPage(1, 2);
        System.out.println("第1页（每页2条）记录数: " + pageWarehouses.size());
        
        // 测试6：测试总记录数
        System.out.println("\n6. 测试总记录数：");
        int totalCount = warehouseDAO.getTotalCount();
        System.out.println("总记录数: " + totalCount);
        
        // 测试7：测试按国家查询
        System.out.println("\n7. 测试按国家查询：");
        List<Warehouse> chinaWarehouses = warehouseDAO.getByCountry("China");
        System.out.println("中国的仓库数量: " + chinaWarehouses.size());
        
        System.out.println("\n=== WarehouseDAO测试完成 ===");
    }
}