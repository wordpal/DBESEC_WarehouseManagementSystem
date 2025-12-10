<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库存统计报表</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.1/dist/echarts.min.js"></script>
    <style>
        .chart-container { height: 400px; margin-top: 20px; }
        .export-btn { margin-left: 10px; }
    </style>
</head>
<body style="padding:15px;">

<fieldset class="layui-elem-field">
    <legend>统计条件</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">仓库</label>
                    <div class="layui-input-inline">
                        <select id="reportWarehouse">
                            <option value="">全部</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">统计维度</label>
                    <div class="layui-input-inline">
                        <select id="reportDimension">
                            <option value="warehouse">按仓库</option>
                            <option value="product">按产品</option>
                            <option value="category">按分类</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">统计时间</label>
                    <div class="layui-input-inline">
                        <select id="reportPeriod">
                            <option value="current">当前库存</option>
                            <option value="month">本月</option>
                            <option value="quarter">本季度</option>
                            <option value="year">本年</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <button class="layui-btn layui-btn-sm" type="button" id="btnGenerate">
                        <i class="layui-icon">&#xe615;</i> 生成报表
                    </button>
                    <button class="layui-btn layui-btn-sm layui-btn-warm export-btn" type="button" id="btnExport">
                        <i class="layui-icon">&#xe601;</i> 导出Excel
                    </button>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<div class="layui-card">
    <div class="layui-card-header">库存统计图表</div>
    <div class="layui-card-body">
        <div id="chartContainer" class="chart-container"></div>
    </div>
</div>

<div class="layui-card" style="margin-top: 15px;">
    <div class="layui-card-header">详细数据</div>
    <div class="layui-card-body">
        <table class="layui-table" id="reportTable">
            <thead id="reportHeader">
                <tr>
                    <th>维度</th>
                    <th>库存数量</th>
                    <th>库存价值</th>
                    <th>占比</th>
                </tr>
            </thead>
            <tbody id="reportBody">
                <tr>
                    <td colspan="4" style="text-align:center;color:#999;">请点击"生成报表"按钮查看数据</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
var API_BASE = '<%=request.getContextPath()%>/api';
var reportChart;

$(document).ready(function() {
    // 初始化ECharts
    reportChart = echarts.init(document.getElementById('chartContainer'));
    
    // 加载仓库下拉框
    loadWarehouses();
    
    // 绑定按钮事件
    $('#btnGenerate').click(generateReport);
    $('#btnExport').click(exportReport);
    
    layui.use('form', function(){
        layui.form.render();
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
                    $('#reportWarehouse').html(html);
                    layui.form.render('select');
                }
            }
        });
    });
}

// 生成报表
function generateReport() {
    var warehouseId = $('#reportWarehouse').val();
    var dimension = $('#reportDimension').val();
    var period = $('#reportPeriod').val();
    
    layui.layer.msg('正在生成报表...', {icon: 16, time: 2000});
    
    layui.use('jquery', function(){
        var $ = layui.$;
        
        $.ajax({
            url: API_BASE + '/report',
            type: 'GET',
            data: {
                action: 'inventory',
                warehouseId: warehouseId,
                dimension: dimension,
                period: period
            },
            success: function(res){
                if(res.success && res.data){
                    renderReport(res.data);
                    layui.layer.msg('报表生成成功', {icon: 1});
                } else {
                    layui.layer.msg(res.message || '生成报表失败', {icon: 2});
                }
            },
            error: function(){
                layui.layer.msg('网络请求失败', {icon: 2});
            }
        });
    });
}

// 渲染报表
function renderReport(data) {
    // 更新图表
    renderChart(data);
    
    // 更新表格
    renderTable(data);
}

// 渲染图表
function renderChart(data) {
    var chartData = [];
    var chartLabels = [];
    
    if(data.items && data.items.length > 0) {
        data.items.forEach(function(item){
            chartLabels.push(item.name || item.dimension);
            chartData.push({
                name: item.name || item.dimension,
                value: item.totalValue || item.quantity || 0
            });
        });
    }
    
    var option = {
        title: {
            text: data.title || '库存统计',
            left: 'center'
        },
        tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: ¥{c} ({d}%)'
        },
        legend: {
            orient: 'vertical',
            left: 'left',
            data: chartLabels
        },
        series: [{
            name: '库存价值',
            type: 'pie',
            radius: '50%',
            data: chartData,
            emphasis: {
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }]
    };
    
    reportChart.setOption(option);
}

