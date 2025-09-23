//
//  CollectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 18.09.2025.
//

import SwiftUI

@Observable
@MainActor
final class CollectionViewModel {
    
    // MARK: - Состояние
    enum State: Equatable {
        case loading
        case loaded
        case error(String)
    }
    var state: State = .loading
    
    let collection: NftCollection
        var nftItems: [NftItem] = []

        var favoriteIds: Set<String> = []
        var cartIds: Set<String> = []

        private let nftService: NftServiceProtocol

        init(collection: NftCollection, nftService: NftServiceProtocol) {
            self.collection = collection
            self.nftService = nftService
        }

        func load() async {
            state = .loading
            do {
                let items = try await nftService.loadItems(ids: collection.nftIDs)
                self.nftItems = items
                state = .loaded
            } catch {
                state = .error("Не удалось загрузить коллекцию")
            }
        }
    
    // MARK: - Локальные действия
    func toggleFavorite(for nftId: String) {
        if favoriteIds.contains(nftId) {
            favoriteIds.remove(nftId)
        } else {
            favoriteIds.insert(nftId)
        }
    }
    
    func toggleCart(for nftId: String) {
        if cartIds.contains(nftId) {
            cartIds.remove(nftId)
        } else {
            cartIds.insert(nftId)
        }
    }
}
