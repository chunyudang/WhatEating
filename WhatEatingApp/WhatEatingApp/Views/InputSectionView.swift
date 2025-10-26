//
//  InputSectionView.swift
//  WhatEatingApp
//
//  Created by Qoder on 2025/10/26.
//

import SwiftUI

struct InputSectionView: View {
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("你想吃点什么？")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.leading, 4)
            
            TextField("输入关键词搜索...", text: $text)
                .font(.system(size: 16))
                .padding(16)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    InputSectionView(text: .constant(""))
}
