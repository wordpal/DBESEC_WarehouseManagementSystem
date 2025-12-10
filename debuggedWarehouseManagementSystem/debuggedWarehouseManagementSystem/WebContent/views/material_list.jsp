<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物料主数据管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
    <style>
        .material-table { margin-top: 15px; }
    </style>
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
                        <input type="text" id="searchName" placeholder="支持模糊查询" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">SKU</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchSku" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">分类</label>
                    <div class="layui-input-inline">
                        <select id="searchCategory">
                            <option value="">全部</option>
                            <option value="原材料">原材料</option>
                            <option value="半成品">半成品</option>
                            <option value="成品">成品</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button" id="btnSearch">
                        <i class="layui-icon">&#xe615;</i> 查询
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" type="button" id="btnAdd">
                        <i class="layui-icon">&#xe654;</i> 新增物料
                    </button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<div class="layui-card">
    <div class="layui-card-body">
        <table class="layui-table" id="materialTable" lay-filter="materialTable"></table>
    </div>
</div>

<!-- 操作列模板 -->
<script type="text/html" id="tableOperation">
    <div class="layui-btn-group">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
    </div>
</script>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
// API基础路径
var API_BASE = '<%=request.getContextPath()%>/api';
var materialTable;

$(document).ready(function() {
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table;
        var form = layui.form;
        var layer = layui.layer;
        
        // 初始化表格
        materialTable = table.render({
            elem: '#materialTable',
            url: API_BASE + '/product?action=getByPage',
            method: 'GET',
            page: true,
            limit: 10,
            limits: [10, 20, 30, 50],
            cols: [[
                {field: 'sku', title: 'SKU', width: 120},
                {field: 'name', title: '物料名称', width: 200},
                {field: 'category', title: '分类', width: 100},
                {field: 'specification', title: '规格', width: 150},
                {field: 'unit', title: '单位', width: 80},
                {field: 'safetyStock', title: '安全库存', width: 100},
                {field: 'currentStock', title: '当前库存', width: 100},
                {field: 'price', title: '单价', width: 100, templet: function(d){
                    return d.price ? '¥' + d.price.toFixed(2) : '-';
                }},
                {field: 'createTime', title: '创建时间', width: 160},
                {title: '操作', width: 120, toolbar: '#tableOperation'}
            ]],
            parseData: function(res){
                return {
                    "code": res.success ? 0 : 1,
                    "msg": res.message || '',
                    "count": res.total || 0,
                    "data": res.data || []
                };
            }
        });
        
        // 表格工具条事件
        table.on('tool(materialTable)', function(obj){
            var data = obj.data;
            var event = obj.event;
            
            if(event === 'edit'){
                editMaterial(data.id);
            } else if(event === 'delete'){
                deleteMaterial(data.id);
            }
        });
        
        // 绑定按钮事件
        $('#btnSearch').click(function(){
            searchMaterials();
        });
        
        $('#btnAdd').click(function(){
            addMaterial();
        });
        
        form.render();
    });
});

// 查询物料
function searchMaterials() {
    var name = $('#searchName').val();
    var sku = $('#searchSku').val();
    var category = $('#searchCategory').val();
    
    var params = {
        pageNum: 1,
        pageSize: 10
    };
    
    if(name) params.keyword = name;
    if(sku) params.sku = sku;
    if(category) params.category = category;
    
    materialTable.reload({
        url: API_BASE + '/product',
        where: Object.assign({action: 'search'}, params),
        page: {curr: 1}
    });
}

// 新增物料
function addMaterial() {
    layui.layer.open({
        type: 2,
        title: '新增物料',
        area: ['600px', '600px'],
        content: '<%=request.getContextPath()%>/views/material_form.jsp',
        end: function(){
            materialTable.reload();
        }
    });
}

// 编辑物料
function editMaterial(id) {
    layui.layer.open({
        type: 2,
        title: '编辑物料',
        area: ['600px', '600px'],
        content: '<%=request.getContextPath()%>/views/material_form.jsp?id=' + id,
        end: function(){
            materialTable.reload();
        }
    });
}

// 删除物料
function deleteMaterial(id) {
    layui.layer.confirm('确定要删除这个物料吗？', {icon: 3, title: '提示'}, function(index){
        layui.layer.close(index);
        
        layui.use('jquery', function(){
            var $ = layui.$;
            $.ajax({
                url: API_BASE + '/product',
                type: 'POST',
                data: {action: 'delete', id: id},
                success: function(res){
                    if(res.success){
                        layui.layer.msg('删除成功');
                        materialTable.reload();
                    } else {
                        layui.layer.msg(res.message || '删除失败', {icon: 2});
                    }
                }
            });
        });
    });
}

// 获取低库存物料
function getLowStockMaterials() {
    layui.use('jquery', function(){
        var $ = layui.$;
        $.ajax({
            url: API_BASE + '/product',
            type: 'GET',
            data: {action: 'getLowStock'},
            success: function(res){
                if(res.success){
                    console.log('低库存物料:', res.data);
                }
            }
        });
    });
}
</script>
</body>
</html>