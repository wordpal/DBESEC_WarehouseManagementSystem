package com.warehouse.controller;

import com.warehouse.service.OutboundService;
import com.warehouse.service.impl.OutboundServiceImpl;
import com.warehouse.util.JsonResponse;
import com.google.gson.Gson;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class OutboundServlet extends HttpServlet {
    private OutboundService outboundService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
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
            if ("getAll".equals(action)) {
                result = gson.toJson(outboundService.getAll());
            } else if ("getById".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                result = gson.toJson(outboundService.getById(id));
            } else if ("getByPage".equals(action)) {
                int pageNum = Integer.parseInt(request.getParameter("pageNum"));
                int pageSize = Integer.parseInt(request.getParameter("pageSize"));
                result = gson.toJson(outboundService.getByPage(pageNum, pageSize));
            } else if ("getByProduct".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                result = gson.toJson(outboundService.getByProduct(productId));
            } else if ("getByOperator".equals(action)) {
                String operator = request.getParameter("operator");
                result = gson.toJson(outboundService.getByOperator(operator));
            } else if ("getRecent".equals(action)) {
                int limit = Integer.parseInt(request.getParameter("limit"));
                result = gson.toJson(outboundService.getRecentOrders(limit));
            } else if ("search".equals(action)) {
                // 修改：读取所有查询参数
                Integer productId = getIntegerParam(request, "productId");
                String outboundNo = request.getParameter("outboundNo");
                String operator = request.getParameter("operator");
                Integer warehouseId = getIntegerParam(request, "warehouseId");
                String startDate = request.getParameter("startDate");
                String endDate = request.getParameter("endDate");
                
                // 打印调试信息
                System.out.println("=== Servlet接收的查询参数 ===");
                System.out.println("productId: " + productId);
                System.out.println("outboundNo: " + outboundNo);
                System.out.println("operator: " + operator);
                System.out.println("warehouseId: " + warehouseId);
                System.out.println("startDate: " + startDate);
                System.out.println("endDate: " + endDate);
                
                result = gson.toJson(outboundService.searchOrders(
                    productId, outboundNo, operator, warehouseId, startDate, endDate
                ));
            } else if ("checkStock".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                result = gson.toJson(outboundService.checkStock(productId, quantity));
            } else if ("getStats".equals(action)) {
                String period = request.getParameter("period");
                result = gson.toJson(outboundService.getOutboundStats(period));
            } else if ("testSearch".equals(action)) {
                // 测试方法
                if (outboundService instanceof OutboundServiceImpl) {
                    OutboundServiceImpl impl = (OutboundServiceImpl) outboundService;
                    result = gson.toJson(impl.testSearch());
                } else {
                    result = gson.toJson(JsonResponse.error("测试方法不可用"));
                }
            } else {
                result = gson.toJson(JsonResponse.error("未知操作"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            result = gson.toJson(JsonResponse.error("操作异常: " + e.getMessage()));
        }
        
        response.getWriter().write(result);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String result = "";
        
        try {
            if ("fifoOutbound".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String operator = request.getParameter("operator");
                result = gson.toJson(outboundService.fifoOutbound(productId, quantity, operator));
            } else {
                result = gson.toJson(JsonResponse.error("未知操作"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            result = gson.toJson(JsonResponse.error("操作异常: " + e.getMessage()));
        }
        
        response.getWriter().write(result);
    }
    
    private Integer getIntegerParam(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        if (value != null && !value.trim().isEmpty()) {
            try {
                return Integer.parseInt(value.trim());
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }
}