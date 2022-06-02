//
//  Pokemon.swift
//  PokeDex
//
//  Created by Cristina C on 6/2/22.
//

import Foundation

// Model
struct Image: Codable {
    let image: String
}

struct Pokemon: Codable {
    let id: String
    let name: String
    let imageSprites: [Image]
    
}
