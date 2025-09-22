//
//  PaymentMethod.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 17.09.2025.
//

import Foundation

struct PaymentMethod: Identifiable, Sendable, Equatable, Hashable {
    let id: String
    let name: String
    let shortName: String
    let icon: URL?
}
