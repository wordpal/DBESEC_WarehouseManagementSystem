<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>快速过滤器测试</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .box { border: 2px solid #4CAF50; padding: 20px; margin: 20px 0; border-radius: 10px; }
        .success { color: #4CAF50; font-weight: bold; }
        .info { color: #2196F3; }
        input[type="text"] { padding: 8px; width: 300px; margin: 10px 0; }
        button { padding: 10px 20px; background: #4CAF50; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <h1>🚀 快速过滤器测试页面</h1>
    
    <div class="box">
        <h2>🔍 当前编码信息</h2>
        <ul>
            <li>请求编码：<span class="info"><%= request.getCharacterEncoding() %></span></li>
            <li>响应编码：<span class="info"><%= response.getCharacterEncoding() %></span></li>
            <li>Content-Type：<span class="info"><%= response.getContentType() %></span></li>
            <li>请求方法：<span class="info"><%= request.getMethod() %></span></li>
        </ul>
    </div>
    
    <div class="box">
        <h2>📝 POST请求测试</h2>
        <form method="post" action="">
            <div>
                <label>输入中文：</label><br>
                <input type="text" name="chineseInput" value="中文测试数据" required>
            </div>
            <div>
                <label>输入邮箱：</label><br>
                <input type="text" name="email" value="test@example.com">
            </div>
            <div style="margin-top: 15px;">
                <button type="submit">提交POST请求</button>
                <button type="button" onclick="location.href='test-quick-filter.jsp?test=中文参数&number=123'">
                    测试GET请求
                </button>
            </div>
        </form>
    </div>
    
    <%
        // 处理POST请求结果
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String chinese = request.getParameter("chineseInput");
            String email = request.getParameter("email");
    %>
    <div class="box" style="border-color: #FF9800;">
        <h2>📊 POST请求结果</h2>
        <table border="1" cellpadding="10">
            <tr>
                <th>参数名</th>
                <th>接收到的值</th>
                <th>状态</th>
                <th>长度</th>
            </tr>
            <tr>
                <td>chineseInput</td>
                <td><strong><%= chinese %></strong></td>
                <td>
                    <% if (chinese != null && chinese.matches(".*[\\u4e00-\\u9fa5].*")) { %>
                        <span class="success">✅ 中文正常</span>
                    <% } else { %>
                        <span style="color:red;">❌ 中文乱码</span>
                    <% } %>
                </td>
                <td><%= chinese != null ? chinese.length() : 0 %></td>
            </tr>
            <tr>
                <td>email</td>
                <td><%= email %></td>
                <td><span class="info">英文字符</span></td>
                <td><%= email != null ? email.length() : 0 %></td>
            </tr>
        </table>
    </div>
    <%
        }
        
        // 处理GET请求参数
        String testParam = request.getParameter("test");
        String numberParam = request.getParameter("number");
        if (testParam != null || numberParam != null) {
    %>
    <div class="box" style="border-color: #9C27B0;">
        <h2>📊 GET请求结果</h2>
        <ul>
            <% if (testParam != null) { %>
            <li>test参数：<strong><%= testParam %></strong> 
                <% if (testParam.matches(".*[\\u4e00-\\u9fa5].*")) { %>
                    <span class="success">✅ 中文正常</span>
                <% } else { %>
                    <span style="color:red;">❌ 可能乱码</span>
                <% } %>
            </li>
            <% } %>
            <% if (numberParam != null) { %>
            <li>number参数：<%= numberParam %></li>
            <% } %>
        </ul>
    </div>
    <%
        }
    %>
    
    <div class="box">
        <h2>🔧 控制台输出参考</h2>
        <p>启动Tomcat时应该看到：</p>
        <pre style="background: #f5f5f5; padding: 10px; border-radius: 5px;">
🚀 快速编码过滤器初始化成功，编码：UTF-8
✅ 过滤器将处理所有请求，包括：POST、GET、FORWARD、INCLUDE
🌐 跨域过滤器初始化成功</pre>
        
        <p>访问此页面时应该看到：</p>
        <pre style="background: #f5f5f5; padding: 10px; border-radius: 5px;">
🔧 过滤器执行: GET /test-quick-filter.jsp
   原始编码: null
✅ 设置后编码: UTF-8
✅ 响应编码: UTF-8</pre>
    </div>
</body>
</html>