//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 13.09.2025.
//


import SwiftUI

struct CatalogView: View {
    @Environment(ServicesAssembly.self) private var services
    
    @State private var viewModel: CatalogViewModel?
    @State private var isSortDialogPresented = false
    
    var body: some View {
        NavigationStack {
            Group {
                if let vm = viewModel {
                    ScrollView {
                        if vm.isLoading {
                            AssetSpinner()
                        } else if let error = vm.errorMessage {
                            VStack(spacing: 12) {
                                Text(error).multilineTextAlignment(.center)
                                Button(String(localized: "Error.repeat", defaultValue: "Retry")) {
                                    Task { await vm.load() }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 32)
                            
                        } else if vm.collections.isEmpty {
                            Text(String(localized: "Catalog.empty", defaultValue: "Коллекций пока нет"))
                                .font(.appRegular15)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.top, 32)
                            
                        } else {
                            LazyVStack(spacing: 0) {
                                ForEach(vm.collections) { collection in
                                    NavigationLink(value: collection) {
                                        CollectionRowView(collection: collection)
                                            .padding(.horizontal, 16)
                                            .padding(.top, 20)
                                            .padding(.bottom, 8)
                                    }
                                }
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button { isSortDialogPresented = true } label: {
                                Image(.list)
                            }
                        }
                    }
                    .confirmationDialog(
                        String(localized: "Sorting.title", defaultValue: "Сортировка"),
                        isPresented: $isSortDialogPresented,
                        titleVisibility: .visible
                    ) {
                        Button(CatalogSort.byTitle.localized) {
                            vm.changeSort(to: .byTitle)
                        }
                        Button(CatalogSort.byItemsCount.localized) {
                            vm.changeSort(to: .byItemsCount)
                        }
                        Button(String(localized: "Close", defaultValue: "Закрыть"), role: .cancel) { }
                    }
                    .navigationDestination(for: NftCollection.self) { collection in
                        // TODO: Screen Collection
                        Text("Коллекция «\(collection.title)»")
                            .font(.appBold32)
                    }
                } else {
                    AssetSpinner()
                }
            }
        }
        .task {
            if viewModel == nil {
                let vm = CatalogViewModel(collectionService: services.nftCollectionService)
                viewModel = vm
                await vm.load()
            }
        }
    }
}

