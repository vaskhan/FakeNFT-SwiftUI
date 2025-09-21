//
//  ProfileEditViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 21.09.2025.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class ProfileEditingViewModel {
    // Зависимости
    private let profileService: ProfileServiceProtocol
    private let profileViewModel: ProfileViewModel
    
    // Состояние редактирования
    var editedName: String
    var editedDescription: String
    var editedWebsite: String
    var editedAvatar: String?
    
    // Состояние UI
    var showImageActionDialog = false
    var showAvatarAlert = false
    var avatarUrlString = ""
    var isLoading = false
    var errorMessage: String?
    
    init(profileViewModel: ProfileViewModel, profileService: ProfileServiceProtocol) {
        self.profileViewModel = profileViewModel
        self.profileService = profileService
        self.editedName = profileViewModel.userName ?? ""
        self.editedDescription = profileViewModel.userDescription ?? ""
        self.editedWebsite = profileViewModel.userWebsite ?? ""
        self.editedAvatar = profileViewModel.userAvatar
    }
    
    var hasChanges: Bool {
        editedName != profileViewModel.userName ||
        editedDescription != profileViewModel.userDescription ||
        editedWebsite != profileViewModel.userWebsite
    }
    
    func saveProfile() async {
        guard hasChanges else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Получаем текущий профиль и обновляем его данными из формы
        guard var currentProfile = profileViewModel.profile else {
            errorMessage = "Профиль не загружен"
            isLoading = false
            return
        }
        
        // Обновляем поля
        currentProfile.name = editedName
        currentProfile.description = editedDescription
        currentProfile.website = editedWebsite
        
        do {
            try await profileService.saveProfile(currentProfile)
            await profileViewModel.getUserInfo()
            print("Профиль успешно сохранен")
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
        
        isLoading = false
    }
    
    func setAvatar(_ avatar: String) async {
        isLoading = true
        errorMessage = nil
        
        // Получаем текущий профиль и обновляем аватар
        guard var currentProfile = profileViewModel.profile else {
            errorMessage = "Профиль не загружен"
            isLoading = false
            return
        }
        
        currentProfile.avatar = avatar
        
        do {
            try await profileService.saveProfile(currentProfile)
            await profileViewModel.getUserInfo() // Обновляем основную VM
            editedAvatar = avatar
            
            print("Аватар успешно сохранен")
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
        
        isLoading = false
    }
    
    func deleteAvatar() async {
        await setAvatar("") // Устанавливаем пустую строку для удаления аватара
    }
}
