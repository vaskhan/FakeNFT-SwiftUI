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
    // Состояние остается только для отображения данных
    var isLoading: Bool = false
    var errorMessage: String?
    var profile: UserModel?
    private let profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    // Вычисляемые свойства остаются без изменений
    var userName: String? { profile?.name }
    var userAvatar: String? { profile?.avatar }
    var userDescription: String? { profile?.description }
    var userWebsite: String? { profile?.website }
    var likesCount: Int? { profile?.likes.count }
    var nftsCount: Int? { profile?.nfts.count }
    
    func getUserInfo() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            print("Начинается загрузка профиля")
            profile = try await profileService.loadProfile()
            print("Профиль успешно загружен")
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
        
        isLoading = false
    }
}
