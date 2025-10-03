//
//  CartCollectionRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 14.09.2025.
//

import SwiftUI

private enum Constants {
    static let imageSize: CGFloat = 108
    static let cornerRadius: CGFloat = 12
}

struct CartCollectionRow: View {
    let item: CartItem
    let onToggleDelete: () -> Void
    @State var deleteDialogIsOpen = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
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
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.appBold17)
                    HStack(alignment: .center, spacing: 2) {
                        ForEach(0..<5, id: \.self) { index in
                            Image(index < item.rating ? "YellowStar" : "WhiteStar")
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 2){
                    Text(String(localized: "CartFlow.Cart.itemPrice"))
                        .font(.appRegular13)
                    Text("\(String(format: "%.2f", item.price)) ETH")
                        .font(.appBold17)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            
            Spacer()
            
            VStack {
                Button {
                    deleteDialogIsOpen = true
                } label: {
                    Image("FullBasket")
                        .frame(width: 40, height: 40)
                }
                .fullScreenCover(isPresented: $deleteDialogIsOpen) {
                    DeleteFromCartView(item: item, onToggleDelete: onToggleDelete)
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
            price: 1.000
        ), onToggleDelete: {}
    )
    .padding()
}
