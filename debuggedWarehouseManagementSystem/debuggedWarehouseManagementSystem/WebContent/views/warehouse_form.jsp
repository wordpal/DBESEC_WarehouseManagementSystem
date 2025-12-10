<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>仓库信息</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/css/layui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        window.jQuery || document.write('<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"><\/script>');
    </script>
    <style>
        body { padding: 20px; }
        .form-container { max-width: 600px; margin: 0 auto; }
        .required:before { content: '* '; color: red; }
    </style>
</head>
<body>

<div class="layui-card">
    <div class="layui-card-header" id="formTitle">仓库信息</div>
    <div class="layui-card-body">
        <form class="layui-form" id="warehouseForm" lay-filter="warehouseForm">
            <input type="hidden" id="warehouseId" name="warehouseId">
            
            <div class="layui-form-item">
                <label class="layui-form-label required">仓库编码</label>
                <div class="layui-input-block">
                    <input type="text" id="warehouseCode" name="warehouseCode" 
                           lay-verify="required" placeholder="请输入仓库编码" class="layui-input">
                </div>
            </div>
            
            <div class="layui-form-item">
                <label class="layui-form-label required">仓库名称</label>
                <div class="layui-input-block">
                    <input type="text" id="warehouseName" name="warehouseName" 
                           lay-verify="required" placeholder="请输入仓库名称" class="layui-input">
                </div>
            </div>
            
            <div class="layui-form-item">
                <label class="layui-form-label required">国家/地区</label>
                <div class="layui-input-block">
                    <select id="country" name="country" lay-verify="required">
                        <option value="">请选择国家</option>
                        <option value="China">中国</option>
                        <option value="USA">美国</option>
                        <option value="Germany">德国</option>
                        <option value="Japan">日本</option>
                        <option value="UK">英国</option>
                        <option value="France">法国</option>
                        <option value="South Korea">韩国</option>
                    </select>
                </div>
            </div>
            
            <div class="layui-form-item">
                <label class="layui-form-label required">详细地址</label>
                <div class="layui-input-block">
                    <textarea id="address" name="address" lay-verify="required" 
                              placeholder="请输入详细地址" class="layui-textarea" rows="3"></textarea>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">联系人</label>
                    <div class="layui-input-inline">
                        <input type="text" id="contactPerson" name="contactPerson" 
                               placeholder="联系人姓名" class="layui-input">
                    </div>
                </div>
                
                <div class="layui-inline">
                    <label class="layui-form-label">联系电话</label>
                    <div class="layui-input-inline">
                        <input type="text" id="contactPhone" name="contactPhone" 
                               placeholder="联系电话" class="layui-input">
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">邮箱</label>
                    <div class="layui-input-inline" style="width: 300px;">
                        <input type="email" id="email" name="email" 
                               placeholder="邮箱地址" class="layui-input">
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">总容量(m³)</label>
                    <div class="layui-input-inline">
                        <input type="number" id="capacity" name="capacity" 
                               min="0" step="100" placeholder="总容量" class="layui-input">
                    </div>
                </div>
                
                <div class="layui-inline">
                    <label class="layui-form-label">仓库状态</label>
                    <div class="layui-input-inline">
                        <select id="isActive" name="isActive">
                            <option value="true">启用</option>
                            <option value="false">禁用</option>
                        </select>
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-block">
                    <textarea id="remark" name="remark" 
                              placeholder="备注信息" class="layui-textarea" rows="2"></textarea>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit lay-filter="saveBtn">保存</button>
                    <button type="button" class="layui-btn layui-btn-primary" onclick="closeWindow()">取消</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/layui@2.8.3/dist/layui.js"></script>
<script>
// API基础路径
var API_BASE = '<%=request.getContextPath()%>/api/warehouse-test';
var isEditMode = false;
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
            result.msg = '响应不是有效的JSON';
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
    layui.use(['form', 'layer'], function(){
        var form = layui.form;
        var layer = layui.layer;
        
        // 获取URL参数
        var urlParams = new URLSearchParams(window.location.search);
        warehouseId = urlParams.get('id');
        
        if(warehouseId){
            // 编辑模式
            isEditMode = true;
            document.getElementById('formTitle').innerText = '编辑仓库';
            loadWarehouseData(warehouseId);
        } else {
            // 新增模式
            document.getElementById('formTitle').innerText = '新增仓库';
        }
        
        // 表单提交
        form.on('submit(saveBtn)', function(data){
            saveWarehouse(data.field);
            return false;
        });
        
        form.render();
    });
});

