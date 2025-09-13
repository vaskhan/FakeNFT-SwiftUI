//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//

import Foundation
import Observation

@Observable
@MainActor
final class ProfileViewModel {
    var isLoading: Bool = false
    var errorMessage: String?
    
    func load() async {
            guard !isLoading else { return }
            isLoading = true
            errorMessage = nil
        
            do {
               
            } catch {
                
            }
        
            isLoading = false
        }

}
