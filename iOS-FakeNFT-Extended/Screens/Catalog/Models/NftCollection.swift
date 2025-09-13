//
//  NftCollection.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 13.09.2025.
//

import Foundation

struct NftCollection: Identifiable, Sendable, Equatable {
    let id: String
    let title: String
    let coverURL: URL?
    let itemsCount: Int
}
