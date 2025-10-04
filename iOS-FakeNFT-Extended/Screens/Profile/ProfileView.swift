//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 13.09.2025.
//
import SwiftUI

struct ProfileView: View {
    @Environment(ServicesAssembly.self) private var services: ServicesAssembly?
    @State private var profileDataService: ProfileDataService?
    @State private var navigationModel = ProfileNavigationModel()
    
    private enum Constants {
        static let basePadding: CGFloat = 16
        static let largePadding: CGFloat = 20
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            ZStack {
                if let profileDataService = profileDataService {
                    profileContentView(profileDataService: profileDataService)
                } else {
                    AssetSpinner()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.lightgrey)
                }
            }
            .navigationDestination(for: ProfileRoute.self) { destination in
                switch destination {
                case .myNFTs:
                    if let profileDataService = profileDataService,
                       let nftService = services?.nftService {
                        MyNftView(
                            profileDataService: profileDataService,
                            nftService: nftService
                        )
                    }
                case .favoriteNFTs:
                    if let profileDataService = profileDataService,
                       let nftService = services?.nftService {
                        FavouriteNftsView(
                            profileDataService: profileDataService,
                            nftService: nftService
                        )
                    }
                case .profileEditing:
                    if let profileDataService = profileDataService,
                       let services = services {
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
                    .disabled(profileDataService?.isLoading == true)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await initializeProfileDataService()
        }
    }
    
    @ViewBuilder
    private func profileContentView(profileDataService: ProfileDataService) -> some View {
        VStack(alignment: .leading, spacing: Constants.largePadding) {
            HStack(spacing: Constants.basePadding) {
                ProfilePhotoView(avatarString: profileDataService.profile?.avatar ?? "")
                userName(profileDataService: profileDataService)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            personalInfo(profileDataService: profileDataService)
            personalSite(profileDataService: profileDataService)
            
            List {
                Section {
                    ZStack {
                        NavigationLink(value: ProfileRoute.myNFTs) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        HStack {
                            Text(String(localized: "ProfileFlow.MyNft.title") + " (\(profileDataService.profile?.nfts.count ?? 0))")
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
                            Text(String(localized: "ProfileFlow.FavouriteNft.title") + " (\(profileDataService.profile?.likes.count ?? 0))")
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
                .listRowInsets(EdgeInsets(top: Constants.basePadding, leading: 0, bottom: Constants.basePadding, trailing: 0))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .padding(.top, Constants.largePadding * 2)
            
            Spacer()
        }
        .padding(.horizontal, Constants.basePadding)
        .padding(.top, Constants.largePadding)
        .disabled(profileDataService.isLoading)
        .overlay {
            if profileDataService.isLoading {
                AssetSpinner()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.lightgrey)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func initializeProfileDataService() async {
        guard let services = services else {
            print("ServicesAssembly is not available in environment")
            return
        }
        
        let dataService = ProfileDataService(profileService: services.profileService)
        self.profileDataService = dataService
        await dataService.loadProfile()
    }
    
    // MARK: - UI Components
    private func userName(profileDataService: ProfileDataService) -> some View {
        Text(profileDataService.profile?.name ?? "")
            .font(.appBold22)
            .foregroundColor(.blackAndWhite)
    }
    
    private func personalInfo(profileDataService: ProfileDataService) -> some View {
        Text(profileDataService.profile?.description ?? "")
            .font(.appRegular13)
            .foregroundColor(profileDataService.profile?.description != nil ? .blackAndWhite : .gray)
    }
    
    private func personalSite(profileDataService: ProfileDataService) -> some View {
        Group {
            if let website = profileDataService.profile?.website {
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
