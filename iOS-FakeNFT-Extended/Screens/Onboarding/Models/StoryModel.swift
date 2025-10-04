//
//  StoryModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 02.10.2025.
//

import Foundation

struct StoryModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let imageName: String
    var wasShown: Bool

    static let storiesData: [StoryModel] =
    (1...3).map { index in
        StoryModel(
            image: "Onboarding\(index)",
            title: NSLocalizedString("Onboarding.Story\(index).title", comment: "Onboarding story title"),
            description: NSLocalizedString("Onboarding.Story\(index).description", comment: "Onboarding story description")
        )
    }
    
    init(
        image: String,
        title: String,
        description: String,
        wasShown: Bool = false
    ) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.imageName = image
        self.wasShown = wasShown
    }
}
