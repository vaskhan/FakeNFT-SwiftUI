//
//  FavouriteNftsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 24.09.2025.
//
import Foundation

@Observable
@MainActor
final class FavouriteNftsViewModel {
    var isLoading: Bool = false
    var errorMessage: String?
    var nftItems: [NftItem] = []
    
    private let nftService: NftServiceProtocol
    
    init(nftService: NftServiceProtocol) {
        self.nftService = nftService
    }
    
    func name(for nftItem: NftItem) -> String? {
        guard let firstImageUrlString = nftItem.imageURL?.absoluteString else { return nil }
        let components = firstImageUrlString.split(separator: "/")
        if components.count >= 2 {
            return String(components[components.count - 2])
        } else {
            return nftItem.title
        }
    }
    
    func loadNftItems(ids: [String]) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            print("Загрузка избранных NFT - начало")
            nftItems = try await nftService.loadItems(ids: ids)
            isLoading = false
            print("Загрузка избранных NFT - успех")
        } catch {
            print("Загрузка избранных NFT - ошибка")
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
            isLoading = false
        }
    }
    
    func toggleFavorite(for nftId: String, newLikeState: Bool, profileDataService: ProfileDataService) async {
        guard !isLoading else { return }
        
        var currentLikes = profileDataService.profile?.likes ?? []
        
        if newLikeState {
            // Добавление лайка
            if !currentLikes.contains(nftId) {
                currentLikes.append(nftId)
            }
        } else {
            // Удаление лайка
            currentLikes.removeAll { $0 == nftId }
            nftItems.removeAll { $0.id == nftId }
        }
        
        // Обновление данных локально
        profileDataService.updateLikes(currentLikes)
        
        do {
            try await nftService.updateFavoriteNftList(nftList: currentLikes)
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
    }
}
