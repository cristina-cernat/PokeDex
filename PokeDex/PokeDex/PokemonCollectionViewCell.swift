//
//  PokemonCollectionViewCell.swift
//  PokeDex
//
//  Created by Cristina C on 6/1/22.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {

    static let identifier = "PokemonCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    static func nib() -> UINib {
        return UINib(nibName: "PokemonCollectionViewCell", bundle: nil)
    }
    
    public func configure(with image: UIImage) {
        imageView.image = image
    }
}
