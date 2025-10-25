import Database from 'better-sqlite3';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const dbPath = join(__dirname, '../../data/dishes.db');
const db = new Database(dbPath);

// 创建数据库表
export function initializeDatabase() {
  const createTableSQL = `
    CREATE TABLE IF NOT EXISTS dishes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name VARCHAR(100) NOT NULL,
      description TEXT,
      category VARCHAR(50),
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `;
  
  db.exec(createTableSQL);
  
  // 创建索引以提升搜索性能
  db.exec('CREATE INDEX IF NOT EXISTS idx_dish_name ON dishes(name)');
  
  console.log('Database initialized successfully');
}

// 插入初始数据
export function seedInitialData() {
  const count = db.prepare('SELECT COUNT(*) as count FROM dishes').get();
  
  if (count.count > 0) {
    console.log('Data already exists, skipping seed');
    return;
  }
  
  const initialDishes = [
    // 川菜
    { name: '宫保鸡丁', description: '经典川菜，鸡肉鲜嫩，花生香脆，麻辣鲜香', category: '川菜' },
    { name: '麻婆豆腐', description: '麻辣鲜香，豆腐嫩滑，下饭神器', category: '川菜' },
    { name: '水煮鱼', description: '鱼肉鲜嫩，麻辣过瘾，香气四溢', category: '川菜' },
    { name: '回锅肉', description: '肥而不腻，香辣可口，川菜经典', category: '川菜' },
    { name: '鱼香肉丝', description: '酸甜咸辣，味道丰富，色香味俱全', category: '川菜' },
    
    // 粤菜
    { name: '白切鸡', description: '皮爽肉滑，保持原汁原味', category: '粤菜' },
    { name: '糖醋排骨', description: '酸甜可口，色泽红亮，外酥里嫩', category: '粤菜' },
    { name: '广式烧鹅', description: '皮脆肉嫩，肥而不腻，风味独特', category: '粤菜' },
    { name: '蒸鲈鱼', description: '鱼肉细嫩，清淡鲜美，营养丰富', category: '粤菜' },
    { name: '白灼虾', description: '保持原味，鲜嫩可口，简单美味', category: '粤菜' },
    
    // 家常菜
    { name: '西红柿炒鸡蛋', description: '酸甜可口，营养丰富，家常必备', category: '家常菜' },
    { name: '青椒肉丝', description: '色泽鲜艳，口感爽脆，简单美味', category: '家常菜' },
    { name: '红烧肉', description: '色泽红亮，肥而不腻，入口即化', category: '家常菜' },
    { name: '清炒时蔬', description: '清淡爽口，保留蔬菜原味，健康营养', category: '家常菜' },
    { name: '醋溜白菜', description: '酸辣爽口，清脆可口，开胃下饭', category: '家常菜' },
    
    // 面食
    { name: '兰州拉面', description: '面条劲道，汤汁浓郁，牛肉鲜香', category: '面食' },
    { name: '炸酱面', description: '酱香浓郁，配菜丰富，北京特色', category: '面食' },
    { name: '刀削面', description: '面条筋道，形状独特，山西名吃', category: '面食' },
    { name: '热干面', description: '芝麻酱香浓，劲道爽滑，武汉早餐', category: '面食' },
    { name: '担担面', description: '麻辣鲜香，面条细滑，四川小吃', category: '面食' },
    
    // 快餐
    { name: '汉堡', description: '西式快餐，肉饼多汁，搭配蔬菜', category: '快餐' },
    { name: '披萨', description: '芝士拉丝，配料丰富，意式美食', category: '快餐' },
    { name: '炸鸡', description: '外酥里嫩，香气诱人，快餐经典', category: '快餐' },
    { name: '三明治', description: '营养均衡，便捷美味，早餐首选', category: '快餐' },
    { name: '煎饼果子', description: '香脆可口，料多味美，天津名小吃', category: '快餐' },
    
    // 其他美食
    { name: '火锅', description: '热气腾腾，想吃什么涮什么', category: '其他' },
    { name: '烤肉', description: '肉香四溢，外焦里嫩，聚餐佳选', category: '其他' },
    { name: '寿司', description: '新鲜美味，造型精致，日式料理', category: '其他' },
    { name: '小龙虾', description: '麻辣鲜香，肉质Q弹，夏日宵夜', category: '其他' },
    { name: '烤鱼', description: '鱼肉鲜嫩，香辣可口，配菜丰富', category: '其他' }
  ];
  
  const insert = db.prepare('INSERT INTO dishes (name, description, category) VALUES (?, ?, ?)');
  
  const insertMany = db.transaction((dishes) => {
    for (const dish of dishes) {
      insert.run(dish.name, dish.description, dish.category);
    }
  });
  
  insertMany(initialDishes);
  console.log(`Seeded ${initialDishes.length} dishes successfully`);
}

export default db;
