//
//  RepositoryService.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 12/08/25.
//

import Foundation

enum RepositoryError: LocalizedError {
    case rateLimited
    case http(Int)
    
    var errorDescription: String? {
        switch self {
        case .rateLimited: return "GitHub request limit reached (403). Please try again later."
        case .http(let code): return "HTTP error \(code) while fetching repositories."
        }
    }
}

final class RepositoryService {
    func searchRepository(page: Int, perPage: Int = 10, token: String? = nil) async throws -> [Repository] {
        var components = URLComponents(string: "https://api.github.com/users/apple/repos")!
        components.queryItems = [
            .init(name: "per_page", value: String(perPage)),
            .init(name: "page", value: String(page))
        ]
        guard let url = components.url else { throw URLError(.badURL) }
        
        var requisition = URLRequest(url: url)
        requisition.httpMethod = "GET"
        requisition.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        requisition.setValue("Emoji Bliss", forHTTPHeaderField: "User-Agent")
        if let token, !token.isEmpty {
            requisition.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: requisition)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        
        print(String(data: data, encoding: .utf8) ?? "Sem bory")
        print("Status Code:", http.statusCode)
        
        switch http.statusCode {
        case 200:
            return try JSONDecoder().decode([Repository].self, from: data)
        case 403:
            throw RepositoryError.rateLimited
        default:
            throw RepositoryError.http(http.statusCode)
        }
    } //: FUNC SEARCH REPOSITORY
} //: CLASS REPOSITORY SERVICE
