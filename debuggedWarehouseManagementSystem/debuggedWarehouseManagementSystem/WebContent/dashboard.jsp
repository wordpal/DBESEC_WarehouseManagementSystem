<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>仪表盘 - 智能仓库管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.1/dist/echarts.min.js"></script>
    <style>
        body { padding: 15px; }
        .kpi-card {
            padding: 15px;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            margin-bottom: 15px;
        }
        .kpi-title { font-size: 14px; color: #888; }
        .kpi-value { font-size: 22px; margin-top: 5px; }
        .chart-container { height: 300px; }
    </style>
</head>
<body>

<!-- KPI卡片 -->
<div class="layui-row">
    <div class="layui-col-md3">
        <div class="kpi-card">
            <div class="kpi-title">库存品种数</div>
            <div class="kpi-value" id="kpiProductCount">-</div>
        </div>
    </div>
    <div class="layui-col-md3">
        <div class="kpi-card">
            <div class="kpi-title">总库存数量</div>
            <div class="kpi-value" id="kpiTotalQuantity">-</div>
        </div>
    </div>
    <div class="layui-col-md3">
        <div class="kpi-card">
            <div class="kpi-title">待处理入库单</div>
            <div class="kpi-value" id="kpiPendingInbound">-</div>
        </div>
    </div>
    <div class="layui-col-md3">
        <div class="kpi-card">
            <div class="kpi-title">待处理出库单</div>
            <div class="kpi-value" id="kpiPendingOutbound">-</div>
        </div>
    </div>
</div>

<div class="layui-row" style="margin-top: 15px;">
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">各仓库库存分布</div>
            <div class="layui-card-body">
                <div id="warehousePie" class="chart-container"></div>
            </div>
        </div>
    </div>
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">近30天出入库趋势</div>
            <div class="layui-card-body">
                <div id="ioTrend" class="chart-container"></div>
            </div>
        </div>
    </div>
</div>

<div class="layui-card" style="margin-top: 15px;">
    <div class="layui-card-header">低库存预警</div>
    <div class="layui-card-body">
        <table class="layui-table" id="lowStockTable">
            <thead>
                <tr>
                    <th>SKU</th>
                    <th>物料名称</th>
                    <th>仓库</th>
                    <th>当前库存</th>
                    <th>安全库存</th>
                    <th>预警等级</th>
                </tr>
            </thead>
            <tbody id="lowStockBody">
                <tr><td colspan="6" style="text-align:center;">加载中...</td></tr>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
var API_BASE = '<%=request.getContextPath()%>/api';
var warehousePieChart;
var ioTrendChart;

$(document).ready(function() {
    // 初始化ECharts
    warehousePieChart = echarts.init(document.getElementById('warehousePie'));
    ioTrendChart = echarts.init(document.getElementById('ioTrend'));
    
    // 加载所有数据
    loadDashboardData();
    
    // 每5分钟刷新一次
    setInterval(loadDashboardData, 5 * 60 * 1000);
});

// 加载仪表盘数据
function loadDashboardData() {
    loadKPIData();
    loadWarehouseDistribution();
    loadIOTrend();
    loadLowStockAlerts();
}

// 加载KPI数据
function loadKPIData() {
    layui.use('jquery', function(){
        var $ = layui.$;
        
        // 调用Dashboard API获取概要数据
        $.ajax({
            url: API_BASE + '/dashboard',
            type: 'GET',
            data: {action: 'summary'},
            success: function(res){
                if(res.success && res.data){
                    var data = res.data;
                    $('#kpiProductCount').text(data.totalProducts || '0');
                    $('#kpiTotalQuantity').text(data.totalInventoryQuantity || '0');
                    $('#kpiPendingInbound').text(data.pendingInbound || '0');
                    $('#kpiPendingOutbound').text(data.pendingOutbound || '0');
                }
            }
        });
    });
}

// 加载仓库分布数据
function loadWarehouseDistribution() {
    layui.use('jquery', function(){
        var $ = layui.$;
        
        $.ajax({
            url: API_BASE + '/dashboard',
            type: 'GET',
            data: {action: 'warehouseDistribution'},
            success: function(res){
                if(res.success && res.data){
                    var data = res.data;
                    var chartData = [];
                    
                    if(data.warehouses && data.warehouses.length > 0){
                        data.warehouses.forEach(function(item){
                            chartData.push({
                                name: item.name,
                                value: item.value || item.count || 0
                            });
                        });
                    }
                    
                    // 更新饼图
                    warehousePieChart.setOption({
                        tooltip: {
                            trigger: 'item',
                            formatter: '{a} <br/>{b}: {c} ({d}%)'
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left'
                        },
                        series: [{
                            name: '库存分布',
                            type: 'pie',
                            radius: '70%',
                            data: chartData,
                            emphasis: {
                                itemStyle: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }]
                    });
                }
            }
        });
    });
}

// 加载出入库趋势
function loadIOTrend() {
    layui.use('jquery', function(){
        var $ = layui.$;
        
        $.ajax({
            url: API_BASE + '/dashboard',
            type: 'GET',
            data: {action: 'trend', days: 30},
            success: function(res){
                if(res.success && res.data){
                    var data = res.data;
                    
                    ioTrendChart.setOption({
                        tooltip: {
                            trigger: 'axis'
                        },
                        legend: {
                            data: ['入库数量', '出库数量']
                        },
                        grid: {
                            left: '3%',
                            right: '4%',
                            bottom: '3%',
                            containLabel: true
                        },
                        xAxis: {
                            type: 'category',
                            boundaryGap: false,
                            data: data.dates || []
                        },
                        yAxis: {
                            type: 'value'
                        },
                        series: [
                            {
                                name: '入库数量',
                                type: 'line',
                                data: data.inbound || []
                            },
                            {
                                name: '出库数量',
                                type: 'line',
                                data: data.outbound || []
                            }
                        ]
                    });
                }
            }
        });
    });
}

// 加载低库存预警
function loadLowStockAlerts() {
    layui.use('jquery', function(){
        var $ = layui.$;
        
        $.ajax({
            url: API_BASE + '/inventory',
            type: 'GET',
            data: {action: 'getLowStock'},
            success: function(res){
                if(res.success && res.data){
                    var tbody = $('#lowStockBody');
                    var html = '';
                    
                    if(res.data.length > 0){
                        res.data.forEach(function(item){
                            var alertLevel = '';
                            var alertColor = '';
                            
                            // 计算预警等级
                            var stockRatio = (item.currentStock / item.safetyStock) * 100;
                            if(stockRatio <= 30){
                                alertLevel = '严重';
                                alertColor = '#ff5722';
                            } else if(stockRatio <= 50){
                                alertLevel = '一般';
                                alertColor = '#ffb800';
                            } else {
                                alertLevel = '轻微';
                                alertColor = '#009688';
                            }
                            
                            html += '<tr>' +
                                   '<td>' + (item.sku || '') + '</td>' +
                                   '<td>' + (item.productName || '') + '</td>' +
                                   '<td>' + (item.warehouseName || '') + '</td>' +
                                   '<td style="color:' + alertColor + '">' + (item.currentStock || 0) + '</td>' +
                                   '<td>' + (item.safetyStock || 0) + '</td>' +
                                   '<td style="color:' + alertColor + '">' + alertLevel + '</td>' +
                                   '</tr>';
                        });
                    } else {
                        html = '<tr><td colspan="6" style="text-align:center;color:#999;">暂无低库存预警</td></tr>';
                    }
                    
                    tbody.html(html);
                }
            }
        });
    });
}

// 窗口大小变化时重绘图表
window.addEventListener('resize', function(){
    warehousePieChart.resize();
    ioTrendChart.resize();
});
</script>
</body>
</html>