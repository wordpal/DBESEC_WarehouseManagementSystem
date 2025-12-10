<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>API测试</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<h2>仓库API测试</h2>

<div>
    <button onclick="testGetAll()">测试获取所有仓库</button>
    <button onclick="testGetById()">测试获取单个仓库</button>
    <button onclick="testUpdate()">测试更新仓库</button>
    <button onclick="testAdd()">测试新增仓库</button>
</div>

<div id="result" style="margin-top:20px;padding:10px;background:#f0f0f0;border:1px solid #ccc;min-height:100px;">
    测试结果将显示在这里
</div>

<script>
var API_BASE = '<%=request.getContextPath()%>/api';

function testGetAll() {
    $('#result').html('测试中...');
    
    $.ajax({
        url: API_BASE + '/warehouse',
        type: 'GET',
        data: {action: 'getAll'},
        success: function(res){
            $('#result').html('<pre>' + JSON.stringify(res, null, 2) + '</pre>');
        },
        error: function(xhr, status, error){
            $('#result').html('错误: ' + error + '<br>状态: ' + xhr.status);
        }
    });
}

function testGetById() {
    $('#result').html('测试中...');
    
    $.ajax({
        url: API_BASE + '/warehouse',
        type: 'GET',
        data: {action: 'getById', id: 1},
        success: function(res){
            $('#result').html('<pre>' + JSON.stringify(res, null, 2) + '</pre>');
        },
        error: function(xhr, status, error){
            $('#result').html('错误: ' + error + '<br>状态: ' + xhr.status);
        }
    });
}

function testUpdate() {
    $('#result').html('测试中...');
    
    // 尝试不同的数据格式
    var testData = {
        action: 'update',
        id: 1,
        warehouseName: '测试修改' + new Date().getTime(),
        isActive: true
    };
    
    $.ajax({
        url: API_BASE + '/warehouse',
        type: 'POST',
        data: testData,
        success: function(res){
            $('#result').html('<pre>' + JSON.stringify(res, null, 2) + '</pre>');
        },
        error: function(xhr, status, error){
            $('#result').html('错误: ' + error + '<br>状态: ' + xhr.status + 
                            '<br>响应: ' + xhr.responseText);
        }
    });
}

function testAdd() {
    $('#result').html('测试中...');
    
    var testData = {
        action: 'add',
        warehouseCode: 'TEST_' + new Date().getTime(),
        warehouseName: '测试仓库',
        country: 'China',
        address: '测试地址',
        isActive: true
    };
    
    $.ajax({
        url: API_BASE + '/warehouse',
        type: 'POST',
        data: testData,
        success: function(res){
            $('#result').html('<pre>' + JSON.stringify(res, null, 2) + '</pre>');
        },
        error: function(xhr, status, error){
            $('#result').html('错误: ' + error + '<br>状态: ' + xhr.status);
        }
    });
}
</script>
</body>
</html>