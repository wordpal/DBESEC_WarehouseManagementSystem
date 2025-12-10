package com.warehouse.service;

import com.warehouse.beans.Product;
import com.warehouse.util.JsonResponse;
import java.util.List;

public interface ProductService extends BaseService<Product> {
    JsonResponse getByCategory(String category);
    JsonResponse search(String keyword);
    JsonResponse getLowStockProducts();
    JsonResponse getBySku(String sku);
}