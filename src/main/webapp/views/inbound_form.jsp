<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>采购入库单</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>
    <style>
        body { padding: 15px; }
    </style>
</head>
<body>

<fieldset class="layui-elem-field">
    <legend>入库单基本信息</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane" id="inboundForm">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">入库单号</label>
                    <div class="layui-input-inline">
                        <input type="text" name="inboundNo" class="layui-input" value="自动生成" disabled>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">供应商</label>
                    <div class="layui-input-inline">
                        <input type="text" name="supplier" required placeholder="请输入供应商名称" class="layui-input">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">入库仓库</label>
                    <div class="layui-input-inline">
                        <!-- name 改成 warehouseId，方便和后端对上 -->
                        <select name="warehouseId" id="warehouseSelect" required>
                            <option value="">请选择</option>
                            <!-- 可以后续用 /api/warehouse 动态加载，这里先写死几条 -->
                            <option value="1">上海保税仓</option>
                            <option value="2">洛杉矶仓</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">入库日期</label>
                    <div class="layui-input-inline">
                        <input type="date" name="inboundDate" class="layui-input">
                    </div>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<fieldset class="layui-elem-field">
    <legend>入库明细（智能货位推荐）</legend>
    <div class="layui-field-box">
        <button class="layui-btn layui-btn-sm" type="button" onclick="addRow()">添加一行</button>
        <table class="layui-table" id="detailTable">
            <thead>
            <tr>
                <th>产品ID / SKU</th>
                <th>物料名称</th>
                <th>数量</th>
                <th>预计体积/重量</th>
                <th>推荐货位</th>
                <th>实际货位</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <!-- 给 SKU 输入框加上 name="productId"，后端就能直接拿 -->
                <td><input type="text" class="layui-input" name="productId" placeholder="例如：1 或 SKU-1001"></td>
                <td><input type="text" class="layui-input" name="productName" placeholder="主板组件A"></td>
                <td><input type="number" class="layui-input" name="quantity" value="100"></td>
                <td><input type="text" class="layui-input" name="sizeInfo" placeholder="1.2m³ / 200kg"></td>
                <td>
                    <input type="text" class="layui-input recommend-slot" name="recommendLocation"
                           placeholder="点击推荐按钮自动填充" readonly>
                </td>
                <td>
                    <input type="text" class="layui-input" name="realLocation" placeholder="可修改货位，如 SH-01-01">
                </td>
                <td>
                    <button class="layui-btn layui-btn-xs" type="button" onclick="recommend(this)">推荐货位</button>
                    <button class="layui-btn layui-btn-xs layui-btn-danger" type="button" onclick="removeRow(this)">删除</button>
                </td>
            </tr>
            </tbody>
        </table>

        <div style="text-align: center; margin-top: 15px;">
            <!-- 保存入库单暂时只做提示，后端可以根据需要改成真正调用 smartInbound -->
            <button class="layui-btn layui-btn-normal" type="button" onclick="saveInbound()">保存入库单</button>
            <button class="layui-btn layui-btn-primary" type="button" onclick="history.back()">返回</button>
        </div>
    </div>
</fieldset>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script>
    const CONTEXT_PATH = '<%=request.getContextPath()%>';

    function showError(msg) {
        layui.use('layer', function () {
            layui.layer.msg(msg || '操作失败', {icon: 5});
        });
    }

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

    function addRow() {
        var tbody = document.querySelector("#detailTable tbody");
        var tr = document.createElement("tr");
        tr.innerHTML =
            '<td><input type="text" class="layui-input" name="productId" placeholder="产品ID"></td>' +
            '<td><input type="text" class="layui-input" name="productName" placeholder="物料名称"></td>' +
            '<td><input type="number" class="layui-input" name="quantity" value="50"></td>' +
            '<td><input type="text" class="layui-input" name="sizeInfo" placeholder="体积/重量"></td>' +
            '<td><input type="text" class="layui-input recommend-slot" name="recommendLocation" placeholder="点击推荐按钮自动填充" readonly></td>' +
            '<td><input type="text" class="layui-input" name="realLocation" placeholder="实际货位"></td>' +
            '<td>' +
            '<button class="layui-btn layui-btn-xs" type="button" onclick="recommend(this)">推荐货位</button> ' +
            '<button class="layui-btn layui-btn-xs layui-btn-danger" type="button" onclick="removeRow(this)">删除</button>' +
            '</td>';
        tbody.appendChild(tr);
    }

    function removeRow(btn) {
        var tr = btn.parentNode.parentNode;
        tr.parentNode.removeChild(tr);
    }

    // 调用 /api/inventory?action=recommendLocation&productId=&warehouseId=&quantity=
    async function recommend(btn) {
        var tr = btn.parentNode.parentNode;
        var productIdInput = tr.querySelector('input[name="productId"]');
        var qtyInput       = tr.querySelector('input[name="quantity"]');
        var slotInput      = tr.querySelector('.recommend-slot');
        var warehouseSelect = document.getElementById('warehouseSelect');

        if (!productIdInput || !productIdInput.value) {
            showError('请先填写产品ID / SKU');
            return;
        }
        if (!warehouseSelect.value) {
            showError('请先选择入库仓库');
            return;
        }

        var params = new URLSearchParams({
            action: 'recommendLocation',
            productId: productIdInput.value,
            warehouseId: warehouseSelect.value,
            quantity: qtyInput && qtyInput.value ? qtyInput.value : 0
        });

        const res = await callApi('/api/inventory?' + params.toString());
        if (!res.success) return;

        var data = res.data || {};
        var location = data.locationCode || data.locationId || data.slotCode;
        if (!location) {
            showError('未获取到推荐货位');
            return;
        }

        slotInput.value = location;

        // 实际货位默认和推荐相同，方便用户直接提交
        var realInput = tr.querySelector('input[name="realLocation"]');
        if (realInput && !realInput.value) {
            realInput.value = location;
        }
    }

    // 保存入库单：这里先做一个简单提示，后端可以根据需要接 smartInbound 接口
    async function saveInbound() {
        layui.use('layer', function () {
            layui.layer.msg('已提交入库单（前端示例），具体入库逻辑可由后端通过 /api/inbound?action=smartInbound 实现。', {icon: 1});
        });
    }
</script>
</body>
</html>
