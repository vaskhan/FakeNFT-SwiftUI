import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    private let networkClient: NetworkClient
//    private let nftStorage: NftStorage

    let nftCollectionService: NftCollectionServiceProtocol
    let nftService: NftServiceProtocol
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
//        self.nftStorage = nftStorage
        self.nftCollectionService = NftCollectionService(networkClient: networkClient)
        self.nftService = NftService(networkClient: networkClient)
    }
}
