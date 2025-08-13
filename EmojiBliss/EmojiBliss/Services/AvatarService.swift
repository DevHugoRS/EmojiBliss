//
//  AvatarService.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import Foundation

enum AvatarError: LocalizedError {
    case emptyUserName
    case notFound
    case rateLimited
    case http(Int)
    
    var errorDescription: String? {
        switch self {
        case .emptyUserName:
            return "Username is required."
        case .notFound:
            return "User not found."
        case .rateLimited:
            return "Rate limited. Please try again later."
        case .http(let code):
            return "HTTP error \(code)."
        }
    }
}

class AvatarService {
    func searchAvatar(username: String, token: String? = nil) async throws -> UserAvatar {
        let clean = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { throw AvatarError.emptyUserName }
        
        let base = URL(string: "https://api.github.com/users/")!
        let url = base.appendingPathComponent(clean)
        
        var requisition = URLRequest(url: url)
        requisition.httpMethod = "GET"
        requisition.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        requisition.setValue("EmojiBliss", forHTTPHeaderField: "User-Agent")
        if let token = token {
            requisition.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: requisition)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        //:  Status code handling
        switch http.statusCode {
        case 200:
            break
        case 404:
            throw AvatarError.notFound
        case 429:
            throw AvatarError.rateLimited
        default:
            throw AvatarError.http(http.statusCode)
        }
        
        return try JSONDecoder().decode(UserAvatar.self, from: data)
    }
}
