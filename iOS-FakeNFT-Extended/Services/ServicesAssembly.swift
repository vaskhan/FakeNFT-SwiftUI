import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    let nftCollectionService: NftCollectionServiceProtocol

    init(networkClient: NetworkClient, nftStorage: NftStorage) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.nftCollectionService = NftCollectionService(networkClient: networkClient)
    }

//    var nftService: NftService {
//        NftServiceImpl(
//            networkClient: networkClient,
//            storage: nftStorage
//        )
//    }
}
