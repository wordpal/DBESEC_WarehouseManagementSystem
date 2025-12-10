package com.warehouse.dao;

import com.warehouse.beans.Inventory;
import java.util.List;

public interface InventoryDAO extends BaseDAO<Inventory> {
    // 库存特有的操作
    Inventory getByProductAndLocation(int productId, int locationId);
    List<Inventory> getByProduct(int productId);
    List<Inventory> getByLocation(int locationId);
    List<Inventory> getByWarehouse(int warehouseId);
    List<Inventory> getLowStockInventory();  // 低库存（库存≤安全库存）
    List<Inventory> getEmptyInventory();     // 零库存
    boolean updateQuantity(int productId, int locationId, int quantity);
    boolean addQuantity(int productId, int locationId, int quantity);  // 增加库存
    boolean reduceQuantity(int productId, int locationId, int quantity); // 减少库存
    int getTotalQuantityByProduct(int productId);  // 某个产品的总库存
    int getTotalQuantityByWarehouse(int warehouseId); // 某个仓库的总库存
    List<Inventory> searchWithConditions(Integer productId, Integer warehouseId, Integer locationId, Integer minQuantity, Integer maxQuantity);
}