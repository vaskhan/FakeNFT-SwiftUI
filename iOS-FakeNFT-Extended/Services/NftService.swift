//
//  NftService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 17.09.2025.
//

import Foundation

protocol NftServiceProtocol: Sendable {
    func loadItems(ids: [String]) async throws -> [NftItem]
    func updateFavoriteNftList(nftList: [String]) async throws
}

actor NftService: NftServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadItems(ids: [String]) async throws -> [NftItem] {
        guard !ids.isEmpty else { return [] }
        
        return try await withThrowingTaskGroup(of: (Int, NftItem).self) { taskGroup in
            for (index, nftID) in ids.enumerated() {
                taskGroup.addTask { [networkClient] in
                    // 1) Запрос
                    let request = try APIRequestBuilder.makeRequest(
                        from: APIEndpoint.NFT.details(id: nftID),
                        query: nil,
                        body: nil
                    )
                    // 2) Декодирование DTO
                    let nftDTO: NftDTO = try await networkClient.send(urlRequest: request)
                    
                    // 3) Маппим в доменные модели
                    let nftItem = NftItem(
                        id: nftDTO.id,
                        title: nftDTO.name ?? "NFT #\(nftDTO.id)",
                        imageURL: nftDTO.images?.compactMap { URL(string: $0) }.first,
                        rating: max(0, min(nftDTO.rating ?? 0, 5)),
                        description: nftDTO.description,
                        price: nftDTO.price,
                        author: nftDTO.author
                    )
                    
                    return (index, nftItem)
                }
            }
            var result = Array<NftItem?>(repeating: nil, count: ids.count)
            for try await (index, item) in taskGroup { result[index] = item }
            return result.compactMap { $0 }
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
