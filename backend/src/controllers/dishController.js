import * as dishService from '../services/dishService.js';

// 获取随机菜单
export function getRandomDish(req, res) {
  try {
    const dish = dishService.getRandomDish();
    
    if (!dish) {
      return res.status(404).json({
        success: false,
        message: '暂无菜单数据'
      });
    }
    
    res.json({
      success: true,
      data: dish
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
}

// 获取所有菜单
export function getAllDishes(req, res) {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    
    const result = dishService.getAllDishes(page, limit);
    
    res.json({
      success: true,
      data: result.dishes,
      total: result.total,
      page: result.page,
      limit: result.limit,
      totalPages: result.totalPages
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
}

// 搜索菜单
export function searchDishes(req, res) {
  try {
    const keyword = req.query.keyword;
    
    if (!keyword) {
      return res.status(400).json({
        success: false,
        message: '请提供搜索关键词'
      });
    }
    
    const dishes = dishService.searchDishes(keyword);
    
    res.json({
      success: true,
      data: dishes
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
}

// 添加新菜单
export function addDish(req, res) {
  try {
    const { name, description, category } = req.body;
    
    if (!name) {
      return res.status(400).json({
        success: false,
        message: '菜品名称不能为空'
      });
    }
    
    const newDish = dishService.addDish(name, description, category);
    
    res.status(201).json({
      success: true,
      data: newDish
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
}
