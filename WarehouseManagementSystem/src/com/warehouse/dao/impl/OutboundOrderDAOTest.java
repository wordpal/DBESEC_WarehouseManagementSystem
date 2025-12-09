package com.warehouse.dao.impl;

import com.warehouse.beans.OutboundOrder;
import java.util.List;
import java.util.Date;
import java.util.Calendar;

public class OutboundOrderDAOTest {
    public static void main(String[] args) {
        System.out.println("=== 开始测试 OutboundOrderDAO ===");
        
        OutboundOrderDAOImpl outboundDAO = new OutboundOrderDAOImpl();
        
        // 测试1：获取所有出库单
        System.out.println("\n1. 测试获取所有出库单：");
        List<OutboundOrder> allOrders = outboundDAO.getAll();
        System.out.println("出库单总数: " + allOrders.size());
        if (allOrders.size() > 0) {
            System.out.println("前3条记录：");
            for (int i = 0; i < Math.min(3, allOrders.size()); i++) {
                OutboundOrder order = allOrders.get(i);
                System.out.println("  - 单号:" + order.getOrderCode() + 
                                 " | 产品ID:" + order.getProductId() + 
                                 " | 数量:" + order.getQuantity() + 
                                 " | 操作员:" + order.getOperator());
            }
        }
        
        // 测试2：按ID获取出库单
        System.out.println("\n2. 测试按ID获取出库单：");
        if (allOrders.size() > 0) {
            OutboundOrder firstOrder = outboundDAO.getById(allOrders.get(0).getOrderId());
            if (firstOrder != null) {
                System.out.println("获取到的出库单: " + firstOrder.getOrderCode() + 
                                 " | 数量: " + firstOrder.getQuantity());
            }
        }
        
        // 测试3：按单号获取出库单
        System.out.println("\n3. 测试按单号获取出库单：");
        OutboundOrder orderByCode = outboundDAO.getByOrderCode("OUT-20240120-001");
        if (orderByCode != null) {
            System.out.println("找出库单: " + orderByCode.getOrderCode() + 
                             " | 产品ID:" + orderByCode.getProductId() + 
                             " | 数量:" + orderByCode.getQuantity());
        } else {
            System.out.println("未找出库单 OUT-20240120-001");
        }
        
        // 测试4：按产品获取出库单（产品ID=1，iPhone 14 Black）
        System.out.println("\n4. 测试按产品获取出库单（产品ID=1）：");
        List<OutboundOrder> productOrders = outboundDAO.getByProduct(1);
        System.out.println("iPhone 14 Black的出库单数量: " + productOrders.size());
        int totalIphoneOutbound = 0;
        for (OutboundOrder order : productOrders) {
            totalIphoneOutbound += order.getQuantity();
            System.out.println("  - " + order.getOrderCode() + " | 数量:" + order.getQuantity() + " | 时间:" + order.getOrderTime());
        }
        System.out.println("iPhone 14 Black总出库量: " + totalIphoneOutbound + "台");
        
        // 测试5：测试FIFO出库单（产品ID=1）
        System.out.println("\n5. 测试FIFO出库单（产品ID=1）：");
        List<OutboundOrder> fifoOrders = outboundDAO.getFIFOOrders(1);
        System.out.println("iPhone 14 Black的FIFO出库单（按时间升序）：");
        for (OutboundOrder order : fifoOrders) {
            System.out.println("  - " + order.getOrderCode() + " | 数量:" + order.getQuantity() + " | 时间:" + order.getOrderTime());
        }
        
        // 测试6：按操作员获取出库单
        System.out.println("\n6. 测试按操作员获取出库单（操作员=Zhang San）：");
        List<OutboundOrder> operatorOrders = outboundDAO.getByOperator("Zhang San");
        System.out.println("Zhang San操作的出库单数量: " + operatorOrders.size());
        
        // 测试7：按日期范围查询
        System.out.println("\n7. 测试按日期范围查询（2024年1月）：");
        Calendar cal = Calendar.getInstance();
        cal.set(2024, Calendar.JANUARY, 1, 0, 0, 0);
        Date startDate = cal.getTime();
        cal.set(2024, Calendar.JANUARY, 31, 23, 59, 59);
        Date endDate = cal.getTime();
        
        List<OutboundOrder> dateRangeOrders = outboundDAO.getByDateRange(startDate, endDate);
        System.out.println("2024年1月的出库单数量: " + dateRangeOrders.size());
        
        // 测试8：获取最近出库单
        System.out.println("\n8. 测试获取最近出库单（最近3条）：");
        List<OutboundOrder> recentOrders = outboundDAO.getRecentOrders(3);
        System.out.println("最近3条出库单：");
        for (OutboundOrder order : recentOrders) {
            System.out.println("  - " + order.getOrderCode() + " | 产品ID:" + order.getProductId() + " | 数量:" + order.getQuantity());
        }
        
        // 测试9：测试分页查询
        System.out.println("\n9. 测试分页查询：");
        List<OutboundOrder> pageOrders = outboundDAO.getByPage(1, 3);
        System.out.println("第1页（每页3条）记录数: " + pageOrders.size());
        
        // 测试10：测试条件分页查询
        System.out.println("\n10. 测试条件分页查询（产品ID=1）：");
        List<OutboundOrder> filteredPage = outboundDAO.getByPageWithConditions(1, 5, 1, null, null, null);
        System.out.println("产品ID=1的出库单第1页记录数: " + filteredPage.size());
        
        // 测试11：测试总记录数
        System.out.println("\n11. 测试总记录数：");
        int totalCount = outboundDAO.getTotalCount();
        System.out.println("出库单总记录数: " + totalCount);
        
        // 测试12：测试条件计数
        System.out.println("\n12. 测试条件计数（操作员=Zhang San）：");
        int operatorCount = outboundDAO.getCountWithConditions(null, "Zhang San", null, null);
        System.out.println("Zhang San操作的出库单数量: " + operatorCount);
        
        System.out.println("\n=== OutboundOrderDAO测试完成 ===");
        
        // 附加：业务验证
        System.out.println("\n=== 出入库业务验证 ===");
        System.out.println("iPhone 14 Black（产品ID=1）库存分析：");
        System.out.println("  - 总入库量: 120台（来自入库单测试）");
        System.out.println("  - 总出库量: " + totalIphoneOutbound + "台");
        System.out.println("  - 当前库存: " + (120 - totalIphoneOutbound) + "台");
        
        System.out.println("\n=== 出库统计信息 ===");
        System.out.println("总出库单数: " + totalCount);
        System.out.println("按操作员分布：");
        // 这里可以添加更多统计
    }
}