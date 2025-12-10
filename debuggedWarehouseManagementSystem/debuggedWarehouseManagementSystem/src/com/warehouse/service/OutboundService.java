package com.warehouse.service;

import com.warehouse.util.JsonResponse;

public interface OutboundService extends BaseService<com.warehouse.beans.OutboundOrder> {
    // 出库单相关查询
    JsonResponse getByProduct(int productId);
    JsonResponse getByOperator(String operator);
    JsonResponse getRecentOrders(int limit);
    
    // 修改searchOrders方法，添加缺失的参数
    JsonResponse searchOrders(Integer productId, String outboundNo, String operator, 
                             Integer warehouseId, String startDate, String endDate);
    
    // FIFO出库（先进先出）
    JsonResponse fifoOutbound(int productId, int quantity, String operator);
    
    // 库存检查
    JsonResponse checkStock(int productId, int quantity);
    
    // 出库统计
    JsonResponse getOutboundStats(String period);
}