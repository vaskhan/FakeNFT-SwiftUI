//
//  PaymentMethodCollectionRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 17.09.2025.
//

import SwiftUI

struct PaymentMethodCollectionRow: View {
    let paymentMethod: PaymentMethod
    let isSelected: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.blackUniversal)
                .frame(width: 36, height: 36)
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
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blackAndWhite : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    PaymentMethodCollectionRow(paymentMethod: .init(id: "1", name: "Bitcoin", shortName: "BTC", icon: URL(string: " ")), isSelected: true)
}
