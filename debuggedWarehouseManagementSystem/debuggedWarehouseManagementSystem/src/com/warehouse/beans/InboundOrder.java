package com.warehouse.beans;

import java.util.Date;

public class InboundOrder {
    private int orderId;
    private String orderCode;
    private int productId;
    private int locationId;
    private int quantity;
    private Date orderTime;
    private String operator;
    private Product product;        // 关联的产品对象
    private StorageLocation location; // 关联的货位对象
    
    public InboundOrder() {}
    
    public InboundOrder(String orderCode, int productId, int locationId, int quantity, String operator) {
        this.orderCode = orderCode;
        this.productId = productId;
        this.locationId = locationId;
        this.quantity = quantity;
        this.operator = operator;
        this.orderTime = new Date();  // 默认当前时间
    }
    
    // Getter和Setter方法
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    
    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public Date getOrderTime() { return orderTime; }
    public void setOrderTime(Date orderTime) { this.orderTime = orderTime; }
    
    public String getOperator() { return operator; }
    public void setOperator(String operator) { this.operator = operator; }
    
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    
    public StorageLocation getLocation() { return location; }
    public void setLocation(StorageLocation location) { this.location = location; }
    
    @Override
    public String toString() {
        return "InboundOrder [orderId=" + orderId + ", orderCode=" + orderCode + 
               ", productId=" + productId + ", quantity=" + quantity + ", orderTime=" + orderTime + "]";
    }
}