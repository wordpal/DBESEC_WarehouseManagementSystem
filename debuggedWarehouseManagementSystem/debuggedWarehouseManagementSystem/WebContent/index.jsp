<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>智能仓库管理系统 - 控制台</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>

    <style>
        body { margin: 0; }
        .layout-header {
            height: 60px;
            line-height: 60px;
            background: #20222a;
            color: #fff;
            padding: 0 20px;
        }
        .layout-title {
            font-size: 18px;
            font-weight: bold;
            display: inline-block;
        }
        .layout-user {
            float: right;
        }
        .layout-body {
            position: absolute;
            top: 60px;
            bottom: 0;
            left: 0;
            right: 0;
        }
        .layout-side {
            width: 200px;
            position: absolute;
            top: 0;
            bottom: 0;
            background: #393d49;
            overflow-y: auto;
        }
        .layout-main {
            position: absolute;
            left: 200px;
            right: 0;
            top: 0;
            bottom: 0;
            background: #f2f2f2;
        }
        #mainFrame {
            width: 100%;
            height: 100%;
            border: 0;
        }
    </style>
</head>
<body>

<div class="layout-header">
    <span class="layout-title">跨国公司智能仓库管理系统</span>
    <div class="layout-user">
        当前用户：<strong id="currentUser">-</strong>
        &nbsp;&nbsp;
        <a href="javascript:void(0);" id="logoutLink" style="color:#fff;">退出登录</a>
    </div>
</div>

<div class="layout-body">
    <!-- 左侧菜单 -->
    <div class="layout-side">
        <ul class="layui-nav layui-nav-tree" lay-filter="side">
            <li class="layui-nav-item layui-nav-itemed">
                <a href="javascript:;">仪表盘</a>
                <dl class="layui-nav-child">
                    <dd><a href="javascript:;" onclick="openPage('dashboard.jsp')">数据看板</a></dd>
                </dl>
            </li>

            <li class="layui-nav-item">
                <a href="javascript:;">基础数据管理</a>
                <dl class="layui-nav-child">
                    <dd><a href="javascript:;" onclick="openPage('views/warehouse_list.jsp')">仓库信息管理</a></dd>
                    <dd><a href="javascript:;" onclick="openPage('views/slot_list.jsp')">货位管理</a></dd>
                    <dd><a href="javascript:;" onclick="openPage('views/material_list.jsp')">物料主数据</a></dd>
                </dl>
            </li>

            <li class="layui-nav-item">
                <a href="javascript:;">库存管理</a>
                <dl class="layui-nav-child">
                    <dd><a href="javascript:;" onclick="openPage('views/inventory_list.jsp')">全局库存查询</a></dd>
                    <dd><a href="javascript:;" onclick="openPage('views/inbound_list.jsp')">采购入库</a></dd>
                    <dd><a href="javascript:;" onclick="openPage('views/outbound_list.jsp')">销售出库</a></dd>
                    <dd><a href="javascript:;" onclick="openPage('views/stocktake_task_list.jsp')">库存盘点</a></dd>
                </dl>
            </li>
        </ul>
    </div>

    <!-- 右侧内容区 -->
    <div class="layout-main">
        <!-- 默认加载仪表盘 -->
        <iframe id="mainFrame" name="mainFrame" src="dashboard.jsp"></iframe>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script>
    // 登录校验 & 用户名显示
    (function() {
        var user = sessionStorage.getItem("loginUser");
        if (!user) {
            // 未登录，回到登录页
            window.location.href = "login.jsp";
            return;
        }
        document.getElementById("currentUser").innerText = user;
    })();

    // Layui 菜单
    layui.use('element', function(){
        var element = layui.element;
    });

    // 切换右侧 iframe
    function openPage(url) {
        document.getElementById("mainFrame").src = url;
    }

    // 退出登录
    document.getElementById("logoutLink").onclick = function () {
        sessionStorage.removeItem("loginUser");
        window.location.href = "login.jsp";
    };
</script>
</body>
</html>
