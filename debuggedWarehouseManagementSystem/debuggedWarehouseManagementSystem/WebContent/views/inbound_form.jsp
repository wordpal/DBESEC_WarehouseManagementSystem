<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>采购入库单</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
    <style>
        body { padding: 15px; }
        .detail-row { margin-bottom: 10px; }
        .required:before { content: '* '; color: red; }
    </style>
</head>
<body>

<fieldset class="layui-elem-field">
    <legend>入库单基本信息</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane" id="inboundForm">
            <input type="hidden" id="inboundId" name="id">
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label required">入库单号</label>
                    <div class="layui-input-inline">
                        <input type="text" id="inboundNo" name="inboundNo" class="layui-input" readonly>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label required">供应商</label>
                    <div class="layui-input-inline">
                        <select id="supplierId" name="supplierId" lay-verify="required">
                            <option value="">请选择供应商</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label required">入库仓库</label>
                    <div class="layui-input-inline">
                        <select id="warehouseId" name="warehouseId" lay-verify="required" lay-filter="warehouseChange">
                            <option value="">请选择仓库</option>
                        </select>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label required">入库日期</label>
                    <div class="layui-input-inline">
                        <input type="text" id="inboundDate" name="inboundDate" class="layui-input" lay-verify="required">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label required">操作员</label>
                    <div class="layui-input-inline">
                        <input type="text" id="operator" name="operator" class="layui-input" readonly>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">备注</label>
                    <div class="layui-input-inline" style="width: 300px;">
                        <input type="text" name="remark" placeholder="备注信息" class="layui-input">
                    </div>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<fieldset class="layui-elem-field">
    <legend>入库明细（智能货位推荐）</legend>
    <div class="layui-field-box">
        <div style="margin-bottom: 15px;">
            <button type="button" class="layui-btn layui-btn-sm" id="btnAddDetail">
                <i class="layui-icon">&#xe654;</i> 添加明细
            </button>
            <button type="button" class="layui-btn layui-btn-sm layui-btn-warm" id="btnRecommendAll">
                <i class="layui-icon">&#xe615;</i> 批量推荐货位
            </button>
        </div>

        <table class="layui-table">
            <thead>
                <tr>
                    <th width="30">#</th>
                    <th width="150">产品</th>
                    <th width="100">数量</th>
                    <th width="120">单位</th>
                    <th width="150">推荐货位</th>
                    <th width="150">实际货位</th>
                    <th width="150">批次号</th>
                    <th width="100">生产日期</th>
                    <th width="80">操作</th>
                </tr>
            </thead>
            <tbody id="detailBody">
                <!-- 明细行将通过JS动态添加 -->
                <tr id="noDataRow">
                    <td colspan="9" style="text-align:center;color:#999;">暂无明细，请点击添加明细按钮</td>
                </tr>
            </tbody>
        </table>

        <div class="layui-form-item" style="margin-top: 20px; text-align: center;">
            <button class="layui-btn layui-btn-lg layui-btn-normal" type="button" id="btnSubmit">
                <i class="layui-icon">&#xe605;</i> 保存入库单
            </button>
            <button class="layui-btn layui-btn-lg layui-btn-primary" type="button" onclick="goBack()">
                返回
            </button>
        </div>
    </div>
</fieldset>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
var API_BASE = '<%=request.getContextPath()%>/api';
var detailIndex = 0;
var selectedWarehouseId = '';
var suppliers = [];
var products = [];

$(document).ready(function() {
    layui.use(['form', 'laydate', 'layer'], function(){
        var form = layui.form;
        var laydate = layui.laydate;
        var layer = layui.layer;
        
        // 初始化日期选择器
        laydate.render({
            elem: '#inboundDate',
            type: 'date',
            value: new Date()
        });
        
        // 设置操作员（当前登录用户）
        var loginUser = sessionStorage.getItem("loginUser") || "admin";
        $('#operator').val(loginUser);
        
        // 生成入库单号
        generateInboundNo();
        
        // 加载供应商
        loadSuppliers();
        
        // 加载仓库
        loadWarehouses();
        
        // 仓库变更事件
        form.on('select(warehouseChange)', function(data){
            selectedWarehouseId = data.value;
            // 重新加载该仓库的产品
            loadProducts(selectedWarehouseId);
        });
        
        // 绑定按钮事件
        $('#btnAddDetail').click(addDetailRow);
        $('#btnRecommendAll').click(recommendAllLocations);
        $('#btnSubmit').click(submitInbound);
        
        // 如果是编辑模式，加载数据
        var urlParams = new URLSearchParams(window.location.search);
        var id = urlParams.get('id');
        if(id) {
            loadInboundData(id);
        }
        
        form.render();
    });
});

