//
//  APIRequestBuilder.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 12.09.2025.
//


import Foundation

// Поддерживаемые HTTP-методы
enum HTTPMethod: String {
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case patch  = "PATCH"
    case delete = "DELETE"
}

// Билдер для создания URLRequest из эндпоинтов
struct APIRequestBuilder {
    static func makeRequest(
        from endpoint: (url: String, method: HTTPMethod),
        query: [URLQueryItem]?,
        body: Encodable?,
        headers: [String:String] = [:]
    ) throws -> URLRequest {
        // Разбираем URL
        guard var components = URLComponents(string: endpoint.url) else {
            throw URLError(.badURL)
        }
        
        // Добавляем query, если есть
        if let query = query, !query.isEmpty {
            components.queryItems = query
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        // Собираем request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Заголовки
        headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        // Тело
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}

// Билдер для PUT запросов с form-urlencoded данными
struct APIPutRequestBuilder {
    static func makeFormURLEncodedRequest(
        from endpoint: (url: String, method: HTTPMethod),
        parameters: [String: Any],
        headers: [String: String] = [:]
    ) throws -> URLRequest {
        // Разбираем URL
        guard let url = URL(string: endpoint.url) else {
            throw URLError(.badURL)
        }
        
        // Собираем request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Подготавливаем тело запроса в формате form-urlencoded
        var components = URLComponents()
        components.queryItems = parameters.map { key, value in
            if let array = value as? [String] {
                // Для массивов создаем несколько параметров с одинаковым именем
                return array.map { URLQueryItem(name: key, value: $0) }
            } else {
                return [URLQueryItem(name: key, value: "\(value)")]
            }
        }.flatMap { $0 }
        
        guard let queryString = components.percentEncodedQuery else {
            throw URLError(.badURL)
        }
        
        request.httpBody = queryString.data(using: .utf8)
        
        // Устанавливаем заголовки
        headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        // Обязательный заголовок для form-urlencoded
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