// 加载仓库数据
function loadWarehouseData(id) {
    layui.use(['jquery', 'layer'], function(){
        var $ = layui.$;
        var layer = layui.layer;
        
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
        
        console.log('加载数据URL:', requestUrl);
        
        $.ajax({
            url: requestUrl,
            type: 'GET',
            beforeSend: function(){
                console.log('开始加载仓库数据...');
            },
            success: function(res){
                console.log('加载数据响应:', res);
                
                var handled = handleApiResponse(res);
                if(handled.success){
                    var data = handled.data || {};
                    console.log('表单数据:', data);
                    
                    // 填充表单字段
                    $('#warehouseId').val(data.warehouseId || data.id);
                    $('#warehouseCode').val(data.warehouseCode || data.code);
                    $('#warehouseName').val(data.warehouseName || data.name);
                    $('#country').val(data.country || 'China');
                    $('#address').val(data.address || '');
                    $('#contactPerson').val(data.contactPerson || '');
                    $('#contactPhone').val(data.contactPhone || '');
                    $('#email').val(data.email || '');
                    $('#capacity').val(data.capacity || '');
                    $('#isActive').val(data.isActive === false ? 'false' : 'true');
                    $('#remark').val(data.remark || '');
                    
                    // 渲染表单
                    layui.form.render();
                } else {
                    layer.msg('加载数据失败: ' + handled.msg, {icon: 2});
                }
            },
            error: function(xhr, status, error){
                console.error('加载数据失败:', error);
                console.error('状态码:', xhr.status);
                console.error('响应文本:', xhr.responseText);
                
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

// 保存仓库
function saveWarehouse(formData) {
    console.log('=== 开始保存 ===');
    console.log('表单数据:', formData);
    console.log('编辑模式:', isEditMode);
    console.log('仓库ID:', warehouseId);
    
    var layer = layui.layer;
    
    // 准备GET请求参数
    var params = {
        warehouseCode: formData.warehouseCode,
        warehouseName: formData.warehouseName,
        country: formData.country,
        address: formData.address,
        contactPerson: formData.contactPerson || '',
        contactPhone: formData.contactPhone || '',
        email: formData.email || '',
        capacity: formData.capacity || 0,
        isActive: formData.isActive === 'true',
        remark: formData.remark || ''
    };
    
    // 添加操作类型
    if(isEditMode){
        params.action = 'update';
        params.id = warehouseId;
        params.warehouseId = warehouseId;
        console.log('编辑操作: update, ID:', warehouseId);
    } else {
        params.action = 'add';
        console.log('新增操作: add');
    }
    
    console.log('请求参数:', params);
    
    // 显示加载中
    var loadingIndex = layer.load(2, {shade: [0.3, '#000']});
    
    // 构建查询字符串
    var queryParts = [];
    for(var key in params){
        if(params[key] !== undefined && params[key] !== null){
            var value = params[key];
            // 特殊处理布尔值和数字
            if(typeof value === 'boolean') {
                value = value ? 'true' : 'false';
            } else if(typeof value === 'number') {
                value = value.toString();
            }
            queryParts.push(key + '=' + encodeURIComponent(value));
        }
    }
    
    var queryString = queryParts.join('&');
    var requestUrl = API_BASE + '?' + queryString;
    
    console.log('请求URL:', requestUrl);
    console.log('查询字符串长度:', queryString.length);
    
    layui.use('jquery', function(){
        var $ = layui.$;
        
        $.ajax({
            url: requestUrl,
            type: 'GET',
            dataType: 'json',
            beforeSend: function(){
                console.log('发送保存请求...');
            },
            success: function(res, status, xhr){
                layer.close(loadingIndex);
                console.log('=== 保存响应 ===');
                console.log('状态:', status);
                console.log('原始响应:', res);
                console.log('响应类型:', typeof res);
                
                // 尝试处理响应
                var handled = handleApiResponse(res);
                console.log('处理后响应:', handled);
                
                if(handled.success){
                    layer.msg('保存成功', {icon: 1, time: 1500}, function(){
                        // 关闭窗口并刷新父页面
                        if(window.parent){
                            try {
                                // 尝试调用父页面的刷新方法
                                if(window.parent.warehouseTable && typeof window.parent.warehouseTable.reload === 'function'){
                                    window.parent.warehouseTable.reload();
                                }
                                // 如果父页面有layer，关闭当前窗口
                                if(window.parent.layui && window.parent.layui.layer){
                                    var index = parent.layer.getFrameIndex(window.name);
                                    parent.layer.close(index);
                                }
                            } catch(e) {
                                console.error('关闭窗口错误:', e);
                                closeWindow();
                            }
                        } else {
                            closeWindow();
                        }
                    });
                } else {
                    console.error('保存失败:', handled.msg);
                    layer.msg('保存失败: ' + handled.msg, {icon: 2});
                }
            },
            error: function(xhr, status, error){
                layer.close(loadingIndex);
                console.error('=== 请求错误 ===');
                console.error('状态码:', xhr.status);
                console.error('状态:', status);
                console.error('错误:', error);
                console.error('响应文本:', xhr.responseText);
                
                // 尝试解析响应文本
                var errorMsg = '保存失败';
                try {
                    var errorRes = JSON.parse(xhr.responseText);
                    errorMsg = errorRes.msg || errorRes.message || errorMsg;
                } catch(e) {
                    if(xhr.status === 414){
                        errorMsg = 'URL过长，尝试简化保存...';
                    } else {
                        errorMsg = '保存失败: ' + error + ' (状态码: ' + xhr.status + ')';
                    }
                }
                
                layer.msg(errorMsg, {icon: 2});
                
                // 如果URL太长，尝试简化参数
                if(xhr.status === 414){
                    setTimeout(function(){
                        saveWarehouseSimple(formData);
                    }, 1000);
                }
            }
        });
    });
}

// 简化保存（当URL过长时）
function saveWarehouseSimple(formData) {
    var layer = layui.layer;
    
    // 只传递必要参数
    var params = {
        warehouseCode: formData.warehouseCode,
        warehouseName: formData.warehouseName,
        country: formData.country,
        isActive: formData.isActive === 'true'
    };
    
    // 添加操作类型
    if(isEditMode){
        params.action = 'update';
        params.id = warehouseId;
    } else {
        params.action = 'add';
    }
    
    console.log('简化保存参数:', params);
    
    // 显示加载中
    var loadingIndex = layer.load(1, {shade: [0.3, '#000']});
    
    // 构建查询字符串
    var queryParts = [];
    for(var key in params){
        if(params[key] !== undefined && params[key] !== null){
            var value = params[key];
            if(typeof value === 'boolean') {
                value = value ? 'true' : 'false';
            }
            queryParts.push(key + '=' + encodeURIComponent(value));
        }
    }
    
    var queryString = queryParts.join('&');
    var requestUrl = API_BASE + '?' + queryString;
    
    console.log('简化保存URL:', requestUrl);
    
    layui.use('jquery', function(){
        var $ = layui.$;
        
        $.ajax({
            url: requestUrl,
            type: 'GET',
            dataType: 'json',
            success: function(res){
                layer.close(loadingIndex);
                console.log('简化保存响应:', res);
                
                var handled = handleApiResponse(res);
                if(handled.success){
                    layer.msg('保存成功（简化版）', {icon: 1, time: 1500}, function(){
                        if(window.parent){
                            try {
                                if(window.parent.warehouseTable){
                                    window.parent.warehouseTable.reload();
                                }
                                if(window.parent.layui && window.parent.layui.layer){
                                    var index = parent.layer.getFrameIndex(window.name);
                                    parent.layer.close(index);
                                }
                            } catch(e) {
                                console.error('关闭窗口错误:', e);
                                closeWindow();
                            }
                        } else {
                            closeWindow();
                        }
                    });
                } else {
                    layer.msg('保存失败: ' + handled.msg, {icon: 2});
                }
            },
            error: function(xhr, status, error){
                layer.close(loadingIndex);
                console.error('简化保存失败:', error);
                layer.msg('保存失败: ' + error, {icon: 2});
            }
        });
    });
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
    console.log('仓库表单页面加载完成');
    console.log('编辑模式:', isEditMode);
    console.log('仓库ID:', warehouseId);
    console.log('API基础路径:', API_BASE);
};
</script>
</body>
</html>