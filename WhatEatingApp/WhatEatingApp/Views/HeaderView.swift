//
//  HeaderView.swift
//  WhatEatingApp
//
//  Created by Qoder on 2025/10/26.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("🍜 今天吃什么？")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
            
            Text("让我来帮你决定吧！")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}

#Preview {
    HeaderView()
}
