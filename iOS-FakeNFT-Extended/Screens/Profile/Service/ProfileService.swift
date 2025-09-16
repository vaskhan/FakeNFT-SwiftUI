//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//

import Foundation

protocol ProfileServiceProtocol: Sendable {
    func loadProfile() async throws -> UserModel
}

actor ProfileService: ProfileServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile() async throws -> UserModel {
        print("ProfileService: loadProfile")
        let request = try APIRequestBuilder.makeRequest(
            from: APIEndpoint.Profile.get,
            query: nil,
            body: nil
        )
        
        let profileData = try await networkClient.send(urlRequest: request)
        
        if let responseString = String(data: profileData, encoding: .utf8) {
            print("Ответ сервера: \(responseString)")
        }
        let decoder = JSONDecoder()
        
        do {
            let user = try decoder.decode(UserModel.self, from: profileData)
            print("Профиль успешно декодирован: \(user)")
            return user
        } catch {
            print("Ошибка декодирования: \(error)")
            
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
}
