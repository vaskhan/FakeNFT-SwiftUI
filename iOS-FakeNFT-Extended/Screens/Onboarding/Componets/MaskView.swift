//
//  MaskView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 02.10.2025.
//

import SwiftUI

struct MaskView: View {
    let numberOfSections: Int
    
    var body: some View {
        HStack {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                MaskFragmentView()
                    .clipShape(RoundedRectangle(cornerRadius: CGFloat(3)))
            }
        }
    }
}
