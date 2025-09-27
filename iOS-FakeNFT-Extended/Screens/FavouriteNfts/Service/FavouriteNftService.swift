//
//  FavouriteNftService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 24.09.2025.
//
import Foundation

protocol FavouriteNftServiceProtocol: Sendable {
    func loadNft(nft: String) async throws -> NftModel
    func updateFavoriteNftList(nftList: [String]) async throws
}

actor FavouriteNftService: FavouriteNftServiceProtocol {
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
    
    // Обновление списка NFT, передавать весь список NFT пользователя
    func updateFavoriteNftList(nftList: [String]) async throws {
        let parameters: [String: Any] = ["likes": nftList.isEmpty ? "null" : nftList]
        
        let request = try APIPutRequestBuilder.makeFormURLEncodedRequest(
            from: APIEndpoint.Profile.update,
            parameters: parameters
        )
        
        let (_, response) = try await networkClient.send(urlRequest: request)
        
        if response.statusCode != 200 {
            print("Ошибка обновления лайков: статус код \(response.statusCode)")
            
            throw URLError(.badServerResponse)
        }
    }
}
