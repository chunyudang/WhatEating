//
//  ResultDisplayView.swift
//  WhatEatingApp
//
//  Created by Qoder on 2025/10/26.
//

import SwiftUI

struct ResultDisplayView: View {
    let dish: Dish?
    let error: String?
    let isVisible: Bool
    
    var body: some View {
        if isVisible {
            VStack(spacing: 0) {
                if let error = error {
                    // 错误显示
                    ErrorCardView(message: error)
                        .transition(.scale.combined(with: .opacity))
                } else if let dish = dish {
                    // 菜品显示
                    DishCardView(dish: dish)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: dish?.id)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: error)
        }
    }
}

struct DishCardView: View {
    let dish: Dish
    
    var body: some View {
        VStack(spacing: 16) {
            // 菜品图标
            Text("🍽️")
                .font(.system(size: 60))
                .padding(.top, 20)
            
            // 菜品名称
            Text(dish.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            // 菜品描述
            if let description = dish.description, !description.isEmpty {
                Text(description)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            // 菜品分类
            if let category = dish.category, !category.isEmpty {
                Text(category)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange, Color.pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

struct ErrorCardView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text("❌")
                .font(.system(size: 24))
            
            Text(message)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.red)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

#Preview {
    VStack {
        ResultDisplayView(
            dish: Dish(id: 1, name: "宫保鸡丁", description: "经典川菜，鸡肉鲜嫩，花生酥脆", category: "川菜"),
            error: nil,
            isVisible: true
        )
        
        ResultDisplayView(
            dish: nil,
            error: "网络连接失败，请检查后端服务是否运行",
            isVisible: true
        )
    }
}
