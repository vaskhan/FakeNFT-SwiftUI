//
//  APIEndpoint.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 12.09.2025.
//


import Foundation

// Список всех эндпоинтов FakeNFT API
enum APIEndpoint {
    static let baseURL = "\(RequestConstants.baseURL)/api/v1"
    
    enum Profile {
        //Получение профиля пользователя
        static let get: (url: String, method: HTTPMethod) =
        ("\(baseURL)/profile/1", .get)
        
        // Обновить данные профиля пользователя
        static let update: (url: String, method: HTTPMethod) =
        ("\(baseURL)/profile/1", .put)
    }
    
    enum NFT {
        // Получить список всех NFT
        static let list: (url: String, method: HTTPMethod) =
        ("\(baseURL)/nft", .get)
        
        // Получить данные конкретного NFT по идентификатору
        static func details(id: String) -> (url: String, method: HTTPMethod) {
            ("\(baseURL)/nft/\(id)", .get)
        }
    }
    
    enum Collections {
        // Получить список коллекций NFT
        static let list: (url: String, method: HTTPMethod) =
        ("\(baseURL)/collections", .get)
    }
    
    enum CollectionDetails {
        // Детали конкретной коллекции
        static func details(id: String) -> (url: String, method: HTTPMethod) {
            ("\(baseURL)/collections/\(id)", .get)
        }
    }
    
    enum Orders {
        // Изменить заказ
        static let update: (url: String, method: HTTPMethod) =
        ("\(baseURL)/orders/1", .put)
        
        // Получить список nft в корзине
        static let list: (url: String, method: HTTPMethod) =
        ("\(baseURL)/orders/1", .get)
    }
    
    enum Currencies {
        // Получить данные валюты по идентификатору
        static func details(id: Int) -> (url: String, method: HTTPMethod) {
            ("\(baseURL)/currencies/\(id)", .get)
        }
    }
}
