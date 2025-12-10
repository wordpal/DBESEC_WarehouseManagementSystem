package com.warehouse.filter;

import javax.servlet.*;
import java.io.IOException;

public class CharacterEncodingFilter implements Filter {
    private String encoding = "UTF-8";
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 从web.xml获取编码配置
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null) {
            encoding = encodingParam;
        }
        System.out.println("字符编码过滤器初始化，编码：" + encoding);
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        // 1. 设置请求编码
        request.setCharacterEncoding(encoding);
        
        // 2. 设置响应编码
        response.setCharacterEncoding(encoding);
        response.setContentType("text/html;charset=" + encoding);
        
        // 3. 打印日志（调试用）
        System.out.println("字符编码过滤器执行：设置编码为 " + encoding);
        
        // 4. 继续执行后续过滤器或Servlet
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("字符编码过滤器销毁");
    }
}