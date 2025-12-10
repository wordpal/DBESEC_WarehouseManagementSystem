<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库存盘点管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
    <style>
        .task-status-0 { color: #ffb800; }
        .task-status-1 { color: #1e9fff; }
        .task-status-2 { color: #009688; }
        .task-status-3 { color: #ff5722; }
    </style>
</head>
<body style="padding:15px;">

<fieldset class="layui-elem-field">
    <legend>盘点任务查询</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">任务编号</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchTaskNo" placeholder="请输入任务编号" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">仓库</label>
                    <div class="layui-input-inline">
                        <select id="searchWarehouse">
                            <option value="">全部仓库</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">盘点类型</label>
                    <div class="layui-input-inline">
                        <select id="searchType">
                            <option value="">全部类型</option>
                            <option value="FULL">全面盘点</option>
                            <option value="CYCLE">循环盘点</option>
                            <option value="SPOT">抽盘</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">任务状态</label>
                    <div class="layui-input-inline">
                        <select id="searchStatus">
                            <option value="">全部状态</option>
                            <option value="PLANNED">已计划</option>
                            <option value="IN_PROGRESS">进行中</option>
                            <option value="COMPLETED">已完成</option>
                            <option value="CANCELLED">已取消</option>
                        </select>
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">计划时间</label>
                    <div class="layui-input-inline" style="width: 150px;">
                        <input type="text" id="startDate" placeholder="开始日期" class="layui-input">
                    </div>
                    <div class="layui-form-mid">-</div>
                    <div class="layui-input-inline" style="width: 150px;">
                        <input type="text" id="endDate" placeholder="结束日期" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">负责人</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchAssignee" placeholder="负责人姓名" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button" id="btnSearch">
                        <i class="layui-icon">&#xe615;</i> 查询
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-primary" type="button" id="btnReset">
                        重置
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" type="button" id="btnCreate">
                        <i class="layui-icon">&#xe654;</i> 创建盘点任务
                    </button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<div class="layui-row" style="margin-bottom: 15px;">
    <div class="layui-col-md3">
        <div class="layui-card">
            <div class="layui-card-header">待盘点</div>
            <div class="layui-card-body" style="text-align: center; font-size: 24px;">
                <span id="plannedCount" style="color: #ffb800;">0</span>
            </div>
        </div>
    </div>
    <div class="layui-col-md3">
        <div class="layui-card">
            <div class="layui-card-header">盘点中</div>
            <div class="layui-card-body" style="text-align: center; font-size: 24px;">
                <span id="inProgressCount" style="color: #1e9fff;">0</span>
            </div>
        </div>
    </div>
    <div class="layui-col-md3">
        <div class="layui-card">
            <div class="layui-card-header">已完成</div>
            <div class="layui-card-body" style="text-align: center; font-size: 24px;">
                <span id="completedCount" style="color: #009688;">0</span>
            </div>
        </div>
    </div>
    <div class="layui-col-md3">
        <div class="layui-card">
            <div class="layui-card-header">差异率</div>
            <div class="layui-card-body" style="text-align: center; font-size: 24px;">
                <span id="differenceRate" style="color: #ff5722;">0%</span>
            </div>
        </div>
    </div>
</div>

<div class="layui-card">
    <div class="layui-card-body">
        <table class="layui-table" id="taskTable" lay-filter="taskTable"></table>
    </div>
</div>

<!-- 操作列模板 -->
<script type="text/html" id="tableOperation">
    <div class="layui-btn-group">
        {{# if(d.status == 'PLANNED'){ }}
            <a class="layui-btn layui-btn-xs" lay-event="start">开始盘点</a>
        {{# } else if(d.status == 'IN_PROGRESS'){ }}
            <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="input">录入数据</a>
            <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="complete">完成盘点</a>
        {{# } }}
        <a class="layui-btn layui-btn-xs" lay-event="view">查看</a>
        {{# if(d.status == 'PLANNED'){ }}
            <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="cancel">取消</a>
        {{# } }}
    </div>
</script>

<!-- 状态模板 -->
<script type="text/html" id="statusTpl">
    {{# if(d.status == 'PLANNED'){ }}
        <span class="layui-badge layui-bg-orange">已计划</span>
    {{# } else if(d.status == 'IN_PROGRESS'){ }}
        <span class="layui-badge layui-bg-blue">进行中</span>
    {{# } else if(d.status == 'COMPLETED'){ }}
        <span class="layui-badge layui-bg-green">已完成</span>
    {{# } else if(d.status == 'CANCELLED'){ }}
        <span class="layui-badge">已取消</span>
    {{# } }}
</script>

<!-- 类型模板 -->
<script type="text/html" id="typeTpl">
    {{# if(d.type == 'FULL'){ }}
        全面盘点
    {{# } else if(d.type == 'CYCLE'){ }}
        循环盘点
    {{# } else if(d.type == 'SPOT'){ }}
        抽盘
    {{# } }}
</script>

<!-- 进度模板 -->
<script type="text/html" id="progressTpl">
    {{# var percent = d.completedItems && d.totalItems ? Math.round(d.completedItems / d.totalItems * 100) : 0; }}
    <div class="layui-progress" style="margin: 0;">
        <div class="layui-progress-bar" lay-percent="{{ percent }}%"></div>
    </div>
    <div style="text-align: center; font-size: 12px; margin-top: 2px;">
        {{ d.completedItems || 0 }}/{{ d.totalItems || 0 }}
    </div>
</script>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
var API_BASE = '<%=request.getContextPath()%>/api';
var taskTable;

$(document).ready(function() {
    layui.use(['table', 'form', 'laydate', 'layer', 'element'], function(){
        var table = layui.table;
        var form = layui.form;
        var laydate = layui.laydate;
        var layer = layui.layer;
        var element = layui.element;
        
        // 初始化日期选择器
        laydate.render({
            elem: '#startDate',
            type: 'date'
        });
        laydate.render({
            elem: '#endDate',
            type: 'date'
        });
        
        // 加载仓库下拉框
        loadWarehouses();
        
        // 初始化表格
        taskTable = table.render({
            elem: '#taskTable',
            url: API_BASE + '/stocktake?action=getByPage&pageNum=1&pageSize=10',
            method: 'GET',
            page: true,
            limit: 10,
            cols: [[
                {field: 'taskNo', title: '任务编号', width: 150},
                {field: 'warehouseName', title: '盘点仓库', width: 150},
                {field: 'type', title: '盘点类型', width: 100, templet: '#typeTpl'},
                {field: 'assignee', title: '负责人', width: 100},
                {field: 'planDate', title: '计划日期', width: 120},
                {field: 'totalItems', title: '总项数', width: 80},
                {field: 'completedItems', title: '完成项数', width: 80},
                {field: 'progress', title: '进度', width: 120, templet: '#progressTpl'},
                {field: 'differenceRate', title: '差异率', width: 100, templet: function(d){
                    if(d.differenceRate != null) {
                        var color = d.differenceRate == 0 ? '#009688' : (d.differenceRate <= 1 ? '#ffb800' : '#ff5722');
                        return '<span style="color:' + color + '">' + d.differenceRate.toFixed(2) + '%</span>';
                    }
                    return '-';
                }},
                {field: 'status', title: '状态', width: 100, templet: '#statusTpl'},
                {field: 'createTime', title: '创建时间', width: 160},
                {title: '操作', width: 200, toolbar: '#tableOperation'}
            ]],
            parseData: function(res){
                return {
                    "code": res.success ? 0 : 1,
                    "msg": res.message || '',
                    "count": res.total || 0,
                    "data": res.data || []
                };
            },
            done: function(res, curr, count){
                element.render('progress');
                updateStats(res.data);
            }
        });
        
        // 表格工具条事件
        table.on('tool(taskTable)', function(obj){
            var data = obj.data;
            var event = obj.event;
            
            if(event === 'view'){
                viewTask(data.id);
            } else if(event === 'start'){
                startTask(data.id);
            } else if(event === 'input'){
                inputData(data.id);
            } else if(event === 'complete'){
                completeTask(data.id);
            } else if(event === 'cancel'){
                cancelTask(data.id);
            }
        });
        
        // 绑定按钮事件
        $('#btnSearch').click(function(){
            searchTasks();
        });
        
        $('#btnReset').click(function(){
            resetSearch();
        });
        
        $('#btnCreate').click(function(){
            createTask();
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
                    var html = '<option value="">全部仓库</option>';
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

// 更新统计信息
function updateStats(tasks) {
    if(!tasks) return;
    
    var planned = 0, inProgress = 0, completed = 0;
    var totalDiffRate = 0, diffCount = 0;
    
    tasks.forEach(function(task){
        switch(task.status) {
            case 'PLANNED': planned++; break;
            case 'IN_PROGRESS': inProgress++; break;
            case 'COMPLETED': completed++; break;
        }
        
        if(task.differenceRate != null) {
            totalDiffRate += task.differenceRate;
            diffCount++;
        }
    });
    
    $('#plannedCount').text(planned);
    $('#inProgressCount').text(inProgress);
    $('#completedCount').text(completed);
    $('#differenceRate').text(diffCount > 0 ? (totalDiffRate / diffCount).toFixed(2) + '%' : '0%');
}

// 查询盘点任务
function searchTasks() {
    var params = {
        taskNo: $('#searchTaskNo').val(),
        warehouseId: $('#searchWarehouse').val(),
        type: $('#searchType').val(),
        status: $('#searchStatus').val(),
        assignee: $('#searchAssignee').val(),
        startDate: $('#startDate').val(),
        endDate: $('#endDate').val()
    };
    
    taskTable.reload({
        url: API_BASE + '/stocktake',
        where: Object.assign({action: 'search'}, params),
        page: {curr: 1}
    });
}

// 重置查询条件
function resetSearch() {
    $('#searchTaskNo').val('');
    $('#searchWarehouse').val('');
    $('#searchType').val('');
    $('#searchStatus').val('');
    $('#searchAssignee').val('');
    $('#startDate').val('');
    $('#endDate').val('');
    layui.form.render();
    taskTable.reload({url: API_BASE + '/stocktake?action=getByPage'});
}

// 创建盘点任务
function createTask() {
    layui.layer.open({
        type: 2,
        title: '创建盘点任务',
        area: ['800px', '600px'],
        content: '<%=request.getContextPath()%>/views/stocktake_form.jsp',
        end: function(){
            taskTable.reload();
        }
    });
}

// 查看盘点任务
function viewTask(id) {
    layui.layer.open({
        type: 2,
        title: '盘点任务详情',
        area: ['1000px', '700px'],
        content: '<%=request.getContextPath()%>/views/stocktake_detail.jsp?id=' + id
    });
}

// 开始盘点
function startTask(id) {
    layui.layer.confirm('确定要开始盘点吗？', function(index){
        layui.layer.close(index);
        
        layui.use('jquery', function(){
            var $ = layui.$;
            $.ajax({
                url: API_BASE + '/stocktake',
                type: 'POST',
                data: {action: 'start', id: id},
                success: function(res){
                    if(res.success){
                        layui.layer.msg('已开始盘点');
                        taskTable.reload();
                    } else {
                        layui.layer.msg(res.message || '操作失败', {icon: 2});
                    }
                }
            });
        });
    });
}

// 录入盘点数据
function inputData(id) {
    layui.layer.open({
        type: 2,
        title: '录入盘点数据',
        area: ['1000px', '700px'],
        content: '<%=request.getContextPath()%>/views/stocktake_input.jsp?taskId=' + id,
        end: function(){
            taskTable.reload();
        }
    });
}

// 完成盘点
function completeTask(id) {
    layui.layer.confirm('确定要完成盘点吗？完成后将生成盘点报告。', function(index){
        layui.layer.close(index);
        
        layui.use('jquery', function(){
            var $ = layui.$;
            $.ajax({
                url: API_BASE + '/stocktake',
                type: 'POST',
                data: {action: 'complete', id: id},
                success: function(res){
                    if(res.success){
                        layui.layer.msg('盘点已完成');
                        taskTable.reload();
                    } else {
                        layui.layer.msg(res.message || '操作失败', {icon: 2});
                    }
                }
            });
        });
    });
}

// 取消盘点任务
function cancelTask(id) {
    layui.layer.confirm('确定要取消此盘点任务吗？', {icon: 3, title: '提示'}, function(index){
        layui.layer.close(index);
        
        layui.use('jquery', function(){
            var $ = layui.$;
            $.ajax({
                url: API_BASE + '/stocktake',
                type: 'POST',
                data: {action: 'cancel', id: id},
                success: function(res){
                    if(res.success){
                        layui.layer.msg('已取消');
                        taskTable.reload();
                    } else {
                        layui.layer.msg(res.message || '取消失败', {icon: 2});
                    }
                }
            });
        });
    });
}
</script>
</body>
</html>