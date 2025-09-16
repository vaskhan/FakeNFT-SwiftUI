import Foundation

@Observable
@MainActor
final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
    
    let profileService: ProfileServiceProtocol

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        
        self.profileService = ProfileService(networkClient: networkClient)
    }
}
