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

/**
 
 EmojiViewModel segue o mesmo padrao com GetEmojis verifica no cache primeiro se encontra usa o emoji, se o cache estiver vazio ai sim usa o emojiSevice para buscar
 
 Se correr bem, guarda os resultados no cache, core datamanager.savemojis, e
depois atualiza a propriedade at published emojis. Uma função interessante é a remove emoji from memory.
Ela remove o emoji da lista at published emojis, o que o faz desaparecer da grelha na emoji list view. Mas, e
este é o ponto, não o apaga do cache persistente no core data. Ah, interessante. Só da memória visual,
digamos assim. Exato. Isso permite que ele reapareça se a lista for recarregada do cache, por exemplo, com o
refreshable. A reload from cache faz precisamente isso. Vai buscar tudo de novo ao core data. Faz sentido
para esse caso de uso. E o repository view model. Bem, este lida com aquele desafio clássico: listas que
podem ser enormes.
 
 -> RepositoryViewModel
 
 
 
**/
