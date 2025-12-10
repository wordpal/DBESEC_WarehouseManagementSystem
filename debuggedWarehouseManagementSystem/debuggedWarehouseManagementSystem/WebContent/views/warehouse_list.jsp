<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>仓库信息管理</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
    <style>
        .search-form .layui-form-item {
            margin-bottom: 10px;
        }
        .capacity-bar {
            display: inline-block;
            width: 60px;
            height: 8px;
            background: #eee;
            border-radius: 4px;
            margin-right: 8px;
            vertical-align: middle;
        }
        .capacity-fill {
            height: 100%;
            border-radius: 4px;
        }
        #btnTestApi {
            margin-left: 10px;
        }
    </style>
</head>
<body style="padding:15px;">

<fieldset class="layui-elem-field">
    <legend>仓库查询</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane" id="searchForm">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">仓库名称</label>
                    <div class="layui-input-inline">
                        <input type="text" id="searchName" placeholder="支持模糊查询" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">国家/地区</label>
                    <div class="layui-input-inline">
                        <select id="searchCountry">
                            <option value="">全部</option>
                            <option value="China">中国</option>
                            <option value="USA">美国</option>
                            <option value="Germany">德国</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">状态</label>
                    <div class="layui-input-inline">
                        <select id="searchStatus">
                            <option value="">全部</option>
                            <option value="true">启用</option>
                            <option value="false">禁用</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button" id="btnSearch">
                        <i class="layui-icon">&#xe615;</i> 查询
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-primary" type="button" id="btnReset">
                        重置
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-normal" type="button" id="btnAdd">
                        <i class="layui-icon">&#xe654;</i> 新增仓库
                    </button>
                    <!-- 测试按钮会通过JS动态添加 -->
                </div>
            </div>
        </form>
    </div>
</fieldset>

<div class="layui-card">
    <div class="layui-card-header">仓库列表</div>
    <div class="layui-card-body">
        <table class="layui-table" id="warehouseTable" lay-filter="warehouseTable"></table>
    </div>
</div>

