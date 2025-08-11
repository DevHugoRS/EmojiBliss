//
//  UserAvatar.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import Foundation

struct UserAvatar: Identifiable, Codable { //: Busca o Avatar
    let id: Int
    let login: String
    let avatarUrl: String
}
