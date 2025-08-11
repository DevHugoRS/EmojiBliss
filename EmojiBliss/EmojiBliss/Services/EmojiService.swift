//
//  EmojiService.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import Foundation

class EmojiService {
    func searchEmojis() async throws -> [Emoji] {
        guard let url = URL(string: "https://api.github.com/emojis") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpAnswer = response as? HTTPURLResponse,
              httpAnswer.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let rawEmojis = try JSONDecoder().decode([String: String].self, from: data)
        
        return rawEmojis.map { Emoji(name: $0.key, url: $0.value) }
        
    } //: FUNC
} //: CLASS EMOJI SERVICE
