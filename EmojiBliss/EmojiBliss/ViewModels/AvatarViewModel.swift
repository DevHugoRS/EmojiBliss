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
    
    func searchUser(username: String) async {
        //: 1. Chegar cache
        
        //: 2. Buscar API se nao houver cache
        
        //: 3 Salvar no Core Data
    }
}
