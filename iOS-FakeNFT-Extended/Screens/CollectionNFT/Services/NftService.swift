//
//  NftService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 17.09.2025.
//

import Foundation

protocol NftServiceProtocol: Sendable {
    func loadItems(ids: [String]) async throws -> [NftItem]
}

actor NftService: NftServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadItems(ids: [String]) async throws -> [NftItem] {
        guard !ids.isEmpty else { return [] }

        return try await withThrowingTaskGroup(of: (String, NftItem).self) { taskGroup in
            for nftIdentifier in ids {
                taskGroup.addTask { [networkClient] in
                    // 1) Запрос
                    let request = try APIRequestBuilder.makeRequest(
                        from: APIEndpoint.NFT.details(id: nftIdentifier),
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

                    return (nftIdentifier, nftItem)
                }
            }

            var itemsByIdentifier: [String: NftItem] = [:]
            for try await (nftIdentifier, nftItem) in taskGroup {
                itemsByIdentifier[nftIdentifier] = nftItem
            }

            return ids.compactMap { itemsByIdentifier[$0] }
        }
    }
}
