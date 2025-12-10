package com.warehouse.beans;

public class Inventory {
    private int productId;
    private int locationId;
    private int quantity;
    private Product product;        // 关联的产品对象
    private StorageLocation location; // 关联的货位对象
    
    public Inventory() {}
    
    public Inventory(int productId, int locationId, int quantity) {
        this.productId = productId;
        this.locationId = locationId;
        this.quantity = quantity;
    }
    
    // Getter和Setter方法
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    
    public StorageLocation getLocation() { return location; }
    public void setLocation(StorageLocation location) { this.location = location; }
    
    @Override
    public String toString() {
        return "Inventory [productId=" + productId + ", locationId=" + locationId + 
               ", quantity=" + quantity + "]";
    }
}