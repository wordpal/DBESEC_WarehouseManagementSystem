package com.warehouse.dao;

import com.warehouse.beans.Warehouse;
import java.util.List;

public interface WarehouseDAO extends BaseDAO<Warehouse> {
    // 仓库特有的操作
    Warehouse getByCode(String warehouseCode);
    List<Warehouse> getActiveWarehouses();
    List<Warehouse> getByCountry(String country);
    boolean deactivateWarehouse(int warehouseId);
    boolean activateWarehouse(int warehouseId);
}