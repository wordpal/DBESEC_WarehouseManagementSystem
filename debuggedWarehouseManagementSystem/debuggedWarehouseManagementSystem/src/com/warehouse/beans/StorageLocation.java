package com.warehouse.beans;

public class StorageLocation {
    private int locationId;
    private String locationCode;
    private int warehouseId;
    private int status;  // 0-空闲, 1-占用
    private Warehouse warehouse;  // 关联的仓库对象
    
    public StorageLocation() {}
    
    public StorageLocation(String locationCode, int warehouseId) {
        this.locationCode = locationCode;
        this.warehouseId = warehouseId;
        this.status = 0;  // 默认空闲
    }
    
    // Getter和Setter方法
    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }
    
    public String getLocationCode() { return locationCode; }
    public void setLocationCode(String locationCode) { this.locationCode = locationCode; }
    
    public int getWarehouseId() { return warehouseId; }
    public void setWarehouseId(int warehouseId) { this.warehouseId = warehouseId; }
    
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    
    public Warehouse getWarehouse() { return warehouse; }
    public void setWarehouse(Warehouse warehouse) { this.warehouse = warehouse; }
    
    @Override
    public String toString() {
        return "StorageLocation [locationId=" + locationId + ", locationCode=" + locationCode + 
               ", warehouseId=" + warehouseId + ", status=" + status + "]";
    }
}