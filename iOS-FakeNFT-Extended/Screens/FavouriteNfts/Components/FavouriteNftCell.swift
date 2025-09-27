//
//  FavouriteNftCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 23.09.2025.
//

import SwiftUI

struct FavouriteNftCell: View {
    @State private var isLiked = true
    private let imageName = "nft_image" // Замените на ваше изображение
    private let name = "Pixi"
    private let rating = 2 // Пример рейтинга от 0 до 5
    private let price = "1.78 ETH"
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Левая часть с изображением
            ZStack(alignment: .topTrailing) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)

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

                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: index < rating ? "star.fill" : "star.fill")
                            .foregroundColor(index < rating ? .yellowUniversal : .lightgrey)
                            .font(.system(size: 12))
                    }
                }

                Text(price)
                    .font(.appRegular15)
                    .foregroundColor(.primary)
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding(.vertical, 8)
    }
}
#Preview {
    FavouriteNftCell()
}
