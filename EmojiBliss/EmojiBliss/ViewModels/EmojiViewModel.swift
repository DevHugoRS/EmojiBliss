//
//  EmojiViewModel.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import SwiftUI

@MainActor
class EmojiViewModel: ObservableObject {
    @Published var emojis: [Emoji] = []
    private let service = EmojiService()
    
    func getEmojis() async {
        // MARK: - 1. Try to load the cache
        let cached = CoreDataManager.shared.searchEmojis()
        if !cached.isEmpty {
            emojis = cached
            print("Loaded from cache")
            return
        }
        
        // MARK: - 2. If there is no cache, search from the API
        do {
            let result = try await service.searchEmojis()
            emojis = result
            CoreDataManager.shared.saveEmojis(result)
            print("Loaded from API and saved in cache")
        } catch {
            print("Error searching for Emojis: \(error.localizedDescription)")
        }
        
    }
    
    func getRandomEmoji() -> Emoji? {
        guard !emojis.isEmpty else { return nil }
        return emojis.randomElement()
    }
    
    func removeEmojiFromMemory(_ emoji: Emoji) {
        emojis.removeAll { $0.id == emoji.id }
    }
    
    func reloadFromCache() async {
        emojis = CoreDataManager.shared.searchEmojis()
    }
}
