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
    @State private var viewModel: MyNftViewModel?
    @State private var currentSort: MyNftSort = .byRating
    
    private let myNfts: [String]
    
    init(myNfts: [String]) {
        self.myNfts = myNfts
    }
    
    var body: some View {
        Group {
            if let viewModel = viewModel {
                if viewModel.nftItems.isEmpty && !viewModel.isLoading {
                    emptyView
                } else {
                    nftTableView(viewModel: viewModel)
                }
            } else {
                AssetSpinner()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.lightgrey)
            }
        }
        .commonToolbar(
            title: (viewModel?.nftItems.isEmpty ?? true) ? nil : MyNFTViewConstants.myNftTitle,
            onBack: { dismiss() }
        )
        .onAppear {
            if viewModel == nil, let services = services {
                viewModel = MyNftViewModel(nftService: services.nftService)
            }
        }
        .task {
            await viewModel?.loadNftItems(ids: myNfts)
        }
    }
    
    private var emptyView: some View {
        Text(MyNFTViewConstants.emptyMessage)
            .font(.appBold17)
    }
    
    @ViewBuilder
    private func nftTableView(viewModel: MyNftViewModel) -> some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.sortedNftItems(by: currentSort), id: \.id) { nftItem in
                        MyNftCell(
                            imageName: viewModel.images(for: nftItem) ?? "",
                            name: viewModel.name(for: nftItem) ?? "",
                            author: viewModel.author(for: nftItem) ?? "",
                            rating: nftItem.rating,
                            price: nftItem.price ?? 0
                        )
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 39))
            }
        }
        .scrollIndicators(.hidden)
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
