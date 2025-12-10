package com.warehouse.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebFilter(
    filterName = "QuickEncodingFilter",
    urlPatterns = {"/*"},  // 过滤所有请求
    initParams = {
        @WebInitParam(name = "encoding", value = "UTF-8")
    },
    dispatcherTypes = {
        DispatcherType.REQUEST,    // 直接请求
        DispatcherType.FORWARD,    // 转发请求
        DispatcherType.INCLUDE     // 包含请求
    }
)
public class QuickEncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.isEmpty()) {
            encoding = encodingParam;
        }
        System.out.println("🚀 快速编码过滤器初始化成功，编码：" + encoding);
        System.out.println("✅ 过滤器将处理所有请求，包括：POST、GET、FORWARD、INCLUDE");
    }
    
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        
        String method = request.getMethod();
        String uri = request.getRequestURI();
        
        System.out.println("🔧 过滤器执行: " + method + " " + uri);
        System.out.println("   原始编码: " + request.getCharacterEncoding());
        
        // ============ 核心修复逻辑 ============
        if ("POST".equalsIgnoreCase(method)) {
            // 关键：先设置请求编码
            request.setCharacterEncoding(encoding);
            
            // 检查是否需要修复已解析的参数
            boolean hasParameters = request.getParameterMap().size() > 0;
            if (hasParameters) {
                System.out.println("   检测到POST参数，进行修复...");
                
                // 使用包装器强制修复参数
                request = new EncodingFixWrapper(request, encoding);
            }
        } else if ("GET".equalsIgnoreCase(method)) {
            // 对于GET请求，也要设置编码
            request.setCharacterEncoding(encoding);
        }
        
        // 设置响应编码
        response.setCharacterEncoding(encoding);
        
        // 自动设置Content-Type
        String contentType = response.getContentType();
        if (contentType == null || contentType.startsWith("text/")) {
            if (contentType == null || !contentType.contains("charset")) {
                response.setContentType("text/html;charset=" + encoding);
            }
        }
        
        System.out.println("✅ 设置后编码: " + request.getCharacterEncoding());
        System.out.println("✅ 响应编码: " + response.getCharacterEncoding());
        // ===================================
        
        // 继续执行过滤器链
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("快速编码过滤器销毁");
    }
    
    /**
     * 参数修复包装器
     */
    private static class EncodingFixWrapper extends HttpServletRequestWrapper {
        private final String encoding;
        private Map<String, String[]> fixedParameters = null;
        
        public EncodingFixWrapper(HttpServletRequest request, String encoding) {
            super(request);
            this.encoding = encoding;
        }
        
        @Override
        public String getParameter(String name) {
            String[] values = getParameterValues(name);
            return (values != null && values.length > 0) ? values[0] : null;
        }
        
        @Override
        public Map<String, String[]> getParameterMap() {
            if (fixedParameters == null) {
                fixParameters();
            }
            return fixedParameters;
        }
        
        @Override
        public String[] getParameterValues(String name) {
            Map<String, String[]> paramMap = getParameterMap();
            return paramMap.get(name);
        }
        
        @Override
        public Enumeration<String> getParameterNames() {
            return Collections.enumeration(getParameterMap().keySet());
        }
        
        @Override
        public String getCharacterEncoding() {
            return encoding; // 始终返回UTF-8
        }
        
        private void fixParameters() {
            Map<String, String[]> originalMap = super.getParameterMap();
            fixedParameters = new HashMap<>(originalMap.size());
            
            for (Map.Entry<String, String[]> entry : originalMap.entrySet()) {
                String[] originalValues = entry.getValue();
                String[] fixedValues = new String[originalValues.length];
                
                for (int i = 0; i < originalValues.length; i++) {
                    fixedValues[i] = fixString(originalValues[i]);
                }
                
                fixedParameters.put(entry.getKey(), fixedValues);
            }
        }
        
        private String fixString(String value) {
            if (value == null) return null;
            
            try {
                // 检查是否已经是正确编码的中文
                if (value.matches(".*[\\u4e00-\\u9fa5].*")) {
                    return value; // 已经是中文，不需要修复
                }
                
                // 尝试从ISO-8859-1转到UTF-8
                String fixed = new String(value.getBytes("ISO-8859-1"), encoding);
                
                // 检查修复后是否是中文
                if (fixed.matches(".*[\\u4e00-\\u9fa5].*")) {
                    System.out.println("   参数修复成功: [" + value + "] -> [" + fixed + "]");
                    return fixed;
                }
                
                return value; // 返回原始值
            } catch (Exception e) {
                return value;
            }
        }
    }
}