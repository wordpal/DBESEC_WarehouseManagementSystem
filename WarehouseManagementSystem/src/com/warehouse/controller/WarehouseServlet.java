package com.warehouse.controller;

import com.warehouse.service.WarehouseService;
import com.warehouse.service.impl.WarehouseServiceImpl;
import com.warehouse.util.JsonResponse;
import com.google.gson.Gson;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class WarehouseServlet extends HttpServlet {
    private WarehouseService warehouseService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        warehouseService = new WarehouseServiceImpl();
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
                result = gson.toJson(warehouseService.getAll());
            } else if ("getById".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                result = gson.toJson(warehouseService.getById(id));
            } else if ("getByPage".equals(action)) {
                int pageNum = Integer.parseInt(request.getParameter("pageNum"));
                int pageSize = Integer.parseInt(request.getParameter("pageSize"));
                result = gson.toJson(warehouseService.getByPage(pageNum, pageSize));
            } else if ("getStats".equals(action)) {
                result = gson.toJson(warehouseService.getWarehouseStats());
            } else {
                result = gson.toJson(JsonResponse.error("未知操作"));
            }
        } catch (Exception e) {
            result = gson.toJson(JsonResponse.error("请求处理失败: " + e.getMessage()));
        }
        
        response.getWriter().write(result);
    }
}