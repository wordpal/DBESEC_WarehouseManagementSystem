package com.warehouse.service.impl;

import com.warehouse.util.JsonResponse;

public class WarehouseServiceTest {
    public static void main(String[] args) {
        System.out.println("=== 开始测试 WarehouseService ===");
        
        WarehouseServiceImpl warehouseService = new WarehouseServiceImpl();
        
        // 测试1：获取所有仓库
        System.out.println("\n1. 测试获取所有仓库：");
        JsonResponse allResponse = warehouseService.getAll();
        System.out.println("响应码: " + allResponse.getCode());
        System.out.println("响应消息: " + allResponse.getMsg());
        if (allResponse.getData() != null) {
            java.util.List<?> warehouses = (java.util.List<?>) allResponse.getData();
            System.out.println("仓库数量: " + warehouses.size());
        }
        
        // 测试2：获取分页数据
        System.out.println("\n2. 测试分页查询（第1页，每页2条）：");
        JsonResponse pageResponse = warehouseService.getByPage(1, 2);
        System.out.println("响应码: " + pageResponse.getCode());
        System.out.println("响应消息: " + pageResponse.getMsg());
        
        // 测试3：按ID获取仓库
        System.out.println("\n3. 测试按ID获取仓库（ID=1）：");
        JsonResponse byIdResponse = warehouseService.getById(1);
        System.out.println("响应码: " + byIdResponse.getCode());
        System.out.println("响应消息: " + byIdResponse.getMsg());
        if (byIdResponse.getData() != null) {
            System.out.println("获取成功");
        }
        
        // 测试4：按编码获取仓库
        System.out.println("\n4. 测试按编码获取仓库（WH_BJ）：");
        JsonResponse byCodeResponse = warehouseService.getByCode("WH_BJ");
        System.out.println("响应码: " + byCodeResponse.getCode());
        System.out.println("响应消息: " + byCodeResponse.getMsg());
        
        // 测试5：获取活跃仓库
        System.out.println("\n5. 测试获取活跃仓库：");
        JsonResponse activeResponse = warehouseService.getActiveWarehouses();
        System.out.println("响应码: " + activeResponse.getCode());
        System.out.println("响应消息: " + activeResponse.getMsg());
        
        // 测试6：获取仓库统计
        System.out.println("\n6. 测试获取仓库统计信息：");
        JsonResponse statsResponse = warehouseService.getWarehouseStats();
        System.out.println("响应码: " + statsResponse.getCode());
        System.out.println("响应消息: " + statsResponse.getMsg());
        if (statsResponse.getData() != null) {
            java.util.Map<?, ?> stats = (java.util.Map<?, ?>) statsResponse.getData();
            System.out.println("统计信息: " + stats);
        }
        
        // 测试7：按国家查询
        System.out.println("\n7. 测试按国家查询（China）：");
        JsonResponse countryResponse = warehouseService.getByCountry("China");
        System.out.println("响应码: " + countryResponse.getCode());
        System.out.println("响应消息: " + countryResponse.getMsg());
        
        // 测试8：测试无效ID（错误处理）
        System.out.println("\n8. 测试错误处理（无效ID=999）：");
        JsonResponse invalidResponse = warehouseService.getById(999);
        System.out.println("响应码: " + invalidResponse.getCode());
        System.out.println("响应消息: " + invalidResponse.getMsg());
        
        System.out.println("\n=== WarehouseService测试完成 ===");
    }
}