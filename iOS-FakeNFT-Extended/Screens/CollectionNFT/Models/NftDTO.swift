//
//  NftDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 17.09.2025.
//

import Foundation

struct NftDTO: Decodable, Sendable {
    let id: String
    let name: String?
    let images: [String]?
    let rating: Int?
    let description: String?
    let price: Double?
    let author: String?
}
