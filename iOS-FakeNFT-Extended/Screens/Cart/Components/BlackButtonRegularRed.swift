//
//  BlackButtonRegularRed.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 25.09.2025.
//

import SwiftUI

struct BlackButtonRegularRed: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.appRegular17)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .background(.blackAndWhite)
            .foregroundStyle(.redUniversal)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    Button("Оплатить") {}
        .buttonStyle(BlackButtonRegularRed())
        .padding()
}
