<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>全局库存查询</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
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
                        <select id="searchWarehouse">
                            <option value="">全部</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">SKU</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchSku" placeholder="精确或前缀" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">物料名称</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchName" placeholder="模糊查询" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">货位编码</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchSlotCode" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button" id="btnSearch">
                        <i class="layui-icon">&#xe615;</i> 查询
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-primary" type="button" id="btnReset">
                        重置
                    </button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<div class="layui-card">
    <div class="layui-card-header">库存列表</div>
    <div class="layui-card-body">
        <table class="layui-table" id="inventoryTable" lay-filter="inventoryTable"></table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
var API_BASE = '<%=request.getContextPath()%>/api';
var inventoryTable;

$(document).ready(function() {
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table;
        var form = layui.form;
        var layer = layui.layer;
        
        // 加载仓库下拉框
        loadWarehouses();
        
        // 初始化表格
        inventoryTable = table.render({
            elem: '#inventoryTable',
            url: API_BASE + '/inventory?action=getAll',
            method: 'GET',
            page: true,
            limit: 15,
            cols: [[
                {field: 'sku', title: 'SKU', width: 120},
                {field: 'productName', title: '物料名称', width: 200},
                {field: 'warehouseName', title: '仓库', width: 150},
                {field: 'locationCode', title: '货位', width: 120},
                {field: 'batchNo', title: '批次号', width: 120},
                {field: 'quantity', title: '数量', width: 100},
                {field: 'unit', title: '单位', width: 80},
                {field: 'productionDate', title: '生产日期', width: 120},
                {field: 'expiryDate', title: '过期日期', width: 120},
                {field: 'inboundDate', title: '入库日期', width: 120}
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
        
        // 绑定按钮事件
        $('#btnSearch').click(function(){
            searchInventory();
        });
        
        $('#btnReset').click(function(){
            $('#searchSku').val('');
            $('#searchName').val('');
            $('#searchSlotCode').val('');
            $('#searchWarehouse').val('');
            form.render();
            loadAllInventory();
        });
        
        form.render();
    });
});

// 加载仓库列表
function loadWarehouses() {
    layui.use('jquery', function(){
        var $ = layui.$;
        $.ajax({
            url: API_BASE + '/warehouse',
            type: 'GET',
            data: {action: 'getAll'},
            success: function(res){
                if(res.success){
                    var html = '<option value="">全部</option>';
                    res.data.forEach(function(warehouse){
                        html += '<option value="' + warehouse.id + '">' + warehouse.name + '</option>';
                    });
                    $('#searchWarehouse').html(html);
                    layui.form.render('select');
                }
            }
        });
    });
}

// 查询库存
function searchInventory() {
    var params = {
        warehouseId: $('#searchWarehouse').val(),
        sku: $('#searchSku').val(),
        productName: $('#searchName').val(),
        locationCode: $('#searchSlotCode').val()
    };
    
    inventoryTable.reload({
        url: API_BASE + '/inventory',
        where: Object.assign({action: 'search'}, params),
        page: {curr: 1}
    });
}

// 加载所有库存
function loadAllInventory() {
    inventoryTable.reload({
        url: API_BASE + '/inventory?action=getAll',
        page: {curr: 1}
    });
}

// 获取库存概要
function getInventorySummary() {
    layui.use('jquery', function(){
        var $ = layui.$;
        $.ajax({
            url: API_BASE + '/inventory',
            type: 'GET',
            data: {action: 'getSummary'},
            success: function(res){
                if(res.success){
                    console.log('库存概要:', res.data);
                }
            }
        });
    });
}

// 获取低库存预警
function getLowStockInventory() {
    layui.use('jquery', function(){
        var $ = layui.$;
        $.ajax({
            url: API_BASE + '/inventory',
            type: 'GET',
            data: {action: 'getLowStock'},
            success: function(res){
                if(res.success){
                    console.log('低库存预警:', res.data);
                }
            }
        });
    });
}
</script>
</body>
</html>