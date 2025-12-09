<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>仓库管理系统</title>
</head>
<body>
    <h1>🚀 仓库管理系统 - 环境测试</h1>
    <p>服务器时间: <%= new java.util.Date() %></p>
    <p>Java版本: <%= System.getProperty("java.version") %></p>
    <p>服务器信息: <%= application.getServerInfo() %></p>
    
    <h3>Tomcat配置成功！</h3>
    <p>项目已成功部署到Tomcat服务器。</p>
</body>
</html>