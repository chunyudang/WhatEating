# 今天吃什么 - WhatEating

一款简单有趣的美食推荐应用，帮你解决"今天吃什么"的世纪难题！

## 项目简介

这是一个基于设计文档在3天内完成的全栈应用项目，包含：
- 🎨 **前端**：React + Vite，美观的渐变UI设计
- ⚙️ **后端**：Node.js + Express + SQLite
- 🍜 **功能**：随机推荐30+道美食，包括川菜、粤菜、家常菜、面食、快餐等

## 技术栈

### 前端
- React 18
- Vite
- CSS3（渐变、动画）
- Fetch API

### 后端
- Node.js
- Express.js
- better-sqlite3
- CORS

## 项目结构

```
WhatEating/
├── backend/              # 后端服务
│   ├── src/
│   │   ├── db/          # 数据库相关
│   │   ├── routes/      # 路由定义
│   │   ├── controllers/ # 控制器
│   │   ├── services/    # 业务逻辑
│   │   └── app.js       # 应用入口
│   └── data/            # SQLite数据库
└── frontend/            # 前端应用
    ├── src/
    │   ├── components/  # React组件
    │   ├── services/    # API服务
    │   └── App.jsx      # 主应用
    └── package.json
```

## 快速开始

### 后端启动

```bash
cd backend
npm install
npm start
```

后端服务运行在：`http://localhost:3000`

### 前端启动

```bash
cd frontend
npm install
npm run dev
```

前端应用运行在：`http://localhost:5174`

## API 端点

- `GET /api/random-dish` - 获取随机菜单
- `GET /api/dishes` - 获取所有菜单（支持分页）
- `GET /api/search?keyword=xxx` - 搜索菜单
- `POST /api/dishes` - 添加新菜单
- `GET /health` - 健康检查

## 功能特性

✅ 随机推荐美食  
✅ 精美的UI设计（橙红渐变主题）  
✅ 加载动画效果  
✅ 错误处理提示  
✅ 响应式设计（支持移动端）  
✅ 30+道初始菜单数据  
✅ 分类展示（川菜、粤菜、家常菜等）

## 部署

### 后端部署（Vercel/Railway/Render）
已包含 `vercel.json` 配置文件，可直接部署到 Vercel。

### 前端部署（Vercel/Netlify）
```bash
cd frontend
npm run build
```

构建产物在 `dist/` 目录。

## 开发进度

- ✅ 第1天：后端开发完成
  - 数据库设计与初始化
  - API 开发与测试
- ✅ 第2天：前端开发完成
  - UI 组件开发
  - 功能集成与联调
- ✅ 第3天：测试与部署
  - 功能测试
  - 部署配置

## 许可证

MIT License
