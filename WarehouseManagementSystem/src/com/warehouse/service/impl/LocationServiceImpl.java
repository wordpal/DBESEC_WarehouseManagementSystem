package com.warehouse.service.impl;

import com.warehouse.service.LocationService;
import com.warehouse.beans.StorageLocation;
import com.warehouse.dao.StorageLocationDAO;
import com.warehouse.dao.impl.StorageLocationDAOImpl;
import com.warehouse.util.JsonResponse;
import java.util.List;

public class LocationServiceImpl implements LocationService {
    
    private StorageLocationDAO locationDAO;
    
    public LocationServiceImpl() {
        this.locationDAO = new StorageLocationDAOImpl();
    }
    
    @Override
    public JsonResponse add(StorageLocation location) {
        try {
            // 验证数据
            if (location.getLocationCode() == null || location.getLocationCode().trim().isEmpty()) {
                return JsonResponse.badRequest("货位编码不能为空");
            }
            if (location.getWarehouseId() <= 0) {
                return JsonResponse.badRequest("仓库ID无效");
            }
            
            // 检查编码是否重复
            StorageLocation existing = locationDAO.getByCode(location.getLocationCode());
            if (existing != null) {
                return JsonResponse.badRequest("货位编码已存在");
            }
            
            boolean success = locationDAO.insert(location);
            if (success) {
                return JsonResponse.success("货位添加成功", location);
            } else {
                return JsonResponse.error("货位添加失败");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse update(StorageLocation location) {
        try {
            if (location.getLocationId() <= 0) {
                return JsonResponse.badRequest("货位ID无效");
            }
            
            boolean success = locationDAO.update(location);
            if (success) {
                return JsonResponse.success("货位更新成功", location);
            } else {
                return JsonResponse.error("货位更新失败");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse delete(int locationId) {
        try {
            // 先检查是否有库存
            StorageLocation location = locationDAO.getById(locationId);
            if (location == null) {
                return JsonResponse.notFound("货位不存在");
            }
            
            // 在实际系统中，这里应该检查货位是否有库存
            // 如果有库存不能删除
            
            boolean success = locationDAO.delete(locationId);
            if (success) {
                return JsonResponse.success("货位删除成功");
            } else {
                return JsonResponse.error("货位删除失败（可能有库存）");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getById(int locationId) {
        try {
            StorageLocation location = locationDAO.getById(locationId);
            if (location != null) {
                return JsonResponse.success(location);
            } else {
                return JsonResponse.notFound("货位不存在");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getAll() {
        try {
            List<StorageLocation> locations = locationDAO.getAll();
            return JsonResponse.success(locations);
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByPage(int pageNum, int pageSize) {
        try {
            if (pageNum < 1) pageNum = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 10;
            
            List<StorageLocation> locations = locationDAO.getByPage(pageNum, pageSize);
            int totalCount = locationDAO.getTotalCount();
            
            java.util.Map<String, Object> pageData = new java.util.HashMap<>();
            pageData.put("list", locations);
            pageData.put("pageNum", pageNum);
            pageData.put("pageSize", pageSize);
            pageData.put("total", totalCount);
            pageData.put("totalPages", (int) Math.ceil((double) totalCount / pageSize));
            
            return JsonResponse.success(pageData);
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByWarehouse(int warehouseId) {
        try {
            if (warehouseId <= 0) {
                return JsonResponse.badRequest("仓库ID无效");
            }
            
            List<StorageLocation> locations = locationDAO.getByWarehouse(warehouseId);
            return JsonResponse.success(locations);
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getAvailableLocations(int warehouseId) {
        try {
            if (warehouseId <= 0) {
                return JsonResponse.badRequest("仓库ID无效");
            }
            
            List<StorageLocation> locations = locationDAO.getAvailableLocations(warehouseId);
            return JsonResponse.success(locations);
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getOccupiedLocations(int warehouseId) {
        try {
            if (warehouseId <= 0) {
                return JsonResponse.badRequest("仓库ID无效");
            }
            
            List<StorageLocation> locations = locationDAO.getOccupiedLocations(warehouseId);
            return JsonResponse.success(locations);
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse updateStatus(int locationId, int status) {
        try {
            if (locationId <= 0) {
                return JsonResponse.badRequest("货位ID无效");
            }
            if (status != 0 && status != 1) {
                return JsonResponse.badRequest("状态值无效（0-空闲，1-占用）");
            }
            
            boolean success = locationDAO.updateStatus(locationId, status);
            if (success) {
                String statusText = status == 0 ? "空闲" : "占用";
                return JsonResponse.success("货位状态已更新为：" + statusText);
            } else {
                return JsonResponse.error("货位状态更新失败");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
    
    @Override
    public JsonResponse getByCode(String locationCode) {
        try {
            if (locationCode == null || locationCode.trim().isEmpty()) {
                return JsonResponse.badRequest("货位编码不能为空");
            }
            
            StorageLocation location = locationDAO.getByCode(locationCode);
            if (location != null) {
                return JsonResponse.success(location);
            } else {
                return JsonResponse.notFound("货位不存在");
            }
        } catch (Exception e) {
            return JsonResponse.error("系统错误: " + e.getMessage());
        }
    }
}