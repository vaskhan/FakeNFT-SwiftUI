//
//  NftModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 24.09.2025.
//

struct NftModel: Decodable, Hashable {
    var name: String
    var images: [String]
    var rating: Int
    var price: Double
    let id: String
}
