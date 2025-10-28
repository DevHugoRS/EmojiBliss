//
//  AvatarViewModel.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import SwiftUI

@MainActor
class AvatarViewModel: ObservableObject {
    @Published var avatars: [UserAvatar] = []
    @Published var searchUsername: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    private let service = AvatarService()
    
    func loadAvatars() {
        avatars = CoreDataManager.shared.searchAvatar()
    } //: FUNC LOAD AVATARS
    
    func searchUser(token: String? = nil) async {
        let username = searchUsername
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = AvatarError.emptyUserName.localizedDescription
            showError = true
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        // MARK: - 1. Check cache
        if let cached = CoreDataManager.shared.searchAvatar()
            .first(where: { $0.login.lowercased() == searchUsername.lowercased() }) {
            
            if !avatars.contains(where: { $0.id == cached.id }) {
                avatars.insert(cached, at: 0)
            }
            searchUsername = ""
            return
        }
        
        // MARK: - 2. Fetch API if no cache
        do {
            let user = try await service.searchAvatar(username: username, token: token)
            CoreDataManager.shared.saveAvatar(user)
            if !avatars.contains(where: { $0.id == user.id }) {
                avatars.insert(user, at: 0)
            }
            searchUsername = ""
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            showError = true
        }
        
    } //: FUNC SEARCH USER
    
    func deleteAvatar(_ avatar: UserAvatar) {
        CoreDataManager.shared.deleteAvatar(avatar)
        avatars.removeAll {
            $0.id == avatar.id
        }
    } //: FUNC DELETE AVATAR
}


/**
 
Funcao SearchUser
 meu chash fist primeiro verifica se o nome do utilizador esta vazio. antes de verificar meu CoreDataManager, se sim ok tudo bem. pega o avatar e adiciona a lista.
 se nao estiver no cach entao ele solicita a AvatarService para ir na API do git
 Se a API responder bem, o view model não o adiciona logo à lista. Primeiro, guardam no cache
 local, core data manager.shared.saveavatar, só depois é que o adiciona à lista de published. Isto garante que
 da próxima vez que se pesquisar por este utilizador, a resposta vem do cache. E claro, tem funções para
 carregar todos os avatares guardados quando a vista aparece, load avatars, e para apagar um, delete avatar,
 que o remove tanto do cache como da lista na UI, mantém tudo sincronizado.
 
 E trata os erros da API,
 atualizando o estado, show error, error message, para a UI poder mostrar um alerta. Muito bem pensado
 
 
 -> EmojiViewModel
 
 **/
