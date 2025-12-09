package com.warehouse.service;

import com.warehouse.util.JsonResponse;
import java.util.List;

public interface BaseService<T> {
    // 业务层统一返回JsonResponse
    JsonResponse add(T obj);
    JsonResponse update(T obj);
    JsonResponse delete(int id);
    JsonResponse getById(int id);
    JsonResponse getAll();
    JsonResponse getByPage(int pageNum, int pageSize);
}