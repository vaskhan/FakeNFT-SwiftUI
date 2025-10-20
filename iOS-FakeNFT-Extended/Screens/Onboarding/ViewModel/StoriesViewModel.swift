//
//  StoriesViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 02.10.2025.
//

import Foundation

@Observable
@MainActor
final class StoriesViewModel {
    var stories = StoryModel.storiesData
    var selectStoryIndex: Int = 0
    
    func showStory(at id: UUID) {
        if let index = stories.firstIndex(where: { $0.id == id }) {
            selectStoryIndex = index
        }
    }
    
    func setStoryAsViewed(at index: Int) {
        if stories.indices.contains(index) {
            stories[index].wasShown = true
        }
    }
}
