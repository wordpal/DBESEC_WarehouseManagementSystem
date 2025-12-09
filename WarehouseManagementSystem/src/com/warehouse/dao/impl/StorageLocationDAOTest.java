package com.warehouse.dao.impl;

import com.warehouse.beans.StorageLocation;
import java.util.List;

public class StorageLocationDAOTest {
    public static void main(String[] args) {
        System.out.println("=== 开始测试 StorageLocationDAO ===");
        
        StorageLocationDAOImpl locationDAO = new StorageLocationDAOImpl();
        
        // 测试1：获取所有货位
        System.out.println("\n1. 测试获取所有货位：");
        List<StorageLocation> allLocations = locationDAO.getAll();
        System.out.println("货位总数: " + allLocations.size());
        for (StorageLocation loc : allLocations) {
            System.out.println("  - " + loc.getLocationCode() + " | 仓库ID:" + loc.getWarehouseId() + " | 状态:" + (loc.getStatus() == 0 ? "空闲" : "占用"));
        }
        
        // 测试2：按ID获取货位
        System.out.println("\n2. 测试按ID获取货位：");
        if (allLocations.size() > 0) {
            StorageLocation firstLocation = locationDAO.getById(allLocations.get(0).getLocationId());
            if (firstLocation != null) {
                System.out.println("获取到的货位: " + firstLocation.getLocationCode() + " | 状态: " + firstLocation.getStatus());
            }
        }
        
        // 测试3：按编码获取货位
        System.out.println("\n3. 测试按编码获取货位：");
        StorageLocation locationByCode = locationDAO.getByCode("BJ-A-01-01");
        if (locationByCode != null) {
            System.out.println("找到货位: " + locationByCode.getLocationCode() + " | 仓库ID: " + locationByCode.getWarehouseId());
        }
        
        // 测试4：按仓库获取货位
        System.out.println("\n4. 测试按仓库获取货位（仓库ID=1，北京仓库）：");
        List<StorageLocation> beijingLocations = locationDAO.getByWarehouse(1);
        System.out.println("北京仓库货位数量: " + beijingLocations.size());
        for (StorageLocation loc : beijingLocations) {
            System.out.println("  - " + loc.getLocationCode() + " | 状态:" + (loc.getStatus() == 0 ? "空闲" : "占用"));
        }
        
        // 测试5：获取空闲货位
        System.out.println("\n5. 测试获取空闲货位（仓库ID=1）：");
        List<StorageLocation> availableLocations = locationDAO.getAvailableLocations(1);
        System.out.println("北京仓库空闲货位数量: " + availableLocations.size());
        
        // 测试6：获取占用货位
        System.out.println("\n6. 测试获取占用货位（仓库ID=1）：");
        List<StorageLocation> occupiedLocations = locationDAO.getOccupiedLocations(1);
        System.out.println("北京仓库占用货位数量: " + occupiedLocations.size());
        
        // 测试7：测试分页查询
        System.out.println("\n7. 测试分页查询：");
        List<StorageLocation> pageLocations = locationDAO.getByPage(1, 5);
        System.out.println("第1页（每页5条）记录数: " + pageLocations.size());
        
        // 测试8：测试带条件分页
        System.out.println("\n8. 测试带条件分页查询（仓库ID=1，空闲货位）：");
        List<StorageLocation> filteredPage = locationDAO.getByPageWithWarehouse(1, 10, 1, 0);
        System.out.println("北京仓库空闲货位第1页记录数: " + filteredPage.size());
        
        // 测试9：测试统计
        System.out.println("\n9. 测试统计查询：");
        int totalCount = locationDAO.getTotalCount();
        System.out.println("总货位数: " + totalCount);
        
        // 测试10：测试状态更新
        System.out.println("\n10. 测试状态更新：");
        if (allLocations.size() > 0) {
            int testLocationId = allLocations.get(0).getLocationId();
            boolean updateSuccess = locationDAO.updateStatus(testLocationId, 1); // 设为占用
            System.out.println("状态更新结果: " + (updateSuccess ? "成功" : "失败"));
            
            // 验证更新
            StorageLocation updatedLoc = locationDAO.getById(testLocationId);
            if (updatedLoc != null) {
                System.out.println("更新后状态: " + updatedLoc.getStatus());
                
                // 恢复原状态
                locationDAO.updateStatus(testLocationId, 0);
            }
        }
        
        // 测试11：测试多仓库情况
        System.out.println("\n11. 测试各仓库货位分布：");
        System.out.println("仓库ID=1（北京）: " + locationDAO.getCountWithWarehouse(1, null) + " 个货位");
        System.out.println("仓库ID=2（上海）: " + locationDAO.getCountWithWarehouse(2, null) + " 个货位");
        System.out.println("仓库ID=3（美国）: " + locationDAO.getCountWithWarehouse(3, null) + " 个货位");
        
        System.out.println("\n=== StorageLocationDAO测试完成 ===");
    }
}