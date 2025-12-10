<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>采购入库单管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
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
                        <input type="text" id="searchInboundNo" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">供应商</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchSupplier" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">仓库</label>
                    <div class="layui-input-inline">
                        <select id="searchWarehouse">
                            <option value="">全部</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select id="searchStatus">
                            <option value="">全部</option>
                            <option value="NEW">待入库</option>
                            <option value="DONE">已完成</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button" id="btnSearch">
                        <i class="layui-icon">&#xe615;</i> 查询
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" type="button" id="btnAdd">
                        <i class="layui-icon">&#xe654;</i> 新建入库单
                    </button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<div class="layui-card">
    <div class="layui-card-body">
        <table class="layui-table" id="inboundTable" lay-filter="inboundTable"></table>
    </div>
</div>

<!-- 操作列模板 -->
<script type="text/html" id="tableOperation">
    <div class="layui-btn-group">
        {{# if(d.status == 'NEW'){ }}
            <a class="layui-btn layui-btn-xs" lay-event="process">处理</a>
        {{# } }}
        <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="view">查看</a>
        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
    </div>
</script>

<!-- 状态模板 -->
<script type="text/html" id="statusTpl">
    {{# if(d.status == 'NEW'){ }}
        <span class="layui-badge layui-bg-orange">待入库</span>
    {{# } else if(d.status == 'DONE'){ }}
        <span class="layui-badge layui-bg-green">已完成</span>
    {{# } }}
</script>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
var API_BASE = '<%=request.getContextPath()%>/api';
var inboundTable;

$(document).ready(function() {
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table;
        var form = layui.form;
        var layer = layui.layer;
        
        // 加载仓库下拉框
        loadWarehouses();
        
        // 初始化表格
        inboundTable = table.render({
            elem: '#inboundTable',
            url: API_BASE + '/inbound?action=getByPage&pageNum=1&pageSize=10',
            method: 'GET',
            page: true,
            limit: 10,
            cols: [[
                {field: 'inboundNo', title: '入库单号', width: 150},
                {field: 'supplier', title: '供应商', width: 150},
                {field: 'warehouseName', title: '仓库', width: 120},
                {field: 'totalQuantity', title: '总数量', width: 100},
                {field: 'totalValue', title: '总金额', width: 120, templet: function(d){
                    return '¥' + (d.totalValue || 0).toFixed(2);
                }},
                {field: 'operator', title: '操作员', width: 100},
                {field: 'inboundDate', title: '入库日期', width: 120},
                {field: 'status', title: '状态', width: 100, templet: '#statusTpl'},
                {field: 'createTime', title: '创建时间', width: 160},
                {title: '操作', width: 180, toolbar: '#tableOperation'}
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
        table.on('tool(inboundTable)', function(obj){
            var data = obj.data;
            var event = obj.event;
            
            if(event === 'view'){
                viewInbound(data.id);
            } else if(event === 'process'){
                processInbound(data.id);
            } else if(event === 'delete'){
                deleteInbound(data.id);
            }
        });
        
        // 绑定按钮事件
        $('#btnSearch').click(function(){
            searchInbounds();
        });
        
        $('#btnAdd').click(function(){
            addInbound();
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

// 查询入库单
function searchInbounds() {
    var params = {
        inboundNo: $('#searchInboundNo').val(),
        supplier: $('#searchSupplier').val(),
        warehouseId: $('#searchWarehouse').val(),
        status: $('#searchStatus').val()
    };
    
    inboundTable.reload({
        url: API_BASE + '/inbound',
        where: Object.assign({action: 'search'}, params),
        page: {curr: 1}
    });
}

// 新增入库单
function addInbound() {
    layui.layer.open({
        type: 2,
        title: '新建入库单',
        area: ['95%', '95%'],
        content: '<%=request.getContextPath()%>/views/inbound_form.jsp',
        end: function(){
            inboundTable.reload();
        }
    });
}

// 查看入库单
function viewInbound(id) {
    layui.layer.open({
        type: 2,
        title: '入库单详情',
        area: ['800px', '600px'],
        content: '<%=request.getContextPath()%>/views/inbound_detail.jsp?id=' + id
    });
}

// 处理入库单
function processInbound(id) {
    layui.layer.confirm('确定要处理此入库单吗？', function(index){
        layui.layer.close(index);
        
        layui.use('jquery', function(){
            var $ = layui.$;
            $.ajax({
                url: API_BASE + '/inbound',
                type: 'POST',
                data: {action: 'process', id: id},
                success: function(res){
                    if(res.success){
                        layui.layer.msg('处理成功');
                        inboundTable.reload();
                    } else {
                        layui.layer.msg(res.message || '处理失败', {icon: 2});
                    }
                }
            });
        });
    });
}

// 删除入库单
function deleteInbound(id) {
    layui.layer.confirm('确定要删除此入库单吗？', {icon: 3, title: '提示'}, function(index){
        layui.layer.close(index);
        
        layui.use('jquery', function(){
            var $ = layui.$;
            $.ajax({
                url: API_BASE + '/inbound',
                type: 'POST',
                data: {action: 'delete', id: id},
                success: function(res){
                    if(res.success){
                        layui.layer.msg('删除成功');
                        inboundTable.reload();
                    } else {
                        layui.layer.msg(res.message || '删除失败', {icon: 2});
                    }
                }
            });
        });
    });
}
</script>
</body>
</html>