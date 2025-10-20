//
//  CloseButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 02.10.2025.
//

import SwiftUI

struct CloseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image(systemName: "xmark")
                    .resizable()
                    .font(Font.largeTitle.bold())
                    .foregroundStyle(.whiteUniversal)
                    .frame(width: 18, height: 18)
            }
            .frame(width: 42, height: 42)
        }
    }
}
