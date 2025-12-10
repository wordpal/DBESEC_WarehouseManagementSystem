package com.warehouse.service.impl;

import com.warehouse.service.ProductService;
import com.warehouse.beans.Product;
import com.warehouse.dao.ProductDAO;
import com.warehouse.dao.impl.ProductDAOImpl;
import com.warehouse.util.JsonResponse;
import java.util.List;

public class ProductServiceImpl implements ProductService {
    
    private ProductDAO productDAO;
    
    public ProductServiceImpl() {
        this.productDAO = new ProductDAOImpl();
    }
    
    @Override
    public JsonResponse add(Product product) {
        try {
            boolean success = productDAO.insert(product);
            if (success) {
                return JsonResponse.success("产品添加成功", product);
            } else {
                return JsonResponse.error("产品添加失败");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse update(Product product) {
        try {
            boolean success = productDAO.update(product);
            if (success) {
                return JsonResponse.success("产品更新成功", product);
            } else {
                return JsonResponse.error("产品更新失败");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse delete(int id) {
        try {
            boolean success = productDAO.delete(id);
            if (success) {
                return JsonResponse.success("产品删除成功");
            } else {
                return JsonResponse.error("产品删除失败");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getById(int id) {
        try {
            Product product = productDAO.getById(id);
            if (product != null) {
                return JsonResponse.success(product);
            } else {
                return JsonResponse.notFound("产品不存在");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getAll() {
        try {
            List<Product> products = productDAO.getAll();
            return JsonResponse.success(products);
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByPage(int pageNum, int pageSize) {
        try {
            if (pageNum < 1) pageNum = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 10;
            
            List<Product> products = productDAO.getByPage(pageNum, pageSize);
            int totalCount = productDAO.getTotalCount();
            
            java.util.Map<String, Object> pageData = new java.util.HashMap<>();
            pageData.put("list", products);
            pageData.put("pageNum", pageNum);
            pageData.put("pageSize", pageSize);
            pageData.put("total", totalCount);
            pageData.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
            
            return JsonResponse.success(pageData);
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByCategory(String category) {
        try {
            List<Product> products = productDAO.getByCategory(category);
            return JsonResponse.success(products);
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse search(String keyword) {
        try {
            List<Product> products = productDAO.search(keyword);
            return JsonResponse.success(products);
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getLowStockProducts() {
        try {
            List<Product> products = productDAO.getLowStockProducts();
            return JsonResponse.success(products);
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getBySku(String sku) {
        try {
            Product product = productDAO.getBySku(sku);
            if (product != null) {
                return JsonResponse.success(product);
            } else {
                return JsonResponse.notFound("产品不存在");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
}