<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>全局库存查询</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>
</head>
<body style="padding:15px;">

<fieldset class="layui-elem-field">
    <legend>库存组合查询</legend>
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
                            <option value="WH-DE-HH">汉堡仓</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">SKU</label>
                    <div class="layui-input-inline">
                        <input type="text" name="sku" placeholder="精确或前缀" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">物料名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="name" placeholder="模糊查询" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">货位编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="slotCode" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button">查询</button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<table class="layui-table">
    <thead>
    <tr>
        <th>SKU</th>
        <th>物料名称</th>
        <th>仓库</th>
        <th>货位</th>
        <th>数量</th>
        <th>单位</th>
    </tr>
    </thead>
    <tbody>
    <!-- 静态示例数据 -->
    <tr>
        <td>SKU-1001</td>
        <td>主板组件A</td>
        <td>上海保税仓</td>
        <td>SH-01-01</td>
        <td>320</td>
        <td>件</td>
    </tr>
    <tr>
        <td>SKU-1001</td>
        <td>主板组件A</td>
        <td>洛杉矶仓</td>
        <td>LA-02-05</td>
        <td>180</td>
        <td>件</td>
    </tr>
    <tr>
        <td>SKU-2001</td>
        <td>包装材料B</td>
        <td>汉堡仓</td>
        <td>HH-03-02</td>
        <td>500</td>
        <td>箱</td>
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
