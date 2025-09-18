//
//  ProfileEditingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Артем Солодовников on 16.09.2025.
//

import SwiftUI

struct ProfileEditingView: View {
    @Environment(\.dismiss) private var dismiss
    var viewModel: ProfileViewModel
    @State private var editedName: String
    @State private var editedDescription: String
    @State private var editedWebsite: String
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self._editedName = State(initialValue: viewModel.userName ?? "")
        self._editedDescription = State(initialValue: viewModel.userDescription ?? "")
        self._editedWebsite = State(initialValue: viewModel.userWebsite ?? "")
    }
    
    var body: some View {
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
            
            LabeledTextEditor(title: "Описание", text: $editedDescription)
            
            LabeledTextField(title: "Сайт", text: $editedWebsite)
            
            Spacer()
            
            Button("Сохранить") {
                
            }
            .buttonStyle(BlackButton())
        }
        .padding(.horizontal, 16)
        
        .toolbar(.hidden, for: .tabBar)
    }
}

//#Preview {
//    ProfileEditingView()
//}
