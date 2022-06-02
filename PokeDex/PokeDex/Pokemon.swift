//
//  Pokemon.swift
//  PokeDex
//
//  Created by Cristina C on 6/2/22.
//

import Foundation

// Model
struct Sprites: Codable {
    let front_default: String?
//    let front_shiny: String?
//    let back_default: String?
//    let back_shiny: String?
}

struct Pokemon: Codable {
    let id: Int
    let name: String
    let sprites: Sprites
    
}
