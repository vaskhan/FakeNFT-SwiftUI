//
//  FavouriteNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 23.09.2025.
//

import SwiftUI

struct FavouriteNftCell: View {
    @State private var isLiked = true
    private let imageName: String
    private let name: String
    private let rating: Int
    private let price: Double
    
    init(isLiked: Bool = true, imageName: String, name: String, rating: Int, price: Double) {
        self.isLiked = isLiked
        self.imageName = imageName
        self.name = name
        self.rating = rating
        self.price = price
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Левая часть с изображением
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

                // Иконка сердечка
                Button(action: { isLiked.toggle() }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .padding(4)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                }
                .offset(x: 6, y: -6) // Смещение для выхода за границы изображения
            }
            .frame(width: 80, height: 80)

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
