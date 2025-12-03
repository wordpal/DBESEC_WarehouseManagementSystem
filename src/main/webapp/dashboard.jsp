<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>仪表盘 - 智能仓库管理系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>
    <style>
        body { padding: 15px; }
        .card-container { margin-bottom: 15px; }
        .kpi-card {
            padding: 15px;
            border-radius: 8px;
            background: #fff;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
        }
        .kpi-title { font-size: 14px; color: #888; }
        .kpi-value { font-size: 22px; margin-top: 5px; }
    </style>
</head>
<body>

<!-- D-01 数据概览卡片 -->
<div class="layui-row card-container">
    <div class="layui-col-md3">
        <div class="kpi-card">
            <div class="kpi-title">库存品种数</div>
            <div class="kpi-value" id="kpiSkuCount">128</div>
        </div>
    </div>
    <div class="layui-col-md3">
        <div class="kpi-card">
            <div class="kpi-title">总库存数量</div>
            <div class="kpi-value" id="kpiQty">23,450</div>
        </div>
    </div>
    <div class="layui-col-md3">
        <div class="kpi-card">
            <div class="kpi-title">待处理入库单</div>
            <div class="kpi-value" id="kpiInbound">5</div>
        </div>
    </div>
    <div class="layui-col-md3">
        <div class="kpi-card">
            <div class="kpi-title">待处理出库单</div>
            <div class="kpi-value" id="kpiOutbound">3</div>
        </div>
    </div>
</div>

<div class="layui-row" style="margin-bottom: 15px;">
    <!-- D-02 仓库库存分布饼图 -->
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">各仓库库存分布</div>
            <div class="layui-card-body">
                <div id="warehousePie" style="height:300px;"></div>
            </div>
        </div>
    </div>

    <!-- D-04 近30天出入库趋势 -->
    <div class="layui-col-md6">
        <div class="layui-card">
            <div class="layui-card-header">近30天出入库趋势</div>
            <div class="layui-card-body">
                <div id="ioTrend" style="height:300px;"></div>
            </div>
        </div>
    </div>
</div>

<!-- D-03 低库存预警表 -->
<div class="layui-card">
    <div class="layui-card-header">低库存预警</div>
    <div class="layui-card-body">
        <table class="layui-table">
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
            <tbody>
            <tr>
                <td>SKU-1001</td>
                <td>主板组件A</td>
                <td>中国上海仓</td>
                <td style="color:#ff5722;">30</td>
                <td>100</td>
                <td style="color:#ff5722;">严重</td>
            </tr>
            <tr>
                <td>SKU-2005</td>
                <td>包装材料B</td>
                <td>美国洛杉矶仓</td>
                <td style="color:#ffb800;">80</td>
                <td>150</td>
                <td style="color:#ffb800;">一般</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
<script>
    // 仓库库存分布饼图
    var pieChart = echarts.init(document.getElementById('warehousePie'));
    pieChart.setOption({
        tooltip: { trigger: 'item' },
        legend: { top: 'bottom' },
        series: [{
            type: 'pie',
            radius: '60%',
            data: [
                {value: 12000, name: '中国上海仓'},
                {value: 8000, name: '美国洛杉矶仓'},
                {value: 5000, name: '德国汉堡仓'}
            ]
        }]
    });

    // 近30天出入库趋势（示意：只画7天）
    var lineChart = echarts.init(document.getElementById('ioTrend'));
    lineChart.setOption({
        tooltip: { trigger: 'axis' },
        legend: { data: ['入库数量', '出库数量'] },
        xAxis: { type: 'category', data: ['11-21','11-22','11-23','11-24','11-25','11-26','11-27'] },
        yAxis: { type: 'value' },
        series: [
            { name: '入库数量', type: 'line', data: [120, 150, 80, 200, 170, 90, 130] },
            { name: '出库数量', type: 'line', data: [100, 90, 110, 150, 160, 120, 140] }
        ]
    });
</script>
</body>
</html>
