//
//  View+CommonToolbar.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 03.10.2025.
//

import SwiftUI

extension View {
    func commonToolbar(title: String?, onBack: @escaping () -> Void) -> some View {
        self
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onBack) {
                        Image("NavigationChevronLeft")
                    }
                }
                
                if let title = title {
                    ToolbarItem(placement: .principal) {
                        Text(title)
                            .font(.appBold17)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
    }
}
