//
//  MyNftView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 16.09.2025.
//
import SwiftUI

private enum MyNFTViewConstants {
    static let myNftTitle = String(localized: "ProfileFlow.MyNft.title")
    static let emptyMessage = String(localized: "ProfileFlow.MyNft.empty")
    static let backButtonImage = "NavigationChevronLeft"
}

enum MyNftSort: String, CaseIterable, Sendable {
    case byPrice
    case byRating
    case byName
    
    var localized: String {
        switch self {
        case .byPrice:
            return String(localized: "SortingMenu.byPrice")
        case .byRating:
            return String(localized: "SortingMenu.byRating")
        case .byName:
            return String(localized: "SortingMenu.byName")
        }
    }
}

import SwiftUI

struct MyNftView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var profileDataService: ProfileDataService
    let nftService: NftServiceProtocol
    @State private var isSortDialogPresented = false
    @State private var viewModel: MyNftViewModel?
    @State private var currentSort: MyNftSort = .byRating
    
    var body: some View {
        ZStack {
            // Основной контент
            Group {
                if let viewModel = viewModel {
                    if viewModel.nftItems.isEmpty && !viewModel.isLoading {
                        emptyView
                    } else {
                        nftTableView(viewModel: viewModel)
                    }
                } else {
                    Color.clear // Заполнитель, чтобы ZStack занимал все пространство
                }
            }
            
            // Спиннер поверх всего контента
            if shouldShowFullScreenSpinner {
                Color(.lightgrey) // Фон на весь экран
                    .ignoresSafeArea()
                
                AssetSpinner()
                    .frame(width: 75, height: 75)
            }
        }
        .commonToolbar(
            title: (viewModel?.nftItems.isEmpty ?? true) ? nil : MyNFTViewConstants.myNftTitle,
            onBack: { dismiss() }
        )
        .onAppear {
            if viewModel == nil {
                viewModel = MyNftViewModel(nftService: nftService)
            }
        }
        .task {
            if let myNfts = profileDataService.profile?.nfts {
                await viewModel?.loadNftItems(ids: myNfts)
            }
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
        Text(MyNFTViewConstants.emptyMessage)
            .font(.appBold17)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func nftTableView(viewModel: MyNftViewModel) -> some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.sortedNftItems(by: currentSort), id: \.id) { nftItem in
                        MyNftCell(
                            nftId: nftItem.id,
                            isLiked: profileDataService.profile?.likes.contains(nftItem.id) == true,
                            imageName: viewModel.images(for: nftItem) ?? "",
                            name: viewModel.name(for: nftItem) ?? "",
                            author: viewModel.author(for: nftItem) ?? "",
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
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 39))
            }
            .scrollIndicators(.hidden)
            
            // Спиннер для случаев, когда данные обновляются, но уже есть контент
            if viewModel.isLoading && !viewModel.nftItems.isEmpty {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                
                AssetSpinner()
                    .frame(width: 75, height: 75)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { isSortDialogPresented = true } label: {
                    Image(.list)
                }
            }
        }
        .confirmationDialog(
            String(localized: "SortingMenu.title"),
            isPresented: $isSortDialogPresented,
            titleVisibility: .visible
        ) {
            Button(MyNftSort.byPrice.localized) { currentSort = .byPrice }
            Button(MyNftSort.byRating.localized) { currentSort = .byRating }
            Button(MyNftSort.byName.localized) { currentSort = .byName }
            Button(String(localized: "SortingMenu.close"), role: .cancel) {}
        }
    }
}
