//
//  CollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 18.09.2025.
//


import SwiftUI

struct CollectionView: View {
    @Environment(ServicesAssembly.self) private var services
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: CollectionViewModel
    
    init(collection: NftCollection, services: ServicesAssembly) {
        _viewModel = State(wrappedValue: CollectionViewModel(
            collection: collection,
            nftService: services.nftService,
            cartService: services.cartService,
            profileService: services.profileService
        ))
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ZStack { Color.clear; AssetSpinner() }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .task { await viewModel.load() }
            
        case .error(let message):
            VStack(spacing: 12) {
                Text(message).multilineTextAlignment(.center)
                Button(String(localized: "Error.repeat", defaultValue: "Retry")) {
                    Task { await viewModel.load() }
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 32)
            
        case .loaded:
            let collection = viewModel.collection
            VStack(alignment: .leading, spacing: 24) {
                CollectionHeader(collection: collection)
                ScrollView {
                    NftGrid(
                        items: viewModel.nftItems,
                        favoriteIds: viewModel.favoriteIds,
                        cartIds: viewModel.cartIds,
                        onToggleFavorite: { id in viewModel.toggleFavorite(for: id) },
                        onToggleCart: { id in viewModel.toggleCart(for: id) }
                    )
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
    
    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image("NavigationChevronLeft")
                    }
                }
            }
    }
}
