package com.warehouse.controller;

import com.warehouse.service.InboundService;
import com.warehouse.service.impl.InboundServiceImpl;
import com.warehouse.util.JsonResponse;
import com.google.gson.Gson;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class InboundServlet extends HttpServlet {
    private InboundService inboundService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        inboundService = new InboundServiceImpl();
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
                result = gson.toJson(inboundService.getAll());
            } else if ("getById".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                result = gson.toJson(inboundService.getById(id));
            } else if ("getByPage".equals(action)) {
                int pageNum = Integer.parseInt(request.getParameter("pageNum"));
                int pageSize = Integer.parseInt(request.getParameter("pageSize"));
                result = gson.toJson(inboundService.getByPage(pageNum, pageSize));
            } else if ("getByProduct".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                result = gson.toJson(inboundService.getByProduct(productId));
            } else if ("getByLocation".equals(action)) {
                int locationId = Integer.parseInt(request.getParameter("locationId"));
                result = gson.toJson(inboundService.getByLocation(locationId));
            } else if ("getByOperator".equals(action)) {
                String operator = request.getParameter("operator");
                result = gson.toJson(inboundService.getByOperator(operator));
            } else if ("getRecent".equals(action)) {
                int limit = Integer.parseInt(request.getParameter("limit"));
                result = gson.toJson(inboundService.getRecentOrders(limit));
            } else if ("search".equals(action)) {
                Integer productId = getIntegerParam(request, "productId");
                Integer locationId = getIntegerParam(request, "locationId");
                String operator = request.getParameter("operator");
                String startDate = request.getParameter("startDate");
                String endDate = request.getParameter("endDate");
                result = gson.toJson(inboundService.searchOrders(productId, locationId, operator, startDate, endDate));
            } else if ("getStats".equals(action)) {
                String period = request.getParameter("period");
                result = gson.toJson(inboundService.getInboundStats(period));
            } else {
                result = gson.toJson(JsonResponse.error("未知操作"));
            }
        } catch (Exception e) {
            result = gson.toJson(JsonResponse.error("请求处理失败: " + e.getMessage()));
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
            if ("smartInbound".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String operator = request.getParameter("operator");
                result = gson.toJson(inboundService.smartInbound(productId, quantity, operator));
            } else {
                result = gson.toJson(JsonResponse.error("未知操作"));
            }
        } catch (Exception e) {
            result = gson.toJson(JsonResponse.error("操作失败: " + e.getMessage()));
        }
        
        response.getWriter().write(result);
    }
    
    private Integer getIntegerParam(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value != null && !value.isEmpty() ? Integer.parseInt(value) : null;
    }
}