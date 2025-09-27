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
    @State private var navigationModel = ProfileNavigationModel()
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            ZStack {

                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 16) {
                        ProfilePhotoView(avatarString: viewModel?.userAvatar ?? "")
                        userName
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    personalInfo
                    personalSite
                    VStack(spacing: 32) {
                        NavigationLink(value: "myNFTs") {
                            HStack {
                                Text("Мои NFT (\(viewModel?.nftsCount ?? 0))")
                                    .font(.appBold17)
                                    .foregroundColor(.blackAndWhite)
                                
                                Spacer()
                                
                                Image(.chevronRight)
                                    .renderingMode(.template)
                                    .foregroundStyle(.blackAndWhite)
                            }
                        }
                        
                        NavigationLink(value: ProfileRoute.favoriteNFTs(likesList: viewModel?.likesList ?? [])) {
                            HStack {
                                Text("Избранные NFT (\(viewModel?.likesCount ?? 0))")
                                    .font(.appBold17)
                                    .foregroundColor(.blackAndWhite)
                                
                                Spacer()
                                
                                Image(.chevronRight)
                                    .renderingMode(.template)
                                    .foregroundStyle(.blackAndWhite)
                            }
                        }
                    }
                    .padding(.top, 56)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .disabled(viewModel?.isLoading == true)
                
                if viewModel?.isLoading == true {
                    AssetSpinner()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.lightgrey)
                }
            }
            .navigationDestination(for: ProfileRoute.self) { destination in
                switch destination {
                case .myNFTs:
                    MyNftView()
                case .favoriteNFTs:
                    FavouriteNftsView(likesIds: viewModel?.likesList ?? [])
                    .onDisappear {
                        Task {
                            await refreshData()
                        }
                    }
                case .profileEditing:
                    if let viewModel, let services = services {
                        ProfileEditingView(
                            profileViewModel: viewModel,
                            profileService: services.profileService
                        )
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigationModel.path.append(ProfileRoute.profileEditing)
                    } label: {
                        Image(.editor)
                    }
                    .disabled(viewModel?.isLoading == true)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            if viewModel == nil, let services = services {
                let newViewModel = ProfileViewModel(profileService: services.profileService)
                self.viewModel = newViewModel
                await viewModel?.getUserInfo()
            }
        }
    }
    
    // MARK: - UI Components
    private var userName: some View {
        Text(viewModel?.userName ?? "")
            .font(.appBold22)
            .foregroundColor(.blackAndWhite)
    }
    
    private var personalInfo: some View {
        Text(viewModel?.userDescription ?? "")
            .font(.appRegular13)
            .foregroundColor(viewModel?.userDescription != nil ? .blackAndWhite : .gray)
    }
    
    private var personalSite: some View {
        Group {
            if let website = viewModel?.userWebsite, let url = URL(string: website) {
                Link(destination: url) {
                    Text(website)
                        .font(.appRegular15)
                        .foregroundColor(.blueUniversal)
                        .lineLimit(1)
                }
            } else if let website = viewModel?.userWebsite {
                Text(website)
                    .font(.appRegular15)
                    .foregroundColor(.blueUniversal)
                    .lineLimit(1)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func refreshData() async {
        await viewModel?.getUserInfo()
    }
}
