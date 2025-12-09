package com.warehouse.dao;

import com.warehouse.beans.OutboundOrder;
import java.util.Date;
import java.util.List;

public interface OutboundOrderDAO extends BaseDAO<OutboundOrder> {
    // 出库单特有的操作
    OutboundOrder getByOrderCode(String orderCode);
    List<OutboundOrder> getByProduct(int productId);
    List<OutboundOrder> getByDateRange(Date startDate, Date endDate);
    List<OutboundOrder> getByOperator(String operator);
    List<OutboundOrder> getRecentOrders(int limit);
    List<OutboundOrder> getByPageWithConditions(int pageNum, int pageSize, Integer productId, String operator, Date startDate, Date endDate);
    int getCountWithConditions(Integer productId, String operator, Date startDate, Date endDate);
    double getTotalOutboundValue(Date startDate, Date endDate);
    List<OutboundOrder> getFIFOOrders(int productId); // 获取某产品的FIFO出库单
}