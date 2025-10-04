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
    @State private var profileDataService: ProfileDataService?
    
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
                    List {
                        Section {
                            ZStack {
                                NavigationLink(value: ProfileRoute.myNFTs) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                HStack {
                                    Text(String(localized: "ProfileFlow.MyNft.title") + " (\(viewModel?.nftsCount ?? 0))")
                                        .font(.appBold17)
                                        .foregroundColor(.blackAndWhite)
                                    
                                    Spacer()
                                    
                                    Image(.chevronRight)
                                        .renderingMode(.template)
                                        .foregroundStyle(.blackAndWhite)
                                }
                                .contentShape(Rectangle())
                            }
                            
                            ZStack {
                                NavigationLink(value: ProfileRoute.favoriteNFTs) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                HStack {
                                    Text(String(localized: "ProfileFlow.FavouriteNft.title") +  " (\(viewModel?.likesCount ?? 0))")
                                        .font(.appBold17)
                                        .foregroundColor(.blackAndWhite)
                                    
                                    Spacer()
                                    
                                    Image(.chevronRight)
                                        .renderingMode(.template)
                                        .foregroundStyle(.blackAndWhite)
                                }
                                .contentShape(Rectangle())
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
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
                    if let profileDataService = profileDataService {
                        MyNftView(
                            myNfts: profileDataService.profile?.nfts ?? [],
                            likesList: Binding(
                                get: { profileDataService.profile?.likes ?? [] },
                                set: { profileDataService.updateLikes($0) }
                            ),
                            profileDataService: profileDataService
                        )
                    }
                case .favoriteNFTs:
                    if let profileDataService = profileDataService {
                        FavouriteNftsView(
                            likesList: Binding(
                                get: { profileDataService.profile?.likes ?? [] },
                                set: { profileDataService.updateLikes($0) }
                            ),
                            profileDataService: profileDataService
                        )
                    }
                case .profileEditing:
                    if let profileDataService = profileDataService, let services = services {
                        ProfileEditingView(
                            profileDataService: profileDataService,
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
                let dataService = ProfileDataService(profileService: services.profileService)
                self.profileDataService = dataService
                self.viewModel = ProfileViewModel(profileDataService: dataService)
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
            if let website = viewModel?.userWebsite {
                NavigationLink {
                    WebViewScreen(urlString: website)
                } label: {
                    Text(website)
                        .font(.appRegular15)
                        .foregroundColor(.blueUniversal)
                        .lineLimit(1)
                }
            }
        }
    }
}
