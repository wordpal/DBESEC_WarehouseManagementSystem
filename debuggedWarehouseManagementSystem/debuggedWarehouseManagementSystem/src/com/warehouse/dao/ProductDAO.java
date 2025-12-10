package com.warehouse.dao;

import com.warehouse.beans.Product;
import java.util.List;

public interface ProductDAO extends BaseDAO<Product> {
    // 产品特有的操作
    Product getBySku(String sku);
    List<Product> getByCategory(String category);
    List<Product> search(String keyword);  // 按名称或SKU搜索
    List<Product> getLowStockProducts();   // 获取低库存产品（库存≤安全库存）
    List<Product> getActiveProducts();
    boolean deactivateProduct(int productId);
    boolean activateProduct(int productId);
    List<Product> getByPageWithKeyword(int pageNum, int pageSize, String keyword, String category);
    int getCountWithKeyword(String keyword, String category);
}