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
    let mockedItems: [PaymentMethod] = [
        .init(id: "1", name: "Dogecoin", shortName: "DOGE", icon: URL(string: " ")),
        .init(id: "2", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "3", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
        .init(id: "4", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "5", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
        .init(id: "6", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "7", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
        .init(id: "8", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "9", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
        .init(id: "10", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "11", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
        .init(id: "12", name: "Dogecoin", shortName: "DOGE", icon: URL(string: " ")),
        .init(id: "13", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "14", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
        .init(id: "15", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "16", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
        .init(id: "17", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "18", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
        .init(id: "19", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "20", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
        .init(id: "21", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "22", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
        .init(id: "23", name: "Tether", shortName: "USDT", icon: URL(string: " ")),
        .init(id: "24", name: "Bicoin", shortName: "BTC", icon: URL(string: " ")),
    ]
}
