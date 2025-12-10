package com.warehouse.beans;

import java.util.Date;

public class OutboundOrder {
    private int orderId;
    private String orderCode;
    private int productId;
    private int locationId;  // ← 添加这行！
    private int quantity;
    private Date orderTime;
    private String operator;
    private Product product;  // 关联的产品对象
    
    public OutboundOrder() {}
    
    // 修改构造方法，添加locationId参数
    public OutboundOrder(String orderCode, int productId, int locationId, int quantity, String operator) {
        this.orderCode = orderCode;
        this.productId = productId;
        this.locationId = locationId;  // ← 添加这行！
        this.quantity = quantity;
        this.operator = operator;
        this.orderTime = new Date();
    }
    
    // Getter和Setter方法
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    
    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    // 添加locationId的getter和setter ↓
    public int getLocationId() { 
        return locationId; 
    }
    
    public void setLocationId(int locationId) { 
        this.locationId = locationId; 
    }
    // 添加locationId的getter和setter ↑
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public Date getOrderTime() { return orderTime; }
    public void setOrderTime(Date orderTime) { this.orderTime = orderTime; }
    
    public String getOperator() { return operator; }
    public void setOperator(String operator) { this.operator = operator; }
    
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    
    @Override
    public String toString() {
        return "OutboundOrder [orderId=" + orderId + ", orderCode=" + orderCode + 
               ", productId=" + productId + ", locationId=" + locationId +  // ← 添加这行！
               ", quantity=" + quantity + ", orderTime=" + orderTime + "]";
    }
}