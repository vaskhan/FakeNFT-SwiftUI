//
//  LabeledTextField.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 17.09.2025.
//

import SwiftUI

struct LabeledTextField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.appBold22)
            
            TextField("Ваше имя", text: $text)
                .font(.appRegular17)
                .padding(.horizontal, 16)
                .padding(.vertical, 11)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.lightgrey)
                )
        }
    }
}

#Preview {
    LabeledTextField(title: "Имя", text: .constant("Крутой программист"))
    
}
