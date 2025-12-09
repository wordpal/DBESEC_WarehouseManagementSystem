package com.warehouse.service;

import com.warehouse.util.JsonResponse;

public interface WarehouseService extends BaseService<com.warehouse.beans.Warehouse> {
    // 仓库业务特有的操作
    JsonResponse getByCode(String warehouseCode);
    JsonResponse getActiveWarehouses();
    JsonResponse getByCountry(String country);
    JsonResponse deactivateWarehouse(int warehouseId);
    JsonResponse activateWarehouse(int warehouseId);
    JsonResponse getWarehouseStats(); // 仓库统计信息
}