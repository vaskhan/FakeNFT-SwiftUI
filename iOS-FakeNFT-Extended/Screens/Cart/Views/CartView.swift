//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 15.09.2025.
//

import SwiftUI

struct CartView: View {
    //    @Environment(ServicesAssembly.self) private var services
    @State var viewModel: CartViewModel
    
    var body: some View {
        NavigationStack {
            VStack() {
                ScrollView() {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.mockedItems, id: \.id) { item in
                            CartCollectionRow(item: item)
                        }
                    }
                }
                .padding()
                .scrollIndicators(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // TODO вызвать контекстное меню
                        } label: {
                            Image(.list)
                        }
                    }
                }
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(viewModel.mockedItems.count) NFT")
                            .font(.appRegular15)
                        Text("\(viewModel.mockedItems.map({$0.price}).reduce(0, +), specifier: "%.2f") ETH")
                            .font(.appBold17)
                            .foregroundColor(.greenUniversal)
                            
                    }
                    .padding()
                    Button("К оплате") {
                        //TODO переход на страницу выбора оплаты
                    }
                    .buttonStyle(BlackButton())
                    .padding()
                }
                .background(.lightgrey)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }.background(.whiteAndBlack)
        }
    }
}

#Preview {
    CartView(viewModel: CartViewModel())
}
