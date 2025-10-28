//
//  RepositoryViewModel.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import SwiftUI

@MainActor
final class RepositoryViewModel: ObservableObject {
    @Published var repository: [Repository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private var currentPage = 1
    private let perPage = 10
    private let service = RepositoryService()
    private var hasMore = true
    
    func loadFirstpage() async {
        guard repository.isEmpty else { return }
        await searchNextPage()
    }
    
    func searchNextPage() async {
        guard !isLoading, hasMore else { return }
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newRepository = try await service.searchRepository(page: currentPage, perPage: perPage)
            
            if newRepository.count < perPage { hasMore = false }
            
            let existingIDs = Set(repository.map { $0.id })
            let filtered = newRepository.filter { !existingIDs.contains($0.id) }
            
            repository.append(contentsOf: filtered)
            currentPage += 1
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            showError = true
        }
    } //: FUNC SEARCH NEXT PAGE
} //: CLASS REPOSITORY VIEWMODEL

/**
 
 E o RepositoryViewModel. Bem, este lida com aquele desafio clássico: listas que
 podem ser enormes. Não queremos carregar tudo de uma vez. Paginação, portanto. Ele controla o estado da
 paginação, qual a página atual, current page, quantos itens por página, per page, aqui está fixo em 10, e o
 indicador has more, para saber se a API ainda tem mais coisas para dar. A função search next page é a chave.
 
 Só executa se não estiver já a carregar, is loading é falso, e se has more for verdadeiro. Aí marca is loading
 como true para mostrar o indicador na UI, chama o repository service para buscar a página seguinte.Um
 ponto importante, se a API devolver menos itens do que os pedidos per page, ele percebe que chegou ao fim
 e mete has more a falso. Sim, para não continuar a pedir.
 
 ele filtra aqueles cujo ID já existe na lista. Isto evita duplicados caso
 haja alguma sobreposição entre chamadas.
 
 
 
**/
