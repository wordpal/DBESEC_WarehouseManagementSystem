<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>货位信息</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui-src/dist/css/layui.css"/>
    <style>
        body { padding: 15px; }
        .form-section { margin-bottom: 20px; }
        .required:before { content: '* '; color: red; }
    </style>
</head>
<body>

<div class="layui-card">
    <div class="layui-card-header">货位信息</div>
    <div class="layui-card-body">
        <form class="layui-form" id="slotForm">
            <input type="hidden" id="slotId" name="id" value="">
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label required">所属仓库</label>
                    <div class="layui-input-inline">
                        <select name="warehouseId" id="warehouseId" required lay-verify="required">
                            <option value="">请选择仓库</option>
                        </select>
                    </div>
                </div>
                
                <div class="layui-inline">
                    <label class="layui-form-label required">货位编码</label>
                    <div class="layui-input-inline">
                        <input type="text" name="slotCode" required lay-verify="required" 
                               placeholder="请输入货位编码" class="layui-input">
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label required">区域</label>
                    <div class="layui-input-inline">
                        <input type="text" name="zone" required lay-verify="required" 
                               placeholder="如：A区、B区" class="layui-input">
                    </div>
                </div>
                
                <div class="layui-inline">
                    <label class="layui-form-label">排号</label>
                    <div class="layui-input-inline">
                        <input type="number" name="row" min="1" placeholder="排号" class="layui-input">
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">列号</label>
                    <div class="layui-input-inline">
                        <input type="number" name="column" min="1" placeholder="列号" class="layui-input">
                    </div>
                </div>
                
                <div class="layui-inline">
                    <label class="layui-form-label">层号</label>
                    <div class="layui-input-inline">
                        <input type="number" name="level" min="1" placeholder="层号" class="layui-input">
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label required">货位类型</label>
                    <div class="layui-input-inline">
                        <select name="type" required lay-verify="required">
                            <option value="">请选择货位类型</option>
                            <option value="1">普通货位</option>
                            <option value="2">重型货位</option>
                            <option value="3">冷藏货位</option>
                            <option value="4">危险品货位</option>
                        </select>
                    </div>
                </div>
                
                <div class="layui-inline">
                    <label class="layui-form-label required">货位状态</label>
                    <div class="layui-input-inline">
                        <select name="status" required lay-verify="required">
                            <option value="0">空闲</option>
                            <option value="1">部分占用</option>
                            <option value="2">已满</option>
                            <option value="3">禁用</option>
                        </select>
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label required">总容量</label>
                    <div class="layui-input-inline">
                        <input type="number" name="totalCapacity" required lay-verify="required|number" 
                               min="1" placeholder="总容量" class="layui-input">
                    </div>
                    <div class="layui-form-mid">单位：件/立方米</div>
                </div>
                
                <div class="layui-inline">
                    <label class="layui-form-label">已用容量</label>
                    <div class="layui-input-inline">
                        <input type="number" name="usedCapacity" min="0" 
                               placeholder="已用容量" class="layui-input">
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">最大承重(kg)</label>
                    <div class="layui-input-inline">
                        <input type="number" name="maxWeight" min="0" 
                               placeholder="最大承重" class="layui-input">
                    </div>
                </div>
                
                <div class="layui-inline">
                    <label class="layui-form-label">温度要求(℃)</label>
                    <div class="layui-input-inline">
                        <input type="text" name="temperature" placeholder="如：2~8" class="layui-input">
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">长(cm)</label>
                    <div class="layui-input-inline">
                        <input type="number" name="length" min="0" step="0.1" 
                               placeholder="长度" class="layui-input">
                    </div>
                </div>
                
                <div class="layui-inline">
                    <label class="layui-form-label">宽(cm)</label>
                    <div class="layui-input-inline">
                        <input type="number" name="width" min="0" step="0.1" 
                               placeholder="宽度" class="layui-input">
                    </div>
                </div>
                
                <div class="layui-inline">
                    <label class="layui-form-label">高(cm)</label>
                    <div class="layui-input-inline">
                        <input type="number" name="height" min="0" step="0.1" 
                               placeholder="高度" class="layui-input">
                    </div>
                </div>
            </div>
            
            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-block">
                    <textarea name="remark" placeholder="请输入备注信息" 
                              class="layui-textarea" rows="3"></textarea>
                </div>
            </div>
            
            <div class="layui-form-item" style="text-align: center;">
                <button class="layui-btn layui-btn-lg layui-btn-normal" lay-submit lay-filter="save">
                    <i class="layui-icon">&#xe605;</i> 保存
                </button>
                <button type="button" class="layui-btn layui-btn-lg layui-btn-primary" onclick="closeWindow()">
                    取消
                </button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/layui-src/dist/layui.js"></script>
<script>
    layui.use(['form', 'layer', 'jquery'], function(){
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.$;
        
        // 加载仓库列表
        loadWarehouses();
        
        // 如果有ID，加载数据
        var urlParams = new URLSearchParams(window.location.search);
        var id = urlParams.get('id');
        if(id){
            loadSlotData(id);
        }
        
        // 表单提交
        form.on('submit(save)', function(data){
            saveSlot(data.field);
            return false;
        });
    });
    
    // 加载仓库列表
    function loadWarehouses() {
        layui.$.ajax({
            url: '../api/warehouse',
            type: 'GET',
            data: { action: 'getAll' },
            dataType: 'json',
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
    }
    
    // 加载货位数据
    function loadSlotData(id) {
        layui.$.ajax({
            url: '../api/location',
            type: 'GET',
            data: { action: 'getById', id: id },
            dataType: 'json',
            success: function(res){
                if(res.success && res.data){
                    var data = res.data;
                    $('#slotId').val(data.id);
                    
                    // 填充表单字段
                    Object.keys(data).forEach(function(key){
                        var input = $('[name="' + key + '"]');
                        if(input.length){
                            if(input.is('select')){
                                input.val(data[key]);
                            } else {
                                input.val(data[key]);
                            }
                        }
                    });
                    
                    layui.form.render();
                }
            }
        });
    }
    
    // 保存货位
    function saveSlot(formData) {
        // 添加操作类型
        var id = $('#slotId').val();
        var url = '../api/location';
        var method = 'POST';
        
        if(id){
            formData.action = 'update';
        } else {
            formData.action = 'add';
        }
        
        // 发送请求
        layui.$.ajax({
            url: url,
            type: method,
            data: formData,
            dataType: 'json',
            success: function(res){
                if(res.success){
                    layui.layer.msg('保存成功', {icon: 1, time: 1500}, function(){
                        if(window.parent){
                            window.parent.location.reload();
                        }
                        closeWindow();
                    });
                } else {
                    layui.layer.msg(res.message || '保存失败', {icon: 2});
                }
            },
            error: function(){
                layui.layer.msg('请求失败，请检查网络连接', {icon: 2});
            }
        });
    }
    
    // 关闭窗口
    function closeWindow() {
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