package com.warehouse.dao;

import com.warehouse.beans.StorageLocation;
import java.util.List;

public interface StorageLocationDAO extends BaseDAO<StorageLocation> {
    // 货位特有的操作
    StorageLocation getByCode(String locationCode);
    List<StorageLocation> getByWarehouse(int warehouseId);
    List<StorageLocation> getAvailableLocations(int warehouseId);  // 空闲货位
    List<StorageLocation> getOccupiedLocations(int warehouseId);   // 占用货位
    boolean updateStatus(int locationId, int status);  // 更新货位状态
    List<StorageLocation> getByPageWithWarehouse(int pageNum, int pageSize, Integer warehouseId, Integer status);
    int getCountWithWarehouse(Integer warehouseId, Integer status);
}