//
//  ProfileDataService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 04.10.2025.
//
import Foundation

@Observable
@MainActor
final class ProfileDataService {
    var profile: UserModel?
    var isLoading: Bool = false
    var errorMessage: String?
    
    private let profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    func loadProfile() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            profile = try await profileService.loadProfile()
        } catch {
            errorMessage = String(localized: "Error.network", defaultValue: "A network error occurred")
        }
        
        isLoading = false
    }
    
    func updateLikes(_ newLikes: [String]) {
        profile?.likes = newLikes
    }
}
