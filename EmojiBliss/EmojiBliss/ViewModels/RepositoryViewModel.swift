//
//  RepositoryViewModel.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import SwiftUI

@MainActor
class RepositoryViewModel: ObservableObject {
    @Published var repository: [Repository] = []
    private var currentPage = 1
    private var isLoading = false
    
    func searchRepository() async {
        guard !isLoading else { return }
        isLoading = true
        
        currentPage += 1
        isLoading = false
    }
}

