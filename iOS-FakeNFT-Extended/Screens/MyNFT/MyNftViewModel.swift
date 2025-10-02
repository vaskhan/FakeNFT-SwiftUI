//
//  MyNftViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 02.10.2025.
//
import Foundation

@MainActor
protocol MyNftViewModelProtocol {
    func getNftInfo(id: String) async
}

@Observable
@MainActor
final class MyNftViewModel: MyNftViewModelProtocol {
    var isLoading: Bool = false
    var errorMessage: String?
    var nft: NftModel?
    private let myNftService: MyNftServiceProtocol
    
    init(myNftService: MyNftServiceProtocol) {
        self.myNftService = myNftService
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
            nft = try await myNftService.loadNft(nft: id)
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
        
        isLoading = false
    }
}
