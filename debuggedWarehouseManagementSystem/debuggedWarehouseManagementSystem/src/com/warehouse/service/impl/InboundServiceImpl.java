package com.warehouse.service.impl;

import com.warehouse.beans.InboundOrder;
import com.warehouse.beans.Inventory;
import com.warehouse.beans.StorageLocation;
import com.warehouse.dao.InboundOrderDAO;
import com.warehouse.dao.InventoryDAO;
import com.warehouse.dao.StorageLocationDAO;
import com.warehouse.service.InboundService;
import com.warehouse.util.JsonResponse;
import com.warehouse.dao.impl.InboundOrderDAOImpl;
import com.warehouse.dao.impl.InventoryDAOImpl;
import com.warehouse.dao.impl.StorageLocationDAOImpl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class InboundServiceImpl implements InboundService {
    private InboundOrderDAO inboundOrderDAO;
    private InventoryDAO inventoryDAO;
    private StorageLocationDAO locationDAO;
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    public InboundServiceImpl() {
        this.inboundOrderDAO = new InboundOrderDAOImpl();
        this.inventoryDAO = new InventoryDAOImpl();
        this.locationDAO = new StorageLocationDAOImpl();
    }
    
    @Override
    public JsonResponse add(InboundOrder order) {
        try {
            // 生成入库单号
            String orderCode = "IN-" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + 
                              "-" + String.format("%03d", inboundOrderDAO.getTotalCount() + 1);
            order.setOrderCode(orderCode);
            
            // 插入入库单
            boolean success = inboundOrderDAO.insert(order);
            if (success) {
                // 更新库存
                inventoryDAO.addQuantity(order.getProductId(), order.getLocationId(), order.getQuantity());
                
                // 更新货位状态
                locationDAO.updateStatus(order.getLocationId(), 1);
                
                return JsonResponse.success("入库成功", order);
            } else {
                return JsonResponse.error("入库失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("入库异常: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse update(InboundOrder order) {
        boolean success = inboundOrderDAO.update(order);
        return success ? JsonResponse.success("更新成功") : JsonResponse.error("更新失败");
    }
    
    @Override
    public JsonResponse delete(int orderId) {
        boolean success = inboundOrderDAO.delete(orderId);
        return success ? JsonResponse.success("删除成功") : JsonResponse.error("删除失败");
    }
    
    @Override
    public JsonResponse getById(int orderId) {
        InboundOrder order = inboundOrderDAO.getById(orderId);
        return order != null ? JsonResponse.success(order) : JsonResponse.notFound("入库单不存在");
    }
    
    @Override
    public JsonResponse getAll() {
        List<InboundOrder> orders = inboundOrderDAO.getAll();
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse getByPage(int pageNum, int pageSize) {
        List<InboundOrder> orders = inboundOrderDAO.getByPage(pageNum, pageSize);
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse getByProduct(int productId) {
        List<InboundOrder> orders = inboundOrderDAO.getByProduct(productId);
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse getByLocation(int locationId) {
        List<InboundOrder> orders = inboundOrderDAO.getByLocation(locationId);
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse getByOperator(String operator) {
        List<InboundOrder> orders = inboundOrderDAO.getByOperator(operator);
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse getRecentOrders(int limit) {
        List<InboundOrder> orders = inboundOrderDAO.getRecentOrders(limit);
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse searchOrders(Integer productId, Integer locationId, String operator, String startDate, String endDate) {
        try {
            Date start = startDate != null ? sdf.parse(startDate) : null;
            Date end = endDate != null ? sdf.parse(endDate) : null;
            
            List<InboundOrder> orders = inboundOrderDAO.getByPageWithConditions(1, 1000, productId, locationId, operator, start, end);
            int total = inboundOrderDAO.getCountWithConditions(productId, locationId, operator, start, end);
            
            // 使用Map而不是匿名内部类，避免字段定义顺序问题
            Map<String, Object> result = new HashMap<>();
            result.put("list", orders);
            result.put("total", total);
            
            return JsonResponse.success(result);
        } catch (Exception e) {
            return JsonResponse.error("搜索失败: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse smartInbound(int productId, int quantity, String operator) {
        try {
            // 这里应该调用InventoryService的智能推荐算法
            // 简化版：选择第一个可用的货位
            List<StorageLocation> availableLocations = locationDAO.getAvailableLocations(1); // 默认仓库1
            
            if (availableLocations.isEmpty()) {
                return JsonResponse.error("没有可用的货位");
            }
            
            StorageLocation location = availableLocations.get(0);
            
            // 创建入库单
            InboundOrder order = new InboundOrder();
            order.setProductId(productId);
            order.setLocationId(location.getLocationId());
            order.setQuantity(quantity);
            order.setOperator(operator);
            
            return add(order);
        } catch (Exception e) {
            return JsonResponse.error("智能入库失败: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getInboundStats(String period) {
        // 使用Map而不是匿名内部类
        Map<String, Object> stats = new HashMap<>();
        stats.put("todayCount", 15);
        stats.put("weekCount", 89);
        stats.put("monthCount", 320);
        stats.put("todayValue", 125000.50);
        stats.put("weekValue", 890000.75);
        stats.put("monthValue", 3250000.25);
        
        return JsonResponse.success(stats);
    }
}