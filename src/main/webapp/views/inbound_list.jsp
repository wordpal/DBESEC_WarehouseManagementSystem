<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>采购入库单管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>
</head>
<body style="padding:15px;">

<fieldset class="layui-elem-field">
    <legend>入库单查询</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">入库单号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="inboundNo" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">供应商</label>
                    <div class="layui-input-inline">
                        <input type="text" name="supplier" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">仓库</label>
                    <div class="layui-input-inline">
                        <select name="warehouse">
                            <option value="">全部</option>
                            <option value="WH-CN-SH">上海保税仓</option>
                            <option value="WH-US-LA">洛杉矶仓</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select name="status">
                            <option value="">全部</option>
                            <option value="NEW">待入库</option>
                            <option value="DONE">已完成</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button">查询</button>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" type="button"
                            onclick="toAdd()">新建入库单</button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<table class="layui-table">
    <thead>
    <tr>
        <th>入库单号</th>
        <th>供应商</th>
        <th>仓库</th>
        <th>入库日期</th>
        <th>状态</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <!-- 示例数据 -->
    <tr>
        <td>IN20251127001</td>
        <td>华东电子供应商</td>
        <td>上海保税仓</td>
        <td>2025-11-27</td>
        <td>待入库</td>
        <td>
            <button class="layui-btn layui-btn-xs" onclick="toEdit()">处理</button>
            <button class="layui-btn layui-btn-xs layui-btn-danger">删除</button>
        </td>
    </tr>
    <tr>
        <td>IN20251126003</td>
        <td>北美配件供应商</td>
        <td>洛杉矶仓</td>
        <td>2025-11-26</td>
        <td>已完成</td>
        <td>
            <button class="layui-btn layui-btn-xs">查看</button>
            <button class="layui-btn layui-btn-xs layui-btn-danger">删除</button>
        </td>
    </tr>
    </tbody>
</table>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script>
    function toAdd() {
        // 现在是直接跳 JSP，后面可以改成 Servlet
        window.location.href = "inbound_form.jsp";
    }
    function toEdit() {
        window.location.href = "inbound_form.jsp";
    }
</script>
</body>
</html>
