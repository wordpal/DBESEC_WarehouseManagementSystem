package com.warehouse.dao.impl;

import com.warehouse.beans.Product;
import java.util.List;
import java.math.BigDecimal;

public class ProductDAOTest {
    public static void main(String[] args) {
        System.out.println("=== 开始测试 ProductDAO ===");
        
        ProductDAOImpl productDAO = new ProductDAOImpl();
        
        // 测试1：获取所有产品
        System.out.println("\n1. 测试获取所有产品：");
        List<Product> allProducts = productDAO.getAll();
        System.out.println("产品总数: " + allProducts.size());
        for (Product p : allProducts) {
            System.out.println("  - " + p.getSku() + " | " + p.getProductName() + " | " + p.getCategory());
        }
        
        // 测试2：按SKU获取产品
        System.out.println("\n2. 测试按SKU获取产品：");
        Product iphone = productDAO.getBySku("IPHONE14-BK");
        if (iphone != null) {
            System.out.println("找到产品: " + iphone.getProductName() + " | 安全库存: " + iphone.getSafetyStock());
        }
        
        // 测试3：按分类获取产品
        System.out.println("\n3. 测试按分类获取产品：");
        List<Product> electronics = productDAO.getByCategory("Mobile Phone");
        System.out.println("手机分类产品数量: " + electronics.size());
        
        // 测试4：搜索产品
        System.out.println("\n4. 测试搜索产品：");
        List<Product> searchResults = productDAO.search("iPhone");
        System.out.println("搜索'iPhone'结果数量: " + searchResults.size());
        
        // 测试5：获取活跃产品
        System.out.println("\n5. 测试获取活跃产品：");
        List<Product> activeProducts = productDAO.getActiveProducts();
        System.out.println("活跃产品数量: " + activeProducts.size());
        
        // 测试6：分页测试
        System.out.println("\n6. 测试分页查询：");
        List<Product> page1 = productDAO.getByPage(1, 3);
        System.out.println("第1页（每页3条）记录数: " + page1.size());
        
        // 测试7：带条件分页
        System.out.println("\n7. 测试带条件分页查询：");
        List<Product> filteredPage = productDAO.getByPageWithKeyword(1, 5, "Phone", null);
        System.out.println("搜索'Phone'第1页记录数: " + filteredPage.size());
        
        System.out.println("\n=== ProductDAO测试完成 ===");
    }
}