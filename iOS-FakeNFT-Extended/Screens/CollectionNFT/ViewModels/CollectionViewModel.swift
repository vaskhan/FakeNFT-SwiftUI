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
    private let cartService: CartServiceProtocol
    private let profileService: ProfileServiceProtocol
    
    init(collection: NftCollection, nftService: NftServiceProtocol, cartService: CartServiceProtocol, profileService: ProfileServiceProtocol) {
        self.collection = collection
        self.nftService = nftService
        self.cartService = cartService
        self.profileService = profileService
    }
    
    func load() async {
        state = .loading
        do {
            async let itemsTask: [NftItem] = nftService.loadItems(ids: collection.nftIDs)
            async let orderTask: OrderDTO = cartService.loadCart()
            async let userTask: UserModel = profileService.loadProfile()
            
            let (items, order, user) = try await (itemsTask, orderTask, userTask)
            self.nftItems = items
            self.cartIds = Set(order.nfts ?? [])
            self.favoriteIds = Set(user.likes)
            
            state = .loaded
        } catch {
            state = .error("Не удалось загрузить данные")
            print("Ошибка при загрузке: \(error)")
        }
    }
    
    func toggleFavorite(for nftId: String) {
        if favoriteIds.contains(nftId) {
            favoriteIds.remove(nftId)
        } else {
            favoriteIds.insert(nftId)
        }
        
        Task {
            try? await profileService.updateLikes(Array(favoriteIds))
        }
    }
    
    func toggleCart(for nftId: String) {
        if cartIds.contains(nftId) {
            cartIds.remove(nftId)
        } else {
            cartIds.insert(nftId)
        }
        
        Task {
            do {
                try await cartService.updateCart(Array(cartIds))
            } catch {
                print("updateCart error: \(error)")
            }
        }
    }
}
