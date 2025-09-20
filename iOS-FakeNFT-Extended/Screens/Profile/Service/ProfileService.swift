//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//

import Foundation

protocol ProfileServiceProtocol: Sendable {
    func loadProfile() async throws -> UserModel
    func saveProfile(_ user: UserModel) async throws
}

actor ProfileService: ProfileServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile() async throws -> UserModel {
        let request = try APIRequestBuilder.makeRequest(
            from: APIEndpoint.Profile.get,
            query: nil,
            body: nil
        )
        
        let (profileData, _)  = try await networkClient.send(urlRequest: request)
    
        let decoder = JSONDecoder()
        
        do {
            let user = try decoder.decode(UserModel.self, from: profileData)
            return user
        } catch {
            
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Не найдено ключа: \(key), путь: \(context.codingPath)")
                case .typeMismatch(let type, let context):
                    print("Несоответствие типа: \(type), путь: \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("Значение не найдено: \(type), путь: \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("Данные повреждены: \(context)")
                @unknown default:
                    print("Неизвестная ошибка декодирования")
                }
            }
            throw error
        }
    }
    
    func saveProfile(_ user: UserModel) async throws {
        // Подготавливаем параметры для запроса
        var parameters: [String: Any] = [
            "name": user.name,
            "website": user.website,
            "description": user.description ?? "",
            "likes": user.likes
        ]
        
        if let avatarString = user.avatar?.absoluteString {
            parameters["avatar"] = avatarString
        } else {
            parameters["avatar"] = "" // или null в зависимости от требований API
        }
        
        // Создаем запрос с помощью специального билдера
        let request = try APIPutRequestBuilder.makeFormURLEncodedRequest(
            from: APIEndpoint.Profile.update,
            parameters: parameters
        )
        
        // Отправка запроса и получение ответа
        let (data, response) = try await networkClient.send(urlRequest: request)
        
        // Проверка статус кода
        if response.statusCode != 200 {
            print("Ошибка сохранения профиля: статус код \(response.statusCode)")
            
            // Можно также вывести тело ответа для отладки
            if let responseBody = String(data: data, encoding: .utf8) {
                print("Тело ответа: \(responseBody)")
            }
            
            throw URLError(.badServerResponse)
        }
        
        print("Профиль успешно сохранен")
    }
}