// 生成入库单号
function generateInboundNo() {
    var date = new Date();
    var year = date.getFullYear();
    var month = (date.getMonth() + 1).toString().padStart(2, '0');
    var day = date.getDate().toString().padStart(2, '0');
    var random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
    $('#inboundNo').val('IN-' + year + month + day + '-' + random);
}

// 加载供应商
function loadSuppliers() {
    layui.use('jquery', function(){
        var $ = layui.$;
        $.ajax({
            url: API_BASE + '/supplier',
            type: 'GET',
            data: {action: 'getAll'},
            success: function(res){
                if(res.success){
                    suppliers = res.data || [];
                    var html = '<option value="">请选择供应商</option>';
                    suppliers.forEach(function(supplier){
                        html += '<option value="' + supplier.id + '">' + supplier.name + '</option>';
                    });
                    $('#supplierId').html(html);
                    layui.form.render('select');
                }
            }
        });
    });
}

// 加载仓库
function loadWarehouses() {
    layui.use('jquery', function(){
        var $ = layui.$;
        $.ajax({
            url: API_BASE + '/warehouse',
            type: 'GET',
            data: {action: 'getAll'},
            success: function(res){
                if(res.success){
                    var html = '<option value="">请选择仓库</option>';
                    res.data.forEach(function(warehouse){
                        html += '<option value="' + warehouse.id + '">' + warehouse.name + '</option>';
                    });
                    $('#warehouseId').html(html);
                    layui.form.render('select');
                }
            }
        });
    });
}

// 加载产品
function loadProducts(warehouseId) {
    if(!warehouseId) return;
    
    layui.use('jquery', function(){
        var $ = layui.$;
        $.ajax({
            url: API_BASE + '/product',
            type: 'GET',
            data: {
                action: 'getByWarehouse',
                warehouseId: warehouseId
            },
            success: function(res){
                if(res.success){
                    products = res.data || [];
                    console.log('加载产品:', products.length, '个');
                }
            }
        });
    });
}

// 添加明细行
function addDetailRow() {
    detailIndex++;
    var rowId = 'row_' + detailIndex;
    
    var html = '<tr id="' + rowId + '">' +
               '<td>' + detailIndex + '</td>' +
               '<td>' +
               '<select name="details[' + detailIndex + '].productId" lay-verify="required" lay-filter="productSelect" data-index="' + detailIndex + '">' +
               '<option value="">请选择产品</option>' +
               '</select>' +
               '</td>' +
               '<td><input type="number" name="details[' + detailIndex + '].quantity" class="layui-input" lay-verify="required|number" min="1" value="1"></td>' +
               '<td><input type="text" name="details[' + detailIndex + '].unit" class="layui-input" readonly></td>' +
               '<td>' +
               '<input type="text" name="details[' + detailIndex + '].recommendLocation" class="layui-input" readonly>' +
               '<button type="button" class="layui-btn layui-btn-xs layui-btn-primary" onclick="recommendLocation(' + detailIndex + ')">推荐</button>' +
               '</td>' +
               '<td>' +
               '<select name="details[' + detailIndex + '].locationId" lay-verify="required">' +
               '<option value="">请选择货位</option>' +
               '</select>' +
               '</td>' +
               '<td><input type="text" name="details[' + detailIndex + '].batchNo" class="layui-input" placeholder="批次号"></td>' +
               '<td><input type="text" name="details[' + detailIndex + '].productionDate" class="layui-input" placeholder="生产日期"></td>' +
               '<td>' +
               '<button type="button" class="layui-btn layui-btn-xs layui-btn-danger" onclick="removeDetailRow(' + detailIndex + ')">删除</button>' +
               '</td>' +
               '</tr>';
    
    $('#noDataRow').remove();
    $('#detailBody').append(html);
    
    // 渲染表单
    layui.form.render();
    
    // 加载产品下拉框
    loadProductOptions(detailIndex);
    
    // 加载货位
    loadLocationOptions(detailIndex);
    
    // 绑定产品选择事件
    layui.form.on('select(productSelect)', function(data){
        var index = $(data.elem).data('index');
        var productId = data.value;
        updateProductInfo(index, productId);
    });
}

// 加载产品下拉框
function loadProductOptions(index) {
    var select = $('select[name="details[' + index + '].productId"]');
    var html = '<option value="">请选择产品</option>';
    
    if(products && products.length > 0) {
        products.forEach(function(product){
            html += '<option value="' + product.id + '" data-unit="' + (product.unit || '') + '">' + 
                   product.sku + ' - ' + product.name + '</option>';
        });
    }
    
    select.html(html);
    layui.form.render('select');
}

