//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//
import Foundation

@Observable
@MainActor
final class ProfileViewModel: ProfileViewModelProtocol {
    private let profileDataService: ProfileDataService
    
    init(profileDataService: ProfileDataService) {
        self.profileDataService = profileDataService
    }
    
    // Вычисляемые свойства
    var isLoading: Bool { profileDataService.isLoading }
    var errorMessage: String? { profileDataService.errorMessage }
    var userName: String? { profileDataService.profile?.name }
    var userAvatar: String? { profileDataService.profile?.avatar }
    var userDescription: String? { profileDataService.profile?.description }
    var userWebsite: String? { profileDataService.profile?.website }
    var likesCount: Int? { profileDataService.profile?.likes.count }
    var nftsCount: Int? { profileDataService.profile?.nfts.count }
    var likesList: [String] { profileDataService.profile?.likes ?? [] }
    var myNftsList: [String] { profileDataService.profile?.nfts ?? [] }
    
    func getUserInfo() async {
        await profileDataService.loadProfile()
    }
    
    func updateLikes(_ newLikes: [String]) {
        profileDataService.updateLikes(newLikes)
    }
}
