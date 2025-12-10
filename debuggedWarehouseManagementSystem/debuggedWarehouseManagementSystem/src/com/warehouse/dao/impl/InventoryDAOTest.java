package com.warehouse.dao.impl;

import com.warehouse.beans.Inventory;
import java.util.List;

public class InventoryDAOTest {
    public static void main(String[] args) {
        System.out.println("=== 开始测试 InventoryDAO ===");
        
        InventoryDAOImpl inventoryDAO = new InventoryDAOImpl();
        
        // 测试1：获取所有库存记录
        System.out.println("\n1. 测试获取所有库存记录：");
        List<Inventory> allInventory = inventoryDAO.getAll();
        System.out.println("库存记录总数: " + allInventory.size());
        if (allInventory.size() > 0) {
            System.out.println("前3条记录：");
            for (int i = 0; i < Math.min(3, allInventory.size()); i++) {
                Inventory inv = allInventory.get(i);
                System.out.println("  - 产品ID:" + inv.getProductId() + " | 货位ID:" + inv.getLocationId() + " | 数量:" + inv.getQuantity());
            }
        }
        
        // 测试2：获取特定产品的库存（iPhone 14 Black，产品ID应为1）
        System.out.println("\n2. 测试获取特定产品库存（产品ID=1，iPhone 14 Black）：");
        List<Inventory> iphoneInventory = inventoryDAO.getByProduct(1);
        System.out.println("iPhone 14 Black在" + iphoneInventory.size() + "个货位有库存：");
        for (Inventory inv : iphoneInventory) {
            System.out.println("  - 货位ID:" + inv.getLocationId() + " | 数量:" + inv.getQuantity());
        }
        
        // 测试3：获取特定货位的库存（BJ-A-01-01，货位ID应为1）
        System.out.println("\n3. 测试获取特定货位库存（货位ID=1，BJ-A-01-01）：");
        List<Inventory> locationInventory = inventoryDAO.getByLocation(1);
        System.out.println("货位BJ-A-01-01有" + locationInventory.size() + "种产品：");
        for (Inventory inv : locationInventory) {
            System.out.println("  - 产品ID:" + inv.getProductId() + " | 数量:" + inv.getQuantity());
        }
        
        // 测试4：获取特定仓库的库存（北京仓库，仓库ID=1）
        System.out.println("\n4. 测试获取特定仓库库存（仓库ID=1，北京仓库）：");
        List<Inventory> warehouseInventory = inventoryDAO.getByWarehouse(1);
        System.out.println("北京仓库共有" + warehouseInventory.size() + "条库存记录");
        
        // 测试5：测试按产品和货位查询
        System.out.println("\n5. 测试按产品和货位查询（产品ID=1，货位ID=1）：");
        Inventory specificInventory = inventoryDAO.getByProductAndLocation(1, 1);
        if (specificInventory != null) {
            System.out.println("找到库存记录：产品ID:" + specificInventory.getProductId() + 
                             " | 货位ID:" + specificInventory.getLocationId() + 
                             " | 数量:" + specificInventory.getQuantity());
        } else {
            System.out.println("未找到指定库存记录");
        }
        
        // 测试6：测试低库存查询
        System.out.println("\n6. 测试低库存查询：");
        List<Inventory> lowStockInventory = inventoryDAO.getLowStockInventory();
        System.out.println("低库存产品数量: " + lowStockInventory.size());
        for (Inventory inv : lowStockInventory) {
            System.out.println("  - 产品ID:" + inv.getProductId() + " | 货位ID:" + inv.getLocationId() + " | 数量:" + inv.getQuantity());
        }
        
        // 测试7：测试零库存查询
        System.out.println("\n7. 测试零库存查询：");
        List<Inventory> emptyInventory = inventoryDAO.getEmptyInventory();
        System.out.println("零库存记录数: " + emptyInventory.size());
        
        // 测试8：测试产品总库存
        System.out.println("\n8. 测试产品总库存计算（产品ID=1，iPhone 14 Black）：");
        int totalIphoneStock = inventoryDAO.getTotalQuantityByProduct(1);
        System.out.println("iPhone 14 Black总库存: " + totalIphoneStock + "台");
        
        // 测试9：测试仓库总库存
        System.out.println("\n9. 测试仓库总库存计算（仓库ID=1，北京仓库）：");
        int totalBeijingStock = inventoryDAO.getTotalQuantityByWarehouse(1);
        System.out.println("北京仓库总库存: " + totalBeijingStock + "件");
        
        // 测试10：测试条件搜索
        System.out.println("\n10. 测试条件搜索（北京仓库，库存>50）：");
        List<Inventory> searchResults = inventoryDAO.searchWithConditions(null, 1, null, 50, null);
        System.out.println("北京仓库库存大于50的记录数: " + searchResults.size());
        
        // 测试11：测试分页查询
        System.out.println("\n11. 测试分页查询：");
        List<Inventory> pageInventory = inventoryDAO.getByPage(1, 5);
        System.out.println("第1页（每页5条）记录数: " + pageInventory.size());
        
        // 测试12：测试库存数量操作
        System.out.println("\n12. 测试库存数量操作：");
        System.out.println("a) 测试增加库存（产品ID=1，货位ID=1，增加10）：");
        boolean addSuccess = inventoryDAO.addQuantity(1, 1, 10);
        System.out.println("增加库存结果: " + (addSuccess ? "成功" : "失败"));
        
        // 验证增加后的库存
        Inventory afterAdd = inventoryDAO.getByProductAndLocation(1, 1);
        if (afterAdd != null) {
            System.out.println("增加后库存: " + afterAdd.getQuantity());
        }
        
        System.out.println("b) 测试减少库存（产品ID=1，货位ID=1，减少5）：");
        boolean reduceSuccess = inventoryDAO.reduceQuantity(1, 1, 5);
        System.out.println("减少库存结果: " + (reduceSuccess ? "成功" : "失败"));
        
        // 验证减少后的库存
        Inventory afterReduce = inventoryDAO.getByProductAndLocation(1, 1);
        if (afterReduce != null) {
            System.out.println("减少后库存: " + afterReduce.getQuantity());
        }
        
        System.out.println("c) 测试恢复原库存数量（产品ID=1，货位ID=1，恢复为120）：");
        boolean restoreSuccess = inventoryDAO.updateQuantity(1, 1, 120);
        System.out.println("恢复库存结果: " + (restoreSuccess ? "成功" : "失败"));
        
        // 测试13：测试总记录数
        System.out.println("\n13. 测试总记录数：");
        int totalCount = inventoryDAO.getTotalCount();
        System.out.println("库存总记录数: " + totalCount);
        
        System.out.println("\n=== InventoryDAO测试完成 ===");
    }
}