// 渲染表格
function renderTable(data) {
    var header = $('#reportHeader');
    var body = $('#reportBody');
    
    // 根据维度更新表头
    var dimension = $('#reportDimension').val();
    var headerHtml = '';
    
    switch(dimension) {
        case 'warehouse':
            headerHtml = '<tr><th>仓库名称</th><th>库存数量</th><th>库存价值</th><th>占比</th></tr>';
            break;
        case 'product':
            headerHtml = '<tr><th>产品名称</th><th>SKU</th><th>库存数量</th><th>库存价值</th><th>占比</th></tr>';
            break;
        case 'category':
            headerHtml = '<tr><th>分类</th><th>库存数量</th><th>库存价值</th><th>占比</th></tr>';
            break;
        default:
            headerHtml = '<tr><th>维度</th><th>库存数量</th><th>库存价值</th><th>占比</th></tr>';
    }
    
    header.html(headerHtml);
    
    // 更新表格内容
    var bodyHtml = '';
    var totalValue = data.totalValue || 0;
    
    if(data.items && data.items.length > 0) {
        data.items.forEach(function(item){
            var percentage = totalValue > 0 ? ((item.totalValue / totalValue) * 100).toFixed(2) + '%' : '0%';
            
            switch(dimension) {
                case 'warehouse':
                    bodyHtml += '<tr>' +
                               '<td>' + (item.warehouseName || '') + '</td>' +
                               '<td>' + (item.totalQuantity || 0) + '</td>' +
                               '<td>¥' + (item.totalValue || 0).toFixed(2) + '</td>' +
                               '<td>' + percentage + '</td>' +
                               '</tr>';
                    break;
                case 'product':
                    bodyHtml += '<tr>' +
                               '<td>' + (item.productName || '') + '</td>' +
                               '<td>' + (item.sku || '') + '</td>' +
                               '<td>' + (item.quantity || 0) + '</td>' +
                               '<td>¥' + (item.value || 0).toFixed(2) + '</td>' +
                               '<td>' + percentage + '</td>' +
                               '</tr>';
                    break;
                case 'category':
                    bodyHtml += '<tr>' +
                               '<td>' + (item.category || '') + '</td>' +
                               '<td>' + (item.totalQuantity || 0) + '</td>' +
                               '<td>¥' + (item.totalValue || 0).toFixed(2) + '</td>' +
                               '<td>' + percentage + '</td>' +
                               '</tr>';
                    break;
            }
        });
        
        // 添加总计行
        bodyHtml += '<tr style="font-weight:bold;background:#f2f2f2;">' +
                   '<td colspan="' + (dimension === 'product' ? '2' : '1') + '" align="right">总计：</td>' +
                   '<td>' + (data.totalQuantity || 0) + '</td>' +
                   '<td>¥' + (totalValue || 0).toFixed(2) + '</td>' +
                   '<td>100%</td>' +
                   '</tr>';
    } else {
        bodyHtml = '<tr><td colspan="4" style="text-align:center;color:#999;">暂无数据</td></tr>';
    }
    
    body.html(bodyHtml);
}

// 导出报表
function exportReport() {
    var warehouseId = $('#reportWarehouse').val();
    var dimension = $('#reportDimension').val();
    var period = $('#reportPeriod').val();
    
    layui.use('jquery', function(){
        var $ = layui.$;
        
        $.ajax({
            url: API_BASE + '/report',
            type: 'GET',
            data: {
                action: 'export',
                warehouseId: warehouseId,
                dimension: dimension,
                period: period,
                format: 'excel'
            },
            xhrFields: {
                responseType: 'blob'
            },
            success: function(blob) {
                // 创建下载链接
                var url = window.URL.createObjectURL(blob);
                var a = document.createElement('a');
                a.href = url;
                a.download = '库存报表_' + new Date().toISOString().slice(0,10) + '.xlsx';
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                window.URL.revokeObjectURL(url);
                
                layui.layer.msg('导出成功', {icon: 1});
            },
            error: function() {
                layui.layer.msg('导出失败', {icon: 2});
            }
        });
    });
}

// 窗口大小变化时重绘图表
window.addEventListener('resize', function(){
    reportChart.resize();
});
</script>
</body>
</html>