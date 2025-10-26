//
//  CustomTabBar.swift
//  WhatEatingApp
//
//  Created by dangchy on 2025/10/26.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    let onCenterButtonTap: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // 首页按钮
            TabBarButton(
                icon: "house.fill",
                title: "首页",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            Spacer()
            
            // 中间占位符（为大圆按钮留空间）
            Color.clear
                .frame(width: 80)
            
            Spacer()
            
            // 我的按钮
            TabBarButton(
                icon: "person.fill",
                title: "我的",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }
        }
        .frame(height: 60)
        .background(
            Color.white
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .overlay(
            // 中间大圆按钮
            CenterButton(action: onCenterButtonTap)
                .offset(y: -20)
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .orange : .gray)
                
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .orange : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct CenterButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
            action()
        }) {
            ZStack {
                // 外圈光晕效果
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange.opacity(0.3), .pink.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                    .blur(radius: 8)
                
                // 主按钮
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.orange.opacity(0.5), radius: 10, x: 0, y: 5)
                
                // 加号图标
                Image(systemName: "plus")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)
                
                // 底部标签
                VStack {
                    Spacer()
                    Text("告诉我")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .offset(y: 45)
                }
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0)) {
            print("Center button tapped")
        }
    }
}
