<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>智能仓库管理系统 - 登录</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>

    <style>
        body {
            background: #f2f2f2;
        }
        .login-container {
            width: 380px;
            margin: 120px auto;
            padding: 30px 40px 40px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0,0,0,0.08);
        }
        .login-title {
            text-align: center;
            font-size: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-title">跨国公司智能仓库管理系统</div>

    <form class="layui-form" lay-filter="loginForm">
        <div class="layui-form-item">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input type="text" name="username" required lay-verify="required"
                       placeholder="请输入用户名" autocomplete="off" class="layui-input" value="admin">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-block">
                <input type="password" name="password" required lay-verify="required"
                       placeholder="请输入密码" autocomplete="off" class="layui-input" value="123456">
            </div>
        </div>

        <div class="layui-form-item" style="text-align: center;">
            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="login">登录</button>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script>
    layui.use(['form', 'layer'], function () {
        var form = layui.form;
        var layer = layui.layer;

        form.on('submit(login)', function (data) {
            var username = data.field.username;
            var password = data.field.password;

            // 这里是“模拟登录”逻辑：前端判断，不访问后端
            if (username === 'admin' && password === '123456') {
                // 记录到 sessionStorage 里，后面 index.jsp 会用到
                sessionStorage.setItem("loginUser", username);
                layer.msg("登录成功，即将进入系统", {icon: 1, time: 800}, function () {
                    window.location.href = "index.jsp";
                });
            } else {
                layer.msg("用户名或密码错误（正确示例：admin / 123456）", {icon: 5});
            }
            return false; // 阻止表单真正提交
        });
    });
</script>
</body>
</html>
