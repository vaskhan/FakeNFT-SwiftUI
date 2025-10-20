//
//  StoriesView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 02.10.2025.
//

import SwiftUI
import Combine

struct StoriesView: View {
    @State private var storiesViewModel: StoriesViewModel
    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?
    @State private var progress: CGFloat
    @Environment(\.dismiss) var dismiss
    
    private var currentStory: StoryModel { storiesViewModel.stories[currentStoryIndex] }
    private var currentStoryIndex: Int {
        let index = Int(progress * CGFloat(storiesViewModel.stories.count))
        return min(index, max(storiesViewModel.stories.count - 1, 0))
    }
    private var timerConfiguration: TimerConfiguration
    
    init(storiesViewModel: StoriesViewModel) {
        self.storiesViewModel = storiesViewModel
        self.timerConfiguration = TimerConfiguration(storiesCount: storiesViewModel.stories.count, secondsPerStory: 10)
        self.timer = Self.createTimer(configuration: timerConfiguration)
        progress = timerConfiguration.progress(for: storiesViewModel.selectStoryIndex)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            StoryView(story: currentStory)
            VStack(alignment: .trailing) {
                ProgressBar(numberOfSections: storiesViewModel.stories.count, progress: progress)
                    .padding(.init(top: 28, leading: 12, bottom: 12, trailing: 12))
                    .frame(maxWidth: .infinity, maxHeight: 1)
                if storiesViewModel.stories.count > currentStoryIndex + 1 {
                    CloseButton {
                        dismiss()
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 20)
                }
                Spacer()
                if storiesViewModel.stories.count == currentStoryIndex + 1 {
                    Button("Onboarding.button") {
                        dismiss()
                    }
                    .buttonStyle(BlackButton())
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 50, trailing: 16))
                }
            }
        }
        .onAppear {
            timer = Self.createTimer(configuration: timerConfiguration)
            cancellable = timer.connect()
            storiesViewModel.setStoryAsViewed(at: currentStoryIndex)
            OnboardingHelper.shared.isOnboarded = true
        }
        .onDisappear {
            cancellable?.cancel()
        }
        .onReceive(timer) {_ in
            timerTick()
        }
        .onTapGesture { location in
            let screenWidth = UIScreen.main.bounds.width
            if location.x < screenWidth / 2 {
                previewStory()
            } else {
                nextStory()
            }
            resetTimer()
        }
        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                switch(value.translation.width, value.translation.height) {
                case (...0, -30...30): nextStory()
                case (0..., -30...30): previewStory()
                case (-100...100, 0...): dismiss()
                default: print("unknown gesture")
                }
            }
        )
    }
    
    private func nextStory() {
        let nextStoryIndex = currentStoryIndex + 1
        if nextStoryIndex == storiesViewModel.stories.count {
            dismiss()
        } else {
            withAnimation {
                progress = CGFloat(nextStoryIndex)/CGFloat(storiesViewModel.stories.count)
                storiesViewModel.setStoryAsViewed(at: nextStoryIndex)
            }
        }
    }
    
    private func previewStory() {
        let prevStoryIndex = max(currentStoryIndex - 1, 0)
        withAnimation {
            progress = CGFloat(prevStoryIndex)/CGFloat(storiesViewModel.stories.count)
            storiesViewModel.setStoryAsViewed(at: prevStoryIndex)
        }
    }
    
    private func resetTimer() {
        cancellable?.cancel()
        timer = Self.createTimer(configuration: timerConfiguration)
        cancellable = timer.connect()
    }
    
    
    private func timerTick() {
        guard progress < 1 else { return }
        var nextProgress = progress + timerConfiguration.progressPerTick
        if nextProgress >= 1 {
            nextProgress = 1
            cancellable?.cancel()
        }
        withAnimation {
            progress = nextProgress
        }
    }
    
    private static func createTimer(configuration: TimerConfiguration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerInterval, on: .main, in: .common)
    }
}

#Preview {
    StoriesView(storiesViewModel: StoriesViewModel())
}
