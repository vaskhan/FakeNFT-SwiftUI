//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 15.09.2025.
//

import Foundation

@Observable
@MainActor
final class CartViewModel {
    var items: [CartItem] = []
    var isLoading: Bool = false
    
    private let cartService: CartServiceProtocol
    private let nftService: NftServiceProtocol
    
    init(cartService: CartServiceProtocol, nftService: NftServiceProtocol) {
        self.cartService = cartService
        self.nftService = nftService
    }
    
    func loadItems() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let order = try await cartService.loadCart()
            guard let nfts = order.nfts else { return }
            let loadedNfts = try await nftService.loadItems(ids: nfts)
            
            let cartItems: [CartItem] = loadedNfts.map { item in
                CartItem(
                    id: item.id,
                    title: item.title,
                    cover: item.imageURL,
                    rating: item.rating,
                    price: item.price ?? 0
                )
            }
            items = cartItems
            print("Items loaded/n \(items)")
        } catch {
            print("Error: \(error)")
        }

        isLoading = false
    }
    
    func removeItem(_ item: CartItem) async {
        do {
            items.removeAll { $0.id == item.id }
            try await cartService.updateCart(items.compactMap(\.id))
        } catch {
            print("Error: \(error)")
        }
    }
}
