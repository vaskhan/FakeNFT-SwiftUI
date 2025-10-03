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

struct MyNftView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var services: ServicesAssembly?
    @State private var isSortDialogPresented = false
    @State private var viewModels: [String: MyNftViewModel] = [:]
    
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
                    ForEach(myNfts, id: \.self) { nftId in
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
            Button(CartSort.byPrice.localized) {}
            Button(CartSort.byRating.localized) {}
            Button(CartSort.byName.localized) {}
            Button(String(localized: "SortingMenu.close"), role: .cancel) {}
        }
    }
    
    private func loadNftData(for nftId: String) async {
        guard viewModels[nftId] == nil, let services = services else { return }
        
        let viewModel = MyNftViewModel(myNftService: services.myNftService)
        viewModels[nftId] = viewModel
        await viewModel.getNftInfo(id: nftId)
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
    MyNftView(myNfts: ["123"])
}
