import db from '../db/database.js';

// 获取随机菜单
export function getRandomDish() {
  try {
    const dish = db.prepare('SELECT * FROM dishes ORDER BY RANDOM() LIMIT 1').get();
    return dish || null;
  } catch (error) {
    throw new Error('Failed to get random dish: ' + error.message);
  }
}

// 获取所有菜单（支持分页）
export function getAllDishes(page = 1, limit = 10) {
  try {
    const offset = (page - 1) * limit;
    const dishes = db.prepare('SELECT * FROM dishes LIMIT ? OFFSET ?').all(limit, offset);
    const total = db.prepare('SELECT COUNT(*) as count FROM dishes').get().count;
    
    return {
      dishes,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit)
    };
  } catch (error) {
    throw new Error('Failed to get dishes: ' + error.message);
  }
}

// 搜索菜单
export function searchDishes(keyword) {
  try {
    const dishes = db.prepare('SELECT * FROM dishes WHERE name LIKE ? OR description LIKE ?')
      .all(`%${keyword}%`, `%${keyword}%`);
    return dishes;
  } catch (error) {
    throw new Error('Failed to search dishes: ' + error.message);
  }
}

// 添加新菜单
export function addDish(name, description, category) {
  try {
    const result = db.prepare('INSERT INTO dishes (name, description, category) VALUES (?, ?, ?)')
      .run(name, description, category);
    
    const newDish = db.prepare('SELECT * FROM dishes WHERE id = ?').get(result.lastInsertRowid);
    return newDish;
  } catch (error) {
    throw new Error('Failed to add dish: ' + error.message);
  }
}

// 根据ID获取菜单
export function getDishById(id) {
  try {
    const dish = db.prepare('SELECT * FROM dishes WHERE id = ?').get(id);
    return dish || null;
  } catch (error) {
    throw new Error('Failed to get dish by id: ' + error.message);
  }
}
