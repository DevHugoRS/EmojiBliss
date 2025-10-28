//
//  UserAvatar.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import Foundation

///  Definição da Estrutura de Avatares de Usuário: A estrutura UserAvatar é definida para representar o avatar de um usuário, incluindo id, login e avatarUrl.
///  Também conforma a Identifiable, Codable e Equatable. A chave avatarUrl é mapeada de avatar_url para facilitar a decodificação de JSON.
struct UserAvatar: Identifiable, Codable, Equatable {
    let id: Int
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarUrl = "avatar_url"
    }
}

/**
 
 - Depois o UserAvatar, tem ID que éo numero, tem o login e o avatarURL, novamente o Codable para decodificar json e codificar para salvar
 E o Equatable para comparar dois avatares, util para evitar duplicacao
 
 e um detalhe é o uso do CodingKeys a API do GitHub manda Avatar URL com underscore, mas a conversao em swift é avatar URL,
 CondigKeys faz a traducao.
 
 -> Repository
 
 **/
