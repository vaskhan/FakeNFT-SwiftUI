//
//  ProfileEditingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 16.09.2025.
//
import SwiftUI

struct ProfileEditingView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable private var viewModel: ProfileViewModel // Используем Bindable для наблюдения
    @State private var editedName: String
    @State private var editedDescription: String
    @State private var editedWebsite: String
    
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
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    ProfilePhotoView()
                    
                    Image(.camera)
                    .frame(width: 23, height: 23)
                    .background(
                        Circle()
                        .fill(.lightgrey)
                    )
                }
                
                LabeledTextField(title: "Имя", text: $editedName)
                    .disabled(viewModel.isLoading) // Блокируем поле при загрузке
                
                LabeledTextEditor(title: "Описание", text: $editedDescription)
                    .disabled(viewModel.isLoading)
                
                LabeledTextField(title: "Сайт", text: $editedWebsite)
                    .disabled(viewModel.isLoading)
                
                Spacer()
                
                if hasChanges && !viewModel.isLoading {
                    Button("Сохранить") {
                        Task {
                            await viewModel.setUserInfo(
                                name: editedName,
                                description: editedDescription,
                                website: editedWebsite
                            )
                        }
                    }
                    .buttonStyle(BlackButton())
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 16)
            .disabled(viewModel.isLoading) // Блокируем всю форму при загрузке
            
            // Показываем лоадер поверх всего контента
            if viewModel.isLoading {
                Color.lightgrey
                    .frame(width: 82, height: 82)
                    .cornerRadius(8)
                
                AssetSpinner()
                    .frame(width: 50, height: 50)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

//#Preview {
//    ProfileEditingView(viewModel: <#ProfileViewModel#>)
//}
