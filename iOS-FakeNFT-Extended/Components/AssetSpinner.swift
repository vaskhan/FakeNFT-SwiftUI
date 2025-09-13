//
//  AssetSpinner.swift
//  iOS-FakeNFT-Extended
//
//  Created by Василий Ханин on 13.09.2025.
//

import SwiftUI

struct AssetSpinner: View {
    var size: CGFloat = 30
    @State private var spin = false

    var body: some View {
        Image(.loader)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .rotationEffect(.degrees(spin ? 360 : 0))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false),
                       value: spin)
            .onAppear { spin = true }
    }
}
