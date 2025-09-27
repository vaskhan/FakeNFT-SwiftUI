//
//  FavouriteNftsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 24.09.2025.
//

import Foundation

@Observable
@MainActor
final class FavouriteNftsViewModel: FavouriteNftViewModelProtocol {
    var isLoading: Bool = false
    var errorMessage: String?
    var nft: NftModel?
    private let favouriteNftService: FavouriteNftServiceProtocol
    
    init(favouriteNftService: FavouriteNftServiceProtocol) {
        self.favouriteNftService = favouriteNftService
    }
    
    //Вычисляемые свойства
    var name: String? { nft?.name }
    var images: String? { nft?.images[0] }
    var rating: Int? { nft?.rating }
    var price: Double? { nft?.price }
    
    func getNftInfo(id: String) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            nft = try await favouriteNftService.loadNft(nft: id)
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
        
        isLoading = false
    }
}
