//
//  Emoji.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import Foundation

struct Emoji: Identifiable, Codable {
    var id: String { name }
    let name: String
    let url: String
}
