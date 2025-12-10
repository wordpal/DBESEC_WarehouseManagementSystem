package com.warehouse.dao;

import com.warehouse.beans.OutboundOrder;
import java.util.Date;
import java.util.List;

public interface OutboundOrderDAO extends BaseDAO<OutboundOrder> {
    OutboundOrder getByOrderCode(String orderCode);
    List<OutboundOrder> getByProduct(int productId);
    List<OutboundOrder> getByDateRange(Date startDate, Date endDate);
    List<OutboundOrder> getByOperator(String operator);
    List<OutboundOrder> getRecentOrders(int limit);
    
    // 修改后的方法，添加outboundNo和warehouseId参数
    List<OutboundOrder> getByPageWithConditions(int pageNum, int pageSize, 
                                               Integer productId, String outboundNo, 
                                               String operator, Integer warehouseId, 
                                               Date startDate, Date endDate);
    int getCountWithConditions(Integer productId, String outboundNo, 
                              String operator, Integer warehouseId, 
                              Date startDate, Date endDate);
    
    double getTotalOutboundValue(Date startDate, Date endDate);
    List<OutboundOrder> getFIFOOrders(int productId);
}