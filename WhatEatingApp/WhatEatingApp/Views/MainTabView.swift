//
//  MainTabView.swift
//  WhatEatingApp
//
//  Created by dangchy on 2025/10/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var isLoading: Bool = false
    @State private var homeViewRef: HomeView = HomeView()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 主内容区域
            Group {
                switch selectedTab {
                case 0:
                    homeViewRef
                case 2:
                    ProfileView()
                default:
                    Color.clear
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 自定义TabBar
            CustomTabBar(selectedTab: $selectedTab) {
                handleCenterButtonTap()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .overlay(
            // 加载动画覆盖层
            Group {
                if isLoading {
                    LoadingOverlay()
                }
            }
        )
    }
    
    private func handleCenterButtonTap() {
        // 切换到首页
        selectedTab = 0
        
        // 触发获取随机菜品
        isLoading = true
        
        Task {
            do {
                let dish = try await APIService.shared.getRandomDish()
                await MainActor.run {
                    homeViewRef.updateDishResult(dish: dish, error: nil)
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    homeViewRef.updateDishResult(dish: nil, error: error.localizedDescription)
                    isLoading = false
                }
            }
        }
    }
}

struct LoadingOverlay: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [.orange, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: rotation))
                    .onAppear {
                        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
                
                Text("正在为您寻找美食...")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.7))
            )
        }
    }
}

#Preview {
    MainTabView()
}
