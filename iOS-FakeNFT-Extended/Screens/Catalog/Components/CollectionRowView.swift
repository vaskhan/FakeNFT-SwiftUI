//
//  CollectionRowView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 13.09.2025.
//


import SwiftUI

struct CollectionRowView: View {
    let collection: NftCollection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Обложка
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .overlay {
                    if let url = collection.coverURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                AssetSpinner()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    
                            case .failure:
                                Image(systemName: "photo")
                                    .font(.appBold32)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Заголовок + количество
            HStack(spacing: 4) {
                Text(collection.title)
                    .font(.appBold17)
                    .foregroundStyle(.blackAndWhite)
                Text("(\(collection.itemsCount))")
                    .font(.appBold17)
                    .foregroundStyle(.blackAndWhite)
            }
        }
        .contentShape(Rectangle())
    }
}

//#Preview {
//    CollectionRowView(
//        collection: NftCollection(
//            id: "1",
//            title: "CryptoCats",
//            coverURL: URL(string: "https://picsum.photos/seed/fakenft/400/300"),
//            itemsCount: 42
//        )
//    )
//    .padding()
//}
