//
//  FavouriteNftsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 16.09.2025.
//
import SwiftUI

private enum FavouriteNFTViewConstants {
    static let favoritesTitle = String(localized: "ProfileFlow.FavouriteNft.title")
    static let emptyMessage = String(localized: "ProfileFlow.FavouriteNft.empty")
}

struct FavouriteNftsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var profileDataService: ProfileDataService
    let nftService: NftServiceProtocol
    @State private var viewModel: FavouriteNftsViewModel?
    
    private enum Constants {
        static let basePadding: CGFloat = 16
        static let rowPadding: CGFloat = 20
    }
    
    var body: some View {
        ZStack {
            // Основной контент
            Group {
                if let viewModel = viewModel {
                    if viewModel.nftItems.isEmpty && !viewModel.isLoading {
                        emptyView
                    } else {
                        gridView(viewModel: viewModel)
                    }
                } else {
                    Color.clear
                }
            }
            
            // Спиннер поверх всего контента
            if shouldShowFullScreenSpinner {
                Color(.lightgrey)
                    .ignoresSafeArea()
                
                AssetSpinner()
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
    
    // Вычисляемое свойство для определения, когда показывать полноэкранный спиннер
    private var shouldShowFullScreenSpinner: Bool {
        // Показываем спиннер когда:
        // 1. ViewModel еще не создан ИЛИ
        // 2. ViewModel создан, но данные загружаются и список пуст
        if viewModel == nil {
            return true
        }
        
        if let viewModel = viewModel, viewModel.isLoading && viewModel.nftItems.isEmpty {
            return true
        }
        
        return false
    }
    
    private var emptyView: some View {
        Text(FavouriteNFTViewConstants.emptyMessage)
            .font(.appBold17)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func gridView(viewModel: FavouriteNftsViewModel) -> some View {
        ZStack {
            ScrollView() {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: Constants.rowPadding ) {
                    ForEach(viewModel.nftItems, id: \.id) { nftItem in
                        FavouriteNftCell(
                            nftId: nftItem.id,
                            isLiked: profileDataService.profile?.likes.contains(nftItem.id) == true,
                            imageURL: nftItem.imageURL,
                            name: viewModel.name(for: nftItem) ?? "",
                            rating: nftItem.rating,
                            price: nftItem.price ?? 0,
                            onLikeToggle: { nftId, newLikeState in
                                await viewModel.toggleFavorite(
                                    for: nftId,
                                    newLikeState: newLikeState,
                                    profileDataService: profileDataService
                                )
                            }
                        )
                    }
                }
                .padding(EdgeInsets(top: Constants.basePadding, leading: Constants.basePadding, bottom: 0, trailing: Constants.basePadding))
            }
            
            // Спиннер для случаев, когда данные обновляются, но уже есть контент
            if viewModel.isLoading && !viewModel.nftItems.isEmpty {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                
                AssetSpinner()
            }
        }
    }
    
    private func initializeViewModelAndLoadData() async {
        let newViewModel = FavouriteNftsViewModel(nftService: nftService)
        self.viewModel = newViewModel
        
        if let likes = profileDataService.profile?.likes {
            await newViewModel.loadNftItems(ids: likes)
        }
    }
}
