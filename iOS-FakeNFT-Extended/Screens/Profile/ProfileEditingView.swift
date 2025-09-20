//
//  ProfileEditingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 16.09.2025.
//

import SwiftUI

struct ProfileEditingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ProfileViewModel
    @State private var editedName: String
    @State private var editedDescription: String
    @State private var editedWebsite: String
    @State private var editedAvatar: URL?
    @State private var showImageActionDialog = false
    @State private var showAvatarAlert = false
    @State private var avatarUrlString = ""
    @State private var isSaving = false
    
    private var hasChanges: Bool {
        editedName != viewModel.userName ||
        editedDescription != viewModel.userDescription ||
        editedWebsite != viewModel.userWebsite
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self._editedName = State(initialValue: viewModel.userName ?? "")
        self._editedDescription = State(initialValue: viewModel.userDescription ?? "")
        self._editedWebsite = State(initialValue: viewModel.userWebsite ?? "")
        self._editedAvatar = State(initialValue: viewModel.userAvatar)
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    if let url = editedAvatar {
                        ProfilePhotoView(avatarUrl: url)
                    }
                    
                    Image(.camera)
                    .frame(width: 23, height: 23)
                    .background(
                        Circle()
                        .fill(.lightgrey)
                    )
                    .onTapGesture {
                        showImageActionDialog = true
                    }
                }
                
                LabeledTextField(title: "Имя", text: $editedName)
                
                LabeledTextEditor(title: "Описание", text: $editedDescription)
                
                LabeledTextField(title: "Сайт", text: $editedWebsite)
                
                Spacer()
                
                if hasChanges && !viewModel.isLoading {
                    Button("Сохранить") {
                        Task {
                            isSaving = true
                            await viewModel.setUserInfo(
                                name: editedName,
                                description: editedDescription,
                                website: editedWebsite
                            )
                            // Обновляем локальные состояния после успешного сохранения
                            editedName = viewModel.userName ?? ""
                            editedDescription = viewModel.userDescription ?? ""
                            editedWebsite = viewModel.userWebsite ?? ""
                            isSaving = false
                        }
                    }
                    .buttonStyle(BlackButton())
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 16)
            .disabled(viewModel.isLoading) // Блокируем всю форму при загрузке
            .confirmationDialog("Фото профиля", isPresented: $showImageActionDialog, titleVisibility: .visible) {
                Button("Изменить фото") {
                    showImageActionDialog = false
                    
                    avatarUrlString = viewModel.userAvatar?.absoluteString ?? ""
                    showAvatarAlert = true
                }
                Button("Удалить фото", role: .destructive) {
                    // Обработка удаления фото
                }
                Button("Отмена", role: .cancel) {}
            }
            .alert("Ссылка на фото", isPresented: $showAvatarAlert) {
                TextField("Введите URL", text: $avatarUrlString)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Button("Отмена", role: .cancel) {
                    
                }
                Button("Сохранить") {
                    if let url = URL(string: avatarUrlString) {
                        editedAvatar = url
                        Task {
                            await viewModel.setUserAvatar(avatar: url)
                        }
                        
                    } else {
                        editedAvatar = nil
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
    }
}

//#Preview {
//    ProfileEditingView(viewModel: <#ProfileViewModel#>)
//}
