//
//  APIService.swift
//  WhatEatingApp
//
//  Created by Qoder on 2025/10/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(String)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的 URL"
        case .networkError:
            return "网络连接失败，请检查后端服务是否运行"
        case .decodingError(let error):
            return "数据解析失败: \(error.localizedDescription)"
        case .serverError(let message):
            return message
        case .noData:
            return "未接收到数据"
        }
    }
}

class APIService {
    static let shared = APIService()
    
    // 使用 localhost 用于模拟器测试，真机测试时改为局域网 IP: http://192.168.50.166:3000/api
    private let baseURL = "http://localhost:3000/api"
    
    private init() {}
    
    // 获取随机菜品
    func getRandomDish() async throws -> Dish {
        guard let url = URL(string: "\(baseURL)/random-dish") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.networkError(NSError(domain: "", code: -1))
            }
            
            guard httpResponse.statusCode == 200 else {
                throw APIError.serverError("服务器错误: \(httpResponse.statusCode)")
            }
            
            let dishResponse = try JSONDecoder().decode(DishResponse.self, from: data)
            
            if !dishResponse.success {
                throw APIError.serverError(dishResponse.message ?? "获取菜品失败")
            }
            
            return dishResponse.data
        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // 获取所有菜品
    func getAllDishes(page: Int = 1, limit: Int = 10) async throws -> DishesListResponse {
        guard let url = URL(string: "\(baseURL)/dishes?page=\(page)&limit=\(limit)") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(DishesListResponse.self, from: data)
            return response
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // 搜索菜品
    func searchDishes(keyword: String) async throws -> [Dish] {
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search?keyword=\(encodedKeyword)") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(DishesListResponse.self, from: data)
            return response.data
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // 添加菜品
    func addDish(name: String, description: String, category: String) async throws -> Dish {
        guard let url = URL(string: "\(baseURL)/dishes") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "name": name,
            "description": description,
            "category": category
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(DishResponse.self, from: data)
            
            if !response.success {
                throw APIError.serverError(response.message ?? "添加菜品失败")
            }
            
            return response.data
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
}
