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
    var favoriteIds: Set<String> = []
    
    // состояние для отслеживания обновляющихся NFT
    var updatingNftIds: Set<String> = []
    
    private let profileDataService: ProfileDataService
    private let nftService: NftServiceProtocol
    
    init(profileDataService: ProfileDataService, nftService: NftServiceProtocol) {
        self.profileDataService = profileDataService
        self.nftService = nftService
    }
    
    func loadNftItems(ids: [String]) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            nftItems = try await nftService.loadItems(ids: ids)
            favoriteIds = Set(ids)
            isLoading = false
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
            isLoading = false
        }
    }
    
    func toggleFavorite(for nftId: String, completion: @escaping ([String]) -> Void) {
        // Блокировка повторного нажатия на NFT
        guard !updatingNftIds.contains(nftId) else { return }
        
        var newFavorites = Array(favoriteIds)
        
        if favoriteIds.contains(nftId) {
            newFavorites.removeAll { $0 == nftId }
            updatingNftIds.insert(nftId)
        } else {
            newFavorites.append(nftId)
        }
        
        favoriteIds = Set(newFavorites)
        
        Task {
            await updateFavoriteList(ids: newFavorites, removedNftId: nftId, completion: completion)
        }
    }
    
    private func updateFavoriteList(ids: [String], removedNftId: String, completion: @escaping ([String]) -> Void) async {
        guard !isLoading else { return }
        
        do {
            try await nftService.updateFavoriteNftList(nftList: ids)
            favoriteIds = Set(ids)

            nftItems.removeAll { $0.id == removedNftId }

            profileDataService.updateLikes(ids)
            
            completion(ids)
            
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
            // В случае ошибки возвращаем лайк
            var restoredFavorites = Array(favoriteIds)
            restoredFavorites.append(removedNftId)
            favoriteIds = Set(restoredFavorites)
        }
        
        updatingNftIds.remove(removedNftId)
    }
}
