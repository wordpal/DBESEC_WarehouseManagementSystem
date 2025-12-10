package com.warehouse.controller;

import com.warehouse.service.ProductService;
import com.warehouse.service.impl.ProductServiceImpl;
import com.warehouse.util.JsonResponse;
import com.google.gson.Gson;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class ProductServlet extends HttpServlet {
    private ProductService productService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        productService = new ProductServiceImpl();
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
                result = gson.toJson(productService.getAll());
            } else if ("getById".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                result = gson.toJson(productService.getById(id));
            } else if ("getByCategory".equals(action)) {
                String category = request.getParameter("category");
                result = gson.toJson(productService.getByCategory(category));
            } else if ("search".equals(action)) {
                String keyword = request.getParameter("keyword");
                result = gson.toJson(productService.search(keyword));
            } else if ("getLowStock".equals(action)) {
                result = gson.toJson(productService.getLowStockProducts());
            } else if ("getByPage".equals(action)) {
                int pageNum = Integer.parseInt(request.getParameter("pageNum"));
                int pageSize = Integer.parseInt(request.getParameter("pageSize"));
                result = gson.toJson(productService.getByPage(pageNum, pageSize));
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
            // 这里可以添加产品的新增、修改、删除操作
            // 为简化，暂时只返回成功
            result = gson.toJson(JsonResponse.success("操作成功"));
        } catch (Exception e) {
            result = gson.toJson(JsonResponse.error("操作失败: " + e.getMessage()));
        }
        
        response.getWriter().write(result);
    }
}