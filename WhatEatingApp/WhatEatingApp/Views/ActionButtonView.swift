//
//  ActionButtonView.swift
//  WhatEatingApp
//
//  Created by Qoder on 2025/10/26.
//

import SwiftUI

struct ActionButtonView: View {
    let action: () -> Void
    let isLoading: Bool
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "shuffle")
                        .font(.system(size: 20, weight: .semibold))
                }
                
                Text(isLoading ? "加载中..." : "随机推荐")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(28)
            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .disabled(isLoading)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview {
    VStack {
        ActionButtonView(action: {}, isLoading: false)
        ActionButtonView(action: {}, isLoading: true)
    }
}
