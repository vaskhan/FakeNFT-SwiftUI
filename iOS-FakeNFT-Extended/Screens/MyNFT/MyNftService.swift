//
//  MyNftService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 02.10.2025.
//

import Foundation

protocol MyNftServiceProtocol: Sendable {
    func loadNft(nft: String) async throws -> NftModel
}

actor MyNftService: MyNftServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    //Загрузка NFT по id
    func loadNft(nft: String) async throws -> NftModel {
        let request = try APIRequestBuilder.makeRequest(
            from: APIEndpoint.NFT.details(id: nft),
            query: nil,
            body: nil
        )
        
        let (NftData, _)  = try await networkClient.send(urlRequest: request)
        
        let decoder = JSONDecoder()
        
        do {
            let NftCart = try decoder.decode(NftModel.self, from: NftData)
            return NftCart
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
}
