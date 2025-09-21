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
    private let profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    //MARK: - Вычисляемые свойства
    
    var userName: String? {
        profile?.name
    }
    
    var userAvatar: String? {
        profile?.avatar
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
    
    //MARK: - Функции
    
    func getUserInfo() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        print("Начинаем загрузку профиля")
        do {
            let response = try await profileService.loadProfile()
            profile = response
            print("Профиль загружен")
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
    
        isLoading = false
    }
    
    func setUserInfo(name: String, description: String, website: String) async {
        isLoading = true
        errorMessage = nil
        
        //Проверка, что профиль загружен
        guard let currentProfile = profile else {
            errorMessage = String(localized: "Profile not loaded", defaultValue: "Profile not loaded")
            isLoading = false
            return
        }
        
        // обновленная модель на основе текущего профиля и новых значений
        let updatedProfile = UserModel(
            name: name,
            avatar: currentProfile.avatar,
            description: description,
            website: website,
            nfts: currentProfile.nfts,
            likes: currentProfile.likes,
            id: currentProfile.id
        )

        do {
            try await profileService.saveProfile(updatedProfile)
            // Если успешно, обновляем локальный профиль
            self.profile = updatedProfile
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
        
        isLoading = false
    }
    
    func setUserAvatar(avatar: String) async {
        isLoading = true
        
        guard let currentProfile = profile else {
            errorMessage = String(localized: "Profile not loaded", defaultValue: "Profile not loaded")
            isLoading = false
            return
        }
        
        let updatedProfile = UserModel(
            name: currentProfile.name,
            avatar: avatar,
            description: currentProfile.description,
            website: currentProfile.website,
            nfts: currentProfile.nfts,
            likes: currentProfile.likes,
            id: currentProfile.id
        )
        
        do {
            try await profileService.saveProfile(updatedProfile)
            self.profile = updatedProfile
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
        
        isLoading = false
    }
    
    func deleteUserAvatar() async {
        await setUserAvatar(avatar: "")
    }
}
