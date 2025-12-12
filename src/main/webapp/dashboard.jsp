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

<!-- 概览卡片（用真实接口） -->
<div class="layui-row card-container">
    <div class="layui-col-md3">
        <div class="kpi-card">
            <div class="kpi-title">库存品种数</div>
            <div class="kpi-value" id="kpiTotalProducts">-</div>
        </div>
    </div>
    <div class="layui-col-md3">
        <div class="kpi-card">
            <div class="kpi-title">总仓库数</div>
            <div class="kpi-value" id="kpiTotalWarehouses">-</div>
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

<!-- 仓库分布 + 出入库趋势 -->
<div class="layui-row">
    <div class="layui-col-md6">
        <div class="kpi-card">
            <div class="kpi-title">各仓库库存分布</div>
            <div id="warehouseDistribution" style="height:320px;"></div>
        </div>
    </div>
    <div class="layui-col-md6">
        <div class="kpi-card">
            <div class="kpi-title">近30天出入库趋势</div>
            <div id="ioTrend" style="height:320px;"></div>
        </div>
    </div>
</div>

<!-- 低库存预警表 -->
<div class="layui-row card-container" style="margin-top: 20px;">
    <div class="layui-col-md12">
        <div class="kpi-card">
            <div class="kpi-title">
                低库存预警（共 <span id="lowStockCount">0</span> 条）
            </div>
            <table class="layui-table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>SKU</th>
                    <th>物料名称</th>
                    <th>所属仓库</th>
                    <th>当前库存</th>
                    <th>安全库存</th>
                    <th>状态</th>
                </tr>
                </thead>
                <tbody id="lowStockTbody">
                <!-- JS 动态填充 -->
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/echarts@5/dist/echarts.min.js"></script>
<script>
    // 项目上下文路径，例如 /WarehouseManagementSystem
    const CONTEXT_PATH = '<%=request.getContextPath()%>';

    function showError(msg) {
        if (window.layui) {
            layui.use('layer', function () {
                layui.layer.msg(msg || '系统错误', {icon: 5});
            });
        } else {
            alert(msg || '系统错误');
        }
    }

    // 统一 API 调用封装：传入 path 形如 '/api/dashboard?action=summary'
    async function callApi(path, options = {}) {
        const url = CONTEXT_PATH + path;
        try {
            const resp = await fetch(url, options);
            const result = await resp.json();
            if (result.code === 200) {
                return {success: true, data: result.data};
            } else {
                showError(result.msg || '接口返回错误');
                return {success: false, error: result.msg};
            }
        } catch (e) {
            console.error(e);
            showError('网络连接失败，请检查服务器状态');
            return {success: false, error: e.message};
        }
    }

    // 初始化仪表盘
    layui.use(function () {
        initDashboard();
    });

    async function initDashboard() {
        loadSummary();
        loadWarehouseDistribution();
        loadTrend();
        loadLowStockAlerts();
    }

    // 1. 概览卡片 /api/dashboard?action=summary
    async function loadSummary() {
        const res = await callApi('/api/dashboard?action=summary');
        if (!res.success || !res.data) return;
        const d = res.data;
        document.getElementById('kpiTotalProducts').innerText   = d.totalProducts ?? '-';
        document.getElementById('kpiTotalWarehouses').innerText = d.totalWarehouses ?? '-';
        document.getElementById('kpiPendingInbound').innerText  = d.pendingInbound ?? '-';
        document.getElementById('kpiPendingOutbound').innerText = d.pendingOutbound ?? '-';
    }

    // 2. 仓库库存分布 /api/dashboard?action=warehouseDistribution
    async function loadWarehouseDistribution() {
        const dom = document.getElementById('warehouseDistribution');
        if (!dom) return;
        const chart = echarts.init(dom);

        const res = await callApi('/api/dashboard?action=warehouseDistribution');
        let dataArr = [];
        if (res.success && res.data && Array.isArray(res.data.warehouses)) {
            dataArr = res.data.warehouses.map(w => ({
                name: w.name,
                value: (w.value != null ? w.value : w.count) || 0
            }));
        }

        if (dataArr.length === 0) {
            // 没有数据时给一个占位
            dataArr = [
                {name: '暂无数据', value: 1}
            ];
        }

        chart.setOption({
            tooltip: { trigger: 'item' },
            legend: { orient: 'vertical', left: 'left' },
            series: [{
                type: 'pie',
                radius: '60%',
                data: dataArr
            }]
        });
    }

    // 3. 趋势图 /api/dashboard?action=trend&days=30
    async function loadTrend() {
        const dom = document.getElementById('ioTrend');
        if (!dom) return;
        const chart = echarts.init(dom);

        let xData = [], inData = [], outData = [];

        const res = await callApi('/api/dashboard?action=trend&days=30');
        if (res.success && res.data) {
            const d = res.data;
            xData  = d.dates || d.xAxis || [];
            inData = d.inbound || d.inList || [];
            outData = d.outbound || d.outList || [];
        }

        // 如果后端暂时还没实现，做个兜底的示例数据
        if (!xData || xData.length === 0) {
            xData  = ['11-21','11-22','11-23','11-24','11-25','11-26','11-27'];
            inData = [120, 150, 80, 200, 170, 90, 130];
            outData = [100, 90, 110, 150, 160, 120, 140];
        }

        chart.setOption({
            tooltip: { trigger: 'axis' },
            legend: { data: ['入库数量', '出库数量'] },
            xAxis: { type: 'category', data: xData },
            yAxis: { type: 'value' },
            series: [
                { name: '入库数量', type: 'line', data: inData },
                { name: '出库数量', type: 'line', data: outData }
            ]
        });
    }

    // 4. 低库存预警 /api/dashboard?action=lowStockAlerts
    async function loadLowStockAlerts() {
        const tbody = document.getElementById('lowStockTbody');
        if (!tbody) return;

        const res = await callApi('/api/dashboard?action=lowStockAlerts');
        if (!res.success) return;

        let rows = [];
        const d = res.data;
        if (Array.isArray(d)) {
            rows = d;
        } else if (d && Array.isArray(d.items)) {
            rows = d.items;
        } else if (d && Array.isArray(d.list)) {
            rows = d.list;
        }

        tbody.innerHTML = '';
        if (!rows.length) {
            tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;">暂无预警数据</td></tr>';
            document.getElementById('lowStockCount').innerText = '0';
            return;
        }

        document.getElementById('lowStockCount').innerText = rows.length.toString();

        rows.forEach((item, idx) => {
            const tr = document.createElement('tr');
            const sku = item.sku || item.productCode || '';
            const name = item.productName || item.name || '';
            const wh = item.warehouseName || item.warehouse || '';
            const current = item.currentStock ?? item.qty ?? '';
            const safe = item.safeStock ?? item.safeQty ?? '';
            tr.innerHTML = `
                <td>${idx + 1}</td>
                <td>${sku}</td>
                <td>${name}</td>
                <td>${wh}</td>
                <td>${current}</td>
                <td>${safe}</td>
                <td><span class="layui-badge layui-bg-orange">预警</span></td>
            `;
            tbody.appendChild(tr);
        });
    }
</script>
</body>
</html>
