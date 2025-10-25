import express from 'express';
import * as dishController from '../controllers/dishController.js';

const router = express.Router();

// 获取随机菜单
router.get('/random-dish', dishController.getRandomDish);

// 获取所有菜单
router.get('/dishes', dishController.getAllDishes);

// 搜索菜单
router.get('/search', dishController.searchDishes);

// 添加新菜单
router.post('/dishes', dishController.addDish);

export default router;
