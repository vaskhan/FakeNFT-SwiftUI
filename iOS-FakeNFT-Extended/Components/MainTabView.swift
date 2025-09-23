//
//  MainTabView.swift
//  FakeNFT
//
//  Created by Василий Ханин on 12.09.2025.
//


import SwiftUI

enum AppTab: Hashable {
    case basket,
         catalog,
         profile,
         statistics
}

struct MainTabView: View {
    @State private var selectedTab: AppTab
    
    init(initialTab: AppTab = .catalog) {
        _selectedTab = State(initialValue: initialTab)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Profile
            Text("Profile Screen")
                .tabItem {
                    VStack(spacing: 1) {
                        Image(selectedTab == .profile ? "ActiveProfile" : "NoActiveProfile")
                            .renderingMode(.original)
                        Text("MainScreen.tabProfile")
                            .font(.appMedium10)
                    }
                }
                .tag(AppTab.profile)
            
            // Catalog
            CatalogView()
                .tabItem {
                    VStack(spacing: 1) {
                        Image(selectedTab == .catalog ? "ActiveCatalog" : "NoActiveCatalog")
                            .renderingMode(.original)
                        Text("MainScreen.tabCatalog")
                            .font(.appMedium10)
                    }
                }
                .tag(AppTab.catalog)
            
            // Basket
            CartView()
                .tabItem {
                    VStack(spacing: 1) {
                        Image(selectedTab == .basket ? "ActiveBasket" : "NoActiveBasket")
                            .renderingMode(.original)
                        Text("MainScreen.tabBasket")
                            .font(.appMedium10)
                    }
                }
                .tag(AppTab.basket)
            
            // Statistics
            Text("Statistics Screen")
                .tabItem {
                    VStack(spacing: 1) {
                        Image(selectedTab == .statistics ? "ActiveStatistics" : "NoActiveStatistics")
                            .renderingMode(.original)
                        Text("MainScreen.tabStatistics")
                            .font(.appMedium10)
                    }
                }
                .tag(AppTab.statistics)
        }
    }
}

#Preview {
    MainTabView(initialTab: .catalog)
        .environment(
            ServicesAssembly(
                networkClient: DefaultNetworkClient()
            )
        )
}
