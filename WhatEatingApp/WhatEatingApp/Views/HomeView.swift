//
//  HomeView.swift
//  WhatEatingApp
//
//  Created by dangchy on 2025/10/26.
//

import SwiftUI

struct HomeView: View {
    @State private var inputText: String = ""
    @State private var currentDish: Dish? = nil
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showResult: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HeaderView()
                        .padding(.bottom, 20)
                    
                    // Input Section (暂时保留，但不使用)
                    InputSectionView(text: $inputText)
                        .padding(.bottom, 10)
                    
                    // Action Button
                    ActionButtonView(action: handleGetDish, isLoading: isLoading)
                        .padding(.bottom, 10)
                    
                    // Result Display
                    ResultDisplayView(
                        dish: currentDish,
                        error: errorMessage,
                        isVisible: showResult
                    )
                    
                    Spacer(minLength: 20)
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
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    private func handleGetDish() {
        isLoading = true
        errorMessage = nil
        showResult = false
        currentDish = nil
        
        Task {
            do {
                let dish = try await APIService.shared.getRandomDish()
                await MainActor.run {
                    currentDish = dish
                    showResult = true
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showResult = true
                    isLoading = false
                }
            }
        }
    }
    
    func updateDishResult(dish: Dish?, error: String?) {
        currentDish = dish
        errorMessage = error
        showResult = true
    }
}

#Preview {
    HomeView()
}
