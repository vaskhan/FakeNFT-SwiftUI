//
//  NftCollectionDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 13.09.2025.
//

import Foundation

struct NftCollectionDTO: Decodable, Sendable {
    let id: String
    let name: String
    let cover: String
    let nfts: [String]
}
