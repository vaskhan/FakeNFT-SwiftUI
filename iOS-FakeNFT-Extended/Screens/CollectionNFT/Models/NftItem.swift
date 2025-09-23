//
//  NftItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 17.09.2025.
//

import SwiftUI

struct NftItem: Identifiable, Sendable, Equatable, Hashable {
    let id: String
    let title: String
    let imageURL: URL?
    let rating: Int
    let description: String?
    let price: Double?
    let author: String?
}
