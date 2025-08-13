//
//  Repository.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import Foundation

struct Repository: Identifiable, Codable, Equatable { // Repositorio Apple
    let id: Int
    let fullName: String
    let isPrivate: Bool
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case isPrivate = "private"
        case description
    }
}
