//
//  NftCollectionService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 13.09.2025.
//


import Foundation

protocol NftCollectionServiceProtocol: Sendable {
    func loadCollections() async throws -> [NftCollection]
}

actor NftCollectionService: NftCollectionServiceProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCollections() async throws -> [NftCollection] {
        // 1) Собираем URLRequest
        let request = try APIRequestBuilder.makeRequest(
            from: APIEndpoint.Collections.list,
            query: nil,
            body: nil
        )

        // 2) Декодим DTO с эндпоинта `/collections`
        let dtoList: [NftCollectionDTO] = try await networkClient.send(urlRequest: request)

        // 3) Маппим в доменные модели
        return dtoList.map { dto in
            NftCollection(
                id: dto.id,
                title: dto.name,
                coverURL: URL(string: dto.cover),
                itemsCount: dto.nfts.count,
                description: dto.description,
                author: dto.author
            )
        }
    }
}
