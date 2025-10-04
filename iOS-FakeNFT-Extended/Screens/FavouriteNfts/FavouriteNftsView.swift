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
    
    @State private var viewModel: FavouriteNftsViewModel?
    @Binding var likesList: [String]
    
    private let profileDataService: ProfileDataService
    
    init(likesList: Binding<[String]>, profileDataService: ProfileDataService) {
        self._likesList = likesList
        self.profileDataService = profileDataService
    }
    
    private enum FavouriteNFTViewConstants {
        static let favoritesTitle = String(localized: "ProfileFlow.FavouriteNft.title")
        static let emptyMessage = String(localized: "ProfileFlow.FavouriteNft.empty")
    }
    
    var body: some View {
        Group {
            if let viewModel = viewModel {
                if viewModel.nftItems.isEmpty && !viewModel.isLoading {
                    emptyView
                } else {
                    gridView(viewModel: viewModel)
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .commonToolbar(
            title: viewModel?.nftItems.isEmpty == false ? FavouriteNFTViewConstants.favoritesTitle : nil,
            onBack: { dismiss() }
        )
        .task {
            await initializeViewModelAndLoadData()
        }
    }
    
    private var emptyView: some View {
        Text(FavouriteNFTViewConstants.emptyMessage)
            .font(.appBold17)
    }
    
    @ViewBuilder
    private func gridView(viewModel: FavouriteNftsViewModel) -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
        
        ScrollView() {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVGrid(columns: columns, spacing: 7) {
                    ForEach(viewModel.nftItems, id: \.id) { nftItem in
                        FavouriteNftCell(
                            nftId: nftItem.id,
                            isLiked: viewModel.favoriteIds.contains(nftItem.id),
                            imageURL: nftItem.imageURL,
                            name: nftItem.title,
                            rating: nftItem.rating,
                            price: nftItem.price ?? 0,
                            onLikeToggle: { nftId, newLikeState in
                                viewModel.toggleFavorite(for: nftId) { newLikes in
                                    // Обновляем binding при изменении лайков
                                    likesList = newLikes
                                }
                            }
                        )
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            }
        }
    }
    
    private func initializeViewModelAndLoadData() async {
        guard let services = services else { return }
        
        let newViewModel = FavouriteNftsViewModel(
            profileDataService: profileDataService,
            nftService: services.nftService
        )
        self.viewModel = newViewModel
        await newViewModel.loadNftItems(ids: likesList)
    }
}
