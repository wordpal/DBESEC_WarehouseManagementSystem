<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>销售出库单</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
    <style>
        body { padding: 15px; }
        .required:before { content: '* '; color: red; }
        .stock-check { margin-left: 10px; }
        .stock-available { color: #009688; }
        .stock-insufficient { color: #ff5722; }
    </style>
</head>
<body>

<fieldset class="layui-elem-field">
    <legend>出库单基本信息</legend>
    <div class="layui-field-box">
        <form class="layui-form layui-form-pane" id="outboundForm">
            <input type="hidden" id="orderId" name="orderId">
            <input type="hidden" id="locationId" name="locationId">
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label required">出库单号</label>
                    <div class="layui-input-inline">
                        <input type="text" id="orderCode" name="orderCode" class="layui-input" 
                               placeholder="系统自动生成" readonly>
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label required">客户</label>
                    <div class="layui-input-inline">
                        <input type="text" id="customer" name="customer" lay-verify="required" 
                               placeholder="请输入客户名称" class="layui-input" value="默认客户">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label required">出库仓库</label>
                    <div class="layui-input-inline">
                        <select id="warehouseId" name="warehouseId" lay-verify="required" lay-filter="warehouseChange">
                            <option value="">请选择仓库</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label required">操作员</label>
                    <div class="layui-input-inline">
                        <input type="text" id="operator" name="operator" class="layui-input" 
                               placeholder="请输入操作员姓名">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label required">出库日期</label>
                    <div class="layui-input-inline">
                        <input type="text" id="orderTime" name="orderTime" lay-verify="required" 
                               class="layui-input" placeholder="请选择出库日期">
                    </div>
                </div>

                <div class="layui-inline">
                    <label class="layui-form-label">联系电话</label>
                    <div class="layui-input-inline">
                        <input type="text" id="phone" name="phone" placeholder="客户联系电话" class="layui-input">
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-block" style="width: 600px;">
                    <textarea name="remark" placeholder="请输入备注信息" 
                              class="layui-textarea" rows="2"></textarea>
                </div>
            </div>
        </form>
    </div>
</fieldset>

<fieldset class="layui-elem-field">
    <legend>出库明细</legend>
    <div class="layui-field-box">
        <div style="margin-bottom: 15px;">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">选择产品</label>
                    <div class="layui-input-inline" style="width: 300px;">
                        <select id="productSelect" lay-search>
                            <option value="">输入产品名称或ID搜索</option>
                        </select>
                    </div>
                    <div class="layui-inline">
                        <button type="button" class="layui-btn layui-btn-sm" id="btnAddProduct">
                            <i class="layui-icon">&#xe654;</i> 添加到明细
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <table class="layui-table">
            <thead>
                <tr>
                    <th width="30">#</th>
                    <th width="120">产品ID</th>
                    <th width="150">产品名称</th>
                    <th width="80">单位</th>
                    <th width="100">可用库存</th>
                    <th width="120">出库数量</th>
                    <th width="150">批次</th>
                    <th width="100">单价</th>
                    <th width="120">金额</th>
                    <th width="100">操作</th>
                </tr>
            </thead>
            <tbody id="detailBody">
                <tr id="noDataRow">
                    <td colspan="10" style="text-align:center;color:#999;">请先选择产品添加到明细</td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="5" align="right"><strong>合计：</strong></td>
                    <td id="totalQuantity">0</td>
                    <td></td>
                    <td></td>
                    <td id="totalAmount">¥ 0.00</td>
                    <td></td>
                </tr>
            </tfoot>
        </table>

        <div style="text-align: center; margin-top: 20px;">
            <button class="layui-btn layui-btn-lg layui-btn-normal" type="button" id="btnSubmit">
                <i class="layui-icon">&#xe605;</i> 保存出库单
            </button>
            <button class="layui-btn layui-btn-lg layui-btn-primary" type="button" onclick="goBack()">
                取消
            </button>
            <button class="layui-btn layui-btn-lg layui-btn-warm" type="button" id="btnCheckAll">
                <i class="layui-icon">&#xe621;</i> 批量检查库存
            </button>
        </div>
    </div>
</fieldset>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
var API_BASE = '<%=request.getContextPath()%>/api';
var detailIndex = 0;
var selectedWarehouseId = '';
var products = [];

// 格式化日期显示
function formatDateForInput(dateStr) {
    if (!dateStr) return '';
    try {
        var date = new Date(dateStr);
        if (isNaN(date.getTime())) return dateStr;
        
        var year = date.getFullYear();
        var month = (date.getMonth() + 1).toString().padStart(2, '0');
        var day = date.getDate().toString().padStart(2, '0');
        var hours = date.getHours().toString().padStart(2, '0');
        var minutes = date.getMinutes().toString().padStart(2, '0');
        
        return year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
    } catch (e) {
        return dateStr;
    }
}

// 统一的API响应处理函数
function handleApiResponse(res) {
    console.log('API响应:', res);
    
    var result = {
        success: false,
        message: '数据格式错误',
        data: null
    };
    
    if (!res) return result;
    
    // 根据您的API格式处理
    if (res.code === 200 || res.code === 0) {
        result.success = true;
        result.message = res.msg || 'success';
        result.data = res.data || res;
    } else if (res.success !== undefined) {
        result.success = res.success;
        result.message = res.message || res.msg || (result.success ? 'success' : '操作失败');
        result.data = res.data || {};
    } else if (res.data !== undefined) {
        result.success = true;
        result.data = res.data;
        result.message = 'success';
    } else {
        result.success = true;
        result.data = res;
        result.message = 'success';
    }
    
    return result;
}

// 统一的GET方法API调用
function callGetApi(action, params, successCallback, errorCallback) {
    layui.use(['jquery', 'layer'], function(){
        var $ = layui.$;
        var layer = layui.layer;
        
        // 显示加载中
        var loadingIndex = layer.load(1, {shade: [0.3, '#000']});
        
        // 构建请求参数
        var requestParams = Object.assign({action: action}, params);
        
        console.log('GET请求:', action, '参数:', requestParams);
        
        $.ajax({
            url: API_BASE + '/outbound',
            type: 'GET',
            data: requestParams,
            success: function(res){
                layer.close(loadingIndex);
                console.log('GET响应:', res);
                
                var handled = handleApiResponse(res);
                if(handled.success){
                    if(successCallback) successCallback(handled.data);
                } else {
                    layer.msg(handled.message || action + '失败', {icon: 2});
                    if(errorCallback) errorCallback(handled.message);
                }
            },
            error: function(xhr, status, error){
                layer.close(loadingIndex);
                console.error('GET请求失败:', error, '状态:', xhr.status, '响应:', xhr.responseText);
                
                layer.msg('请求失败: ' + error, {icon: 2});
                if(errorCallback) errorCallback(error);
            }
        });
    });
}

$(document).ready(function() {
    layui.use(['form', 'laydate', 'layer'], function(){
        var form = layui.form;
        var laydate = layui.laydate;
        var layer = layui.layer;
        
        // 初始化日期选择器
        laydate.render({
            elem: '#orderTime',
            type: 'datetime',
            value: new Date(),
            format: 'yyyy-MM-dd HH:mm:ss'
        });
        
        // 设置默认操作员
        var loginUser = sessionStorage.getItem("loginUser") || localStorage.getItem("loginUser") || "admin";
        $('#operator').val(loginUser);
        
        // 生成出库单号（如果是新增）
        generateOutboundNo();
        
        // 加载仓库
        loadWarehouses();
        
        // 仓库变更事件
        form.on('select(warehouseChange)', function(data){
            selectedWarehouseId = data.value;
            $('#locationId').val(selectedWarehouseId);
            loadProducts(selectedWarehouseId);
        });
        
        // 绑定按钮事件
        $('#btnAddProduct').click(addProductToDetail);
        $('#btnCheckAll').click(checkAllStock);
        $('#btnSubmit').click(submitOutbound);
        
        // 产品选择事件
        form.on('select(productSelect)', function(data){
            if(data.value){
                addProductToDetail();
                $('#productSelect').val('');
                form.render('select');
            }
        });
        
        // 如果是编辑模式，加载数据
        var urlParams = new URLSearchParams(window.location.search);
        var orderId = urlParams.get('orderId');
        var orderCode = urlParams.get('orderCode');
        var productId = urlParams.get('productId');
        var locationId = urlParams.get('locationId');
        var quantity = urlParams.get('quantity');
        var operator = urlParams.get('operator');
        
        if (orderId || orderCode) {
            // 有参数，表示是查看或编辑
            loadOutboundDataFromParams({
                orderId: orderId,
                orderCode: orderCode,
                productId: productId,
                locationId: locationId,
                quantity: quantity,
                operator: operator
            });
        }
        
        form.render();
    });
});

// 生成出库单号
function generateOutboundNo() {
    var currentOrderCode = $('#orderCode').val();
    if (currentOrderCode && currentOrderCode.trim() !== '') {
        return; // 已有单号，不重新生成
    }
    
    var date = new Date();
    var year = date.getFullYear();
    var month = (date.getMonth() + 1).toString().padStart(2, '0');
    var day = date.getDate().toString().padStart(2, '0');
    var random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
    $('#orderCode').val('OUT-' + year + month + day + '-' + random);
}

// 加载仓库
function loadWarehouses() {
    callGetApi('getAll', {}, function(data){
        var warehouses = Array.isArray(data) ? data : (data.list || []);
        var html = '<option value="">请选择仓库</option>';
        
        if (warehouses.length === 0) {
            // 如果没有数据，使用默认选项
            for (var i = 1; i <= 5; i++) {
                html += '<option value="' + i + '">仓库' + i + '</option>';
            }
        } else {
            warehouses.forEach(function(warehouse){
                var warehouseId = warehouse.locationId || warehouse.id;
                var warehouseName = warehouse.name || '仓库' + warehouseId;
                html += '<option value="' + warehouseId + '">' + warehouseName + '</option>';
            });
        }
        
        $('#warehouseId').html(html);
        
        // 如果URL中有locationId参数，选中对应的仓库
        var urlParams = new URLSearchParams(window.location.search);
        var locationId = urlParams.get('locationId');
        if (locationId) {
            $('#warehouseId').val(locationId);
            selectedWarehouseId = locationId;
            $('#locationId').val(locationId);
            loadProducts(locationId);
        }
        
        layui.form.render('select');
    }, function(error){
        console.error('加载仓库失败:', error);
        // 失败时显示默认选项
        var html = '<option value="">请选择仓库</option>';
        for (var i = 1; i <= 5; i++) {
            html += '<option value="' + i + '">仓库' + i + '</option>';
        }
        $('#warehouseId').html(html);
        layui.form.render('select');
    });
}

// 加载产品
function loadProducts(warehouseId) {
    if(!warehouseId) {
        console.warn('未选择仓库，无法加载产品');
        return;
    }
    
    callGetApi('getProducts', {warehouseId: warehouseId}, function(data){
        products = Array.isArray(data) ? data : (data.list || []);
        var html = '<option value="">输入产品名称或ID搜索</option>';
        
        if (products.length === 0) {
            // 如果没有数据，使用示例产品
            var sampleProducts = [
                {id: 1, sku: 'P001', name: '示例产品1', currentStock: 100},
                {id: 2, sku: 'P002', name: '示例产品2', currentStock: 50},
                {id: 3, sku: 'P003', name: '示例产品3', currentStock: 200}
            ];
            products = sampleProducts;
        }
        
        products.forEach(function(product){
            var stockText = product.currentStock ? ' (库存: ' + product.currentStock + ')' : '';
            html += '<option value="' + product.id + '">' + 
                   (product.sku || 'P' + product.id) + ' - ' + 
                   (product.name || '产品' + product.id) + stockText + '</option>';
        });
        
        $('#productSelect').html(html);
        
        // 如果URL中有productId参数，选中对应的产品
        var urlParams = new URLSearchParams(window.location.search);
        var productId = urlParams.get('productId');
        if (productId && products.some(p => p.id == productId)) {
            $('#productSelect').val(productId);
            // 自动添加到明细
            setTimeout(function() {
                addProductToDetailForEdit(productId, urlParams.get('quantity'));
            }, 500);
        }
        
        layui.form.render('select');
    }, function(error){
        console.error('加载产品失败:', error);
        // 失败时显示示例产品
        products = [
            {id: 1, sku: 'P001', name: '示例产品1', currentStock: 100},
            {id: 2, sku: 'P002', name: '示例产品2', currentStock: 50},
            {id: 3, sku: 'P003', name: '示例产品3', currentStock: 200}
        ];
        
        var html = '<option value="">输入产品名称或ID搜索</option>';
        products.forEach(function(product){
            html += '<option value="' + product.id + '">' + 
                   product.sku + ' - ' + product.name + ' (库存: ' + product.currentStock + ')' + '</option>';
        });
        $('#productSelect').html(html);
        layui.form.render('select');
    });
}

// 从URL参数加载出库单数据（查看模式）
function loadOutboundDataFromParams(params) {
    console.log('从参数加载数据:', params);
    
    // 填充基本信息
    if (params.orderId) {
        $('#orderId').val(params.orderId);
    }
    if (params.orderCode) {
        $('#orderCode').val(decodeURIComponent(params.orderCode));
    }
    if (params.operator) {
        $('#operator').val(decodeURIComponent(params.operator));
    }
    if (params.productId) {
        // 产品信息将在loadProducts中处理
    }
    if (params.quantity) {
        // 数量信息将在添加产品时处理
    }
    
    // 设置日期为当前时间
    $('#orderTime').val(formatDateForInput(new Date()));
    
    // 禁用表单（查看模式）
    $('input, select, textarea, button').prop('disabled', true);
    $('#btnSubmit').hide();
    $('#btnCheckAll').hide();
    $('#btnAddProduct').hide();
    
    // 设置标题
    document.title = '出库单详情 - ' + (params.orderCode || params.orderId);
}

// 为编辑模式添加产品
function addProductToDetailForEdit(productId, quantity) {
    var product = products.find(p => p.id == productId);
    if(!product) {
        layui.layer.msg('产品不存在', {icon: 2});
        return;
    }
    
    detailIndex++;
    var rowId = 'row_' + detailIndex;
    
    var qty = quantity || 1;
    
    var html = '<tr id="' + rowId + '">' +
               '<td>' + detailIndex + '</td>' +
               '<td>' +
               '<input type="hidden" name="details[' + detailIndex + '].productId" value="' + product.id + '">' +
               (product.sku || 'P' + product.id) +
               '</td>' +
               '<td>' + (product.name || '产品' + product.id) + '</td>' +
               '<td>件</td>' +
               '<td>' +
               '<span id="stock_' + detailIndex + '" class="stock-available">' + (product.currentStock || 0) + '</span>' +
               '</td>' +
               '<td>' +
               '<input type="number" name="details[' + detailIndex + '].quantity" class="layui-input quantity-input" ' +
               'min="1" max="' + (product.currentStock || 9999) + '" value="' + qty + '" data-index="' + detailIndex + '" ' +
               'data-product-id="' + product.id + '" style="width: 100px;" disabled>' +
               '</td>' +
               '<td>默认批次</td>' +
               '<td>' +
               '<input type="number" name="details[' + detailIndex + '].price" class="layui-input price-input" ' +
               'min="0" step="0.01" value="' + (product.price || 100) + '" data-index="' + detailIndex + '" style="width: 100px;" disabled>' +
               '</td>' +
               '<td id="amount_' + detailIndex + '">¥ ' + (qty * (product.price || 100)).toFixed(2) + '</td>' +
               '<td></td>' +
               '</tr>';
    
    $('#noDataRow').remove();
    $('#detailBody').append(html);
    
    // 计算合计
    calculateTotal();
}

// 添加产品到明细（正常模式）
function addProductToDetail() {
    var productId = $('#productSelect').val();
    if(!productId) {
        layui.layer.msg('请先选择产品', {icon: 2});
        return;
    }
    
    var product = products.find(p => p.id == productId);
    if(!product) {
        layui.layer.msg('产品不存在', {icon: 2});
        return;
    }
    
    detailIndex++;
    var rowId = 'row_' + detailIndex;
    
    var html = '<tr id="' + rowId + '">' +
               '<td>' + detailIndex + '</td>' +
               '<td>' +
               '<input type="hidden" name="details[' + detailIndex + '].productId" value="' + product.id + '">' +
               (product.sku || 'P' + product.id) +
               '</td>' +
               '<td>' + (product.name || '产品' + product.id) + '</td>' +
               '<td>件</td>' +
               '<td>' +
               '<span id="stock_' + detailIndex + '" class="stock-available">' + (product.currentStock || 0) + '</span>' +
               '<button type="button" class="layui-btn layui-btn-xs layui-btn-primary stock-check" onclick="checkStock(' + detailIndex + ', ' + product.id + ')">检查</button>' +
               '</td>' +
               '<td>' +
               '<input type="number" name="details[' + detailIndex + '].quantity" class="layui-input quantity-input" ' +
               'min="1" max="' + (product.currentStock || 9999) + '" value="1" data-index="' + detailIndex + '" ' +
               'data-product-id="' + product.id + '" style="width: 100px;">' +
               '</td>' +
               '<td>默认批次</td>' +
               '<td>' +
               '<input type="number" name="details[' + detailIndex + '].price" class="layui-input price-input" ' +
               'min="0" step="0.01" value="' + (product.price || 100) + '" data-index="' + detailIndex + '" style="width: 100px;">' +
               '</td>' +
               '<td id="amount_' + detailIndex + '">¥ 0.00</td>' +
               '<td>' +
               '<button type="button" class="layui-btn layui-btn-xs layui-btn-danger" onclick="removeDetailRow(' + detailIndex + ')">删除</button>' +
               '</td>' +
               '</tr>';
    
    $('#noDataRow').remove();
    $('#detailBody').append(html);
    
    // 绑定事件
    $('.quantity-input').off('change').on('change', function(){
        var index = $(this).data('index');
        updateAmount(index);
    });
    
    $('.price-input').off('change').on('change', function(){
        var index = $(this).data('index');
        updateAmount(index);
    });
    
    // 初始计算金额
    updateAmount(detailIndex);
    
    // 渲染表单
    layui.form.render();
    
    // 清空产品选择
    $('#productSelect').val('');
    layui.form.render('select');
}

// 检查库存
function checkStock(index, productId) {
    var quantity = $('input[name="details[' + index + '].quantity"]').val();
    if(!quantity || quantity <= 0) {
        layui.layer.msg('请输入出库数量', {icon: 2});
        return;
    }
    
    var product = products.find(p => p.id == productId);
    if(!product) {
        layui.layer.msg('产品不存在', {icon: 2});
        return;
    }
    
    var availableStock = product.currentStock || 0;
    var stockSpan = $('#stock_' + index);
    
    if(quantity <= availableStock){
        stockSpan.removeClass('stock-insufficient').addClass('stock-available');
        stockSpan.text(availableStock + ' ✓');
        layui.layer.msg('库存充足', {icon: 1});
    } else {
        stockSpan.removeClass('stock-available').addClass('stock-insufficient');
        stockSpan.text(availableStock + ' ✗');
        layui.layer.msg('库存不足，可用库存：' + availableStock, {icon: 2});
    }
}

// 批量检查库存
function checkAllStock() {
    var rows = $('#detailBody tr[id^="row_"]');
    if(rows.length === 0) {
        layui.layer.msg('请先添加明细', {icon: 2});
        return;
    }
    
    var checkCount = 0;
    rows.each(function() {
        var row = $(this);
        var productId = row.find('input[name*=".productId"]').val();
        var quantity = row.find('.quantity-input').val();
        
        if(productId && quantity) {
            checkCount++;
            checkStock(row.attr('id').replace('row_', ''), productId);
        }
    });
    
    if(checkCount > 0) {
        layui.layer.msg('批量检查完成', {icon: 1, time: 1500});
    }
}

// 更新金额
function updateAmount(index) {
    var quantity = parseFloat($('input[name="details[' + index + '].quantity"]').val()) || 0;
    var price = parseFloat($('input[name="details[' + index + '].price"]').val()) || 0;
    var amount = quantity * price;
    
    $('#amount_' + index).text('¥ ' + amount.toFixed(2));
    calculateTotal();
}

// 计算合计
function calculateTotal() {
    var totalQuantity = 0;
    var totalAmount = 0;
    
    $('.quantity-input').each(function(){
        var quantity = parseFloat($(this).val()) || 0;
        totalQuantity += quantity;
    });
    
    $('.price-input').each(function(){
        var index = $(this).data('index');
        var quantity = parseFloat($('input[name="details[' + index + '].quantity"]').val()) || 0;
        var price = parseFloat($(this).val()) || 0;
        totalAmount += quantity * price;
    });
    
    $('#totalQuantity').text(totalQuantity);
    $('#totalAmount').text('¥ ' + totalAmount.toFixed(2));
}

// 删除明细行
function removeDetailRow(index) {
    $('#row_' + index).remove();
    
    if($('#detailBody tr[id^="row_"]').length === 0) {
        $('#detailBody').html('<tr id="noDataRow"><td colspan="10" style="text-align:center;color:#999;">请先选择产品添加到明细</td></tr>');
    }
    
    calculateTotal();
}

// 提交出库单
function submitOutbound() {
    if(!validateForm()) {
        return;
    }
    
    // 收集表单数据（匹配后端字段）
    var formData = {
        action: 'save',
        orderCode: $('#orderCode').val(),
        customer: $('#customer').val(),
        locationId: $('#warehouseId').val(),
        orderTime: $('#orderTime').val(),
        operator: $('#operator').val(),
        phone: $('#phone').val(),
        remark: $('textarea[name="remark"]').val()
    };
    
    // 收集明细数据
    var details = [];
    $('#detailBody tr[id^="row_"]').each(function() {
        var row = $(this);
        var index = row.attr('id').replace('row_', '');
        
        var detail = {
            productId: row.find('input[name*=".productId"]').val(),
            quantity: row.find('.quantity-input').val(),
            price: row.find('.price-input').val()
        };
        
        details.push(detail);
    });
    
    if (details.length > 0) {
        formData.productId = details[0].productId;
        formData.quantity = details[0].quantity;
    }
    
    // 编辑模式
    var orderId = $('#orderId').val();
    if(orderId) {
        formData.orderId = orderId;
    }
    
    console.log('提交数据:', formData);
    
    // 发送请求
    callGetApi('save', formData, function(data){
        layui.layer.msg('出库单保存成功', {icon: 1, time: 1500}, function(){
            if(window.parent){
                window.parent.location.reload();
            }
            goBack();
        });
    }, function(error){
        layui.layer.msg('保存失败: ' + error, {icon: 2});
    });
}

// 验证表单
function validateForm() {
    var customer = $('#customer').val();
    var warehouseId = $('#warehouseId').val();
    var orderTime = $('#orderTime').val();
    var operator = $('#operator').val();
    
    if(!customer || customer.trim() === '') {
        layui.layer.msg('请输入客户名称', {icon: 2});
        return false;
    }
    
    if(!warehouseId) {
        layui.layer.msg('请选择仓库', {icon: 2});
        return false;
    }
    
    if(!orderTime) {
        layui.layer.msg('请选择出库日期', {icon: 2});
        return false;
    }
    
    if(!operator || operator.trim() === '') {
        layui.layer.msg('请输入操作员', {icon: 2});
        return false;
    }
    
    // 检查明细
    if($('#detailBody tr[id^="row_"]').length === 0) {
        layui.layer.msg('请至少添加一条出库明细', {icon: 2});
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