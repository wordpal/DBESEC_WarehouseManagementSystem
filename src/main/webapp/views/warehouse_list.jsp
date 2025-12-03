<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>仓库信息管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>
</head>
<body style="padding:15px;">

<fieldset class="layui-elem-field">
    <legend>仓库查询</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">仓库名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="name" placeholder="支持模糊查询" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">国家/地区</label>
                    <div class="layui-input-inline">
                        <select name="country">
                            <option value="">全部</option>
                            <option value="CN">中国</option>
                            <option value="US">美国</option>
                            <option value="DE">德国</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button">查询</button>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" type="button">新增仓库</button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<table class="layui-table">
    <thead>
    <tr>
        <th>仓库编码</th>
        <th>仓库名称</th>
        <th>所在城市</th>
        <th>国家/地区</th>
        <th>本位币</th>
        <th>状态</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <!-- 先用静态数据示例，后端接好接口后再换成动态 -->
    <tr>
        <td>WH-CN-SH</td>
        <td>上海保税仓</td>
        <td>上海</td>
        <td>中国</td>
        <td>CNY</td>
        <td>启用</td>
        <td>
            <button class="layui-btn layui-btn-xs">编辑</button>
            <button class="layui-btn layui-btn-xs layui-btn-danger">删除</button>
        </td>
    </tr>
    <tr>
        <td>WH-US-LA</td>
        <td>洛杉矶仓</td>
        <td>Los Angeles</td>
        <td>美国</td>
        <td>USD</td>
        <td>启用</td>
        <td>
            <button class="layui-btn layui-btn-xs">编辑</button>
            <button class="layui-btn layui-btn-xs layui-btn-danger">删除</button>
        </td>
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
