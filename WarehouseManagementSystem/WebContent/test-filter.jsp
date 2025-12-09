<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%
    // 记录JSP中的编码状态
    System.out.println("=== JSP页面开始执行 ===");
    System.out.println("=== JSP中的请求编码：" + request.getCharacterEncoding() + " ===");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>过滤器测试页面</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .result { background-color: #f0f0f0; padding: 15px; margin: 15px 0; border-radius: 5px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <h1>🔍 过滤器测试页面</h1>
    
    <!-- 测试表单 -->
    <div style="border: 1px solid #ccc; padding: 20px; margin: 20px 0;">
        <h3>测试表单（POST请求）</h3>
        <form method="post" action="">
            <div>
                <label>输入中文：</label>
                <input type="text" name="chineseInput" value="你好，世界！" style="width: 300px;">
            </div>
            <div style="margin-top: 10px;">
                <button type="submit">提交测试</button>
                <button type="button" onclick="location.reload()">刷新页面</button>
            </div>
        </form>
    </div>
    
    <!-- 显示测试结果 -->
    <div class="result">
        <h3>🔧 系统信息</h3>
        <ul>
            <li>请求编码：<%= request.getCharacterEncoding() %></li>
            <li>响应编码：<%= response.getCharacterEncoding() %></li>
            <li>响应Content-Type：<%= response.getContentType() %></li>
            <li>请求方法：<%= request.getMethod() %></li>
        </ul>
    </div>
    
    <%
        // 处理表单提交
        String input = request.getParameter("chineseInput");
        if (input != null && !input.isEmpty()) {
    %>
    <div class="result">
        <h3>📊 提交结果分析</h3>
        <ul>
            <li>接收到的参数值：<strong>"<%= input %>"</strong></li>
            <li>参数长度：<%= input.length() %></li>
            <li>参数字节数：<%= input.getBytes().length %></li>
            <li>是否为中文（判断）：<%= input.matches(".*[\\u4e00-\\u9fa5].*") ? "✅ 是" : "❌ 否（可能乱码）" %></li>
        </ul>
        
        <%
            // 如果乱码，尝试修复
            if (!input.matches(".*[\\u4e00-\\u9fa5].*")) {
                String fixed = new String(input.getBytes("ISO-8859-1"), "UTF-8");
        %>
        <h4>🛠️ 乱码修复尝试</h4>
        <ul>
            <li>修复前："<%= input %>"</li>
            <li>修复后："<%= fixed %>"</li>
            <li>修复是否成功：<%= fixed.matches(".*[\\u4e00-\\u9fa5].*") ? "✅ 成功" : "❌ 失败" %></li>
        </ul>
        <%
            }
        %>
    </div>
    <%
        }
    %>
    
    <!-- 测试链接 -->
    <div style="margin-top: 30px;">
        <h3>🔗 其他测试</h3>
        <ul>
            <li><a href="test-filter.jsp?testParam=测试参数">GET请求测试（带中文参数）</a></li>
            <li><a href="test-encoding.jsp">查看原始编码测试页面</a></li>
            <li><a href="api/test">测试API接口</a></li>
        </ul>
    </div>
    
    <!-- 显示所有参数 -->
    <div class="result">
        <h3>📝 所有请求参数</h3>
        <%
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            if (!paramNames.hasMoreElements()) {
                out.println("<p>无请求参数</p>");
            } else {
                out.println("<table border='1' cellpadding='5'>");
                out.println("<tr><th>参数名</th><th>参数值</th><th>状态</th></tr>");
                while (paramNames.hasMoreElements()) {
                    String name = paramNames.nextElement();
                    String value = request.getParameter(name);
                    boolean isChinese = value != null && value.matches(".*[\\u4e00-\\u9fa5].*");
                    String status = isChinese ? "✅ 正常" : "⚠️ 可能乱码";
                    out.println("<tr><td>" + name + "</td><td>" + value + "</td><td>" + status + "</td></tr>");
                }
                out.println("</table>");
            }
        %>
    </div>
</body>
</html>