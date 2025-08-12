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
        
        //: 1. Check cache
        if let cached = CoreDataManager.shared.searchAvatar()
            .first(where: { $0.login.lowercased() == searchUsername.lowercased() }) {
            
            if !avatars.contains(where: { $0.id == cached.id }) {
                avatars.insert(cached, at: 0)
            }
            searchUsername = ""
            return
        }
        
        //: 2. Fetch API if no cache
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
        //: 3 Save to Core Data
        
    } //: FUNC SEARCH USER
    
    func deleteAvatar(_ avatar: UserAvatar) {
        CoreDataManager.shared.deleteAvatar(avatar)
        avatars.removeAll {
            $0.id == avatar.id
        }
    } //: FUNC DELETE AVATAR
}
