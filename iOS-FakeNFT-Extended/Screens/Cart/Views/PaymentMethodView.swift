//
//  PaymentMethodView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 17.09.2025.
//

import SwiftUI

struct PaymentMethodView: View {
    @Environment(ServicesAssembly.self) private var services
    @State var viewModel: PaymentMethodViewModel?
    @State var selectedItem: PaymentMethod?
    @Binding var isPresented: Bool
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
        VStack() {
            ScrollView() {
                LazyVGrid(columns: columns, spacing: 7) {
                    if let viewModel = viewModel {
                        ForEach(viewModel.mockedItems, id: \.self) { item in
                            PaymentMethodCollectionRow(paymentMethod: item, isSelected: selectedItem == item)
                                .onTapGesture {
                                    selectedItem = item
                                }
                        }
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
            }
            .scrollIndicators(.hidden)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 2) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(String(localized: "Payment.agreement1"))
                        .font(.appRegular13)
                    Text(String(localized: "Payment.agreement2"))
                        .font(.appRegular13)
                        .foregroundColor(.blueUniversal)
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                Button(String(localized: "Payment.payButton")) {
                    //TODO действие оплаты
                }
                .buttonStyle(BlackButton())
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
            }
            .background(.lightgrey)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .background(.whiteAndBlack)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.blackAndWhite)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(String(localized: "Payment.title"))
                    .font(.appBold17)
                    .foregroundColor(.blackAndWhite)
            }
        }
        
    }
}

#Preview {
    PaymentMethodView(viewModel: PaymentMethodViewModel(), isPresented: .constant(true))
        .environment(
            ServicesAssembly(
                networkClient: DefaultNetworkClient(),
                nftStorage: NftStorageImpl()
            )
        )
}
