//
//  CartItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 14.09.2025.
//

import Foundation

struct CartItem: Identifiable, Sendable, Equatable {
    let id: String
    let title: String
    let cover: URL?
    let rating: Int
    let price: Double
}