<!-- 操作列模板 -->
<script type="text/html" id="tableOperation">
    <div class="layui-btn-group">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
        <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="view">查看</a>
        {{# if(d.isActive){ }}
            <a class="layui-btn layui-btn-xs layui-btn-warm" lay-event="disable">禁用</a>
        {{# } else { }}
            <a class="layui-btn layui-btn-xs layui-btn-success" lay-event="enable">启用</a>
        {{# } }}
        <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
    </div>
</script>

<!-- 状态显示模板 -->
<script type="text/html" id="statusTpl">
    {{# if(d.isActive){ }}
        <span class="layui-badge layui-bg-green">启用</span>
    {{# } else { }}
        <span class="layui-badge">禁用</span>
    {{# } }}
</script>

<!-- 货币显示模板 -->
<script type="text/html" id="currencyTpl">
    {{# if(d.country === 'China'){ }}
        CNY
    {{# } else if(d.country === 'USA'){ }}
        USD
    {{# } else if(d.country === 'Germany'){ }}
        EUR
    {{# } else { }}
        -
    {{# } }}
</script>

<!-- 容量显示模板 -->
<script type="text/html" id="capacityTpl">
    {{# if(d.capacity && d.usedCapacity){ }}
        {{# var percent = Math.round((d.usedCapacity / d.capacity) * 100); }}
        {{# var color = percent < 70 ? '#009688' : (percent < 90 ? '#ffb800' : '#ff5722'); }}
        <div style="display:flex;align-items:center;">
            <div class="capacity-bar">
                <div class="capacity-fill" style="width:{{ percent }}%;background:{{ color }};"></div>
            </div>
            <span>{{ d.usedCapacity }}/{{ d.capacity }}</span>
        </div>
    {{# } else { }}
        -
    {{# } }}
</script>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
// API基础路径 - 修改为你的Servlet路径
var API_BASE = '<%=request.getContextPath()%>/api/warehouse-test';
var warehouseTable;

console.log('API基础路径:', API_BASE);

// 统一的API响应处理函数
function handleApiResponse(res) {
    console.log('API响应原始数据:', res);
    
    var result = {
        code: 1,
        msg: '数据格式错误',
        data: null,
        count: 0,
        success: false
    };
    
    // 检查响应是否为空
    if(res === undefined || res === null){
        result.msg = '响应为空';
        return result;
    }
    
    // 如果响应是字符串，尝试解析为JSON
    if(typeof res === 'string'){
        try{
            res = JSON.parse(res);
        }catch(e){
            result.msg = '响应不是有效的JSON: ' + res.substring(0, 100);
            return result;
        }
    }
    
    // 处理不同的响应格式
    
    // 格式1: {code: 200, msg: 'success', data: [...]}
    if(res.code !== undefined){
        if(res.code === 200 || res.code === 0){
            result.code = 0;
            result.success = true;
            result.msg = res.msg || 'success';
            result.data = res.data || [];
            result.count = Array.isArray(res.data) ? res.data.length : 
                          (res.count || res.total || 0);
        } else {
            result.code = res.code;
            result.msg = res.msg || '操作失败';
            result.data = res.data || [];
            result.count = res.count || 0;
        }
    }
    // 格式2: {success: true, data: [...], total: 10}
    else if(res.success !== undefined){
        result.code = res.success ? 0 : 1;
        result.success = res.success;
        result.msg = res.message || (res.success ? 'success' : 'failed');
        result.data = res.data || [];
        result.count = res.total || res.count || 0;
    }
    // 格式3: 直接是数组数据
    else if(Array.isArray(res)){
        result.code = 0;
        result.success = true;
        result.msg = 'success';
        result.data = res;
        result.count = res.length;
    }
    // 格式4: {data: [...], total: 10}
    else if(res.data !== undefined){
        result.code = 0;
        result.success = true;
        result.msg = 'success';
        result.data = res.data;
        result.count = res.total || res.count || 
                      (Array.isArray(res.data) ? res.data.length : 0);
    }
    // 格式5: 其他未知格式
    else{
        result.msg = '未知响应格式: ' + JSON.stringify(res).substring(0, 100);
        result.data = [];
    }
    
    console.log('API响应处理结果:', result);
    return result;
}

// 统一的表格数据解析函数
function parseTableData(res) {
    console.log('表格数据解析输入:', res);
    var handled = handleApiResponse(res);
    var result = {
        "code": handled.code,
        "msg": handled.msg,
        "count": handled.count,
        "data": handled.data
    };
    console.log('表格数据解析输出:', result);
    return result;
}

// 测试API连接
function testApiConnection() {
    console.log('=== 开始测试API连接 ===');
    console.log('API基础路径:', API_BASE);
    
    layui.use(['jquery', 'layer'], function(){
        var $ = layui.$;
        var layer = layui.layer;
        
        var testUrl = API_BASE + '?action=getAll&_=' + new Date().getTime();
        console.log('测试URL:', testUrl);
        
        $.ajax({
            url: testUrl,
            type: 'GET',
            dataType: 'json',
            timeout: 5000,
            beforeSend: function() {
                console.log('发送测试请求...');
            },
            success: function(res, status, xhr) {
                console.log('API连接测试成功:', res);
                console.log('状态码:', xhr.status);
                console.log('响应类型:', xhr.getResponseHeader('Content-Type'));
                
                var handled = handleApiResponse(res);
                if(handled.success){
                    var dataCount = handled.count || (handled.data ? handled.data.length : 0);
                    layer.msg('API连接成功！数据条数：' + dataCount, {icon: 1, time: 3000});
                    
                    // 如果表格没有数据，重新加载
                    if (!warehouseTable || (warehouseTable.config.data && warehouseTable.config.data.length === 0)) {
                        console.log('重新加载表格数据...');
                        warehouseTable.reload();
                    }
                } else {
                    layer.msg('API返回错误：' + handled.msg, {icon: 2});
                }
            },
            error: function(xhr, status, error) {
                console.error('API连接测试失败:');
                console.error('错误:', error);
                console.error('状态:', status);
                console.error('状态码:', xhr.status);
                console.error('响应文本:', xhr.responseText);
                
                var errorMsg = 'API连接失败: ';
                if (xhr.status === 0) {
                    errorMsg += '网络连接错误，请检查服务器是否启动';
                } else if (xhr.status === 404) {
                    errorMsg += '接口不存在 (404)，请检查Servlet路径';
                } else if (xhr.status === 500) {
                    errorMsg += '服务器内部错误 (500)，请检查Tomcat日志';
                } else {
                    errorMsg += error + ' (' + xhr.status + ')';
                }
                
                layer.msg(errorMsg, {icon: 2, time: 5000});
            }
        });
    });
}

$(document).ready(function() {
    layui.use(['table', 'form', 'layer'], function(){
        var table = layui.table;
        var form = layui.form;
        var layer = layui.layer;
        
        // 添加测试按钮到页面
        var testBtn = $('<button>')
            .addClass('layui-btn layui-btn-sm layui-btn-danger')
            .attr('type', 'button')
            .attr('id', 'btnTestApi')
            .html('<i class="layui-icon">&#xe608;</i> 测试API连接')
            .css('margin-left', '10px');
        
        $('#btnSearch').after(testBtn);
        
        // 绑定测试按钮事件
        $('#btnTestApi').click(function(){
            testApiConnection();
        });
        
        // 初始化表格
        warehouseTable = table.render({
            elem: '#warehouseTable',
            url: API_BASE + '?action=getAll',
            method: 'GET',
            page: true,
            limit: 10,
            limits: [10, 20, 30, 50],
            loading: true,
            text: {
                none: '暂无数据'
            },
            cols: [[
                {field: 'warehouseCode', title: '仓库编码', width: 120, fixed: 'left'},
                {field: 'warehouseName', title: '仓库名称', width: 180},
                {field: 'country', title: '国家/地区', width: 120},
                {field: 'city', title: '所在城市', width: 120, templet: function(d){
                    if(!d) return '-';
                    // 从地址中提取城市信息
                    if(d.address){
                        var parts = d.address.split(',');
                        if(parts.length > 1){
                            return parts[parts.length - 2].trim();
                        }
                        return parts[0].trim();
                    }
                    return d.city || '-';
                }},
                {field: 'currency', title: '本位币', width: 80, templet: '#currencyTpl'},
                {field: 'capacity', title: '容量使用情况', width: 150, templet: '#capacityTpl'},
                {field: 'contactPerson', title: '联系人', width: 100},
                {field: 'contactPhone', title: '联系电话', width: 120},
                {field: 'isActive', title: '状态', width: 80, templet: '#statusTpl'},
                {field: 'createTime', title: '创建时间', width: 160},
                {title: '操作', width: 200, fixed: 'right', toolbar: '#tableOperation'}
            ]],
            parseData: parseTableData,
            request: {
                pageName: 'page',
                limitName: 'limit'
            },
            response: {
                statusName: 'code',
                statusCode: 0,
                msgName: 'msg',
                countName: 'count',
                dataName: 'data'
            },
            done: function(res, curr, count){
                console.log('表格渲染完成:', res);
                console.log('当前页:', curr, '总条数:', count);
                
                if(res.code !== 0){
                    console.error('表格数据加载失败:', res.msg);
                    layer.msg('加载数据失败: ' + res.msg, {icon: 2});
                } else {
                    console.log('表格加载成功，数据条数:', count);
                }
            },
            error: function(res, msg){
                console.error('表格请求错误:', res, msg);
                layer.msg('请求失败: ' + msg, {icon: 2});
            }
        });
        
        // 表格工具条事件
        table.on('tool(warehouseTable)', function(obj){
            var data = obj.data;
            var event = obj.event;
            
            console.log('操作事件:', event, '数据:', data);
            
            if(event === 'view'){
                viewWarehouse(data.warehouseId || data.id);
            } else if(event === 'edit'){
                editWarehouse(data.warehouseId || data.id);
            } else if(event === 'enable'){
                enableWarehouse(data.warehouseId || data.id, data);
            } else if(event === 'disable'){
                disableWarehouse(data.warehouseId || data.id, data);
            } else if(event === 'delete'){
                deleteWarehouse(data.warehouseId || data.id, data);
            }
        });
        
        // 绑定按钮事件
        $('#btnSearch').click(function(){
            searchWarehouses();
        });
        
        $('#btnReset').click(function(){
            resetSearch();
        });
        
        $('#btnAdd').click(function(){
            addWarehouse();
        });
        
        // 初始加载数据
        form.render();
        
        // 页面加载后自动测试API连接
        setTimeout(function(){
            console.log('页面加载完成，开始测试API连接...');
            testApiConnection();
        }, 500);
    });
});

// 查询仓库
function searchWarehouses() {
    var name = $('#searchName').val();
    var country = $('#searchCountry').val();
    var status = $('#searchStatus').val();
    
    console.log('查询条件:', {name: name, country: country, status: status});
    
    // 构建查询参数 - 使用后端期望的参数名
    var queryParams = {
        action: 'getAll'
    };
    
    // 注意：参数名需要和后端接口保持一致
    if (name && name.trim() !== '') {
        queryParams.warehouseName = name.trim();
    }
    if (country && country !== '') {
        queryParams.country = country;
    }
    if (status && status !== '') {
        queryParams.isActive = status === 'true';
    }
    
    console.log('查询参数:', queryParams);
    
    // 构建查询字符串
    var queryParts = [];
    for (var key in queryParams) {
        if (queryParams[key] !== undefined && queryParams[key] !== null) {
            var value = queryParams[key];
            if (typeof value === 'boolean') {
                value = value ? 'true' : 'false';
            }
            queryParts.push(key + '=' + encodeURIComponent(value));
        }
    }
    
    var queryString = queryParts.join('&');
    var requestUrl = API_BASE + '?' + queryString;
    
    console.log('完整请求URL:', requestUrl);
    
    // 重新加载表格数据
    warehouseTable.reload({
        url: requestUrl,
        where: queryParams,
        page: {
            curr: 1 // 重新从第1页开始
        }
    });
}

// 重置查询条件
function resetSearch() {
    $('#searchName').val('');
    $('#searchCountry').val('');
    $('#searchStatus').val('');
    layui.form.render();
    
    // 重新加载所有数据
    warehouseTable.reload({
        url: API_BASE + '?action=getAll',
        page: {curr: 1}
    });
}

// 新增仓库
function addWarehouse() {
    layui.layer.open({
        type: 2,
        title: '新增仓库',
        area: ['600px', '650px'],
        content: '<%=request.getContextPath()%>/views/warehouse_form.jsp',
        end: function(){
            // 关闭后刷新表格
            warehouseTable.reload();
        }
    });
}

// 查看仓库详情
function viewWarehouse(id) {
    layui.layer.open({
        type: 2,
        title: '仓库详情',
        area: ['700px', '600px'],
        content: '<%=request.getContextPath()%>/views/warehouse_detail.jsp?id=' + id
    });
}

// 编辑仓库
function editWarehouse(id) {
    layui.layer.open({
        type: 2,
        title: '编辑仓库',
        area: ['600px', '650px'],
        content: '<%=request.getContextPath()%>/views/warehouse_form.jsp?id=' + id,
        end: function(){
            warehouseTable.reload();
        }
    });
}

// 启用仓库
function enableWarehouse(id, data) {
    layui.layer.confirm('确定要启用这个仓库吗？', {icon: 3, title: '提示'}, function(index){
        layui.layer.close(index);
        
        console.log('启用仓库，ID:', id);
        
        // 直接调用API，不使用包装函数
        layui.use(['jquery', 'layer'], function(){
            var $ = layui.$;
            var layer = layui.layer;
            
            var requestUrl = API_BASE + '?action=enable&id=' + encodeURIComponent(id);
            console.log('启用请求URL:', requestUrl);
            
            $.ajax({
                url: requestUrl,
                type: 'GET',
                dataType: 'json',
                beforeSend: function() {
                    console.log('发送启用请求...');
                },
                success: function(res) {
                    console.log('启用响应:', res);
                    
                    var handled = handleApiResponse(res);
                    if(handled.success){
                        layer.msg(handled.msg || '启用成功', {icon: 1, time: 1500});
                        // 刷新表格
                        setTimeout(function(){
                            warehouseTable.reload();
                        }, 500);
                    } else {
                        layer.msg(handled.msg || '启用失败', {icon: 2});
                    }
                },
                error: function(xhr, status, error) {
                    console.error('启用失败:', error);
                    console.error('状态码:', xhr.status);
                    console.error('响应文本:', xhr.responseText);
                    layer.msg('启用失败: ' + error, {icon: 2});
                }
            });
        });
    });
}

// 禁用仓库
function disableWarehouse(id, data) {
    layui.layer.confirm('确定要禁用这个仓库吗？', {icon: 3, title: '提示'}, function(index){
        layui.layer.close(index);
        
        console.log('禁用仓库，ID:', id);
        
        // 直接调用API，不使用包装函数
        layui.use(['jquery', 'layer'], function(){
            var $ = layui.$;
            var layer = layui.layer;
            
            var requestUrl = API_BASE + '?action=disable&id=' + encodeURIComponent(id);
            console.log('禁用请求URL:', requestUrl);
            
            $.ajax({
                url: requestUrl,
                type: 'GET',
                dataType: 'json',
                beforeSend: function() {
                    console.log('发送禁用请求...');
                },
                success: function(res) {
                    console.log('禁用响应:', res);
                    
                    var handled = handleApiResponse(res);
                    if(handled.success){
                        layer.msg(handled.msg || '禁用成功', {icon: 1, time: 1500});
                        // 刷新表格
                        setTimeout(function(){
                            warehouseTable.reload();
                        }, 500);
                    } else {
                        layer.msg(handled.msg || '禁用失败', {icon: 2});
                    }
                },
                error: function(xhr, status, error) {
                    console.error('禁用失败:', error);
                    console.error('状态码:', xhr.status);
                    console.error('响应文本:', xhr.responseText);
                    layer.msg('禁用失败: ' + error, {icon: 2});
                }
            });
        });
    });
}

// 删除仓库
function deleteWarehouse(id, data) {
    layui.layer.confirm('确定要删除这个仓库吗？此操作不可恢复！', {icon: 3, title: '警告'}, function(index){
        layui.layer.close(index);
        
        console.log('删除仓库，ID:', id);
        
        // 直接调用API，不使用包装函数
        layui.use(['jquery', 'layer'], function(){
            var $ = layui.$;
            var layer = layui.layer;
            
            var requestUrl = API_BASE + '?action=delete&id=' + encodeURIComponent(id);
            console.log('删除请求URL:', requestUrl);
            
            $.ajax({
                url: requestUrl,
                type: 'GET',
                dataType: 'json',
                beforeSend: function() {
                    console.log('发送删除请求...');
                },
                success: function(res) {
                    console.log('删除响应:', res);
                    
                    var handled = handleApiResponse(res);
                    if(handled.success){
                        layer.msg(handled.msg || '删除成功', {icon: 1, time: 1500});
                        // 刷新表格
                        setTimeout(function(){
                            warehouseTable.reload();
                        }, 500);
                    } else {
                        layer.msg(handled.msg || '删除失败', {icon: 2});
                    }
                },
                error: function(xhr, status, error) {
                    console.error('删除失败:', error);
                    console.error('状态码:', xhr.status);
                    console.error('响应文本:', xhr.responseText);
                    layer.msg('删除失败: ' + error, {icon: 2});
                }
            });
        });
    });
}

// 页面加载时执行
window.onload = function() {
    console.log('仓库管理页面加载完成');
    console.log('项目路径:', '<%=request.getContextPath()%>');
    console.log('完整API路径:', API_BASE);
};
</script>
</body>
</html>