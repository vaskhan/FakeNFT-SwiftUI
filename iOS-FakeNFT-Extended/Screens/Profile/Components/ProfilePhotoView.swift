//
//  ProfilePhotoView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 18.09.2025.
//

import SwiftUI

struct ProfilePhotoView: View {
    let avatarUrl: URL?
    
    var body: some View {
        Group {
            if let avatarUrl {
                AsyncImage(url: avatarUrl) { phase in
                    switch phase {
                    case .empty:
                        AssetSpinner()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(.avatar)
                            .resizable()
                            .scaledToFill()
                    @unknown default:
                        Image(.avatar)
                            .resizable()
                            .scaledToFill()
                    }
                }
            } else {
                Image(.avatar)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 70, height: 70)
        .scaledToFill()
        .clipShape(Circle())
    }
}

//#Preview {
//    ProfilePhotoView(avatarUrl: URL("https://avatars.mds.yandex.net/get-shedevrum/14810012/img_dc6143fba35211efbf2f463786c64669/orig"))
//}
