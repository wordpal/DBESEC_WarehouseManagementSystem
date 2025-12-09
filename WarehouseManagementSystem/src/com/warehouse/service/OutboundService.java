package com.warehouse.service;

import com.warehouse.util.JsonResponse;

public interface OutboundService extends BaseService<com.warehouse.beans.OutboundOrder> {
    // 出库业务特有方法
    JsonResponse getByProduct(int productId);
    JsonResponse getByOperator(String operator);
    JsonResponse getRecentOrders(int limit);
    JsonResponse searchOrders(Integer productId, String operator, String startDate, String endDate);
    
    // FIFO出库策略（核心功能）
    JsonResponse fifoOutbound(int productId, int quantity, String operator);
    
    // 库存检查
    JsonResponse checkStock(int productId, int quantity);
    
    // 出库统计
    JsonResponse getOutboundStats(String period);
}