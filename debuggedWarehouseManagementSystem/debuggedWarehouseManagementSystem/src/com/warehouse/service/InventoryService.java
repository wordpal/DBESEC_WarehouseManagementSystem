package com.warehouse.service;

import com.warehouse.util.JsonResponse;

public interface InventoryService extends BaseService<com.warehouse.beans.Inventory> {
    // 库存业务特有的操作
    JsonResponse getByProduct(int productId);
    JsonResponse getByWarehouse(int warehouseId);
    JsonResponse getLowStockInventory();
    JsonResponse getInventorySummary(); // 库存概览
    JsonResponse searchInventory(Integer productId, Integer warehouseId, Integer minQty, Integer maxQty);
    
    // 【核心亮点】智能货位推荐
    JsonResponse recommendLocation(int productId, int warehouseId, int quantity);
    
    // 库存操作
    JsonResponse addStock(int productId, int locationId, int quantity, String operator);
    JsonResponse reduceStock(int productId, int locationId, int quantity, String operator);
    JsonResponse transferStock(int productId, int fromLocationId, int toLocationId, int quantity, String operator);
    
    // 库存统计报表
    JsonResponse getInventoryReport(String format); // format: "json", "excel", "csv"
}