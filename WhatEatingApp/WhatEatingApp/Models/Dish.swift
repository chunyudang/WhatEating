//
//  Dish.swift
//  WhatEatingApp
//
//  Created by Qoder on 2025/10/26.
//

import Foundation

struct Dish: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let category: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case category
    }
}

struct DishResponse: Codable {
    let success: Bool
    let message: String?
    let data: Dish
}

struct DishesListResponse: Codable {
    let success: Bool
    let message: String?
    let data: [Dish]
    let pagination: Pagination?
}

struct Pagination: Codable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int
}
