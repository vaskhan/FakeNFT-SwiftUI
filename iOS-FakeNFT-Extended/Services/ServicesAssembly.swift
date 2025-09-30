import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    private let networkClient: NetworkClient
    // private let nftStorage: NftStorage

    let profileService: ProfileServiceProtocol
    let nftCollectionService: NftCollectionServiceProtocol
    let nftService: NftServiceProtocol
    let cartService: CartServiceProtocol
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        // self.nftStorage = nftStorage  // Закомментировано в develop

        self.profileService = ProfileService(networkClient: networkClient)
        self.nftCollectionService = NftCollectionService(networkClient: networkClient)
        self.nftService = NftService(networkClient: networkClient)
        self.cartService = CartService(networkClient: networkClient)
    }
}
