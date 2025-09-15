//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 13.09.2025.
//

import Observation
import SwiftUI

// Сортировка
enum CatalogSort: String, CaseIterable, Sendable {
    case byTitle      = "by_name"
    case byItemsCount = "by_count"
    
    var localized: String {
        String(localized: String.LocalizationValue(rawValue))
    }
}


@Observable
@MainActor
final class CatalogViewModel {
    // Input
    var selectedSort: CatalogSort = UserDefaults.standard.catalogSort {
        didSet { UserDefaults.standard.catalogSort = selectedSort }
    }
    
    // State
    var isLoading: Bool = false
    var collections: [NftCollection] = []
    var errorMessage: String?
    
    private let collectionService: NftCollectionServiceProtocol
    
    init(collectionService: NftCollectionServiceProtocol) {
        self.collectionService = collectionService
    }
    
    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            let loaded = try await collectionService.loadCollections()
            collections = applySort(to: loaded, sort: selectedSort)
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
        isLoading = false
    }
    
    func changeSort(to sort: CatalogSort) {
        selectedSort = sort
        collections = applySort(to: collections, sort: sort)
    }
    
    private func applySort(to input: [NftCollection], sort: CatalogSort) -> [NftCollection] {
        switch sort {
        case .byTitle:
            return input.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
        case .byItemsCount:
            return input.sorted {
                $0.itemsCount > $1.itemsCount
            }
        }
    }
}

extension UserDefaults {
    private enum Keys { static let catalogSort = "catalog_sort" }
    
    var catalogSort: CatalogSort {
        get { CatalogSort(rawValue: string(forKey: Keys.catalogSort) ?? "") ?? .byItemsCount }
        set { set(newValue.rawValue, forKey: Keys.catalogSort) }
    }
}
