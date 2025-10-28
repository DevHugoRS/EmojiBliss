//
//  NetworkService.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import Foundation



class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func searchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpAnswer = response as? HTTPURLResponse,
              httpAnswer.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    } //: FUNC SEARCH DATA
} //: CLASS NETWORKSERVICE
