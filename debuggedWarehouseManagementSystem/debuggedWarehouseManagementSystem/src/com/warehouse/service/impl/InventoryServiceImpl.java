package com.warehouse.service.impl;

import com.warehouse.service.InventoryService;
import com.warehouse.beans.Inventory;
import com.warehouse.beans.Product;
import com.warehouse.beans.StorageLocation;
import com.warehouse.dao.InventoryDAO;
import com.warehouse.dao.ProductDAO;
import com.warehouse.dao.StorageLocationDAO;
import com.warehouse.dao.impl.InventoryDAOImpl;
import com.warehouse.dao.impl.ProductDAOImpl;
import com.warehouse.dao.impl.StorageLocationDAOImpl;
import com.warehouse.util.JsonResponse;
import java.util.*;

public class InventoryServiceImpl implements InventoryService {
    
    private InventoryDAO inventoryDAO;
    private ProductDAO productDAO;
    private StorageLocationDAO locationDAO;
    
    public InventoryServiceImpl() {
        this.inventoryDAO = new InventoryDAOImpl();
        this.productDAO = new ProductDAOImpl();
        this.locationDAO = new StorageLocationDAOImpl();
    }
    
    @Override
    public JsonResponse add(Inventory inventory) {
        try {
            // 数据验证
            if (inventory.getProductId() <= 0) {
                return JsonResponse.badRequest("产品ID无效");
            }
            if (inventory.getLocationId() <= 0) {
                return JsonResponse.badRequest("货位ID无效");
            }
            if (inventory.getQuantity() < 0) {
                return JsonResponse.badRequest("库存数量不能为负数");
            }
            
            // 检查产品和货位是否存在
            Product product = productDAO.getById(inventory.getProductId());
            if (product == null) {
                return JsonResponse.notFound("产品不存在");
            }
            
            StorageLocation location = locationDAO.getById(inventory.getLocationId());
            if (location == null) {
                return JsonResponse.notFound("货位不存在");
            }
            
            boolean success = inventoryDAO.insert(inventory);
            if (success) {
                // 优化：更新货位状态为占用
                locationDAO.updateStatus(inventory.getLocationId(), 1);
                return JsonResponse.success("库存添加成功", inventory);
            } else {
                return JsonResponse.error("库存添加失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse update(Inventory inventory) {
        try {
            // Inventory表使用复合主键，更新逻辑特殊
            if (inventory.getProductId() <= 0 || inventory.getLocationId() <= 0) {
                return JsonResponse.badRequest("产品ID或货位ID无效");
            }
            
            boolean success = inventoryDAO.update(inventory);
            if (success) {
                // 优化：如果库存为0，更新货位状态为空闲
                if (inventory.getQuantity() == 0) {
                    locationDAO.updateStatus(inventory.getLocationId(), 0);
                }
                return JsonResponse.success("库存更新成功", inventory);
            } else {
                return JsonResponse.error("库存更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse delete(int id) {
        // Inventory使用复合主键，不能直接用单个ID删除
        return JsonResponse.error("库存记录需要使用产品ID和货位ID删除");
    }
    
    @Override
    public JsonResponse getById(int id) {
        // Inventory使用复合主键，不能直接用单个ID查询
        return JsonResponse.error("库存记录需要使用产品ID和货位ID查询");
    }
    
    @Override
    public JsonResponse getAll() {
        try {
            List<Inventory> inventories = inventoryDAO.getAll();
            // 关联产品信息
            List<Map<String, Object>> result = new ArrayList<>();
            for (Inventory inv : inventories) {
                Map<String, Object> item = new HashMap<>();
                item.put("inventory", inv);
                
                Product product = productDAO.getById(inv.getProductId());
                if (product != null) {
                    item.put("productName", product.getProductName());
                    item.put("sku", product.getSku());
                    item.put("safetyStock", product.getSafetyStock());
                }
                
                result.add(item);
            }
            return JsonResponse.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByPage(int pageNum, int pageSize) {
        try {
            if (pageNum < 1) pageNum = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 10;
            
            List<Inventory> inventories = inventoryDAO.getByPage(pageNum, pageSize);
            int totalCount = inventoryDAO.getTotalCount();
            
            Map<String, Object> pageData = new HashMap<>();
            pageData.put("list", inventories);
            pageData.put("pageNum", pageNum);
            pageData.put("pageSize", pageSize);
            pageData.put("total", totalCount);
            pageData.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
            
            return JsonResponse.success(pageData);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByProduct(int productId) {
        try {
            List<Inventory> inventories = inventoryDAO.getByProduct(productId);
            
            // 计算总库存
            int totalStock = 0;
            for (Inventory inv : inventories) {
                totalStock += inv.getQuantity();
            }
            
            Map<String, Object> result = new HashMap<>();
            result.put("inventories", inventories);
            result.put("totalStock", totalStock);
            
            // 添加产品信息
            Product product = productDAO.getById(productId);
            if (product != null) {
                result.put("productName", product.getProductName());
                result.put("safetyStock", product.getSafetyStock());
                result.put("isLowStock", totalStock <= product.getSafetyStock());
            }
            
            return JsonResponse.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByWarehouse(int warehouseId) {
        try {
            List<Inventory> inventories = inventoryDAO.getByWarehouse(warehouseId);
            
            // 按产品分类统计
            Map<Integer, Integer> productStock = new HashMap<>();
            int totalValue = 0;
            
            for (Inventory inv : inventories) {
                productStock.put(inv.getProductId(), 
                    productStock.getOrDefault(inv.getProductId(), 0) + inv.getQuantity());
            }
            
            Map<String, Object> result = new HashMap<>();
            result.put("inventories", inventories);
            result.put("productCount", productStock.size());
            result.put("totalItems", inventories.size());
            result.put("productDistribution", productStock);
            
            return JsonResponse.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getLowStockInventory() {
        try {
            List<Inventory> lowStockItems = inventoryDAO.getLowStockInventory();
            
            // 添加产品信息和库存状态
            List<Map<String, Object>> result = new ArrayList<>();
            for (Inventory inv : lowStockItems) {
                Map<String, Object> item = new HashMap<>();
                item.put("inventory", inv);
                
                Product product = productDAO.getById(inv.getProductId());
                if (product != null) {
                    item.put("productName", product.getProductName());
                    item.put("sku", product.getSku());
                    item.put("safetyStock", product.getSafetyStock());
                    item.put("stockRatio", (double) inv.getQuantity() / product.getSafetyStock());
                    
                    // 预警级别
                    if (inv.getQuantity() == 0) {
                        item.put("alertLevel", "red");      // 红色预警：无库存
                    } else if (inv.getQuantity() <= product.getSafetyStock() * 0.3) {
                        item.put("alertLevel", "orange");   // 橙色预警：库存严重不足
                    } else {
                        item.put("alertLevel", "yellow");   // 黄色预警：库存不足
                    }
                }
                
                result.add(item);
            }
            
            return JsonResponse.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getInventorySummary() {
        try {
            List<Inventory> allInventory = inventoryDAO.getAll();
            
            // 统计信息
            int totalProducts = 0;
            int totalQuantity = 0;
            int lowStockCount = 0;
            int zeroStockCount = 0;
            
            Set<Integer> productSet = new HashSet<>();
            for (Inventory inv : allInventory) {
                productSet.add(inv.getProductId());
                totalQuantity += inv.getQuantity();
                
                if (inv.getQuantity() == 0) {
                    zeroStockCount++;
                }
            }
            totalProducts = productSet.size();
            
            // 低库存统计
            List<Inventory> lowStock = inventoryDAO.getLowStockInventory();
            lowStockCount = lowStock.size();
            
            Map<String, Object> summary = new HashMap<>();
            summary.put("totalProducts", totalProducts);
            summary.put("totalQuantity", totalQuantity);
            summary.put("lowStockCount", lowStockCount);
            summary.put("zeroStockCount", zeroStockCount);
            summary.put("inventoryValue", "待计算"); // 需要价格信息
            
            return JsonResponse.success(summary);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse searchInventory(Integer productId, Integer warehouseId, Integer minQty, Integer maxQty) {
        try {
            List<Inventory> results = inventoryDAO.searchWithConditions(productId, warehouseId, null, minQty, maxQty);
            return JsonResponse.success(results);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse recommendLocation(int productId, int warehouseId, int quantity) {
        try {
            Product product = productDAO.getById(productId);
            if (product == null) {
                return JsonResponse.notFound("产品不存在");
            }
            
            // 1. 获取已有库存的货位
            List<Inventory> existingInventory = inventoryDAO.getByProduct(productId);
            Set<Integer> existingLocationIds = new HashSet<>();
            for (Inventory inv : existingInventory) {
                existingLocationIds.add(inv.getLocationId());
            }
            
            System.out.println("=== 智能推荐调试 ===");
            System.out.println("产品ID: " + productId + ", 已有库存货位: " + existingLocationIds);
            
            // 2. 获取所有候选货位（空闲的 + 已有库存的）
            List<StorageLocation> candidateLocations = new ArrayList<>();
            
            // 2.1 空闲货位
            List<StorageLocation> freeLocations = locationDAO.getAvailableLocations(warehouseId);
            candidateLocations.addAll(freeLocations);
            System.out.println("空闲货位数量: " + freeLocations.size());
            
            // 2.2 已有库存的货位（即使被占用）
            for (Integer locId : existingLocationIds) {
                StorageLocation loc = locationDAO.getById(locId);
                if (loc != null && loc.getWarehouseId() == warehouseId) {
                    // 检查是否已添加
                    boolean alreadyAdded = candidateLocations.stream()
                        .anyMatch(l -> l.getLocationId() == locId);
                    if (!alreadyAdded) {
                        candidateLocations.add(loc);
                        System.out.println("添加已有库存货位: " + locId);
                    }
                }
            }
            
            if (candidateLocations.isEmpty()) {
                return JsonResponse.error("该仓库没有可用货位");
            }
            
            System.out.println("总候选货位: " + candidateLocations.size());
            
            // 3. 智能推荐算法
            boolean hasDimensions = product.getLength() != null && product.getWidth() != null && product.getHeight() != null;
            
            List<Map<String, Object>> recommendations = new ArrayList<>();
            
            for (StorageLocation location : candidateLocations) {
                System.out.println("评分货位 " + location.getLocationId() + "[" + location.getLocationCode() + 
                                 "], status=" + location.getStatus());
                
                Map<String, Object> recommendation = new HashMap<>();
                recommendation.put("locationId", location.getLocationId());
                recommendation.put("locationCode", location.getLocationCode());
                
                int score = 0;
                StringBuilder reason = new StringBuilder();
                
                // 规则1：同一产品已有货位加分（集中存放）
                if (existingLocationIds.contains(location.getLocationId())) {
                    score += 30;
                    reason.append("同一产品已在此货位存放; ");
                    System.out.println("  +30分：已有库存");
                }
                
                // 规则2：尺寸匹配
                if (hasDimensions) {
                    score += 20;
                    reason.append("尺寸匹配; ");
                    System.out.println("  +20分：尺寸匹配");
                }
                
                // 规则3：空闲货位加分
                if (location.getStatus() == 0) {
                    score += 15;
                    reason.append("空闲货位; ");
                    System.out.println("  +15分：空闲货位");
                }
                
                // 规则4：基础分
                score += 5;
                reason.append("基础推荐");
                System.out.println("  +5分：基础分");
                System.out.println("  总分: " + score);
                
                recommendation.put("score", score);
                recommendation.put("reason", reason.toString());
                recommendations.add(recommendation);
            }
            
            // 按分数排序
            recommendations.sort((a, b) -> {
                int scoreA = (int) a.get("score");
                int scoreB = (int) b.get("score");
                return Integer.compare(scoreB, scoreA); // 降序
            });
            
            // 只返回前5个推荐
            if (recommendations.size() > 5) {
                recommendations = recommendations.subList(0, 5);
            }
            
            Map<String, Object> result = new HashMap<>();
            result.put("productId", productId);
            result.put("productName", product.getProductName());
            result.put("warehouseId", warehouseId);
            result.put("quantity", quantity);
            result.put("recommendations", recommendations);
            
            return JsonResponse.success("智能货位推荐完成", result);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse addStock(int productId, int locationId, int quantity, String operator) {
        try {
            if (quantity <= 0) {
                return JsonResponse.badRequest("入库数量必须大于0");
            }
            
            boolean success = inventoryDAO.addQuantity(productId, locationId, quantity);
            if (success) {
                // 优化：更新货位状态为占用
                locationDAO.updateStatus(locationId, 1);
                
                // 记录入库日志（这里可以调用InboundOrderDAO）
                Map<String, Object> result = new HashMap<>();
                result.put("productId", productId);
                result.put("locationId", locationId);
                result.put("quantity", quantity);
                result.put("operator", operator);
                result.put("message", "入库成功");
                
                return JsonResponse.success(result);
            } else {
                return JsonResponse.error("入库失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse reduceStock(int productId, int locationId, int quantity, String operator) {
        try {
            if (quantity <= 0) {
                return JsonResponse.badRequest("出库数量必须大于0");
            }
            
            // 检查库存是否足够
            Inventory current = inventoryDAO.getByProductAndLocation(productId, locationId);
            if (current == null || current.getQuantity() < quantity) {
                return JsonResponse.error("库存不足");
            }
            
            boolean success = inventoryDAO.reduceQuantity(productId, locationId, quantity);
            if (success) {
                // 计算新库存
                int newQuantity = current.getQuantity() - quantity;
                
                // 优化：如果库存为0，更新货位状态为空闲
                if (newQuantity == 0) {
                    locationDAO.updateStatus(locationId, 0);
                }
                
                // 记录出库日志
                Map<String, Object> result = new HashMap<>();
                result.put("productId", productId);
                result.put("locationId", locationId);
                result.put("quantity", quantity);
                result.put("remaining", newQuantity);
                result.put("operator", operator);
                result.put("message", "出库成功");
                
                return JsonResponse.success(result);
            } else {
                return JsonResponse.error("出库失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse transferStock(int productId, int fromLocationId, int toLocationId, int quantity, String operator) {
        try {
            // 1. 从原货位减少库存
            JsonResponse reduceResult = reduceStock(productId, fromLocationId, quantity, operator);
            if (reduceResult.getCode() != 200) {
                return reduceResult;
            }
            
            // 2. 向目标货位增加库存
            JsonResponse addResult = addStock(productId, toLocationId, quantity, operator);
            if (addResult.getCode() != 200) {
                // 如果增加失败，尝试恢复原库存
                addStock(productId, fromLocationId, quantity, "system-recovery");
                return JsonResponse.error("库存转移失败，已恢复原库存");
            }
            
            Map<String, Object> result = new HashMap<>();
            result.put("productId", productId);
            result.put("fromLocationId", fromLocationId);
            result.put("toLocationId", toLocationId);
            result.put("quantity", quantity);
            result.put("operator", operator);
            result.put("message", "库存转移成功");
            
            return JsonResponse.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getInventoryReport(String format) {
        // 简化的报表功能
        try {
            List<Inventory> allInventory = inventoryDAO.getAll();
            
            if ("json".equalsIgnoreCase(format)) {
                return JsonResponse.success(allInventory);
            } else if ("excel".equalsIgnoreCase(format) || "csv".equalsIgnoreCase(format)) {
                // 这里可以生成Excel或CSV文件
                Map<String, Object> report = new HashMap<>();
                report.put("format", format);
                report.put("recordCount", allInventory.size());
                report.put("message", format.toUpperCase() + "报表生成功能待实现");
                return JsonResponse.success(report);
            } else {
                return JsonResponse.badRequest("不支持的报表格式，支持: json, excel, csv");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
}