# API 参考文档

<cite>
**Referenced Files in This Document**   
- [app.js](file://backend/src/app.js)
- [api.js](file://backend/src/routes/api.js)
- [dishController.js](file://backend/src/controllers/dishController.js)
- [dishService.js](file://backend/src/services/dishService.js)
- [database.js](file://backend/src/db/database.js)
- [api.js](file://frontend/src/services/api.js)
</cite>

## 目录
1. [简介](#简介)
2. [API 端点](#api-端点)
   - [获取随机菜品](#获取随机菜品)
   - [获取所有菜品](#获取所有菜品)
   - [搜索菜品](#搜索菜品)
   - [添加新菜品](#添加新菜品)
3. [错误处理](#错误处理)
4. [前端调用示例](#前端调用示例)
5. [后端扩展指南](#后端扩展指南)

## 简介

WhatEating 后端API提供了一套RESTful接口，用于管理菜品数据。API基于Express框架构建，使用SQLite数据库存储菜品信息。系统支持获取随机菜品、分页查询所有菜品、关键词搜索以及添加新菜品等核心功能。

API基础URL为 `http://localhost:3000/api`，所有端点均以 `/api` 为前缀。服务器在启动时会自动初始化数据库并填充初始菜品数据。

**Section sources**
- [app.js](file://backend/src/app.js#L1-L65)
- [database.js](file://backend/src/db/database.js#L1-L97)

## API 端点

### 获取随机菜品

从数据库中随机返回一道菜品。

**HTTP 方法**: `GET`  
**URL 路径**: `/api/random-dish`

#### 请求参数
无

#### 请求头
- `Content-Type`: `application/json` (可选)

#### 响应状态码
- `200 OK`: 成功获取随机菜品
- `404 Not Found`: 数据库中无菜品数据
- `500 Internal Server Error`: 服务器内部错误

#### 响应体 (200 OK)
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "宫保鸡丁",
    "description": "经典川菜，鸡肉鲜嫩，花生香脆，麻辣鲜香",
    "category": "川菜",
    "created_at": "2025-01-01T00:00:00.000Z"
  }
}
```

#### 错误响应
```json
{
  "success": false,
  "message": "暂无菜单数据"
}
```

#### 业务逻辑
该端点通过调用 `dishService.getRandomDish()` 方法实现，使用SQL的 `ORDER BY RANDOM() LIMIT 1` 语句从数据库中随机选择一条记录。

**Section sources**
- [api.js](file://backend/src/routes/api.js#L5-L5)
- [dishController.js](file://backend/src/controllers/dishController.js#L3-L24)
- [dishService.js](file://backend/src/services/dishService.js#L3-L10)

### 获取所有菜品

获取所有菜品的分页列表。

**HTTP 方法**: `GET`  
**URL 路径**: `/api/dishes`

#### 请求参数
- **查询参数**:
  - `page` (可选): 页码，从1开始，默认为1
  - `limit` (可选): 每页数量，最大100，默认为10

#### 请求头
- `Content-Type`: `application/json` (可选)

#### 响应状态码
- `200 OK`: 成功获取菜品列表
- `500 Internal Server Error`: 服务器内部错误

#### 响应体 (200 OK)
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "宫保鸡丁",
      "description": "经典川菜，鸡肉鲜嫩，花生香脆，麻辣鲜香",
      "category": "川菜",
      "created_at": "2025-01-01T00:00:00.000Z"
    }
  ],
  "total": 25,
  "page": 1,
  "limit": 10,
  "totalPages": 3
}
```

#### 业务逻辑
该端点支持分页功能，通过计算 `OFFSET` 和 `LIMIT` 实现分页查询。同时返回总记录数和总页数，便于前端实现分页控件。

**Section sources**
- [api.js](file://backend/src/routes/api.js#L8-L8)
- [dishController.js](file://backend/src/controllers/dishController.js#L26-L47)
- [dishService.js](file://backend/src/services/dishService.js#L12-L25)

### 搜索菜品

根据关键词搜索菜品名称或描述。

**HTTP 方法**: `GET`  
**URL 路径**: `/api/search`

#### 请求参数
- **查询参数**:
  - `keyword`: 搜索关键词，必须提供

#### 请求头
- `Content-Type`: `application/json` (可选)

#### 响应状态码
- `200 OK`: 成功搜索到菜品
- `400 Bad Request`: 未提供搜索关键词
- `500 Internal Server Error`: 服务器内部错误

#### 响应体 (200 OK)
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "宫保鸡丁",
      "description": "经典川菜，鸡肉鲜嫩，花生香脆，麻辣鲜香",
      "category": "川菜",
      "created_at": "2025-01-01T00:00:00.000Z"
    }
  ]
}
```

#### 错误响应
```json
{
  "success": false,
  "message": "请提供搜索关键词"
}
```

#### 业务逻辑
搜索功能在菜品名称和描述字段上执行模糊匹配（LIKE查询），使用 `%keyword%` 模式进行搜索。

**Section sources**
- [api.js](file://backend/src/routes/api.js#L11-L11)
- [dishController.js](file://backend/src/controllers/dishController.js#L49-L75)
- [dishService.js](file://backend/src/services/dishService.js#L27-L35)

### 添加新菜品

向数据库中添加一道新菜品。

**HTTP 方法**: `POST`  
**URL 路径**: `/api/dishes`

#### 请求参数
- **请求体 (JSON)**:
  - `name` (必需): 菜品名称
  - `description` (可选): 菜品描述
  - `category` (可选): 菜品分类

#### 请求头
- `Content-Type`: `application/json` (必需)

#### 响应状态码
- `201 Created`: 成功创建新菜品
- `400 Bad Request`: 请求参数无效（如菜品名称为空）
- `500 Internal Server Error`: 服务器内部错误

#### 请求体示例
```json
{
  "name": "北京烤鸭",
  "description": "皮脆肉嫩，香气四溢，北京名菜",
  "category": "鲁菜"
}
```

#### 响应体 (201 Created)
```json
{
  "success": true,
  "data": {
    "id": 26,
    "name": "北京烤鸭",
    "description": "皮脆肉嫩，香气四溢，北京名菜",
    "category": "鲁菜",
    "created_at": "2025-01-01T00:00:00.000Z"
  }
}
```

#### 错误响应
```json
{
  "success": false,
  "message": "菜品名称不能为空"
}
```

#### 业务逻辑
该端点验证菜品名称是否为空，然后调用服务层方法将新菜品插入数据库。成功后返回新创建的菜品对象。

**Section sources**
- [api.js](file://backend/src/routes/api.js#L14-L14)
- [dishController.js](file://backend/src/controllers/dishController.js#L77-L100)
- [dishService.js](file://backend/src/services/dishService.js#L43-L53)

## 错误处理

API实现了统一的错误处理机制：

1. **客户端错误 (4xx)**: 返回具体的错误信息，如参数验证失败
2. **服务器错误 (5xx)**: 在生产环境中仅返回通用错误信息，避免暴露敏感信息
3. **全局错误处理**: 使用Express的错误处理中间件捕获未处理的异常

在开发环境中，错误响应会包含详细的堆栈信息，便于调试。

**Section sources**
- [app.js](file://backend/src/app.js#L50-L64)
- [dishController.js](file://backend/src/controllers/dishController.js#L5-L24)

## 前端调用示例

以下是使用JavaScript fetch API调用后端接口的示例：

### 获取随机菜品
```javascript
async function getRandomDish() {
  try {
    const response = await fetch('http://localhost:3000/api/random-dish');
    const data = await response.json();
    
    if (!response.ok) {
      throw new Error(data.message || '获取菜单失败');
    }
    
    if (!data.success) {
      throw new Error(data.message || '获取菜单失败');
    }
    
    return data.data;
  } catch (error) {
    if (error.message === 'Failed to fetch') {
      throw new Error('网络连接失败，请检查后端服务是否运行');
    }
    throw error;
  }
}
```

### 添加新菜品
```javascript
async function addDish(name, description, category) {
  try {
    const response = await fetch('http://localhost:3000/api/dishes', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ name, description, category }),
    });
    
    const data = await response.json();
    
    if (!response.ok) {
      throw new Error(data.message || '添加菜单失败');
    }
    
    return data.data;
  } catch (error) {
    if (error.message === 'Failed to fetch') {
      throw new Error('网络连接失败，请检查后端服务是否运行');
    }
    throw error;
  }
}
```

**Section sources**
- [api.js](file://frontend/src/services/api.js#L2-L84)

## 后端扩展指南

### 添加新API端点
1. 在 `routes/api.js` 中定义新的路由
2. 在 `controllers/` 目录下创建对应的控制器函数
3. 在 `services/` 目录下实现业务逻辑
4. 如有必要，在 `db/` 目录下扩展数据库操作

### 数据库模式变更
当前数据库表结构如下：
```sql
CREATE TABLE dishes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  category VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

如需添加新字段，需修改 `database.js` 中的表创建语句，并更新相关服务层代码。

### 性能优化建议
1. 已为菜品名称字段创建索引以提升搜索性能
2. 考虑为分类字段添加索引，如果按分类查询频繁
3. 对于高并发场景，可考虑添加缓存层

**Section sources**
- [database.js](file://backend/src/db/database.js#L10-L20)
- [api.js](file://backend/src/routes/api.js#L1-L19)
- [dishService.js](file://backend/src/services/dishService.js#L1-L65)