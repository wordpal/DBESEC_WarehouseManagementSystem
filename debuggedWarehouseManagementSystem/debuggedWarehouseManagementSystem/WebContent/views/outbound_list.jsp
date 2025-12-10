<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>销售出库单管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
    <style>
        .search-form .layui-form-item {
            margin-bottom: 10px;
        }
        .search-form .layui-btn {
            margin-right: 5px;
        }
        #searchResultInfo {
            color: #1e9fff;
            font-size: 14px;
            font-weight: bold;
        }
    </style>
</head>
<body style="padding:15px;">

<fieldset class="layui-elem-field">
    <legend>出库单查询</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane search-form" id="searchForm">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">出库单号</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchOutboundNo" placeholder="支持模糊查询" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">操作员</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchOperator" placeholder="操作员姓名" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">仓库</label>
                    <div class="layui-input-inline">
                        <select id="searchWarehouse">
                            <option value="">全部</option>
                            <option value="1">仓库1</option>
                            <option value="2">仓库2</option>
                            <option value="4">仓库4</option>
                            <option value="5">仓库5</option>
                            <option value="6">仓库6</option>
                            <option value="7">仓库7</option>
                            <option value="11">仓库11</option>
                            <option value="12">仓库12</option>
                            <option value="19">仓库19</option>
                            <option value="20">仓库20</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">产品ID</label>
                    <div class="layui-input-inline">
                        <input type="number" id="searchProductId" placeholder="产品ID" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button" id="btnSearch">
                        <i class="layui-icon">&#xe615;</i> 查询
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-primary" type="button" id="btnReset">
                        <i class="layui-icon">&#xe669;</i> 重置
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" type="button" id="btnAdd">
                        <i class="layui-icon">&#xe654;</i> 新建
                    </button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<div class="layui-card">
    <div class="layui-card-header">
        <span>出库单列表</span>
        <span id="searchResultInfo" style="margin-left: 20px;"></span>
    </div>
    <div class="layui-card-body">
        <table class="layui-table" id="outboundTable" lay-filter="outboundTable"></table>
    </div>
</div>

<!-- 操作列模板 -->
<script type="text/html" id="tableOperation">
    <div class="layui-btn-group">
        <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="view">查看</a>
        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
    </div>
</script>

<!-- 状态显示模板 -->
<script type="text/html" id="statusTpl">
    <span class="layui-badge layui-bg-green">已出库</span>
</script>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
// API基础路径
var API_BASE = '<%=request.getContextPath()%>/api';
var outboundTable;

// 格式化日期
function formatDate(dateStr) {
    if (!dateStr) return '';
    
    try {
        // 处理Dec 10, 2025 2:44:21 PM格式
        if (dateStr.includes('Dec') || dateStr.includes('Jan') || dateStr.includes('Feb') || 
            dateStr.includes('Mar') || dateStr.includes('Apr') || dateStr.includes('May') ||
            dateStr.includes('Jun') || dateStr.includes('Jul') || dateStr.includes('Aug') ||
            dateStr.includes('Sep') || dateStr.includes('Oct') || dateStr.includes('Nov')) {
            
            // 转换格式: Dec 10, 2025 2:44:21 PM
            var date = new Date(dateStr);
            if (isNaN(date.getTime())) {
                // 如果Date解析失败，尝试手动解析
                var parts = dateStr.split(' ');
                if (parts.length >= 6) {
                    var monthMap = {
                        'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
                        'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
                        'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
                    };
                    
                    var month = monthMap[parts[0]] || '01';
                    var day = parts[1].replace(',', '').padStart(2, '0');
                    var year = parts[2];
                    var time = parts[3];
                    var ampm = parts[4];
                    
                    // 处理12小时制
                    var timeParts = time.split(':');
                    var hours = parseInt(timeParts[0]);
                    var minutes = timeParts[1];
                    var seconds = timeParts[2] || '00';
                    
                    if (ampm === 'PM' && hours < 12) hours += 12;
                    if (ampm === 'AM' && hours === 12) hours = 0;
                    
                    return year + '-' + month + '-' + day + ' ' + 
                           hours.toString().padStart(2, '0') + ':' + minutes + ':' + seconds;
                }
            } else {
                var year = date.getFullYear();
                var month = (date.getMonth() + 1).toString().padStart(2, '0');
                var day = date.getDate().toString().padStart(2, '0');
                var hours = date.getHours().toString().padStart(2, '0');
                var minutes = date.getMinutes().toString().padStart(2, '0');
                var seconds = date.getSeconds().toString().padStart(2, '0');
                
                return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
            }
        }
        
        // 尝试直接创建Date对象
        var date = new Date(dateStr);
        if (!isNaN(date.getTime())) {
            var year = date.getFullYear();
            var month = (date.getMonth() + 1).toString().padStart(2, '0');
            var day = date.getDate().toString().padStart(2, '0');
            var hours = date.getHours().toString().padStart(2, '0');
            var minutes = date.getMinutes().toString().padStart(2, '0');
            var seconds = date.getSeconds().toString().padStart(2, '0');
            
            return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
        }
        
        return dateStr;
    } catch (e) {
        console.error('日期格式化错误:', e, '原始日期:', dateStr);
        return dateStr;
    }
}

