<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>仓库详情</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
    <style>
        body { padding: 20px; }
        .detail-container { max-width: 800px; margin: 0 auto; }
        .detail-section { margin-bottom: 20px; }
        .detail-label { font-weight: bold; color: #666; width: 120px; display: inline-block; }
        .detail-value { color: #333; }
        .status-active { color: #009688; }
        .status-inactive { color: #ff5722; }
    </style>
</head>
<body>

<div class="layui-card detail-container">
    <div class="layui-card-header">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <span>仓库详细信息</span>
            <button class="layui-btn layui-btn-sm layui-btn-primary" onclick="closeWindow()">关闭</button>
        </div>
    </div>
    <div class="layui-card-body">
        <div id="loading" style="text-align: center; padding: 50px;">
            <i class="layui-icon layui-icon-loading layui-anim layui-anim-rotate"></i> 加载中...
        </div>
        
        <div id="detailContent" style="display: none;">
            <!-- 基本信息 -->
            <fieldset class="layui-elem-field detail-section">
                <legend>基本信息</legend>
                <div class="layui-field-box">
                    <div class="layui-row">
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="detail-label">仓库编码：</label>
                                <span class="detail-value" id="warehouseCode"></span>
                            </div>
                            <div class="layui-form-item">
                                <label class="detail-label">仓库名称：</label>
                                <span class="detail-value" id="warehouseName"></span>
                            </div>
                            <div class="layui-form-item">
                                <label class="detail-label">国家/地区：</label>
                                <span class="detail-value" id="country"></span>
                            </div>
                        </div>
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="detail-label">仓库状态：</label>
                                <span class="detail-value" id="status"></span>
                            </div>
                            <div class="layui-form-item">
                                <label class="detail-label">创建时间：</label>
                                <span class="detail-value" id="createTime"></span>
                            </div>
                            <div class="layui-form-item">
                                <label class="detail-label">更新时间：</label>
                                <span class="detail-value" id="updateTime"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </fieldset>
            
            <!-- 联系信息 -->
            <fieldset class="layui-elem-field detail-section">
                <legend>联系信息</legend>
                <div class="layui-field-box">
                    <div class="layui-form-item">
                        <label class="detail-label">详细地址：</label>
                        <span class="detail-value" id="address" style="display: block; margin-top: 5px;"></span>
                    </div>
                    <div class="layui-row">
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="detail-label">联系人：</label>
                                <span class="detail-value" id="contactPerson"></span>
                            </div>
                        </div>
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="detail-label">联系电话：</label>
                                <span class="detail-value" id="contactPhone"></span>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="detail-label">邮箱：</label>
                        <span class="detail-value" id="email"></span>
                    </div>
                </div>
            </fieldset>
            
            <!-- 容量信息 -->
            <fieldset class="layui-elem-field detail-section">
                <legend>容量信息</legend>
                <div class="layui-field-box">
                    <div class="layui-row">
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="detail-label">总容量(m³)：</label>
                                <span class="detail-value" id="capacity"></span>
                            </div>
                        </div>
                        <div class="layui-col-md6">
                            <div class="layui-form-item">
                                <label class="detail-label">已用容量：</label>
                                <span class="detail-value" id="usedCapacity"></span>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="detail-label">使用率：</label>
                        <div style="display: inline-block; width: 300px; vertical-align: middle; margin-left: 10px;">
                            <div class="layui-progress" lay-filter="usageProgress">
                                <div class="layui-progress-bar" lay-percent="0%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </fieldset>
            
            <!-- 备注信息 -->
            <fieldset class="layui-elem-field detail-section">
                <legend>备注信息</legend>
                <div class="layui-field-box">
                    <div class="layui-form-item">
                        <span class="detail-value" id="remark" style="display: block; min-height: 60px; padding: 10px; background: #f8f8f8; border-radius: 4px;"></span>
                    </div>
                </div>
            </fieldset>
            
            <!-- 操作按钮 -->
            <div class="layui-form-item" style="text-align: center; margin-top: 30px;">
                <button class="layui-btn layui-btn-normal" onclick="editWarehouse()">
                    <i class="layui-icon">&#xe642;</i> 编辑
                </button>
                <button class="layui-btn layui-btn-primary" onclick="closeWindow()">关闭</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
// API基础路径
var API_BASE = '<%=request.getContextPath()%>/api/warehouse-test';
var warehouseId = '';

// 统一的API响应处理函数
function handleApiResponse(res) {
    console.log('handleApiResponse输入:', res);
    
    var result = {
        code: 1,
        msg: '未知错误',
        data: null,
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
    
    // 格式1: {code: 200, msg: 'success', data: {...}}
    if(res.code !== undefined){
        if(res.code === 200 || res.code === 0){
            result.code = 0;
            result.success = true;
            result.msg = res.msg || 'success';
            result.data = res.data || null;
        } else {
            result.code = res.code;
            result.msg = res.msg || '操作失败';
            result.data = res.data || null;
        }
    }
    // 格式2: {success: true, data: {...}}
    else if(res.success !== undefined){
        result.code = res.success ? 0 : 1;
        result.success = res.success;
        result.msg = res.message || (res.success ? 'success' : 'failed');
        result.data = res.data || null;
    }
    // 格式3: {data: {...}}
    else if(res.data !== undefined){
        result.code = 0;
        result.success = true;
        result.msg = 'success';
        result.data = res.data;
    }
    // 格式4: 其他格式
    else{
        result.msg = '未知响应格式';
        result.data = res;
    }
    
    console.log('handleApiResponse输出:', result);
    return result;
}

$(document).ready(function() {
    layui.use(['form', 'layer', 'element'], function(){
        var form = layui.form;
        var layer = layui.layer;
        var element = layui.element;
        
        // 获取URL参数
        var urlParams = new URLSearchParams(window.location.search);
        warehouseId = urlParams.get('id');
        
        if(warehouseId){
            loadWarehouseDetail(warehouseId);
        } else {
            layer.msg('未指定仓库ID', {icon: 2});
            setTimeout(closeWindow, 1500);
        }
    });
});

// 加载仓库详情
function loadWarehouseDetail(id) {
    layui.use(['jquery', 'layer', 'element'], function(){
        var $ = layui.$;
        var layer = layui.layer;
        var element = layui.element;
        
        // 构建GET请求参数
        var params = {
            action: 'getById',
            id: id
        };
        
        // 构建查询字符串
        var queryParts = [];
        for(var key in params){
            if(params[key] !== undefined && params[key] !== null){
                queryParts.push(key + '=' + encodeURIComponent(params[key]));
            }
        }
        
        var queryString = queryParts.join('&');
        var requestUrl = API_BASE + '?' + queryString;
        
        console.log('加载详情URL:', requestUrl);
        
        $.ajax({
            url: requestUrl,
            type: 'GET',
            beforeSend: function(){
                console.log('开始加载仓库详情...');
            },
            success: function(res){
                console.log('仓库详情响应:', res);
                
                $('#loading').hide();
                $('#detailContent').show();
                
                var handled = handleApiResponse(res);
                
                if(handled.success){
                    var data = handled.data || {};
                    console.log('仓库数据:', data);
                    
                    // 填充基本信息
                    $('#warehouseCode').text(data.warehouseCode || data.code || '-');
                    $('#warehouseName').text(data.warehouseName || data.name || '-');
                    $('#country').text(data.country || '-');
                    $('#createTime').text(data.createTime || data.createDate || '-');
                    $('#updateTime').text(data.updateTime || data.updateDate || '-');
                    
                    // 状态
                    var isActive = data.isActive !== false;
                    $('#status').html(isActive ? 
                        '<span class="status-active">✓ 启用</span>' : 
                        '<span class="status-inactive">✗ 禁用</span>');
                    
                    // 联系信息
                    $('#address').text(data.address || '-');
                    $('#contactPerson').text(data.contactPerson || '-');
                    $('#contactPhone').text(data.contactPhone || '-');
                    $('#email').text(data.email || '-');
                    
                    // 容量信息
                    var capacity = data.capacity || 0;
                    var usedCapacity = data.usedCapacity || 0;
                    $('#capacity').text(capacity.toLocaleString());
                    $('#usedCapacity').text(usedCapacity.toLocaleString());
                    
                    // 计算使用率
                    var usageRate = capacity > 0 ? Math.round((usedCapacity / capacity) * 100) : 0;
                    element.progress('usageProgress', usageRate + '%');
                    
                    // 备注
                    $('#remark').text(data.remark || data.description || '无');
                    
                } else {
                    layer.msg('加载数据失败: ' + handled.msg, {icon: 2});
                    showMockData();
                }
            },
            error: function(xhr, status, error){
                console.error('加载详情失败:', error);
                console.error('状态码:', xhr.status);
                console.error('响应文本:', xhr.responseText);
                
                $('#loading').hide();
                $('#detailContent').show();
                
                var errorMsg = '加载数据失败';
                try {
                    var errorRes = JSON.parse(xhr.responseText);
                    errorMsg = errorRes.msg || errorRes.message || errorMsg;
                } catch(e) {
                    errorMsg = '网络错误: ' + error;
                }
                
                layer.msg(errorMsg, {icon: 2});
                
            }
        });
    });
}



// 编辑仓库
function editWarehouse() {
    if(window.parent && window.parent.layui && window.parent.layui.layer){
        // 先关闭当前详情窗口
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
        
        // 在父窗口打开编辑表单
        setTimeout(function(){
            parent.layui.layer.open({
                type: 2,
                title: '编辑仓库',
                area: ['600px', '650px'],
                content: '<%=request.getContextPath()%>/views/warehouse_form.jsp?id=' + warehouseId
            });
        }, 300);
    } else {
        // 直接跳转到编辑页面
        window.location.href = 'warehouse_form.jsp?id=' + warehouseId;
    }
}

// 关闭窗口
function closeWindow() {
    if(window.parent && window.parent.layui && window.parent.layui.layer){
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    } else {
        history.back();
    }
}

// 页面加载完成
window.onload = function() {
    console.log('仓库详情页面加载完成');
    console.log('仓库ID:', warehouseId);
};
</script>
</body>
</html>