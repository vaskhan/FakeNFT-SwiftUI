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
    @State private var isSortDialogPresented = false
    
    var body: some View {
        if let viewModel = viewModel {
            NavigationStack {
                VStack() {
                    ScrollView() {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.mockedItems, id: \.id) { item in
                                CartCollectionRow(item: item)
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
                        Button(CartSort.byPrice.localized) {}
                        Button(CartSort.byRating.localized) {}
                        Button(CartSort.byName.localized) {}
                        Button(String(localized: "SortingMenu.close"), role: .cancel) {}
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(viewModel.mockedItems.count) NFT")
                                .font(.appRegular15)
                            Text("\(viewModel.mockedItems.map({$0.price}).reduce(0, +), specifier: "%.2f") ETH")
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
                    PaymentMethodView(viewModel: PaymentMethodViewModel(), isPresented: $paymentMethodIsOpen)
                }
            }
        } else {
            ZStack() {
                Text(String(localized: "CartFlow.Cart.empty"))
                    .font(.appBold17)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.whiteAndBlack)
        }
    }
}

//#Preview {
//    CartView(viewModel: CartViewModel())
//        .environment(
//            ServicesAssembly(
//                networkClient: DefaultNetworkClient(),
//                nftStorage: NftStorageImpl()
//            )
//        )
//}
