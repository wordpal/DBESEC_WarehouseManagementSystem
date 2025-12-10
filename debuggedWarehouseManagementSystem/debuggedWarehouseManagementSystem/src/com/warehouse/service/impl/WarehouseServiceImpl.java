package com.warehouse.service.impl;

import com.warehouse.service.WarehouseService;
import com.warehouse.beans.Warehouse;
import com.warehouse.dao.WarehouseDAO;
import com.warehouse.dao.impl.WarehouseDAOImpl;
import com.warehouse.util.JsonResponse;
import java.util.List;

public class WarehouseServiceImpl implements WarehouseService {
    
    private WarehouseDAO warehouseDAO;
    
    public WarehouseServiceImpl() {
        this.warehouseDAO = new WarehouseDAOImpl();
    }
    
    @Override
    public JsonResponse add(Warehouse warehouse) {
        try {
            // 数据验证
            if (warehouse.getWarehouseCode() == null || warehouse.getWarehouseCode().trim().isEmpty()) {
                return JsonResponse.badRequest("仓库编码不能为空");
            }
            if (warehouse.getWarehouseName() == null || warehouse.getWarehouseName().trim().isEmpty()) {
                return JsonResponse.badRequest("仓库名称不能为空");
            }
            
            // 检查编码是否已存在
            Warehouse existing = warehouseDAO.getByCode(warehouse.getWarehouseCode());
            if (existing != null) {
                return JsonResponse.badRequest("仓库编码已存在");
            }
            
            boolean success = warehouseDAO.insert(warehouse);
            if (success) {
                return JsonResponse.success("仓库添加成功", warehouse);
            } else {
                return JsonResponse.error("仓库添加失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse update(Warehouse warehouse) {
        try {
            // 数据验证
            if (warehouse.getWarehouseId() <= 0) {
                return JsonResponse.badRequest("仓库ID无效");
            }
            if (warehouse.getWarehouseCode() == null || warehouse.getWarehouseCode().trim().isEmpty()) {
                return JsonResponse.badRequest("仓库编码不能为空");
            }
            
            // 检查编码是否被其他仓库使用
            Warehouse existingByCode = warehouseDAO.getByCode(warehouse.getWarehouseCode());
            if (existingByCode != null && existingByCode.getWarehouseId() != warehouse.getWarehouseId()) {
                return JsonResponse.badRequest("仓库编码已被其他仓库使用");
            }
            
            boolean success = warehouseDAO.update(warehouse);
            if (success) {
                return JsonResponse.success("仓库更新成功", warehouse);
            } else {
                return JsonResponse.error("仓库更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse delete(int warehouseId) {
        try {
            // 检查仓库是否存在
            Warehouse warehouse = warehouseDAO.getById(warehouseId);
            if (warehouse == null) {
                return JsonResponse.notFound("仓库不存在");
            }
            
            // 逻辑删除（设为非活跃）
            boolean success = warehouseDAO.delete(warehouseId);
            if (success) {
                return JsonResponse.success("仓库删除成功");
            } else {
                return JsonResponse.error("仓库删除失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getById(int warehouseId) {
        try {
            Warehouse warehouse = warehouseDAO.getById(warehouseId);
            if (warehouse != null) {
                return JsonResponse.success(warehouse);
            } else {
                return JsonResponse.notFound("仓库不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getAll() {
        try {
            List<Warehouse> warehouses = warehouseDAO.getAll();
            return JsonResponse.success(warehouses);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByPage(int pageNum, int pageSize) {
        try {
            // 参数验证
            if (pageNum < 1) pageNum = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 10;
            
            List<Warehouse> warehouses = warehouseDAO.getByPage(pageNum, pageSize);
            int totalCount = warehouseDAO.getTotalCount();
            
            // 构建分页响应
            java.util.Map<String, Object> pageData = new java.util.HashMap<>();
            pageData.put("list", warehouses);
            pageData.put("pageNum", pageNum);
            pageData.put("pageSize", pageSize);
            pageData.put("total", totalCount);
            pageData.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
            
            return JsonResponse.success(pageData);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByCode(String warehouseCode) {
        try {
            Warehouse warehouse = warehouseDAO.getByCode(warehouseCode);
            if (warehouse != null) {
                return JsonResponse.success(warehouse);
            } else {
                return JsonResponse.notFound("仓库不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getActiveWarehouses() {
        try {
            List<Warehouse> warehouses = warehouseDAO.getActiveWarehouses();
            return JsonResponse.success(warehouses);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByCountry(String country) {
        try {
            if (country == null || country.trim().isEmpty()) {
                return JsonResponse.badRequest("国家不能为空");
            }
            
            List<Warehouse> warehouses = warehouseDAO.getByCountry(country);
            return JsonResponse.success(warehouses);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse deactivateWarehouse(int warehouseId) {
        try {
            boolean success = warehouseDAO.deactivateWarehouse(warehouseId);
            if (success) {
                return JsonResponse.success("仓库已停用");
            } else {
                return JsonResponse.error("仓库停用失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse activateWarehouse(int warehouseId) {
        try {
            boolean success = warehouseDAO.activateWarehouse(warehouseId);
            if (success) {
                return JsonResponse.success("仓库已启用");
            } else {
                return JsonResponse.error("仓库启用失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getWarehouseStats() {
        try {
            List<Warehouse> allWarehouses = warehouseDAO.getAll();
            List<Warehouse> activeWarehouses = warehouseDAO.getActiveWarehouses();
            
            // 按国家统计
            java.util.Map<String, Integer> countryStats = new java.util.HashMap<>();
            for (Warehouse wh : allWarehouses) {
                String country = wh.getCountry();
                countryStats.put(country, countryStats.getOrDefault(country, 0) + 1);
            }
            
            java.util.Map<String, Object> stats = new java.util.HashMap<>();
            stats.put("totalWarehouses", allWarehouses.size());
            stats.put("activeWarehouses", activeWarehouses.size());
            stats.put("inactiveWarehouses", allWarehouses.size() - activeWarehouses.size());
            stats.put("countryDistribution", countryStats);
            
            return JsonResponse.success(stats);
        } catch (Exception e) {
            e.printStackTrace();
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
}