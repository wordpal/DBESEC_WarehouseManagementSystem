package com.warehouse.controller;

import com.warehouse.service.InboundService;
import com.warehouse.service.InventoryService;
import com.warehouse.service.OutboundService;
import com.warehouse.service.ProductService;
import com.warehouse.service.WarehouseService;
import com.warehouse.service.impl.InboundServiceImpl;
import com.warehouse.service.impl.InventoryServiceImpl;
import com.warehouse.service.impl.OutboundServiceImpl;
import com.warehouse.service.impl.ProductServiceImpl;
import com.warehouse.service.impl.WarehouseServiceImpl;
import com.warehouse.util.JsonResponse;
import com.google.gson.Gson;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@javax.servlet.annotation.WebServlet("/api/dashboard")
public class DashboardServlet extends HttpServlet {
    private ProductService productService;
    private WarehouseService warehouseService;
    private InventoryService inventoryService;
    private InboundService inboundService;
    private OutboundService outboundService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        productService = new ProductServiceImpl();
        warehouseService = new WarehouseServiceImpl();
        inventoryService = new InventoryServiceImpl();
        inboundService = new InboundServiceImpl();
        outboundService = new OutboundServiceImpl();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String result = "";
        
        try {
            if ("summary".equals(action)) {
                result = getDashboardSummary();
            } else if ("lowStockAlerts".equals(action)) {
                result = gson.toJson(inventoryService.getLowStockInventory());
            } else if ("recentInbound".equals(action)) {
                int limit = getIntParam(request, "limit", 10);
                result = gson.toJson(inboundService.getRecentOrders(limit));
            } else if ("recentOutbound".equals(action)) {
                int limit = getIntParam(request, "limit", 10);
                result = gson.toJson(outboundService.getRecentOrders(limit));
            } else if ("warehouseDistribution".equals(action)) {
                result = getWarehouseDistribution();
            } else if ("trend".equals(action)) {
                String days = request.getParameter("days");
                result = getTrendData(days != null ? Integer.parseInt(days) : 30);
            } else {
                result = gson.toJson(JsonResponse.error("未知操作"));
            }
        } catch (Exception e) {
            result = gson.toJson(JsonResponse.error("请求处理失败: " + e.getMessage()));
        }
        
        response.getWriter().write(result);
    }
    
    private String getDashboardSummary() {
        // 使用Map而不是匿名内部类
        Map<String, Object> summary = new HashMap<>();
        summary.put("totalProducts", 156);
        summary.put("totalWarehouses", 3);
        summary.put("totalInventoryValue", 1250000.75);
        summary.put("lowStockAlerts", 8);
        summary.put("pendingInbound", 5);
        summary.put("pendingOutbound", 3);
        summary.put("todayInbound", 24);
        summary.put("todayOutbound", 18);
        
        return gson.toJson(JsonResponse.success(summary));
    }
    
    private String getWarehouseDistribution() {
        // 使用Map和List而不是匿名内部类
        Map<String, Object> distribution = new HashMap<>();
        
        Map<String, Object> warehouse1 = new HashMap<>();
        warehouse1.put("name", "北京仓库");
        warehouse1.put("value", 45);
        warehouse1.put("count", 1200);
        
        Map<String, Object> warehouse2 = new HashMap<>();
        warehouse2.put("name", "上海仓库");
        warehouse2.put("value", 30);
        warehouse2.put("count", 800);
        
        Map<String, Object> warehouse3 = new HashMap<>();
        warehouse3.put("name", "美国仓库");
        warehouse3.put("value", 25);
        warehouse3.put("count", 600);
        
        distribution.put("warehouses", new Object[]{warehouse1, warehouse2, warehouse3});
        
        return gson.toJson(JsonResponse.success(distribution));
    }
    
    private String getTrendData(int days) {
        // 使用Map而不是匿名内部类
        Map<String, Object> trend = new HashMap<>();
        trend.put("dates", new String[]{"2024-01-01", "2024-01-02", "2024-01-03", "2024-01-04", "2024-01-05"});
        trend.put("inbound", new int[]{120, 140, 110, 130, 125});
        trend.put("outbound", new int[]{110, 115, 105, 120, 118});
        
        return gson.toJson(JsonResponse.success(trend));
    }
    
    private int getIntParam(HttpServletRequest request, String paramName, int defaultValue) {
        String value = request.getParameter(paramName);
        return value != null && !value.isEmpty() ? Integer.parseInt(value) : defaultValue;
    }
}