// 处理API响应数据
function parseApiData(res) {
    console.log('解析API数据:', res);
    
    try {
        if (!res) {
            return { data: [], total: 0 };
        }
        
        // 根据API格式解析
        if (res.code === 200 || res.code === 0) {
            if (res.data) {
                if (Array.isArray(res.data)) {
                    return { data: res.data, total: res.data.length };
                } else if (res.data.list && Array.isArray(res.data.list)) {
                    return { 
                        data: res.data.list, 
                        total: res.data.total || res.data.list.length 
                    };
                } else {
                    return { data: [], total: 0 };
                }
            }
        }
        
        return { data: [], total: 0 };
        
    } catch (error) {
        console.error('解析API数据时出错:', error);
        return { data: [], total: 0 };
    }
}

// 处理表格数据
function processTableData(res) {
    console.log('处理表格数据:', res);
    
    try {
        // 解析API数据
        var parsed = parseApiData(res);
        var data = parsed.data;
        var total = parsed.total;
        
        console.log('解析后的数据条数:', data.length);
        
        // 转换数据格式
        var tableData = data.map(function(item) {
            return {
                id: item.orderId,
                outboundNo: item.orderCode,
                customer: '客户' + (item.orderId || ''),
                warehouseId: item.locationId,
                warehouseName: '仓库' + item.locationId,
                operator: item.operator || '系统操作员',
                productId: item.productId,
                productName: '产品' + item.productId,
                totalQuantity: item.quantity || 0,
                outboundDate: formatDate(item.orderTime),
                status: 'COMPLETED',
                _raw: item // 保留原始数据
            };
        });
        
        console.log('转换后的表格数据:', tableData);
        
        return {
            "code": 0,
            "msg": "成功",
            "count": total,
            "data": tableData
        };
        
    } catch (error) {
        console.error('处理表格数据时出错:', error);
        return {
            "code": 1,
            "msg": "数据处理失败: " + error.message,
            "count": 0,
            "data": []
        };
    }
}

$(document).ready(function() {
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table;
        var form = layui.form;
        var layer = layui.layer;
        
        console.log('开始初始化页面...');
        
        // 初始化表格
        outboundTable = table.render({
            elem: '#outboundTable',
            url: API_BASE + '/outbound?action=getAll',
            method: 'GET',
            page: true,
            limit: 10,
            limits: [10, 20, 30, 50],
            loading: true,
            text: {
                none: '<div style="padding:20px;color:#999;text-align:center;">暂无出库单数据</div>'
            },
            cols: [[
                {field: 'outboundNo', title: '出库单号', width: 180, fixed: 'left'},
                {field: 'customer', title: '客户', width: 120},
                {field: 'warehouseName', title: '仓库', width: 120},
                {field: 'operator', title: '操作员', width: 120},
                {field: 'productName', title: '产品', width: 150},
                {field: 'totalQuantity', title: '数量', width: 80, sort: true},
                {field: 'outboundDate', title: '出库时间', width: 160, sort: true},
                {field: 'status', title: '状态', width: 100, templet: '#statusTpl'},
                {title: '操作', width: 120, fixed: 'right', toolbar: '#tableOperation'}
            ]],
            parseData: processTableData,
            done: function(res, curr, count){
                console.log('表格渲染完成，总数:', count);
                $('#searchResultInfo').text('共 ' + count + ' 条记录');
                
                if (count === 0) {
                    layer.msg('暂无出库单数据', {icon: 3, time: 2000});
                }
            },
            error: function(res, msg){
                console.error('表格加载错误:', msg);
                layer.msg('加载数据失败: ' + msg, {icon: 2, time: 3000});
            }
        });
        
        // 表格工具条事件
        table.on('tool(outboundTable)', function(obj){
            var data = obj.data;
            var event = obj.event;
            
            console.log('操作事件:', event, '数据:', data);
            
            if (event === 'view') {
                viewOutbound(data);
            } else if (event === 'delete') {
                deleteOutbound(data.id, data.outboundNo);
            }
        });
        
        // 绑定按钮事件
        $('#btnSearch').click(function(){
            console.log('点击查询按钮');
            searchOutbounds();
        });
        
        // 支持按Enter键查询
        $('#searchOutboundNo, #searchOperator, #searchProductId').keypress(function(e){
            if (e.which === 13) {
                $('#btnSearch').click();
            }
        });
        
        $('#btnReset').click(function(){
            console.log('点击重置按钮');
            resetSearch();
        });
        
        $('#btnAdd').click(function(){
            console.log('点击新建按钮');
            addOutbound();
        });
        
        form.render();
        console.log('页面初始化完成');
    });
});

