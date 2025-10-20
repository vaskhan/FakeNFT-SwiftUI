//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 15.09.2025.
//

import SwiftUI

enum CartSort: String, CaseIterable, Sendable {
    case byPrice  = "SortingMenu.byPrice"
    case byRating = "SortingMenu.byRating"
    case byName   = "SortingMenu.byName"
    
    var localized: String {
        String(localized: String.LocalizationValue(rawValue))
    }
}

struct CartView: View {
    @Environment(ServicesAssembly.self) private var services
    @State var viewModel: CartViewModel?
    @State private var paymentMethodIsOpen = false
    @State private var deleteDialogIsOpen = false
    @State private var isSortDialogPresented = false
    
    var body: some View {
        NavigationStack {
            if let viewModel = viewModel {
                if viewModel.isLoading {
                    AssetSpinner()
                } else if viewModel.items.isEmpty {
                    ZStack() {
                        Text(String(localized: "CartFlow.Cart.empty"))
                            .font(.appBold17)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.whiteAndBlack)
                    .navigationBarBackButtonHidden(true)
                } else {
                    VStack() {
                        ScrollView() {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.items, id: \.id) { item in
                                    CartCollectionRow(
                                        item: item,
                                        onToggleDelete: {
                                            Task { await viewModel.removeItem(item) }
                                        }
                                    )
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                        .scrollIndicators(.hidden)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    isSortDialogPresented = true
                                } label: {
                                    Image(.list)
                                }
                            }
                        }
                        .confirmationDialog(
                            String(localized: "SortingMenu.title"),
                            isPresented: $isSortDialogPresented,
                            titleVisibility: .visible
                        ) {
                            Button(CartSort.byPrice.localized) {
                                viewModel.sortItems(by: .byPrice)
                                viewModel.selectedSort = .byPrice
                            }
                            Button(CartSort.byRating.localized) {
                                viewModel.sortItems(by: .byRating)
                                viewModel.selectedSort = .byRating
                            }
                            Button(CartSort.byName.localized) {
                                viewModel.sortItems(by: .byName)
                                viewModel.selectedSort = .byName
                            }
                            Button(String(localized: "SortingMenu.close"), role: .cancel) {}
                        }
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(viewModel.items.count) NFT")
                                    .font(.appRegular15)
                                Text("\(viewModel.items.map({$0.price}).reduce(0, +), specifier: "%.2f") ETH")
                                    .font(.appBold17)
                                    .foregroundColor(.greenUniversal)
                                
                            }
                            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                            Button(String(localized: "CartFlow.Cart.payButton")) {
                                paymentMethodIsOpen = true
                            }
                            .buttonStyle(BlackButton())
                            .padding()
                        }
                        .background(.lightgrey)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .background(.whiteAndBlack)
                    .navigationDestination(isPresented: $paymentMethodIsOpen) {
                        PaymentMethodView(cartViewModel: $viewModel, paymentMethodIsOpen: $paymentMethodIsOpen)
                    }
                    .toolbar(.visible, for: .tabBar)
                }
            }
            
        }
        .onAppear {
            Task {
                if let viewModel {
                    await viewModel.loadItems()
                } else {
                    viewModel = CartViewModel(cartService: services.cartService, nftService: services.nftService)
                    await viewModel?.loadItems()
                }
            }
        }
    }
}



#Preview {
    CartView()
        .environment(
            ServicesAssembly(
                networkClient: DefaultNetworkClient()
            )
        )
}
