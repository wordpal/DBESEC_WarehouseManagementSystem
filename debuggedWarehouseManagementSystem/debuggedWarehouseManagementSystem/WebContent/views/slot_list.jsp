<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>货位管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>
    <style>
        .search-form .layui-form-item {
            margin-bottom: 10px;
        }
        .slot-status-0 { color: #009688; } /* 空闲 */
        .slot-status-1 { color: #ffb800; } /* 部分占用 */
        .slot-status-2 { color: #ff5722; } /* 已满 */
        .slot-status-3 { color: #999; }    /* 禁用 */
    </style>
</head>
<body style="padding:15px;">

<fieldset class="layui-elem-field">
    <legend>货位查询</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane search-form" id="searchForm">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">仓库</label>
                    <div class="layui-input-inline">
                        <select name="warehouseId" id="warehouseSelect">
                            <option value="">全部仓库</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">货位编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="slotCode" placeholder="请输入货位编码" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">货位状态</label>
                    <div class="layui-input-inline">
                        <select name="status">
                            <option value="">全部状态</option>
                            <option value="0">空闲</option>
                            <option value="1">部分占用</option>
                            <option value="2">已满</option>
                            <option value="3">禁用</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">货位类型</label>
                    <div class="layui-input-inline">
                        <select name="type">
                            <option value="">全部类型</option>
                            <option value="1">普通货位</option>
                            <option value="2">重型货位</option>
                            <option value="3">冷藏货位</option>
                            <option value="4">危险品货位</option>
                        </select>
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button" onclick="searchSlots()">
                        <i class="layui-icon">&#xe615;</i> 查询
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-primary" type="button" onclick="resetSearch()">
                        重置
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" type="button" onclick="openSlotForm()">
                        <i class="layui-icon">&#xe654;</i> 新增货位
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-warm" type="button" onclick="batchImport()">
                        <i class="layui-icon">&#xe67c;</i> 批量导入
                    </button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<!-- 货位列表 -->
<div class="layui-card">
    <div class="layui-card-body">
        <table class="layui-table" id="slotTable" lay-filter="slotTable"></table>
    </div>
</div>

<!-- 表格操作列模板 -->
<script type="text/html" id="tableOperation">
    <div class="layui-btn-group">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
        <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="view">查看详情</a>
        {{# if(d.status != 3){ }}
            <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="toggle">
                {{# if(d.status == 0 || d.status == 1 || d.status == 2){ }}
                    禁用
                {{# } else if(d.status == 3){ }}
                    启用
                {{# } }}
            </a>
        {{# } }}
    </div>
</script>

<!-- 状态显示模板 -->
<script type="text/html" id="statusTpl">
    {{#  if(d.status === 0){ }}
        <span class="layui-badge layui-bg-green">空闲</span>
    {{#  } else if(d.status === 1){ }}
        <span class="layui-badge layui-bg-orange">部分占用</span>
    {{#  } else if(d.status === 2){ }}
        <span class="layui-badge layui-bg-red">已满</span>
    {{#  } else if(d.status === 3){ }}
        <span class="layui-badge">禁用</span>
    {{#  } }}
</script>

<!-- 类型显示模板 -->
<script type="text/html" id="typeTpl">
    {{#  if(d.type === 1){ }}
        普通货位
    {{#  } else if(d.type === 2){ }}
        <span style="color:#ff5722;">重型货位</span>
    {{#  } else if(d.type === 3){ }}
        <span style="color:#1e9fff;">冷藏货位</span>
    {{#  } else if(d.type === 4){ }}
        <span style="color:#f00;">危险品货位</span>
    {{#  } }}
</script>

<!-- 使用率显示模板 -->
<script type="text/html" id="usageTpl">
    {{# var percent = (d.usedCapacity / d.totalCapacity * 100).toFixed(1); }}
    {{# if(percent < 50){ }}
        <span style="color:#009688;">{{ percent }}%</span>
    {{# } else if(percent < 80){ }}
        <span style="color:#ffb800;">{{ percent }}%</span>
    {{# } else { }}
        <span style="color:#ff5722;">{{ percent }}%</span>
    {{# } }}
</script>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script>
    let table;
    
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table;
        var form = layui.form;
        var layer = layui.layer;
        
        // 加载仓库下拉框
        loadWarehouses();
        
        // 初始化表格
        initTable();
        
        // 表格监听事件
        table.on('tool(slotTable)', function(obj){
            var data = obj.data;
            var event = obj.event;
            
            if(event === 'view'){
                viewSlot(data.id);
            } else if(event === 'edit'){
                editSlot(data.id);
            } else if(event === 'toggle'){
                toggleSlotStatus(data.id, data.status);
            }
        });
    });
    
    // 加载仓库列表
    function loadWarehouses() {
        layui.use('jquery', function(){
            var $ = layui.$;
            $.ajax({
                url: '../api/warehouse',
                type: 'GET',
                data: { action: 'getAll' },
                dataType: 'json',
                success: function(res){
                    if(res.success){
                        var html = '<option value="">全部仓库</option>';
                        res.data.forEach(function(warehouse){
                            html += '<option value="' + warehouse.id + '">' + warehouse.name + '</option>';
                        });
                        $('#warehouseSelect').html(html);
                        layui.form.render('select');
                    }
                }
            });
        });
    }
    
    // 初始化表格
    function initTable() {
        table = layui.table.render({
            elem: '#slotTable',
            url: '../api/location?action=getByPage&pageNum=1&pageSize=15',
            method: 'GET',
            page: true,
            limit: 15,
            limits: [10, 15, 20, 30, 50],
            cols: [[
                {field: 'slotCode', title: '货位编码', width: 120, fixed: 'left'},
                {field: 'warehouseName', title: '所属仓库', width: 150},
                {field: 'zone', title: '区域', width: 100},
                {field: 'row', title: '排', width: 80},
                {field: 'column', title: '列', width: 80},
                {field: 'level', title: '层', width: 80},
                {field: 'type', title: '货位类型', width: 100, templet: '#typeTpl'},
                {field: 'totalCapacity', title: '总容量', width: 100},
                {field: 'usedCapacity', title: '已用容量', width: 100},
                {field: 'usageRate', title: '使用率', width: 100, templet: '#usageTpl'},
                {field: 'currentProduct', title: '当前货物', width: 150, templet: function(d){
                    return d.currentProduct ? d.currentProduct.sku + '<br>' + d.currentProduct.name : '-';
                }},
                {field: 'status', title: '状态', width: 100, templet: '#statusTpl'},
                {field: 'createTime', title: '创建时间', width: 160},
                {field: 'updateTime', title: '更新时间', width: 160},
                {title: '操作', width: 180, fixed: 'right', toolbar: '#tableOperation'}
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
    }
    
    // 查询货位
    function searchSlots() {
        var params = {
            action: 'search'
        };
        
        // 收集表单数据
        $('#searchForm').find('input,select').each(function(){
            var name = $(this).attr('name');
            var value = $(this).val();
            if(name && value){
                params[name] = value;
            }
        });
        
        // 如果是按仓库查询，使用专门的接口
        var warehouseId = $('#warehouseSelect').val();
        if(warehouseId){
            params.action = 'getByWarehouse';
        }
        
        // 重新加载表格数据
        table.reload('slotTable', {
            url: '../api/location',
            where: params,
            page: { curr: 1 }
        });
    }
    
    // 重置查询条件
    function resetSearch() {
        $('#searchForm')[0].reset();
        layui.form.render();
        searchSlots();
    }
    
    // 打开货位表单
    function openSlotForm(id) {
        var title = id ? '编辑货位' : '新增货位';
        var content = 'slot_form.jsp';
        if(id){
            content += '?id=' + id;
        }
        
        layer.open({
            type: 2,
            title: title,
            area: ['600px', '700px'],
            fixed: false,
            maxmin: true,
            content: content,
            end: function(){
                searchSlots(); // 关闭后刷新列表
            }
        });
    }
    
    // 查看货位详情
    function viewSlot(id) {
        layer.open({
            type: 2,
            title: '货位详情',
            area: ['800px', '600px'],
            content: 'slot_detail.jsp?id=' + id
        });
    }
    
    // 编辑货位
    function editSlot(id) {
        openSlotForm(id);
    }
    
    // 切换货位状态
    function toggleSlotStatus(id, currentStatus) {
        var newStatus = currentStatus === 3 ? 0 : 3;
        var action = newStatus === 0 ? '启用' : '禁用';
        
        layer.confirm('确定要' + action + '此货位吗？', {icon: 3, title: '提示'}, function(index){
            layer.close(index);
            
            layui.use('jquery', function(){
                var $ = layui.$;
                $.ajax({
                    url: '../api/location',
                    type: 'POST',
                    data: {
                        action: 'toggleStatus',
                        id: id,
                        status: newStatus
                    },
                    success: function(res){
                        if(res.success){
                            layer.msg(action + '成功');
                            searchSlots();
                        } else {
                            layer.msg(res.message || action + '失败');
                        }
                    }
                });
            });
        });
    }
    
    // 批量导入
    function batchImport() {
        layer.open({
            type: 2,
            title: '批量导入货位',
            area: ['500px', '400px'],
            content: 'slot_import.jsp'
        });
    }
</script>
</body>
</html>