//
//  FavouriteNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 23.09.2025.
//
import SwiftUI

struct FavouriteNftCell: View {
    let nftId: String
    @State private var isLiked: Bool
    private let imageURL: URL?
    private let name: String
    private let rating: Int
    private let price: Double
    private let onLikeToggle: (String, Bool) async -> Void
    
    init(nftId: String, isLiked: Bool = true, imageURL: URL?, name: String, rating: Int, price: Double, onLikeToggle: @escaping (String, Bool) async -> Void) {
        self.nftId = nftId
        self.isLiked = isLiked
        self.imageURL = imageURL
        self.name = name
        self.rating = rating
        self.price = price
        self.onLikeToggle = onLikeToggle
    }
    
    private enum Constants {
        static let imageSize: CGFloat = 80
        static let cornerRadius: CGFloat = 12
        static let basePadding: CGFloat = 20
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Constants.basePadding) {
            // Левая часть с изображением
            RoundedRectangle(cornerRadius: Constants.imageSize)
                .fill(Color.gray.opacity(0.1))
                .overlay {
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: imageURL) { phase in
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
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                        
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
