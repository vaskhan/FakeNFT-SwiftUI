//
//  ProfilePhotoView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 18.09.2025.
//

import SwiftUI

struct ProfilePhotoView: View {
    var body: some View {
        Image(.avatar)
            .resizable()
            .frame(width: 70, height: 70)
            .scaledToFill()
            .clipShape(Circle())
    }
}

#Preview {
    ProfilePhotoView()
}
