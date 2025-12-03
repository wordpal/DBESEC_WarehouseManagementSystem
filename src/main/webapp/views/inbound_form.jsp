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
                        <select name="warehouse" required>
                            <option value="">请选择</option>
                            <option value="WH-CN-SH">上海保税仓</option>
                            <option value="WH-US-LA">洛杉矶仓</option>
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
                <th>SKU</th>
                <th>物料名称</th>
                <th>数量</th>
                <th>预计体积/重量</th>
                <th>推荐货位</th>
                <th>实际货位</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <!-- 先放一行示例 -->
            <tr>
                <td><input type="text" class="layui-input" placeholder="例如：SKU-1001"></td>
                <td><input type="text" class="layui-input" placeholder="主板组件A"></td>
                <td><input type="number" class="layui-input" value="100"></td>
                <td><input type="text" class="layui-input" placeholder="1.2m³ / 200kg"></td>
                <td>
                    <input type="text" class="layui-input recommend-slot" placeholder="点击推荐按钮自动填充" readonly>
                </td>
                <td>
                    <input type="text" class="layui-input" placeholder="可修改货位，如 SH-01-01">
                </td>
                <td>
                    <button class="layui-btn layui-btn-xs" type="button" onclick="recommend(this)">推荐货位</button>
                    <button class="layui-btn layui-btn-xs layui-btn-danger" type="button" onclick="removeRow(this)">删除</button>
                </td>
            </tr>
            </tbody>
        </table>

        <div style="text-align: center; margin-top: 15px;">
            <button class="layui-btn layui-btn-normal" type="button">保存入库单（预留后端接口）</button>
            <button class="layui-btn layui-btn-primary" type="button" onclick="history.back()">返回</button>
        </div>
    </div>
</fieldset>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script>
    function addRow() {
        var tbody = document.querySelector("#detailTable tbody");
        var tr = document.createElement("tr");
        tr.innerHTML =
            '<td><input type="text" class="layui-input"></td>' +
            '<td><input type="text" class="layui-input"></td>' +
            '<td><input type="number" class="layui-input" value="50"></td>' +
            '<td><input type="text" class="layui-input" placeholder="体积/重量"></td>' +
            '<td><input type="text" class="layui-input recommend-slot" placeholder="点击推荐按钮自动填充" readonly></td>' +
            '<td><input type="text" class="layui-input"></td>' +
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

    // 当前是“前端假装推荐”：简单示例，后续可以改成调用后端接口
    function recommend(btn) {
        var tr = btn.parentNode.parentNode;
        var input = tr.querySelector(".recommend-slot");
        // 这里随便模拟一个“推荐货位”
        var candidates = ["SH-01-01", "SH-02-03", "LA-01-05", "LA-03-02"];
        var slot = candidates[Math.floor(Math.random() * candidates.length)];
        input.value = slot;
        // 实际货位默认跟推荐一样
        var realInput = tr.children[5].querySelector("input");
        if (realInput && !realInput.value) {
            realInput.value = slot;
        }
    }
</script>
</body>
</html>
