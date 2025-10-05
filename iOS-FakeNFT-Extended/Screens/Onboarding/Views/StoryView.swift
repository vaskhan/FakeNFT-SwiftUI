//
//  StoryView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 02.10.2025.
//

import SwiftUI

struct StoryView: View {
    let story: StoryModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.blackUniversal.ignoresSafeArea()
            Image(story.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 40))
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.black, .clear]),
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .ignoresSafeArea()
            ZStack() {
                VStack(alignment: .leading, spacing: 12) {
                    Text(story.title)
                        .font(.appBold32)
                        .lineLimit(2)
                        
                    Text(story.description)
                        .font(.appRegular15)
                        .lineLimit(3)
                    Spacer()
                }
                .foregroundStyle(.whiteUniversal)
                .padding(.top, 260)
                .padding(.horizontal, 16)
                .multilineTextAlignment(TextAlignment.leading)
            }

        }
        .ignoresSafeArea()
    }
}

#Preview {
    StoryView(story: StoryModel.storiesData[1])
}
