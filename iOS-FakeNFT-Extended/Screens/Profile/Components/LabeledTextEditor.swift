//
//  LabeledTextEditor.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 17.09.2025.
//

import SwiftUI

struct LabeledTextEditor: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.appBold22)
            
            TextEditor(text: $text)
                .font(.appRegular17)
                .padding(.horizontal, 16)
                .padding(.vertical, 11)
                .frame(maxWidth: .infinity, maxHeight: 135)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.lightgrey)
                )
                .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    LabeledTextEditor(title: "Описание", text: .constant("Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям."))
}
