//
//  OrderDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 23.09.2025.
//

import Foundation

struct OrderDTO: Decodable, Sendable {
    let nfts: [String]?
    let id: String
}
