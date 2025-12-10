package com.warehouse.dao;

import com.warehouse.beans.InboundOrder;
import java.util.Date;
import java.util.List;

public interface InboundOrderDAO extends BaseDAO<InboundOrder> {
    // 入库单特有的操作
    InboundOrder getByOrderCode(String orderCode);
    List<InboundOrder> getByProduct(int productId);
    List<InboundOrder> getByLocation(int locationId);
    List<InboundOrder> getByDateRange(Date startDate, Date endDate);
    List<InboundOrder> getByOperator(String operator);
    List<InboundOrder> getRecentOrders(int limit);
    List<InboundOrder> getByPageWithConditions(int pageNum, int pageSize, Integer productId, Integer locationId, String operator, Date startDate, Date endDate);
    int getCountWithConditions(Integer productId, Integer locationId, String operator, Date startDate, Date endDate);
    double getTotalInboundValue(Date startDate, Date endDate); // 入库总价值（需关联产品表）
}