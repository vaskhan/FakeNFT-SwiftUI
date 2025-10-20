//
//  NftGrid.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 18.09.2025.
//

import SwiftUI

struct NftGrid: View {
    let items: [NftItem]
    let favoriteIds: Set<String>
    let cartIds: Set<String>
    let onToggleFavorite: (String) -> Void
    let onToggleCart: (String) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 9),
        GridItem(.flexible(), spacing: 9),
        GridItem(.flexible(), spacing: 9)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                NftCard(
                    item: item,
                    isFavorite: favoriteIds.contains(item.id),
                    isInCart: cartIds.contains(item.id),
                    onToggleFavorite: { onToggleFavorite(item.id) },
                    onToggleCart: { onToggleCart(item.id) }
                )
            }
        }
        .padding(.horizontal, 16)
    }
}
