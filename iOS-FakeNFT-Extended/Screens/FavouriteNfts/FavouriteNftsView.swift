//
//  FavouriteNftsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 16.09.2025.
//
import SwiftUI

struct FavouriteNftsView: View {
    @Environment(\.dismiss) private var dismiss
    let likesIds: [String]
    
    private enum FavouriteNFTViewConstants {
        static let favoritesTitle = "Избранные NFT"
        static let emptyMessage = "У вас еще нет избранных NFT"
        static let backButtonImage = "NavigationChevronLeft"
    }
    
    var body: some View {
        Group {
            if likesIds.isEmpty {
                emptyView
            } else {
                gridView
            }
        }
        .commonToolbar(
            title: likesIds.isEmpty ? nil : FavouriteNFTViewConstants.favoritesTitle,
            onBack: { dismiss() }
        )
    }
    
    // MARK: - Вспомогательные View
    
    private var emptyView: some View {
        Text(FavouriteNFTViewConstants.emptyMessage)
            .font(.appBold17)
    }
    
    @ViewBuilder
    private var gridView: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
        
        ScrollView() {
            LazyVGrid(columns: columns, spacing: 7) {
                ForEach(likesIds, id: \.self) { nftId in
                    FavouriteNftCell()
                }
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        }
        
        Text("\(FavouriteNFTViewConstants.favoritesTitle) \(likesIds.count)")
    }
}

// MARK: - View Extension

private extension View {
    func commonToolbar(title: String?, onBack: @escaping () -> Void) -> some View {
        self
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onBack) {
                        Image("NavigationChevronLeft")
                    }
                }
                
                if let title = title {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .font(.appBold17)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FavouriteNftsView(likesIds: ["1ce4f491-877d-48d0-9428-0e0129a80ec9", "ba441c43-cf07-4f94-9ea8-082b3436c729", "5093c01d-e79e-4281-96f1-76db5880ba70"])
}
