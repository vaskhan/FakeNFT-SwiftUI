//
//  NftCard.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 18.09.2025.
//

import SwiftUI

struct NftCard: View {
    let item: NftItem
    let isFavorite: Bool
    let isInCart: Bool
    let onToggleFavorite: () -> Void
    let onToggleCart: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                if let url = item.imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty: Color.gray.opacity(0.1)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                            
                        case .failure: Color.gray.opacity(0.1)
                        @unknown default: Color.gray.opacity(0.1)
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                Button(action: onToggleFavorite) {
                    Image(isFavorite ? "FilHeart" : "EmptyHeart")
                }
            }
            
            StarsView(rating: item.rating)
                .padding(.top, 8
                )
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.appBold17)
                        .foregroundStyle(.blackAndWhite)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                    
                    Text(item.price.map { "\($0.cleanETH) ETH" } ?? "—")
                        .font(.appMedium10)
                        .foregroundStyle(.blackAndWhite)
                }
                Spacer()
                Button(action: onToggleCart) {
                    Image(isInCart ? "FullBasket" : "EmptyBasket")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct StarsView: View {
    let rating: Int
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                Image(index < rating ? "YellowStar" : "WhiteStar")
            }
        }
    }
}

private extension Double {
    var cleanETH: String {
        let intPart = Int(self)
        return self == Double(intPart) ? "\(intPart)" : String(format: "%.2f", self)
    }
}

#Preview {
    NftCard(
        item: NftItem(
            id: "nft-1",
            title: "CryptoCat #1",
            imageURL: URL(string: "https://picsum.photos/200/200"),
            rating: 4,
            description: "Уникальный цифровой кот в шляпе",
            price: 2.5,
            author: "Alice"
        ),
        isFavorite: true,
        isInCart: false,
        onToggleFavorite: { print("Toggle favorite") },
        onToggleCart: { print("Toggle cart") }
    )
    .padding()
}
