import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    private let networkClient: NetworkClient
    
    let profileService: ProfileServiceProtocol
    let favouriteNftService: FavouriteNftServiceProtocol
    let myNftService: MyNftServiceProtocol
    let nftCollectionService: NftCollectionServiceProtocol
    let nftService: NftServiceProtocol
    let cartService: CartServiceProtocol
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        self.profileService = ProfileService(networkClient: networkClient)
        self.favouriteNftService = FavouriteNftService(networkClient: networkClient)
        self.myNftService = MyNftService(networkClient: networkClient)
        self.nftCollectionService = NftCollectionService(networkClient: networkClient)
        self.nftService = NftService(networkClient: networkClient)
        self.cartService = CartService(networkClient: networkClient)
    }
}
