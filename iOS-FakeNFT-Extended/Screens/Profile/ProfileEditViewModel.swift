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
    private let profileDataService: ProfileDataService
    
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
    
    init(profileDataService: ProfileDataService, profileService: ProfileServiceProtocol) {
        self.profileDataService = profileDataService
        self.profileService = profileService
        
        // Инициализируем данные из profileDataService
        self.editedName = profileDataService.profile?.name ?? ""
        self.editedDescription = profileDataService.profile?.description ?? ""
        self.editedWebsite = profileDataService.profile?.website ?? ""
        self.editedAvatar = profileDataService.profile?.avatar
    }
    
    var hasChanges: Bool {
        editedName != (profileDataService.profile?.name ?? "") ||
        editedDescription != (profileDataService.profile?.description ?? "") ||
        editedWebsite != (profileDataService.profile?.website ?? "")
    }
    
    func saveProfile() async {
        guard hasChanges else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Получаем текущий профиль и обновляем его данными из формы
        guard var currentProfile = profileDataService.profile else {
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
            // Обновляем данные в общей службе
            profileDataService.profile = currentProfile
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
        guard var currentProfile = profileDataService.profile else {
            errorMessage = "Профиль не загружен"
            isLoading = false
            return
        }
        
        currentProfile.avatar = avatar
        
        do {
            try await profileService.saveProfile(currentProfile)
            // Обновляем данные в общей службе
            profileDataService.profile = currentProfile
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
