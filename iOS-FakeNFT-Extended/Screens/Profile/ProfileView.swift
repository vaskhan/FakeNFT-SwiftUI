//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//

import SwiftUI

struct ProfileView: View {
//    @Environment(ServicesAssembly.self) private var services
    @State private var viewModel: ProfileViewModel?
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    userPhoto
                    userName
                    Spacer()
                }
                
                .frame(maxWidth: .infinity)
                
                personalInfo
                personalSite
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var userPhoto: some View {
        Image(.avatar)
            .resizable()
            .frame(width: 70, height: 70)
            .clipShape(Circle())
    }
    
    private var userName: some View {
        Text("Joaquin Phoenix")
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.blackAndWhite)
    }
    
    private var personalInfo: some View {
        Text("Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайт. Открыт к коллаборациям.")
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(.blackAndWhite)
    }
    
    private var personalSite: some View {
        Text("Joaquin Phoenix.com")
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.blueUniversal)
    }
    
    
}

#Preview {
    ProfileView()
}
