//
//  PaymentMethodCollectionRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 17.09.2025.
//

import SwiftUI

private enum Constants {
    static let imageSize: CGFloat = 36
    static let cornerRadius: CGFloat = 12
}

struct PaymentMethodCollectionRow: View {
    let paymentMethod: PaymentMethod
    let isSelected: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(.blackUniversal)
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .overlay {
                    if let url = paymentMethod.icon {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image("bitcoin")
                                    .font(.appBold32)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 0))
            
            VStack(alignment: .leading) {
                Text(paymentMethod.name)
                    .font(.appRegular13)
                Text(paymentMethod.shortName)
                    .font(.appRegular13)
                    .foregroundColor(.greenUniversal)
            }
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 12))
            
            Spacer()
        }
        .frame(height: 46)
        .background(.lightgrey)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(isSelected ? Color.blackAndWhite : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    PaymentMethodCollectionRow(paymentMethod: .init(id: "1", name: "Bitcoin", shortName: "BTC", icon: URL(string: " ")), isSelected: true)
}
