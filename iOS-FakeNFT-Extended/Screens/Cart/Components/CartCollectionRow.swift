//
//  CartCollectionRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 14.09.2025.
//

import SwiftUI

struct CartCollectionRow: View {
    let item: CartItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .overlay {
                    if let url = item.cover {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image("NFTcard")
                                    .resizable()
                                    .scaledToFill()
                                    .font(.appBold32)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .frame(width: 108, height: 108)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.appBold17)
                    HStack(alignment: .center, spacing: 2) {
                        ForEach(0 ..< item.rating, id: \.self) { _ in
                            Image("YellowStar")
                                .frame(width: 12, height: 12)
                        }
                        ForEach(0 ..< 5 - item.rating, id: \.self) { _ in
                            Image("WhiteStar")
                                .frame(width: 12, height: 12)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 2){
                    Text(String(localized: "Cart.itemPrice"))
                        .font(.appRegular13)
                    Text("\(String(format: "%.2f", item.price)) ETH")
                        .font(.appBold17)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            
            Spacer()
            
            VStack {
                Button {
                    //TODO добавить функцию удаления из корзины
                } label: {
                    Image("FullBasket")
                        .frame(width: 40, height: 40)
                }
            }
            
        }
    }
}

#Preview {
    CartCollectionRow (
        item: CartItem (
            id: "1",
            title: "April",
            cover: URL(string: " "),
            rating: 4,
            price: 1.453
        )
    )
    .padding()
}
