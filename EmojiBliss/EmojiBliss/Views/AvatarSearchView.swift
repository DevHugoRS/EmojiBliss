//
//  AvatarSearchView.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 12/08/25.
//

import SwiftUI

struct AvatarSearchView: View {
//    MARK: - PROPERTIES
    @StateObject private var viewModel = AvatarViewModel()
    
//    MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                TextField("Enter the username", text: $viewModel.searchUsername)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                Button("Search") {
                    Task {
                        await viewModel.searchUser()
                    }
                } //: BUTTON
                .buttonStyle(.borderedProminent)
            } //: HSTACK
            .padding()
            
            List(viewModel.avatars) { avatar in
                HStack {
                    AsyncImage(url: URL(string: avatar.avatarUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    
                    Text(avatar.login)
                } //: HSTACK
            } //: LIST
        } //: VSTACK
        .navigationTitle("Search Avatar")
        .onAppear {
            viewModel.loadAvatars()
        }
        .alert("Erro", isPresented: $viewModel.showError) {
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred.")
        }
    }
}

//    MARK: - PREVIEW
#Preview {
    AvatarSearchView()
}

/**  AvatarSearchView, e é bastante direta. Tem um campo de texto para o nome do utilizador, um botão "search" e uma lista
 para mostrar os resultados. E o que posso da destaque o uso do async image, sabe? Em vez de
 bloquear tudo enquanto carrega a imagem do avatar. Sim, isso é crucial. Exato. Ele mostra um indicador de
 progresso, aquele progress view, e carrega a imagem por trás. Isso faz uma diferença brutal na fluidez,
 principalmente se a net estiver mais lenta.
 
 Bom a gestao do estado fica por conta da AvatarViewModel e esta ligada com @StateObject ou at StateObject
 
 
 ->  AvatarListView 
 
 **/
