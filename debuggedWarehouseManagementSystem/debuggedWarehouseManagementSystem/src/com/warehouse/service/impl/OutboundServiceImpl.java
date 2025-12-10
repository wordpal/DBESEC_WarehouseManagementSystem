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
import com.warehouse.dao.StorageLocationDAO;
import com.warehouse.dao.impl.StorageLocationDAOImpl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class OutboundServiceImpl implements OutboundService {
    private OutboundOrderDAO outboundOrderDAO;
    private InventoryDAO inventoryDAO;
    private InboundOrderDAO inboundOrderDAO;
    private StorageLocationDAO locationDAO;
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    public OutboundServiceImpl() {
        this.outboundOrderDAO = new OutboundOrderDAOImpl();
        this.inventoryDAO = new InventoryDAOImpl();
        this.inboundOrderDAO = new InboundOrderDAOImpl();
        this.locationDAO = new StorageLocationDAOImpl();
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
    public JsonResponse searchOrders(Integer productId, String outboundNo, String operator, 
                                    Integer warehouseId, String startDate, String endDate) {
        try {
            Date start = null;
            Date end = null;
            
            // 解析日期参数
            if (startDate != null && !startDate.trim().isEmpty()) {
                start = sdf.parse(startDate);
            }
            if (endDate != null && !endDate.trim().isEmpty()) {
                end = sdf.parse(endDate);
            }
            
            // 调用修改后的DAO方法，传递所有参数
            List<OutboundOrder> orders = outboundOrderDAO.getByPageWithConditions(
                1, 1000, productId, outboundNo, operator, warehouseId, start, end);
            int total = outboundOrderDAO.getCountWithConditions(
                productId, outboundNo, operator, warehouseId, start, end);
            
            // 使用Map返回结果
            Map<String, Object> result = new HashMap<>();
            result.put("list", orders);
            result.put("total", total);
            
            // 打印调试信息
            System.out.println("=== 出库单搜索调试 ===");
            System.out.println("查询条件: productId=" + productId + 
                              ", outboundNo=" + outboundNo + 
                              ", operator=" + operator + 
                              ", warehouseId=" + warehouseId + 
                              ", startDate=" + startDate + 
                              ", endDate=" + endDate);
            System.out.println("查询结果: 找到 " + orders.size() + " 条记录");
            
            return JsonResponse.success(result);
        } catch (Exception e) {
            e.printStackTrace();
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
            
            // 按入库时间排序（确保FIFO）
            inboundRecords.sort((a, b) -> a.getOrderTime().compareTo(b.getOrderTime()));
            
            int remainingQuantity = quantity;
            int outboundLocationId = -1;
            boolean locationAssigned = false;
            
            System.out.println("=== FIFO出库调试 ===");
            System.out.println("产品ID: " + productId + ", 数量: " + quantity);
            System.out.println("入库记录数: " + inboundRecords.size());
            
            for (InboundOrder inbound : inboundRecords) {
                if (remainingQuantity <= 0) break;
                
                // 获取该货位的当前库存
                Inventory inventory = inventoryDAO.getByProductAndLocation(productId, inbound.getLocationId());
                System.out.println("检查货位 " + inbound.getLocationId() + " 库存: " + 
                                  (inventory != null ? inventory.getQuantity() : 0));
                
                if (inventory != null && inventory.getQuantity() > 0) {
                    int available = Math.min(inventory.getQuantity(), remainingQuantity);
                    
                    System.out.println("从货位 " + inbound.getLocationId() + " 出库 " + available + " 个");
                    
                    // 减少库存
                    boolean reduced = inventoryDAO.reduceQuantity(productId, inbound.getLocationId(), available);
                    if (reduced) {
                        remainingQuantity -= available;
                        
                        // 记录第一个出库的货位作为出库单的location_id
                        if (!locationAssigned) {
                            outboundLocationId = inbound.getLocationId();
                            locationAssigned = true;
                            System.out.println("设置出库货位ID: " + outboundLocationId);
                        }
                        
                        // 检查扣减后库存是否为0
                        Inventory updated = inventoryDAO.getByProductAndLocation(productId, inbound.getLocationId());
                        if (updated != null && updated.getQuantity() == 0) {
                            // 更新货位状态为空闲
                            locationDAO.updateStatus(inbound.getLocationId(), 0);
                            System.out.println("货位 " + inbound.getLocationId() + " 库存为0，状态更新为空闲");
                        }
                    }
                }
            }
            
            if (remainingQuantity > 0) {
                return JsonResponse.error("FIFO出库失败，剩余 " + remainingQuantity + " 个无法出库");
            }
            
            if (outboundLocationId == -1) {
                return JsonResponse.error("无法确定出库货位");
            }
            
            System.out.println("创建出库单，货位ID: " + outboundLocationId);
            
            // 创建出库单
            OutboundOrder order = new OutboundOrder();
            order.setProductId(productId);
            order.setLocationId(outboundLocationId);
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
    
    // 测试方法（可选）
    public JsonResponse testSearch() {
        try {
            // 测试仓库ID=1的查询
            List<OutboundOrder> orders = outboundOrderDAO.getByPageWithConditions(
                1, 1000, null, null, null, 1, null, null);
            
            Map<String, Object> result = new HashMap<>();
            result.put("message", "测试查询成功");
            result.put("count", orders.size());
            result.put("data", orders);
            
            return JsonResponse.success(result);
        } catch (Exception e) {
            return JsonResponse.error("测试失败: " + e.getMessage());
        }
    }
}