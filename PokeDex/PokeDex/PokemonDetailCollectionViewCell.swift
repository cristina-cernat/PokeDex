//
//  PokemonDetailCollectionViewCell.swift
//  PokeDex
//
//  Created by Cristina C on 6/6/22.
//

import UIKit

class PokemonDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagePokemon: UIImageView!
    
    func setup(with image: UIImage) {
        imagePokemon.image = image
        self.isHidden = false
        imagePokemon.backgroundColor = .red
        
    }
    
}
