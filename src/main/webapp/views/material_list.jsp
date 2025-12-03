<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物料主数据管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>
</head>
<body style="padding:15px;">

<fieldset class="layui-elem-field">
    <legend>物料查询</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">物料名称</label>
                    <div class="layui-input-inline">
                        <input type="text" name="name" placeholder="支持模糊查询" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">SKU</label>
                    <div class="layui-input-inline">
                        <input type="text" name="sku" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">分类</label>
                    <div class="layui-input-inline">
                        <select name="category">
                            <option value="">全部</option>
                            <option value="原材料">原材料</option>
                            <option value="半成品">半成品</option>
                            <option value="成品">成品</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button">查询</button>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" type="button">新增物料</button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<table class="layui-table">
    <thead>
    <tr>
        <th>SKU</th>
        <th>名称</th>
        <th>分类</th>
        <th>规格</th>
        <th>尺寸</th>
        <th>重量(kg)</th>
        <th>安全库存</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <!-- 先用静态数据示意，后面再接后端 -->
    <tr>
        <td>SKU-1001</td>
        <td>主板组件A</td>
        <td>半成品</td>
        <td>MB-A</td>
        <td>30x20x3cm</td>
        <td>1.2</td>
        <td>100</td>
        <td>
            <button class="layui-btn layui-btn-xs">编辑</button>
            <button class="layui-btn layui-btn-xs layui-btn-danger">删除</button>
        </td>
    </tr>
    <tr>
        <td>SKU-2001</td>
        <td>包装材料B</td>
        <td>原材料</td>
        <td>Box-B</td>
        <td>40x30x10cm</td>
        <td>0.5</td>
        <td>200</td>
        <td>
            <button class="layui-btn layui-btn-xs">编辑</button>
            <button class="layui-btn layui-btn-xs layui-btn-danger">删除</button>
        </td>
    </tr>
    </tbody>
</table>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script>
    layui.use('form', function(){
        var form = layui.form;
    });
</script>
</body>
</html>