// 查询出库单
function searchOutbounds() {
    var outboundNo = $('#searchOutboundNo').val().trim();
    var operator = $('#searchOperator').val().trim();
    var warehouseId = $('#searchWarehouse').val();
    var productId = $('#searchProductId').val();
    
    console.log('查询条件:', {
        outboundNo: outboundNo,
        operator: operator,
        warehouseId: warehouseId,
        productId: productId
    });
    
    // 检查是否有查询条件
    var hasFilter = false;
    if (outboundNo || operator || warehouseId || productId) {
        hasFilter = true;
    }
    
    // 显示加载中
    var loading = layui.layer.load(2, {shade: [0.3, '#000']});
    
    // 构建查询参数
    var params = {};
    if (outboundNo) params.outboundNo = outboundNo;
    if (operator) params.operator = operator;
    if (warehouseId) params.warehouseId = warehouseId;
    if (productId) params.productId = productId;
    
    // 如果有查询条件，使用search接口；否则使用getAll接口
    var url = API_BASE + '/outbound';
    var requestData = hasFilter ? 
        Object.assign({action: 'search'}, params) : 
        {action: 'getAll'};
    
    console.log('发送请求:', url, requestData);
    
    // 重新加载表格数据
    outboundTable.reload({
        url: url,
        method: 'GET',
        where: requestData,
        page: {curr: 1}
    });
    
    // 设置一个定时器来关闭加载提示
    setTimeout(function() {
        layui.layer.close(loading);
    }, 500);
    
    // 更新搜索结果显示
    if (hasFilter) {
        var infoText = '正在查询...';
        if (outboundNo) infoText += '，出库单号包含"' + outboundNo + '"';
        if (operator) infoText += '，操作员包含"' + operator + '"';
        if (warehouseId) infoText += '，仓库ID=' + warehouseId;
        if (productId) infoText += '，产品ID=' + productId;
        $('#searchResultInfo').text(infoText);
    } else {
        $('#searchResultInfo').text('正在加载所有数据...');
    }
}

// 重置查询条件
function resetSearch() {
    $('#searchOutboundNo').val('');
    $('#searchOperator').val('');
    $('#searchWarehouse').val('');
    $('#searchProductId').val('');
    layui.form.render();
    
    // 重新加载所有数据
    outboundTable.reload({
        url: API_BASE + '/outbound?action=getAll',
        page: {curr: 1}
    });
    
    $('#searchResultInfo').text('已重置查询条件，加载所有数据...');
    layui.layer.msg('已重置查询条件', {icon: 1, time: 1500});
}

// 新增出库单
function addOutbound() {
    layui.layer.open({
        type: 2,
        title: '新建出库单',
        area: ['95%', '95%'],
        content: '<%=request.getContextPath()%>/views/outbound_form.jsp',
        end: function(){
            outboundTable.reload();
        }
    });
}

// 查看出库单详情
function viewOutbound(data) {
    console.log('查看出库单:', data);
    
    // 构建URL参数
    var params = [];
    if (data._raw.orderId) params.push('orderId=' + data._raw.orderId);
    if (data.outboundNo) params.push('orderCode=' + encodeURIComponent(data.outboundNo));
    if (data.productId) params.push('productId=' + data.productId);
    if (data.warehouseId) params.push('locationId=' + data.warehouseId);
    if (data.totalQuantity) params.push('quantity=' + data.totalQuantity);
    if (data.operator) params.push('operator=' + encodeURIComponent(data.operator));
    if (data._raw.orderTime) params.push('orderTime=' + encodeURIComponent(data._raw.orderTime));
    
    var url = '<%=request.getContextPath()%>/views/outbound_form.jsp';
    if (params.length > 0) {
        url += '?' + params.join('&');
    }
    
    layui.layer.open({
        type: 2,
        title: '出库单详情 - ' + data.outboundNo,
        area: ['95%', '95%'],
        content: url,
        success: function() {
            console.log('详情页打开成功');
        }
    });
}

// 删除出库单
function deleteOutbound(id, outboundNo) {
    layui.layer.confirm('确定要删除出库单"' + (outboundNo || id) + '"吗？', 
        {icon: 3, title: '提示'}, 
        function(index){
            layui.layer.close(index);
            
            $.ajax({
                url: API_BASE + '/outbound',
                type: 'GET',
                data: {action: 'delete', id: id},
                success: function(res) {
                    console.log('删除响应:', res);
                    try {
                        if (res.code === 200 || res.code === 0) {
                            layui.layer.msg('删除成功', {icon: 1});
                            outboundTable.reload();
                        } else {
                            layui.layer.msg('删除失败: ' + (res.msg || '未知错误'), {icon: 2});
                        }
                    } catch (e) {
                        layui.layer.msg('操作完成', {icon: 1});
                        outboundTable.reload();
                    }
                },
                error: function() {
                    layui.layer.msg('删除请求失败', {icon: 2});
                }
            });
        }
    );
}

// 页面加载完成
window.onload = function() {
    console.log('页面加载完成，API路径:', API_BASE);
};
</script>
</body>
</html>