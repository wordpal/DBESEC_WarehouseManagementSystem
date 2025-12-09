package com.warehouse.service.impl;

import com.warehouse.beans.InboundOrder;
import com.warehouse.beans.Inventory;
import com.warehouse.beans.OutboundOrder;
import com.warehouse.dao.InboundOrderDAO;
import com.warehouse.dao.InventoryDAO;
import com.warehouse.dao.OutboundOrderDAO;
import com.warehouse.service.OutboundService;
import com.warehouse.util.JsonResponse;
import com.warehouse.dao.impl.InboundOrderDAOImpl;
import com.warehouse.dao.impl.InventoryDAOImpl;
import com.warehouse.dao.impl.OutboundOrderDAOImpl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class OutboundServiceImpl implements OutboundService {
    private OutboundOrderDAO outboundOrderDAO;
    private InventoryDAO inventoryDAO;
    private InboundOrderDAO inboundOrderDAO;
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    public OutboundServiceImpl() {
        this.outboundOrderDAO = new OutboundOrderDAOImpl();
        this.inventoryDAO = new InventoryDAOImpl();
        this.inboundOrderDAO = new InboundOrderDAOImpl();
    }
    
    @Override
    public JsonResponse add(OutboundOrder order) {
        try {
            // 生成出库单号
            String orderCode = "OUT-" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + 
                              "-" + String.format("%03d", outboundOrderDAO.getTotalCount() + 1);
            order.setOrderCode(orderCode);
            
            // 插入出库单
            boolean success = outboundOrderDAO.insert(order);
            if (success) {
                return JsonResponse.success("出库单创建成功", order);
            } else {
                return JsonResponse.error("出库单创建失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("出库异常: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse update(OutboundOrder order) {
        boolean success = outboundOrderDAO.update(order);
        return success ? JsonResponse.success("更新成功") : JsonResponse.error("更新失败");
    }
    
    @Override
    public JsonResponse delete(int orderId) {
        boolean success = outboundOrderDAO.delete(orderId);
        return success ? JsonResponse.success("删除成功") : JsonResponse.error("删除失败");
    }
    
    @Override
    public JsonResponse getById(int orderId) {
        OutboundOrder order = outboundOrderDAO.getById(orderId);
        return order != null ? JsonResponse.success(order) : JsonResponse.notFound("出库单不存在");
    }
    
    @Override
    public JsonResponse getAll() {
        List<OutboundOrder> orders = outboundOrderDAO.getAll();
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse getByPage(int pageNum, int pageSize) {
        List<OutboundOrder> orders = outboundOrderDAO.getByPage(pageNum, pageSize);
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse getByProduct(int productId) {
        List<OutboundOrder> orders = outboundOrderDAO.getByProduct(productId);
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse getByOperator(String operator) {
        List<OutboundOrder> orders = outboundOrderDAO.getByOperator(operator);
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse getRecentOrders(int limit) {
        List<OutboundOrder> orders = outboundOrderDAO.getRecentOrders(limit);
        return JsonResponse.success(orders);
    }
    
    @Override
    public JsonResponse searchOrders(Integer productId, String operator, String startDate, String endDate) {
        try {
            Date start = startDate != null ? sdf.parse(startDate) : null;
            Date end = endDate != null ? sdf.parse(endDate) : null;
            
            List<OutboundOrder> orders = outboundOrderDAO.getByPageWithConditions(1, 1000, productId, operator, start, end);
            int total = outboundOrderDAO.getCountWithConditions(productId, operator, start, end);
            
            // 使用Map而不是匿名内部类
            Map<String, Object> result = new HashMap<>();
            result.put("list", orders);
            result.put("total", total);
            
            return JsonResponse.success(result);
        } catch (Exception e) {
            return JsonResponse.error("搜索失败: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse fifoOutbound(int productId, int quantity, String operator) {
        try {
            // 检查总库存
            int totalStock = inventoryDAO.getTotalQuantityByProduct(productId);
            if (totalStock < quantity) {
                return JsonResponse.error("库存不足。总库存: " + totalStock + ", 需要: " + quantity);
            }
            
            // 获取按时间排序的入库记录（FIFO：先进先出）
            List<InboundOrder> inboundRecords = inboundOrderDAO.getByProduct(productId);
            
            int remainingQuantity = quantity;
            
            for (InboundOrder inbound : inboundRecords) {
                if (remainingQuantity <= 0) break;
                
                // 获取该货位的当前库存
                Inventory inventory = inventoryDAO.getByProductAndLocation(productId, inbound.getLocationId());
                if (inventory != null && inventory.getQuantity() > 0) {
                    int available = Math.min(inventory.getQuantity(), remainingQuantity);
                    
                    // 减少库存
                    boolean reduced = inventoryDAO.reduceQuantity(productId, inbound.getLocationId(), available);
                    if (reduced) {
                        remainingQuantity -= available;
                        
                        // 如果该货位库存清空，更新状态为空闲
                        Inventory updated = inventoryDAO.getByProductAndLocation(productId, inbound.getLocationId());
                        if (updated != null && updated.getQuantity() == 0) {
                            // 这里需要调用locationDAO更新状态，暂时省略
                        }
                    }
                }
            }
            
            if (remainingQuantity > 0) {
                return JsonResponse.error("FIFO出库失败，部分库存无法出库");
            }
            
            // 创建出库单
            OutboundOrder order = new OutboundOrder();
            order.setProductId(productId);
            order.setQuantity(quantity);
            order.setOperator(operator);
            
            return add(order);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("FIFO出库失败: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse checkStock(int productId, int quantity) {
        int totalStock = inventoryDAO.getTotalQuantityByProduct(productId);
        boolean available = totalStock >= quantity;
        
        // 使用Map而不是匿名内部类
        Map<String, Object> result = new HashMap<>();
        result.put("available", available);
        result.put("totalStock", totalStock);
        result.put("required", quantity);
        result.put("message", available ? "库存充足" : "库存不足");
        
        return JsonResponse.success(result);
    }
    
    @Override
    public JsonResponse getOutboundStats(String period) {
        // 使用Map而不是匿名内部类
        Map<String, Object> stats = new HashMap<>();
        stats.put("todayCount", 12);
        stats.put("weekCount", 76);
        stats.put("monthCount", 285);
        stats.put("todayValue", 98000.25);
        stats.put("weekValue", 720000.50);
        stats.put("monthValue", 2850000.75);
        
        return JsonResponse.success(stats);
    }
}