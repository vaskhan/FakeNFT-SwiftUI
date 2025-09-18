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
    var isLoading: Bool = false
    var errorMessage: String?
    var profile: UserModel?
    
    // Вычисляемые свойства для упрощения доступа из View
    var userName: String? {
        profile?.name
    }
    
    var userDescription: String? {
        profile?.description
    }
    
    var userWebsite: String? {
        profile?.website
    }
    
    var likesCount: Int? {
        profile?.likes.count
    }
    
    var nftsCount: Int? {
        profile?.nfts.count
    }
    
    func updateName(_ newName: String) {
        profile?.name = newName
    }
    
    func updateDescription(_ newDescription: String) {
        profile?.description = newDescription
    }
    
    func updateWebsite(_ newWebsite: String) {
        profile?.website = newWebsite
    }
    
    private let profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    func getUserInfo() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        print("Начинаем загрузку профиля")
        do {
            let response = try await profileService.loadProfile()
            profile = response
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
    
        isLoading = false
    }
}
