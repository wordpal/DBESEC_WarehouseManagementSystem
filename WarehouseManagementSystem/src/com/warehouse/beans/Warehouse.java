package com.warehouse.beans;

public class Warehouse {
    private int warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private String country;
    private String address;
    private boolean isActive;
    
    public Warehouse() {}
    
    public Warehouse(String warehouseCode, String warehouseName, String country, String address) {
        this.warehouseCode = warehouseCode;
        this.warehouseName = warehouseName;
        this.country = country;
        this.address = address;
        this.isActive = true;
    }
    
    // GetterºÍSetter·½·¨
    public int getWarehouseId() { return warehouseId; }
    public void setWarehouseId(int warehouseId) { this.warehouseId = warehouseId; }
    
    public String getWarehouseCode() { return warehouseCode; }
    public void setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }
    
    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }
    
    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
    
    @Override
    public String toString() {
        return "Warehouse [warehouseId=" + warehouseId + ", warehouseCode=" + warehouseCode + 
               ", warehouseName=" + warehouseName + ", country=" + country + "]";
    }
}