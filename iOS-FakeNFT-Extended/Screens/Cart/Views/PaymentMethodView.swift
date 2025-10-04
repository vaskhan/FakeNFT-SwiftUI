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
    @Binding var cartViewModel: CartViewModel?
    @State var successPaymentIsOpen: Bool = false
    @State var showAlert: Bool = false
    @Binding var paymentMethodIsOpen: Bool
    
    var body: some View {
        NavigationStack {
            if let viewModel = viewModel {
                if viewModel.isLoading {
                    AssetSpinner()
                } else {
                    ZStack {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ]
                        VStack() {
                            ScrollView() {
                                LazyVGrid(columns: columns, spacing: 7) {
                                    ForEach(viewModel.currencies, id: \.self) { item in
                                        PaymentMethodCollectionRow(paymentMethod: item, isSelected: viewModel.selectedCurrency == item)
                                            .onTapGesture {
                                                viewModel.selectedCurrency = item
                                            }
                                    }
                                }
                                .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
                            }
                            .scrollIndicators(.hidden)
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 2) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(String(localized: "CartFlow.Payment.agreement1"))
                                        .font(.appRegular13)
                                    NavigationLink {
                                        WebViewScreen()
                                    } label: {
                                        Text(String(localized: "CartFlow.Payment.agreement2"))
                                            .font(.appRegular13)
                                            .foregroundStyle(.blueUniversal)
                                    }
                                }
                                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                                Button(String(localized: "CartFlow.Payment.payButton")) {
                                    if let selectedItem = viewModel.selectedCurrency {
                                        Task {
                                            let isSuccess = await viewModel.buy()
                                            if isSuccess {
                                                successPaymentIsOpen = true
                                            } else {
                                                showAlert = true
                                            }
                                        }
                                    }
                                }
                                .buttonStyle(BlackButton())
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                                .fullScreenCover(isPresented: $successPaymentIsOpen) {
                                    SuccessPaymentView(paymentMethodIsOpen: $paymentMethodIsOpen, cartViewModel: $cartViewModel)
                                }
                                .alert("CartFlow.UnsuccessPayment.title", isPresented: $showAlert, actions: {
                                    Button("CartFlow.UnsuccessPayment.cancel") {
                                        showAlert = false
                                    }
                                    Button("CartFlow.UnsuccessPayment.retry") {
                                        showAlert = false
                                        Task {
                                            let isSuccess = await viewModel.buy()
                                            if isSuccess {
                                                successPaymentIsOpen = true
                                            } else {
                                                showAlert = true
                                            }
                                        }
                                    }
                                    .keyboardShortcut(.defaultAction)
                                }) {}
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
                                    paymentMethodIsOpen = false
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(.blackAndWhite)
                                }
                            }
                            
                            ToolbarItem(placement: .principal) {
                                Text(String(localized: "CartFlow.Payment.title"))
                                    .font(.appBold17)
                                    .foregroundColor(.blackAndWhite)
                            }
                        }
                        if viewModel.paymentInProcess {
                            ZStack {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                    .ignoresSafeArea()
                                AssetSpinner()
                            }
                        }
                        
                    }
                }
            }
        }
        .onAppear {
            Task {
                if let viewModel {
                    await viewModel.fetchCurrencies()
                } else {
                    viewModel = PaymentMethodViewModel(cartService: services.cartService)
                    await viewModel?.fetchCurrencies()
                }
            }
        }
    }
}

#Preview {
    PaymentMethodView(
        cartViewModel: .constant(nil),
        paymentMethodIsOpen: .constant(true)
    )
    .environment(
        ServicesAssembly(
            networkClient: DefaultNetworkClient()
        )
    )
}
