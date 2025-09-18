//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//

import SwiftUI

struct ProfileView: View {
    @Environment(ServicesAssembly.self) private var services: ServicesAssembly?
    @State private var viewModel: ProfileViewModel?
    @State private var isShowingProfileEditing = false
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    ProfilePhotoView()
                    userName
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                personalInfo
                personalSite
                VStack(spacing: 32) {
                    NavigationLink(destination: MyNftView()) {
                        Text("Мои NFT (\(viewModel?.nftsCount ?? 0))")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.blackAndWhite)
                        
                        Spacer()
                        
                        Image(.chevronRight)
                            .renderingMode(.template)
                            .foregroundStyle(.blackAndWhite)
                    }
                    
                    NavigationLink(destination: FavouriteNftsView()) {
                        Text("Избранные NFT (\(viewModel?.likesCount ?? 0))")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.blackAndWhite)
                        
                        Spacer()
                        
                        Image(.chevronRight)
                            .renderingMode(.template)
                            .foregroundStyle(.blackAndWhite)
                    }
                }
                .padding(.top, 56)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingProfileEditing.toggle()
                    } label: {
                        Image(.editor)
                    }
                }
            }
            .navigationDestination(isPresented: $isShowingProfileEditing) {
                if let viewModel {
                    ProfileEditingView(viewModel: viewModel)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    isShowingProfileEditing.toggle()
                                } label: {
                                    Image(.navigationChevronLeft)
                                }
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
        .task {
            if viewModel == nil, let services = services {
                let newViewModel = ProfileViewModel(profileService: services.profileService)
                self.viewModel = newViewModel
                await newViewModel.getUserInfo()
            }
        }
    }
    // MARK: - UI Components
    private var userName: some View {
        Text(viewModel?.userName ?? "")
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.blackAndWhite)
    }
    
    private var personalInfo: some View {
        Text(viewModel?.userDescription ?? "")
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(viewModel?.userDescription != nil ? .blackAndWhite : .gray)
    }
    
    private var personalSite: some View {
        Group {
            if let website = viewModel?.userWebsite, let url = URL(string: website) {
                Link(destination: url) {
                    Text(website)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.blueUniversal)
                        .lineLimit(1)
                }
            } else if let website = viewModel?.userWebsite {
                Text(website)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.blueUniversal)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    ProfileView()
}
