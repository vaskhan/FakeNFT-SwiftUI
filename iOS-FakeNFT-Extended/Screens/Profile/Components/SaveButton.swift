//
//  SaveButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 18.09.2025.
//

import SwiftUI

struct SaveButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.appBold17)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 19)
            .background(.blackAndWhite)
            .foregroundStyle(.whiteAndBlack)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    Button("Сохранить") {}
        .buttonStyle(BlackButton())
        .padding()
}
