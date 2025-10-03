//
//  FavouriteNftsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 16.09.2025.
//
import SwiftUI

struct FavouriteNftsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var services: ServicesAssembly?
    @State private var viewModels: [String: FavouriteNftsViewModel] = [:]
    @State private var currentLikesIds: [String]
    @State private var allDisplayedNFTs: [String]
    
    let likesIds: [String]
    
    init(likesIds: [String]) {
        self.likesIds = likesIds
        self._currentLikesIds = State(initialValue: likesIds)
        self._allDisplayedNFTs = State(initialValue: likesIds)
    }
    
    private enum FavouriteNFTViewConstants {
        static let favoritesTitle = String(localized: "ProfileFlow.FavouriteNft.title")
        static let emptyMessage = String(localized: "ProfileFlow.FavouriteNft.empty")
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
                    FavouriteNftCell(
                        nftId: nftId,
                        isLiked: currentLikesIds.contains(nftId),
                        imageName: viewModels[nftId]?.images ?? "",
                        name: viewModels[nftId]?.name ?? "",
                        rating: viewModels[nftId]?.rating ?? 0,
                        price: viewModels[nftId]?.price ?? 0,
                        onLikeToggle: { nftId, newLikeState in
                            await toggleLike(for: nftId, newState: newLikeState)
                        }
                    )
                    .task {
                        await loadNftData(for: nftId)
                    }
                }
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        }
    }
    
    // MARK: - Private Methods
    
    private func toggleLike(for nftId: String, newState: Bool) async {
        if newState {
            if !currentLikesIds.contains(nftId) {
                currentLikesIds.append(nftId)
            }
        } else {
            currentLikesIds.removeAll { $0 == nftId }
        }
        
        if !allDisplayedNFTs.contains(nftId) {
            allDisplayedNFTs.append(nftId)
        }
        
        await updateFavoriteListOnServer()
    }
    
    private func updateFavoriteListOnServer() async {
        guard let services = services else { return }
        
        let viewModel = FavouriteNftsViewModel(favouriteNftService: services.favouriteNftService)
        await viewModel.updateNftFavoriteList(ids: currentLikesIds)
        
        if let error = viewModel.errorMessage {
            print("Ошибка при обновлении лайков: \(error)")
        }
    }
    
    private func loadNftData(for nftId: String) async {
        guard viewModels[nftId] == nil, let services = services else { return }
        
        let viewModel = FavouriteNftsViewModel(favouriteNftService: services.favouriteNftService)
        viewModels[nftId] = viewModel
        await viewModel.getNftInfo(id: nftId)
    }
}
