package com.warehouse.controller;

import com.warehouse.service.LocationService;
import com.warehouse.service.impl.LocationServiceImpl;
import com.warehouse.util.JsonResponse;
import com.google.gson.Gson;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LocationServlet extends HttpServlet {
    private LocationService locationService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        locationService = new LocationServiceImpl();
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
                result = gson.toJson(locationService.getAll());
            } else if ("getByWarehouse".equals(action)) {
                int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
                result = gson.toJson(locationService.getByWarehouse(warehouseId));
            } else if ("getAvailable".equals(action)) {
                int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
                result = gson.toJson(locationService.getAvailableLocations(warehouseId));
            } else if ("getOccupied".equals(action)) {
                int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
                result = gson.toJson(locationService.getOccupiedLocations(warehouseId));
            } else {
                result = gson.toJson(JsonResponse.error("未知操作"));
            }
        } catch (Exception e) {
            result = gson.toJson(JsonResponse.error("请求处理失败: " + e.getMessage()));
        }
        
        response.getWriter().write(result);
    }
}