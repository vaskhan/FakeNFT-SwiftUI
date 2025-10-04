//
//  MyNftViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 02.10.2025.
//
import Foundation

@Observable
@MainActor
final class MyNftViewModel {
    var isLoading: Bool = false
    var errorMessage: String?
    var nftItems: [NftItem] = []
    
    private let nftService: NftServiceProtocol
    
    init(nftService: NftServiceProtocol) {
        self.nftService = nftService
    }
    
    // Вычисляемые свойства для каждого NFT
    func name(for nftItem: NftItem) -> String? {
        guard let firstImageUrlString = nftItem.imageURL?.absoluteString else { return nil }
        let components = firstImageUrlString.split(separator: "/")
        if components.count >= 2 {
            return String(components[components.count - 2])
        } else {
            return nftItem.title
        }
    }
    
    func images(for nftItem: NftItem) -> String? {
        return nftItem.imageURL?.absoluteString
    }
    
    func author(for nftItem: NftItem) -> String? {
        return nftItem.title
    }
    
    func loadNftItems(ids: [String]) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            nftItems = try await nftService.loadItems(ids: ids)
            isLoading = false
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
            isLoading = false
        }
    }
    
    func sortedNftItems(by sort: MyNftSort) -> [NftItem] {
        switch sort {
        case .byPrice:
            return nftItems.sorted { ($0.price ?? 0) < ($1.price ?? 0) }
        case .byRating:
            return nftItems.sorted { $0.rating < $1.rating }
        case .byName:
            return nftItems.sorted {
                let name1 = name(for: $0) ?? ""
                let name2 = name(for: $1) ?? ""
                return name1 < name2
            }
        }
    }
}
