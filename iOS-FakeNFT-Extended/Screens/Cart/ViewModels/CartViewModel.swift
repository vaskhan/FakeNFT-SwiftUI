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
    let mockedItems: [CartItem] = [
        CartItem (
            id: "1",
            title: "April",
            cover: URL(string: " "),
            rating: 3,
            price: 1.453
        ),
        CartItem (
            id: "3",
            title: "Greena",
            cover: URL(string: " "),
            rating: 5,
            price: 21.453
        ),
        CartItem (
            id: "2",
            title: "Greena",
            cover: URL(string: " "),
            rating: 5,
            price: 21.453
        ),
        CartItem (
            id: "4",
            title: "Greena",
            cover: URL(string: " "),
            rating: 5,
            price: 21.453
        ),
        CartItem (
            id: "6",
            title: "Greena",
            cover: URL(string: " "),
            rating: 5,
            price: 21.453
        ),
        CartItem (
            id: "7",
            title: "Greena",
            cover: URL(string: " "),
            rating: 5,
            price: 21.453
        )
    ]
    
    var items: [CartItem] = []
}
