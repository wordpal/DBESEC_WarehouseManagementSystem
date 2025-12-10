package com.warehouse.controller;

import com.warehouse.service.InventoryService;
import com.warehouse.service.impl.InventoryServiceImpl;
import com.warehouse.util.JsonResponse;
import com.google.gson.Gson;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class InventoryServlet extends HttpServlet {
    private InventoryService inventoryService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        inventoryService = new InventoryServiceImpl();
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
            if ("getSummary".equals(action)) {
                result = gson.toJson(inventoryService.getInventorySummary());
            } else if ("getLowStock".equals(action)) {
                result = gson.toJson(inventoryService.getLowStockInventory());
            } else if ("recommendLocation".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                result = gson.toJson(inventoryService.recommendLocation(productId, warehouseId, quantity));
            } else if ("getByProduct".equals(action)) {
                int pid = Integer.parseInt(request.getParameter("productId"));
                result = gson.toJson(inventoryService.getByProduct(pid));
            } else if ("getAll".equals(action)) {
                result = gson.toJson(inventoryService.getAll());
            } else {
                result = gson.toJson(JsonResponse.error("未知操作"));
            }
        } catch (Exception e) {
            result = gson.toJson(JsonResponse.error("请求处理失败: " + e.getMessage()));
        }
        
        response.getWriter().write(result);
    }
}