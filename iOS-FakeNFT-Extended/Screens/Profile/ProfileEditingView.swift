//
//  ProfileEditingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 16.09.2025.
//
import SwiftUI

struct ProfileEditingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ProfileEditingViewModel
    @State private var isShowingExitAlert = false
    
    init(profileDataService: ProfileDataService, profileService: ProfileServiceProtocol) {
        self._viewModel = State(initialValue: ProfileEditingViewModel(
            profileDataService: profileDataService,
            profileService: profileService
        ))
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    if let editedAvatar = viewModel.editedAvatar, !editedAvatar.isEmpty {
                        ProfilePhotoView(avatarString: editedAvatar)
                    } else {
                        Image(systemName: "photo")
                            .font(.appBold32)
                            .foregroundColor(.gray)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    }
                    
                    Image(.camera)
                        .frame(width: 23, height: 23)
                        .background(Circle().fill(.lightgrey))
                        .onTapGesture {
                            viewModel.showImageActionDialog = true
                        }
                }
                
                LabeledTextField(title: String(localized: "ProfileFlow.Editing.name"), text: $viewModel.editedName)
                LabeledTextEditor(title: String(localized: "ProfileFlow.Editing.description"), text: $viewModel.editedDescription)
                LabeledTextField(title: String(localized: "ProfileFlow.Editing.site"), text: $viewModel.editedWebsite)
                
                Spacer()
                
                if viewModel.hasChanges && !viewModel.isLoading {
                    Button(String(localized: "ProfileFlow.Editing.save")) {
                        Task {
                            await viewModel.saveProfile()
                            dismiss()
                        }
                    }
                    .buttonStyle(BlackButton())
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 16)
            .disabled(viewModel.isLoading)
            .confirmationDialog(String(localized: "ProfileFlow.PhotoEdit.title"),
                                isPresented: $viewModel.showImageActionDialog,
                                titleVisibility: .visible
            ) {
                Button(String(localized: "ProfileFlow.PhotoEdit.change")) {
                    viewModel.showImageActionDialog = false
                    viewModel.avatarUrlString = viewModel.editedAvatar ?? ""
                    viewModel.showAvatarAlert = true
                }
                Button(String(localized: "ProfileFlow.PhotoEdit.delete"), role: .destructive) {
                    Task {
                        await viewModel.deleteAvatar()
                    }
                }
                Button(String(localized: "ProfileFlow.PhotoEdit.cancel"), role: .cancel) {}
            }
            .alert(String(localized: "ProfileFlow.PhotoEdit.linkTitle"), isPresented: $viewModel.showAvatarAlert) {
                TextField(String(localized: "ProfileFlow.PhotoEdit.enterURL"), text: $viewModel.avatarUrlString)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button(String(localized: "ProfileFlow.PhotoEdit.cancel"), role: .cancel) { }
                Button(String(localized: "ProfileFlow.Editing.save")) {
                    Task {
                        await viewModel.setAvatar(viewModel.avatarUrlString)
                    }
                }
            }
            .alert(String(localized: "ProfileFlow.PhotoEdit.confirmation"), isPresented: $isShowingExitAlert) {
                Button(String(localized: "ProfileFlow.PhotoEdit.stay"), role: .cancel) {}
                Button(String(localized: "ProfileFlow.PhotoEdit.exit")) {
                    dismiss()
                }
            }
            
            if viewModel.isLoading {
                // На дизайне затемнения фона нет, но лоадер теряется в таком случае
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                
                ZStack {
                    Color.lightgrey
                        .frame(width: 82, height: 82)
                        .cornerRadius(8)
                    
                    AssetSpinner()
                        .frame(width: 50, height: 50)
                }
                .zIndex(2)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if viewModel.hasChanges {
                        isShowingExitAlert = true
                    } else {
                        dismiss()
                    }
                }) {
                    Image("NavigationChevronLeft")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}
