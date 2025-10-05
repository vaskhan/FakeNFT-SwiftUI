//
//  TimerConfiguration.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 02.10.2025.
//

import Foundation

struct TimerConfiguration {
    let storiesCount: Int
    let timerInterval: TimeInterval
    let progressPerTick: CGFloat
    
    init(storiesCount: Int, secondsPerStory: TimeInterval = 5, timerTickInternal: TimeInterval = 0.25) {
        self.storiesCount = storiesCount
        self.timerInterval = timerTickInternal
        self.progressPerTick = 1.0 / CGFloat(storiesCount == 0 ? 1 : storiesCount) / secondsPerStory * timerTickInternal
    }
    
    func progress(for storyIndex: Int) -> CGFloat {
        min(CGFloat(storyIndex)/CGFloat(storiesCount), 1)
    }
}
