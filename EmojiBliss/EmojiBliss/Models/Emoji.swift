//
//  Emoji.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import Foundation

struct Emoji: Identifiable, Codable {
    var id: String { name }
    let name: String
    let url: String
}



/**
 
 E essa interface toda, claro, depende de estruturas de dados bem definidas para
 funcionar. Temos a struct em Swift, que representa os dados, os que vêm da API e os que usamos na UI. A
 Emoji, . Tem um name que também serve de ID, de identificador único, e a URL
 da imagem. Ser codable é fundamental aqui
 Aqui Codable para converter facilmente o JSON da API nesta estrutura emoji, e vice-versa, se quiséssemos salvar
 ou enviar
 
 -> UserAvatar
 
 **/
