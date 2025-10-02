//
//  MyNftView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 16.09.2025.
//

import SwiftUI

struct MyNftView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ServicesAssembly.self) private var services: ServicesAssembly?
    @State private var viewModels: [String: MyNftViewModel] = [:]
    
    let myNfts: [String]
    
    init(myNfts: [String]) {
        self.myNfts = myNfts
    }
    
    var body: some View {
        ScrollView() {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(myNfts, id: \.self) { nftId in
                        MyNftCell(
                            nftId: nftId,
                            imageName: viewModels[nftId]?.images ?? "",
                            name: viewModels[nftId]?.name ?? "",
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
    }
    
    private func loadNftData(for nftId: String) async {
        guard viewModels[nftId] == nil, let services = services else { return }
        
        let viewModel = MyNftViewModel(myNftService: services.myNftService)
        viewModels[nftId] = viewModel
        await viewModel.getNftInfo(id: nftId)
    }
}

#Preview {
    MyNftView(myNfts: ["123"])
}
