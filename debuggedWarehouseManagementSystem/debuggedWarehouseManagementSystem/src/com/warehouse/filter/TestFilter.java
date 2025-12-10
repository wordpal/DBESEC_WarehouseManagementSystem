package com.warehouse.filter;

import javax.servlet.*;
import java.io.IOException;

public class TestFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("=== 测试过滤器初始化 ===");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        System.out.println("=== 测试过滤器执行 ===");
        System.out.println("请求编码前：" + request.getCharacterEncoding());
        
        // 强制设置编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        System.out.println("请求编码后：" + request.getCharacterEncoding());
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
    }
}