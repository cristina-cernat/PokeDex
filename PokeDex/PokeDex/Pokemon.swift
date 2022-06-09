//
//  Pokemon.swift
//  PokeDex
//
//  Created by Cristina C on 6/2/22.
//

import Foundation
import UIKit

// Model
struct Sprites: Codable {
    // MARK: URLs
    let front_default: String?
    let front_shiny: String?
    let back_default: String?
    let back_shiny: String?
}

// MARK: - Pokemons + properties to store
struct Pokemon: Codable {
    let id: Int
    let name: String
    let sprites: Sprites
    let weight: Int
    let height: Int
    let stats: [Stats]
    
    // non j-son properties
    // TODO: use this dict
    var images: [String: Data]?
    
    var imageData: Data?
    var imageDataBack: Data?
    var imageDataShiny: Data?
    var imageDataBackShiny: Data?
}

struct Stats: Codable {
    let base_stat: Int // the actual value for the stat
    let stat: Stat
}

struct Stat: Codable {
    let name: String
}

extension UIImage {

        var pngRepresentationData: Data? {
            return self.pngData()
        }

        var jpegRepresentationData: Data? {
            return self.jpegData(compressionQuality: 1.0)
        }
    }