// 加载货位下拉框
function loadLocationOptions(index) {
    if(!selectedWarehouseId) return;
    
    layui.use('jquery', function(){
        var $ = layui.$;
        $.ajax({
            url: API_BASE + '/location',
            type: 'GET',
            data: {
                action: 'getAvailable',
                warehouseId: selectedWarehouseId
            },
            success: function(res){
                if(res.success){
                    var select = $('select[name="details[' + index + '].locationId"]');
                    var html = '<option value="">请选择货位</option>';
                    
                    res.data.forEach(function(location){
                        html += '<option value="' + location.id + '">' + location.slotCode + ' (容量: ' + 
                               (location.availableCapacity || 0) + ')</option>';
                    });
                    
                    select.html(html);
                    layui.form.render('select');
                }
            }
        });
    });
}

// 更新产品信息
function updateProductInfo(index, productId) {
    var product = products.find(p => p.id == productId);
    if(product) {
        // 更新单位
        $('input[name="details[' + index + '].unit"]').val(product.unit || '');
    }
}

// 推荐货位
function recommendLocation(index) {
    var productId = $('select[name="details[' + index + '].productId"]').val();
    var quantity = $('input[name="details[' + index + '].quantity"]').val();
    
    if(!productId || !quantity || !selectedWarehouseId) {
        layui.layer.msg('请先选择产品和输入数量', {icon: 2});
        return;
    }
    
    layui.use('jquery', function(){
        var $ = layui.$;
        $.ajax({
            url: API_BASE + '/inventory',
            type: 'GET',
            data: {
                action: 'recommendLocation',
                productId: productId,
                warehouseId: selectedWarehouseId,
                quantity: quantity
            },
            success: function(res){
                if(res.success && res.data){
                    var recommend = res.data.recommendedLocation;
                    if(recommend) {
                        $('input[name="details[' + index + '].recommendLocation"]').val(recommend.slotCode);
                        
                        // 自动选择推荐的货位
                        var locationSelect = $('select[name="details[' + index + '].locationId"]');
                        locationSelect.val(recommend.id);
                        layui.form.render('select');
                        
                        layui.layer.msg('推荐成功: ' + recommend.slotCode, {icon: 1});
                    } else {
                        layui.layer.msg('无合适货位推荐', {icon: 2});
                    }
                } else {
                    layui.layer.msg('推荐失败', {icon: 2});
                }
            }
        });
    });
}

// 批量推荐货位
function recommendAllLocations() {
    var rows = $('#detailBody tr[id^="row_"]');
    if(rows.length === 0) {
        layui.layer.msg('请先添加明细', {icon: 2});
        return;
    }
    
    layui.layer.msg('批量推荐中...', {icon: 16, time: 2000});
    
    rows.each(function() {
        var row = $(this);
        var index = row.attr('id').replace('row_', '');
        recommendLocation(index);
    });
}

// 删除明细行
function removeDetailRow(index) {
    $('#row_' + index).remove();
    
    // 如果没有明细了，显示提示
    if($('#detailBody tr').length === 0) {
        $('#detailBody').html('<tr id="noDataRow"><td colspan="9" style="text-align:center;color:#999;">暂无明细，请点击添加明细按钮</td></tr>');
    }
}

// 加载入库单数据（编辑模式）
function loadInboundData(id) {
    layui.use('jquery', function(){
        var $ = layui.$;
        $.ajax({
            url: API_BASE + '/inbound',
            type: 'GET',
            data: {action: 'getById', id: id},
            success: function(res){
                if(res.success && res.data){
                    var data = res.data;
                    
                    // 填充基本信息
                    $('#inboundId').val(data.id);
                    $('#inboundNo').val(data.inboundNo);
                    $('#supplierId').val(data.supplierId);
                    $('#warehouseId').val(data.warehouseId);
                    selectedWarehouseId = data.warehouseId;
                    $('#inboundDate').val(data.inboundDate);
                    $('#operator').val(data.operator);
                    $('input[name="remark"]').val(data.remark);
                    
                    // 加载产品（基于仓库）
                    loadProducts(selectedWarehouseId);
                    
                    // 加载明细
                    if(data.details && data.details.length > 0) {
                        $('#noDataRow').remove();
                        data.details.forEach(function(detail, index){
                            detailIndex = index + 1;
                            addDetailRowForEdit(detailIndex, detail);
                        });
                    }
                    
                    layui.form.render();
                }
            }
        });
    });
}

