package com.warehouse.service;

import com.warehouse.beans.StorageLocation;
import com.warehouse.util.JsonResponse;
import java.util.List;

public interface LocationService extends BaseService<StorageLocation> {
    // 货位特有的业务操作
    JsonResponse getByWarehouse(int warehouseId);
    JsonResponse getAvailableLocations(int warehouseId);
    JsonResponse getOccupiedLocations(int warehouseId);
    JsonResponse updateStatus(int locationId, int status);
    JsonResponse getByCode(String locationCode);
}