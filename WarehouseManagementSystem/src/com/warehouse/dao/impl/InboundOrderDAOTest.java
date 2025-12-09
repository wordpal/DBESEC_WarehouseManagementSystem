package com.warehouse.dao.impl;

import com.warehouse.beans.InboundOrder;
import java.util.List;
import java.util.Date;
import java.util.Calendar;

public class InboundOrderDAOTest {
    public static void main(String[] args) {
        System.out.println("=== 开始测试 InboundOrderDAO ===");
        
        InboundOrderDAOImpl inboundDAO = new InboundOrderDAOImpl();
        
        // 测试1：获取所有入库单
        System.out.println("\n1. 测试获取所有入库单：");
        List<InboundOrder> allOrders = inboundDAO.getAll();
        System.out.println("入库单总数: " + allOrders.size());
        if (allOrders.size() > 0) {
            System.out.println("前3条记录：");
            for (int i = 0; i < Math.min(3, allOrders.size()); i++) {
                InboundOrder order = allOrders.get(i);
                System.out.println("  - 单号:" + order.getOrderCode() + 
                                 " | 产品ID:" + order.getProductId() + 
                                 " | 数量:" + order.getQuantity() + 
                                 " | 操作员:" + order.getOperator());
            }
        }
        
        // 测试2：按ID获取入库单
        System.out.println("\n2. 测试按ID获取入库单：");
        if (allOrders.size() > 0) {
            InboundOrder firstOrder = inboundDAO.getById(allOrders.get(0).getOrderId());
            if (firstOrder != null) {
                System.out.println("获取到的入库单: " + firstOrder.getOrderCode() + 
                                 " | 数量: " + firstOrder.getQuantity());
            }
        }
        
        // 测试3：按单号获取入库单
        System.out.println("\n3. 测试按单号获取入库单：");
        InboundOrder orderByCode = inboundDAO.getByOrderCode("IN-20240115-001");
        if (orderByCode != null) {
            System.out.println("找到入库单: " + orderByCode.getOrderCode() + 
                             " | 产品ID:" + orderByCode.getProductId() + 
                             " | 数量:" + orderByCode.getQuantity());
        } else {
            System.out.println("未找到入库单 IN-20240115-001");
        }
        
        // 测试4：按产品获取入库单（产品ID=1，iPhone 14 Black）
        System.out.println("\n4. 测试按产品获取入库单（产品ID=1）：");
        List<InboundOrder> productOrders = inboundDAO.getByProduct(1);
        System.out.println("iPhone 14 Black的入库单数量: " + productOrders.size());
        int totalIphoneInbound = 0;
        for (InboundOrder order : productOrders) {
            totalIphoneInbound += order.getQuantity();
            System.out.println("  - " + order.getOrderCode() + " | 数量:" + order.getQuantity() + " | 时间:" + order.getOrderTime());
        }
        System.out.println("iPhone 14 Black总入库量: " + totalIphoneInbound + "台");
        
        // 测试5：按货位获取入库单（货位ID=1，BJ-A-01-01）
        System.out.println("\n5. 测试按货位获取入库单（货位ID=1）：");
        List<InboundOrder> locationOrders = inboundDAO.getByLocation(1);
        System.out.println("货位BJ-A-01-01的入库单数量: " + locationOrders.size());
        
        // 测试6：按操作员获取入库单
        System.out.println("\n6. 测试按操作员获取入库单（操作员=Zhang San）：");
        List<InboundOrder> operatorOrders = inboundDAO.getByOperator("Zhang San");
        System.out.println("Zhang San操作的入库单数量: " + operatorOrders.size());
        
        // 测试7：按日期范围查询
        System.out.println("\n7. 测试按日期范围查询（2024年1月）：");
        Calendar cal = Calendar.getInstance();
        cal.set(2024, Calendar.JANUARY, 1, 0, 0, 0);
        Date startDate = cal.getTime();
        cal.set(2024, Calendar.JANUARY, 31, 23, 59, 59);
        Date endDate = cal.getTime();
        
        List<InboundOrder> dateRangeOrders = inboundDAO.getByDateRange(startDate, endDate);
        System.out.println("2024年1月的入库单数量: " + dateRangeOrders.size());
        
        // 测试8：获取最近入库单
        System.out.println("\n8. 测试获取最近入库单（最近3条）：");
        List<InboundOrder> recentOrders = inboundDAO.getRecentOrders(3);
        System.out.println("最近3条入库单：");
        for (InboundOrder order : recentOrders) {
            System.out.println("  - " + order.getOrderCode() + " | 产品ID:" + order.getProductId() + " | 数量:" + order.getQuantity());
        }
        
        // 测试9：测试分页查询
        System.out.println("\n9. 测试分页查询：");
        List<InboundOrder> pageOrders = inboundDAO.getByPage(1, 3);
        System.out.println("第1页（每页3条）记录数: " + pageOrders.size());
        
        // 测试10：测试条件分页查询
        System.out.println("\n10. 测试条件分页查询（产品ID=1）：");
        List<InboundOrder> filteredPage = inboundDAO.getByPageWithConditions(1, 5, 1, null, null, null, null);
        System.out.println("产品ID=1的入库单第1页记录数: " + filteredPage.size());
        
        // 测试11：测试总记录数
        System.out.println("\n11. 测试总记录数：");
        int totalCount = inboundDAO.getTotalCount();
        System.out.println("入库单总记录数: " + totalCount);
        
        // 测试12：测试条件计数
        System.out.println("\n12. 测试条件计数（操作员=Zhang San）：");
        int operatorCount = inboundDAO.getCountWithConditions(null, null, "Zhang San", null, null);
        System.out.println("Zhang San操作的入库单数量: " + operatorCount);
        
        // 测试13：测试新增入库单（演示，不实际保存）
        System.out.println("\n13. 测试新增入库单（演示）：");
        System.out.println("新增入库单功能接口已就绪，可在实际业务中调用");
        
        System.out.println("\n=== InboundOrderDAO测试完成 ===");
        
        // 附加：统计信息展示
        System.out.println("\n=== 入库统计信息 ===");
        System.out.println("总入库单数: " + totalCount);
        System.out.println("按操作员分布：");
        System.out.println("  - Zhang San: " + inboundDAO.getCountWithConditions(null, null, "Zhang San", null, null) + " 单");
        System.out.println("  - Li Si: " + inboundDAO.getCountWithConditions(null, null, "Li Si", null, null) + " 单");
        System.out.println("  - Wang Wu: " + inboundDAO.getCountWithConditions(null, null, "Wang Wu", null, null) + " 单");
        System.out.println("  - Zhao Liu: " + inboundDAO.getCountWithConditions(null, null, "Zhao Liu", null, null) + " 单");
        
        // 各产品入库量统计
        System.out.println("\n各产品入库量统计：");
        int[] productIds = {1, 2, 3, 4, 5, 9};
        for (int productId : productIds) {
            List<InboundOrder> orders = inboundDAO.getByProduct(productId);
            int totalQty = 0;
            for (InboundOrder order : orders) {
                totalQty += order.getQuantity();
            }
            if (totalQty > 0) {
                System.out.println("  - 产品ID " + productId + ": " + totalQty + " 件");
            }
        }
    }
}