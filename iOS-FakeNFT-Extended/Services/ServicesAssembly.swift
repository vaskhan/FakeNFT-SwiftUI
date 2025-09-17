import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    let nftCollectionService: NftCollectionServiceProtocol
    let NftService: NftServiceProtocol
    
    init(networkClient: NetworkClient, nftStorage: NftStorage) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.nftCollectionService = NftCollectionService(networkClient: networkClient)
        self.NftService = iOS_FakeNFT_Extended.NftService(networkClient: networkClient)
    }
}
