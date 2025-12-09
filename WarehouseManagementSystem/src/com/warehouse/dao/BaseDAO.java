package com.warehouse.dao;

import java.util.List;

public interface BaseDAO<T> {
    // 基础CRUD操作
    boolean insert(T obj);
    boolean update(T obj);
    boolean delete(int id);
    T getById(int id);
    List<T> getAll();
    
    // 分页查询
    List<T> getByPage(int pageNum, int pageSize);
    int getTotalCount();
}