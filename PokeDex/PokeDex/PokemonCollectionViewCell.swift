//
//  PokemonCollectionViewCell.swift
//  PokeDex
//
//  Created by Cristina C on 6/1/22.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {

    static let identifier = "PokemonCollectionViewCell"
    
    @IBOutlet weak var imagePokemon: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var image: UIImage? {
        didSet {
          imagePokemon.image = image
        }
    }
    
    var title: String? {
        didSet {
          titleLabel.text = title
        }
      }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    static func nib() -> UINib {
        return UINib(nibName: "PokemonCollectionViewCell", bundle: nil)
    }
    
    
}
