package com.warehouse.beans;

import java.math.BigDecimal;

public class Product {
    private int productId;
    private String sku;
    private String productName;
    private String category;
    private String specification;
    private BigDecimal length;
    private BigDecimal width;
    private BigDecimal height;
    private BigDecimal weight;
    private int safetyStock;
    private boolean isActive;
    
    public Product() {}
    
    public Product(String sku, String productName, String category, String specification, 
                  BigDecimal length, BigDecimal width, BigDecimal height, BigDecimal weight, int safetyStock) {
        this.sku = sku;
        this.productName = productName;
        this.category = category;
        this.specification = specification;
        this.length = length;
        this.width = width;
        this.height = height;
        this.weight = weight;
        this.safetyStock = safetyStock;
        this.isActive = true;
    }
    
    // GetterºÍSetter·½·¨
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public String getSpecification() { return specification; }
    public void setSpecification(String specification) { this.specification = specification; }
    
    public BigDecimal getLength() { return length; }
    public void setLength(BigDecimal length) { this.length = length; }
    
    public BigDecimal getWidth() { return width; }
    public void setWidth(BigDecimal width) { this.width = width; }
    
    public BigDecimal getHeight() { return height; }
    public void setHeight(BigDecimal height) { this.height = height; }
    
    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }
    
    public int getSafetyStock() { return safetyStock; }
    public void setSafetyStock(int safetyStock) { this.safetyStock = safetyStock; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
    
    @Override
    public String toString() {
        return "Product [productId=" + productId + ", sku=" + sku + 
               ", productName=" + productName + ", category=" + category + "]";
    }
}