//
//  FakeNFTApp.swift
//  FakeNFT
//
//  Created by Василий Ханин on 12.09.2025.
//


import SwiftUI

@main
struct FakeNFTApp: App {
    private let services = ServicesAssembly(
        networkClient: DefaultNetworkClient()
    )
    
    var body: some Scene {
        WindowGroup {
            MainTabView(initialTab: .catalog)
                .environment(services)
                .tint(Color(.blueUniversal))
        }
    }
}
