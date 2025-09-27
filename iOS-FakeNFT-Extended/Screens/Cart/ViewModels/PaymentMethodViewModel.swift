//
//  PaymentMethodViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 17.09.2025.
//

import Foundation

@Observable
@MainActor
final class PaymentMethodViewModel {
    var currencies: [PaymentMethod] = []
    var selectedCurrency: PaymentMethod?
    var isLoading: Bool = false
    var paymentInProcess: Bool = false
    
    private let cartService: CartServiceProtocol
    
    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }
    
    func fetchCurrencies() async {
        guard !isLoading else { return }
        isLoading = true
        do {
            let loadedCurrencies = try await cartService.getCurrencies()
            currencies = loadedCurrencies
            print("Currencies loaded successfully")
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    func buy() async -> Bool {
        guard !paymentInProcess else { return false }
        paymentInProcess = true
        print("Payment in processing...")
        let isSuccess = false
        guard let selectedCurrency else {
            preconditionFailure("selectedCurrency is nil!")
        }
        do {
            let isSuccess = try await cartService.buy(currencyId: selectedCurrency.id)
        } catch {
            print(error)
        }
        paymentInProcess = false
        print("Response received")
        return isSuccess
    }
}
