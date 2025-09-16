//
//  BlackButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 13.09.2025.
//

import SwiftUI

struct BlackButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.appBold17)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .background(.blackAndWhite)
            .foregroundStyle(.whiteAndBlack)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    Button("Оплатить") {}
        .buttonStyle(BlackButton())
        .padding()
}
