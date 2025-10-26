//
//  ProfileView.swift
//  WhatEatingApp
//
//  Created by dangchy on 2025/10/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // 用户头像区域
                    VStack(spacing: 15) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.orange, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                            )
                        
                        Text("美食爱好者")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 30)
                    
                    // 功能列表
                    VStack(spacing: 0) {
                        ProfileMenuItem(icon: "heart.fill", title: "我的收藏", color: .pink)
                        Divider().padding(.leading, 60)
                        
                        ProfileMenuItem(icon: "clock.fill", title: "历史记录", color: .blue)
                        Divider().padding(.leading, 60)
                        
                        ProfileMenuItem(icon: "star.fill", title: "我的评分", color: .yellow)
                        Divider().padding(.leading, 60)
                        
                        ProfileMenuItem(icon: "gearshape.fill", title: "设置", color: .gray)
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .padding(.bottom, 100) // 为底部TabBar留出空间
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.97, blue: 1.0),
                        Color(red: 1.0, green: 0.95, blue: 0.97)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("我的")
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(color)
            
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .contentShape(Rectangle())
    }
}

#Preview {
    ProfileView()
}
