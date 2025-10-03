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

struct MyNftView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var services: ServicesAssembly?
    @State private var isSortDialogPresented = false
    @State private var viewModels: [String: MyNftViewModel] = [:]
    @State private var currentSort: MyNftSort = .byRating
    
    let myNfts: [String]
    
    init(myNfts: [String]) {
        self.myNfts = myNfts
    }
    
    var body: some View {
        Group {
            if myNfts.isEmpty {
                emptyView
            } else {
                nftTable
            }
        }
        .commonToolbar(
            title: myNfts.isEmpty ? nil : MyNFTViewConstants.myNftTitle,
            onBack: { dismiss() }
        )
    }
    
    private var emptyView: some View {
        Text(MyNFTViewConstants.emptyMessage)
            .font(.appBold17)
    }
    
    
    private var nftTable: some View {
        ScrollView {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(sortedNfts, id: \.self) { nftId in
                        MyNftCell(
                            imageName: viewModels[nftId]?.images ?? "",
                            name: viewModels[nftId]?.name ?? "",
                            author: viewModels[nftId]?.author ?? "",
                            rating: viewModels[nftId]?.rating ?? 0,
                            price: viewModels[nftId]?.price ?? 0
                        )
                        .task {
                            await loadNftData(for: nftId)
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 39))
            .scrollIndicators(.hidden)
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
    
    private func loadNftData(for nftId: String) async {
        guard viewModels[nftId] == nil, let services = services else { return }
        
        let viewModel = MyNftViewModel(myNftService: services.myNftService)
        viewModels[nftId] = viewModel
        await viewModel.getNftInfo(id: nftId)
    }
    
    // Вычисляемое свойство для отсортированных NFT
    private var sortedNfts: [String] {
        let loadedNfts = myNfts.compactMap { nftId -> (id: String, vm: MyNftViewModel)? in
            guard let vm = viewModels[nftId], vm.nft != nil else { return nil }
            return (nftId, vm)
        }
        
        let sorted = loadedNfts.sorted { first, second in
            switch currentSort {
            case .byPrice:
                return (first.vm.price ?? 0) < (second.vm.price ?? 0)
            case .byRating:
                return (first.vm.rating ?? 0) < (second.vm.rating ?? 0)
            case .byName:
                return (first.vm.name ?? "") < (second.vm.name ?? "")
            }
        }
        
        return sorted.map { $0.id } + myNfts.filter { viewModels[$0]?.nft == nil }
    }
}
