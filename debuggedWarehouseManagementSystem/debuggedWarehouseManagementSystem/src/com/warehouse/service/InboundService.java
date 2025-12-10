package com.warehouse.service;

import com.warehouse.util.JsonResponse;

public interface InboundService extends BaseService<com.warehouse.beans.InboundOrder> {
    // 入库业务特有方法
    JsonResponse getByProduct(int productId);
    JsonResponse getByLocation(int locationId);
    JsonResponse getByOperator(String operator);
    JsonResponse getRecentOrders(int limit);
    JsonResponse searchOrders(Integer productId, Integer locationId, String operator, String startDate, String endDate);
    
    // 智能入库（核心功能）
    JsonResponse smartInbound(int productId, int quantity, String operator);
    
    // 入库统计
    JsonResponse getInboundStats(String period); // daily, weekly, monthly
}