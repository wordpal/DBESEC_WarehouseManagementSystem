<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库存统计报表</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>
</head>
<body style="padding:15px;">

<fieldset class="layui-elem-field">
    <legend>统计条件</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane">
            <div class="layui-form-item">
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
                    <label class="layui-form-label">统计维度</label>
                    <div class="layui-input-inline">
                        <select name="dim">
                            <option value="warehouse">按仓库</option>
                            <option value="material">按物料</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button">统计</button>
                    <button class="layui-btn layui-btn-sm layui-btn-warm" type="button">
                        导出为 Excel（预留后端）
                    </button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<table class="layui-table">
    <thead>
    <tr>
        <th>维度</th>
        <th>库存总数量</th>
        <th>库存总价值（示例）</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td>上海保税仓</td>
        <td>10,000</td>
        <td>¥ 2,500,000</td>
    </tr>
    <tr>
        <td>洛杉矶仓</td>
        <td>8,000</td>
        <td>$ 1,800,000</td>
    </tr>
    </tbody>
</table>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script>
    layui.use('form', function () {
        var form = layui.form;
    });
</script>
</body>
</html>
