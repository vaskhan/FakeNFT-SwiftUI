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
    
    init(profileViewModel: ProfileViewModel, profileService: ProfileServiceProtocol) {
        self._viewModel = State(
            initialValue: ProfileEditingViewModel(
                profileViewModel: profileViewModel,
                profileService: profileService
            )
        )
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    if let editedAvatar = viewModel.editedAvatar, !editedAvatar.isEmpty {
                        ProfilePhotoView(avatarString: editedAvatar)
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 100)
                    }
                    
                    Image(.camera)
                        .frame(width: 23, height: 23)
                        .background(Circle().fill(.lightgrey))
                        .onTapGesture {
                            viewModel.showImageActionDialog = true
                        }
                }
                
                LabeledTextField(title: "Имя", text: $viewModel.editedName)
                LabeledTextEditor(title: "Описание", text: $viewModel.editedDescription)
                LabeledTextField(title: "Сайт", text: $viewModel.editedWebsite)
                
                Spacer()
                
                if viewModel.hasChanges && !viewModel.isLoading {
                    Button("Сохранить") {
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
            .confirmationDialog("Фото профиля",
                isPresented: $viewModel.showImageActionDialog,
                titleVisibility: .visible
            ) {
                Button("Изменить фото") {
                    viewModel.showImageActionDialog = false
                    viewModel.avatarUrlString = viewModel.editedAvatar ?? ""
                    viewModel.showAvatarAlert = true
                }
                Button("Удалить фото", role: .destructive) {
                    Task {
                        await viewModel.deleteAvatar()
                    }
                }
                Button("Отмена", role: .cancel) {}
            }
            .alert("Ссылка на фото", isPresented: $viewModel.showAvatarAlert) {
                TextField("Введите URL", text: $viewModel.avatarUrlString)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button("Отмена", role: .cancel) { }
                Button("Сохранить") {
                    Task {
                        await viewModel.setAvatar(viewModel.avatarUrlString)
                    }
                }
            }
            
            if viewModel.isLoading {
                Color.lightgrey
                    .frame(width: 82, height: 82)
                    .cornerRadius(8)
                
                AssetSpinner()
                    .frame(width: 50, height: 50)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image("NavigationChevronLeft")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    ProfileEditingView(viewModel: <#ProfileViewModel#>)
//}
