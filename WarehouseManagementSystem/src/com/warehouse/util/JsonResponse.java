package com.warehouse.util;

public class JsonResponse {
    private int code;
    private String msg;
    private Object data;
    
    public JsonResponse(int code, String msg, Object data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }
    
    // 成功响应
    public static JsonResponse success(Object data) {
        return new JsonResponse(200, "success", data);
    }
    
    public static JsonResponse success(String msg, Object data) {
        return new JsonResponse(200, msg, data);
    }
    
    public static JsonResponse success() {
        return new JsonResponse(200, "success", null);
    }
    
    // 错误响应
    public static JsonResponse error(String msg) {
        return new JsonResponse(500, msg, null);
    }
    
    public static JsonResponse error(int code, String msg) {
        return new JsonResponse(code, msg, null);
    }
    
    // 客户端错误
    public static JsonResponse badRequest(String msg) {
        return new JsonResponse(400, msg, null);
    }
    
    // 未授权
    public static JsonResponse unauthorized(String msg) {
        return new JsonResponse(401, msg, null);
    }
    
    // 未找到
    public static JsonResponse notFound(String msg) {
        return new JsonResponse(404, msg, null);
    }
    
    // Getters and Setters
    public int getCode() { return code; }
    public void setCode(int code) { this.code = code; }
    public String getMsg() { return msg; }
    public void setMsg(String msg) { this.msg = msg; }
    public Object getData() { return data; }
    public void setData(Object data) { this.data = data; }
    
    @Override
    public String toString() {
        return "JsonResponse [code=" + code + ", msg=" + msg + ", data=" + data + "]";
    }
}