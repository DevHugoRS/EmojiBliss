//
//  Repository.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import Foundation

///  Definição da Estrutura de Repositórios GitHub: A estrutura Repository é definida para representar um repositório GitHub, incluindo id, fullName, isPrivate e description.
///  Conformada a Identifiable, Codable e Equatable. As chaves fullName e isPrivate são mapeadas de full_name e private, respectivamente.

struct Repository: Identifiable, Codable, Equatable {
    let id: Int
    let fullName: String
    let isPrivate: Bool
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case isPrivate = "private"
        case description
    }
}

/**
 
Tem o Repositorio que segue a mesma Logica, e novamente o Codingkeys para mapear o FullName e private da API
 
 - para viewModel tres view Model,
 Todas segue o padrao ObservableObjct do swiftUI isso combinado com at Publish nas variaveis que guardam os dados
 
 -> AvatarViewModel
 
**/
