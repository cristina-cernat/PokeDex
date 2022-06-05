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
    let front_default: String? // url
//    let front_shiny: String?
//    let back_default: String?
//    let back_shiny: String?
}

struct Pokemon: Codable {
    let id: Int
    let name: String
    let sprites: Sprites
    
    // non j-son properties
    var imageData: Data?
}

extension UIImage {

        var pngRepresentationData: Data? {
            return self.pngData()
        }

        var jpegRepresentationData: Data? {
            return self.jpegData(compressionQuality: 1.0)
        }
    }
