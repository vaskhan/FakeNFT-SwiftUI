//
//  DeleteFromCartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 25.09.2025.
//

import SwiftUI

private enum Constants {
    static let imageSize: CGFloat = 108
    static let cornerRadius: CGFloat = 12
}

struct DeleteFromCartView: View {
    @Environment(\.dismiss) var dismiss
    let item: CartItem
    let onToggleDelete: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            VStack {
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
                
                Text("CartFlow.DeleteFromCart.question")
                    .frame(width: 180, height: 36)
                    .font(.appRegular13)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                HStack(alignment: .center, spacing: 8) {
                    Button(String(localized: "CartFlow.DeleteFromCart.delete")) {
                        onToggleDelete()
                        dismiss()
                    }
                    .buttonStyle(BlackButtonRegularRed())
                    Button(String(localized: "CartFlow.DeleteFromCart.return")) {
                        dismiss()
                    }
                    .buttonStyle(BlackButtonRegular())
                }
                .frame(width: 262)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .presentationBackground(.clear)
    }
}

#Preview {
    DeleteFromCartView (
        item: CartItem (
            id: "1",
            title: "April",
            cover: URL(string: " "),
            rating: 4,
            price: 1.000
        ), onToggleDelete: {}
    )
}
