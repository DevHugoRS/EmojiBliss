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

