//
//  APIEndpoint.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 12.09.2025.
//


import Foundation

// Список всех эндпоинтов FakeNFT API
enum APIEndpoint {
    static let baseURL = "https://example.com/api/v1"

    enum Profile {
        // Обновить данные профиля пользователя
        static let update: (url: String, method: HTTPMethod) =
            ("\(baseURL)/profile/1", .put)
    }

    enum NFT {
        // Получить список всех NFT
        static let list: (url: String, method: HTTPMethod) =
            ("\(baseURL)/nft", .get)

        // Получить данные конкретного NFT по идентификатору
        static func details(id: Int) -> (url: String, method: HTTPMethod) {
            ("\(baseURL)/nft/\(id)", .get)
        }
    }

    enum Collections {
        // Получить список коллекций NFT
        static let list: (url: String, method: HTTPMethod) =
            ("\(baseURL)/collections", .get)
    }

    enum Orders {
        // Изменить заказ
        static let update: (url: String, method: HTTPMethod) =
            ("\(baseURL)/orders/1", .put)
    }

    enum Currencies {
        // Получить данные валюты по идентификатору
        static func details(id: Int) -> (url: String, method: HTTPMethod) {
            ("\(baseURL)/currencies/\(id)", .get)
        }
    }
}
