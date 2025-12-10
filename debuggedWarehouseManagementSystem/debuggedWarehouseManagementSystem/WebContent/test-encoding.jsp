<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>过滤器测试</title>
</head>
<body>
    <h1>字符编码过滤器测试</h1>
    
    <form method="post" action="test-encoding.jsp">
        <input type="text" name="testInput" placeholder="输入中文测试">
        <button type="submit">提交</button>
    </form>
    
    <%
        String input = request.getParameter("testInput");
        if (input != null) {
            out.println("<p>你输入的是：" + input + "</p>");
            out.println("<p>字符编码：" + request.getCharacterEncoding() + "</p>");
        }
    %>
    
    <p>当前编码：<%= request.getCharacterEncoding() %></p>
    <p>如果没有过滤器，这里可能是null或ISO-8859-1</p>
</body>
</html>