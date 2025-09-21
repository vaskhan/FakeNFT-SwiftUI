//
//  ProfilePhotoView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 18.09.2025.
//
//
//  ProfilePhotoView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 18.09.2025.
//

import SwiftUI
import Kingfisher

struct ProfilePhotoView: View {
    let avatarString: String
    
    var body: some View {
        Group {
            if !avatarString.isEmpty, let avatarUrl = URL(string: avatarString) {
                KFImage.url(avatarUrl)
                    .placeholder {
                        AssetSpinner().frame(width: 40, height: 40)
                    }
                    .onFailure { error in
                        print("[KF] error:", error.localizedDescription)
                    }
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "photo")
                    .font(.appBold32)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 70, height: 70)
        .clipShape(Circle())
    }
}


//#Preview {
//    ProfilePhotoView(avatarUrl: URL("https://avatars.mds.yandex.net/get-shedevrum/14810012/img_dc6143fba35211efbf2f463786c64669/orig"))
//}
