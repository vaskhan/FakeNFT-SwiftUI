//
//  FavouriteNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 23.09.2025.
//

import SwiftUI

struct FavouriteNftCell: View {
    let nftId: String
    @State private var isLiked = true
    private let imageName: String
    private let name: String
    private let rating: Int
    private let price: Double
    private let onLikeToggle: (String, Bool) async -> Void
    
    init(nftId: String, isLiked: Bool = true, imageName: String, name: String, rating: Int, price: Double, onLikeToggle: @escaping (String, Bool) async -> Void) {
        self.nftId = nftId
        self.isLiked = isLiked
        self.imageName = imageName
        self.name = name
        self.rating = rating
        self.price = price
        self.onLikeToggle = onLikeToggle
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Левая часть с изображением
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .overlay {
                    ZStack(alignment: .topTrailing) {
                        let url = URL(string: imageName)
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
                        .frame(width: 80, height: 80)
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        // Иконка сердечка
                        Button(action: {
                            Task {
                                let newLikeState = !isLiked
                                await onLikeToggle(nftId, newLikeState)
                                
                                await MainActor.run {
                                    isLiked = newLikeState
                                }
                            }
                        }) {
                            Image(isLiked ? "FilHeart" : "EmptyHeart")
                        }
                        .frame(width: 21, height: 18)
                        .padding(5)
                    }
                }
            
            // Правая часть с информацией
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.appBold17)
                    .foregroundColor(.primary)
                
                HStack(alignment: .center, spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(index < rating ? "YellowStar" : "WhiteStar")
                    }
                }
                
                Text("\(String(format: "%.2f", price)) ETH")
                    .font(.appRegular15)
                    .foregroundColor(.primary)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

//#Preview {
//    FavouriteNftCell(imageName: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Calder/1.png", name: "Fhntv", rating: 3, price: 19.84)
//}
