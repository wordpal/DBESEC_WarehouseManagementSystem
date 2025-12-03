API接口详细文档

🔗 基础信息

项目名：WarehouseManagementSystem



基础URL：http://localhost:8080/WarehouseManagementSystem



响应格式：{code: int, msg: string, data: object}



字符编码：UTF-8



📊 仪表盘模块

1\. 获取数据概览

text

GET /api/dashboard?action=summary

响应示例：



json

{

&nbsp; "code": 200,

&nbsp; "msg": "success",

&nbsp; "data": {

&nbsp;   "totalProducts": 156,

&nbsp;   "totalWarehouses": 3,

&nbsp;   "totalInventoryValue": 1250000.75,

&nbsp;   "lowStockAlerts": 8,

&nbsp;   "pendingInbound": 5,

&nbsp;   "pendingOutbound": 3,

&nbsp;   "todayInbound": 24,

&nbsp;   "todayOutbound": 18

&nbsp; }

}

2\. 获取仓库库存分布

text

GET /api/dashboard?action=warehouseDistribution

响应示例：



json

{

&nbsp; "code": 200,

&nbsp; "msg": "success",

&nbsp; "data": {

&nbsp;   "warehouses": \[

&nbsp;     {"name": "北京仓库", "value": 45, "count": 1200},

&nbsp;     {"name": "上海仓库", "value": 30, "count": 800},

&nbsp;     {"name": "美国仓库", "value": 25, "count": 600}

&nbsp;   ]

&nbsp; }

}

3\. 获取低库存预警

text

GET /api/dashboard?action=lowStockAlerts

4\. 获取趋势数据

text

GET /api/dashboard?action=trend\&days=30

📦 产品管理模块

1\. 分页获取产品

text

GET /api/product?action=getByPage\&pageNum=1\&pageSize=10

参数：



pageNum: 页码（从1开始）



pageSize: 每页条数



2\. 搜索产品

text

GET /api/product?action=search\&keyword=iPhone

3\. 获取低库存产品

text

GET /api/product?action=getLowStock

📥 入库管理模块

1\. 获取入库单列表

text

GET /api/inbound?action=getAll

2\. 智能入库

text

POST /api/inbound?action=smartInbound\&productId=1\&quantity=100\&operator=张三

3\. 搜索入库单

text

GET /api/inbound?action=search\&productId=1\&startDate=2024-01-01\&endDate=2024-01-31

📤 出库管理模块

1\. 获取出库单列表

text

GET /api/outbound?action=getAll

2\. FIFO出库

text

POST /api/outbound?action=fifoOutbound\&productId=1\&quantity=50\&operator=李四

3\. 库存检查

text

GET /api/outbound?action=checkStock\&productId=1\&quantity=50

📊 库存管理模块

1\. 智能货位推荐

text

GET /api/inventory?action=recommendLocation\&productId=1\&warehouseId=1\&quantity=100

2\. 获取库存列表

text

GET /api/inventory?action=getAll

3\. 获取低库存

text

GET /api/inventory?action=getLowStock

文档完整，可以立即开始前端开发工作！

