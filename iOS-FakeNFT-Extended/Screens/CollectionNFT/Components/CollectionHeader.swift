//
//  CollectionHeader.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 18.09.2025.
//

import SwiftUI

struct CollectionHeader: View {
    let collection: NftCollection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
                                Color.gray.opacity(0.1)
                            }
                        }
                    }
                }
                .frame(height: 310)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 16)
            
            // Название
            Text(collection.title)
                .font(.appBold22)
                .foregroundStyle(.blackAndWhite)
                .padding(.horizontal, 16)
            
            // Автор
            if let author = collection.author, !author.isEmpty {
                HStack(spacing: 4) {
                    Text("Автор коллекции:")
                        .font(.appRegular13)
                        .foregroundStyle(.blackAndWhite)
                    
                    NavigationLink {
                        WebViewScreen()
                    } label: {
                        Text(author)
                            .font(.appRegular15)
                            .foregroundStyle(.blueUniversal)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            
            // Описание
            if let description = collection.description, !description.isEmpty {
                Text(description)
                    .font(.appRegular13)
                    .foregroundStyle(.blackAndWhite)
                    .padding(.horizontal, 16)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    CollectionHeader(
        collection: NftCollection(
            id: "123",
            title: "CryptoCats",
            coverURL: URL(string: "https://picsum.photos/400/300"),
            itemsCount: 42,
            description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
            author: "John Doe",
            nftIDs: ["1", "2", "3"]
        )
    )
    .padding()
}