// 为编辑模式添加明细行
function addDetailRowForEdit(index, detail) {
    var rowId = 'row_' + index;
    
    var html = '<tr id="' + rowId + '">' +
               '<td>' + index + '</td>' +
               '<td>' +
               '<select name="details[' + index + '].productId" lay-verify="required">' +
               '<option value="">请选择产品</option>' +
               '</select>' +
               '</td>' +
               '<td><input type="number" name="details[' + index + '].quantity" class="layui-input" value="' + (detail.quantity || 1) + '"></td>' +
               '<td><input type="text" name="details[' + index + '].unit" class="layui-input" value="' + (detail.unit || '') + '" readonly></td>' +
               '<td>' +
               '<input type="text" name="details[' + index + '].recommendLocation" class="layui-input" value="' + (detail.recommendLocation || '') + '" readonly>' +
               '<button type="button" class="layui-btn layui-btn-xs layui-btn-primary" onclick="recommendLocation(' + index + ')">推荐</button>' +
               '</td>' +
               '<td>' +
               '<select name="details[' + index + '].locationId">' +
               '<option value="">请选择货位</option>' +
               '</select>' +
               '</td>' +
               '<td><input type="text" name="details[' + index + '].batchNo" class="layui-input" value="' + (detail.batchNo || '') + '"></td>' +
               '<td><input type="text" name="details[' + index + '].productionDate" class="layui-input" value="' + (detail.productionDate || '') + '"></td>' +
               '<td>' +
               '<button type="button" class="layui-btn layui-btn-xs layui-btn-danger" onclick="removeDetailRow(' + index + ')">删除</button>' +
               '</td>' +
               '</tr>';
    
    $('#detailBody').append(html);
    
    // 延迟加载选项
    setTimeout(function() {
        loadProductOptions(index);
        loadLocationOptions(index);
        
        // 设置选中的值
        $('select[name="details[' + index + '].productId"]').val(detail.productId);
        $('select[name="details[' + index + '].locationId"]').val(detail.locationId);
        
        layui.form.render();
    }, 100);
}

// 提交入库单
function submitInbound() {
    // 验证表单
    if(!validateForm()) {
        return;
    }
    
    // 收集表单数据
    var formData = {
        action: 'smartInbound',
        inboundNo: $('#inboundNo').val(),
        supplierId: $('#supplierId').val(),
        warehouseId: $('#warehouseId').val(),
        inboundDate: $('#inboundDate').val(),
        operator: $('#operator').val(),
        remark: $('input[name="remark"]').val()
    };
    
    // 收集明细数据
    var details = [];
    $('#detailBody tr[id^="row_"]').each(function() {
        var row = $(this);
        var index = row.attr('id').replace('row_', '');
        
        var detail = {
            productId: $('select[name="details[' + index + '].productId"]').val(),
            quantity: $('input[name="details[' + index + '].quantity"]').val(),
            locationId: $('select[name="details[' + index + '].locationId"]').val(),
            batchNo: $('input[name="details[' + index + '].batchNo"]').val(),
            productionDate: $('input[name="details[' + index + '].productionDate"]').val()
        };
        
        details.push(detail);
    });
    
    formData.details = details;
    
    // 发送请求
    layui.use('jquery', function(){
        var $ = layui.$;
        
        $.ajax({
            url: API_BASE + '/inbound',
            type: 'POST',
            data: formData,
            success: function(res){
                if(res.success){
                    layui.layer.msg('入库单保存成功', {icon: 1, time: 1500}, function(){
                        // 返回列表页面
                        if(window.parent){
                            window.parent.location.reload();
                        }
                        goBack();
                    });
                } else {
                    layui.layer.msg(res.message || '保存失败', {icon: 2});
                }
            },
            error: function(){
                layui.layer.msg('网络请求失败', {icon: 2});
            }
        });
    });
}

// 验证表单
function validateForm() {
    var supplierId = $('#supplierId').val();
    var warehouseId = $('#warehouseId').val();
    var inboundDate = $('#inboundDate').val();
    
    if(!supplierId) {
        layui.layer.msg('请选择供应商', {icon: 2});
        return false;
    }
    
    if(!warehouseId) {
        layui.layer.msg('请选择仓库', {icon: 2});
        return false;
    }
    
    if(!inboundDate) {
        layui.layer.msg('请选择入库日期', {icon: 2});
        return false;
    }
    
    // 检查是否有明细
    if($('#detailBody tr[id^="row_"]').length === 0) {
        layui.layer.msg('请至少添加一条入库明细', {icon: 2});
        return false;
    }
    
    // 验证每条明细
    var isValid = true;
    $('#detailBody tr[id^="row_"]').each(function() {
        var row = $(this);
        var productId = row.find('select[name*=".productId"]').val();
        var quantity = row.find('input[name*=".quantity"]').val();
        var locationId = row.find('select[name*=".locationId"]').val();
        
        if(!productId || !quantity || !locationId) {
            isValid = false;
        }
    });
    
    if(!isValid) {
        layui.layer.msg('请完善所有明细信息', {icon: 2});
        return false;
    }
    
    return true;
}

// 返回
function goBack() {
    if(window.parent && window.parent.layui && window.parent.layui.layer){
        var index = window.parent.layer.getFrameIndex(window.name);
        window.parent.layer.close(index);
    } else {
        history.back();
    }
}
</script>
</body>
</html>