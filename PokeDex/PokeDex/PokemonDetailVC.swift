//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by Cristina C on 6/3/22.
//

import UIKit

class PokemonDetailVC: UIViewController {

    

    @IBOutlet weak var imagePokemonDetail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var titleText = ""
    var imagePokemon = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleText
        imagePokemonDetail.image = imagePokemon
    }
  

}
