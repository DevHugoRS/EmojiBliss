//
//  RepositoryListView.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 12/08/25.
//

import SwiftUI

struct RepositoryListView: View {
//    MARK: - PROPERTIES
    @StateObject private var viewModel = RepositoryViewModel()
    
//    MARK: - BODY
    var body: some View {
        List {
            ForEach(viewModel.repository) { repo in
                VStack(alignment: .leading, spacing: 4) {
                    Text(repo.fullName)
                        .font(.headline)
                    Text(repo.isPrivate ? "Private" : "Public")
                        .font(.subheadline)
                        .foregroundStyle(repo.isPrivate ? .red : .green)
                } //: HSTACK
                .padding(.vertical, 6)
                .onAppear {
                    if repo.id == viewModel.repository.last?.id {
                        Task { await viewModel.searchNextPage() }
                    }
                }
            }
            
            if viewModel.isLoading {
                ProgressView("Loading…")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        } //: LIST
        .navigationTitle("Apple Repository")
        .task {
            await viewModel.loadFirstpage()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred.")
        }
    }
}
//    MARK: - PREVIEW
#Preview {
    RepositoryListView()
}
