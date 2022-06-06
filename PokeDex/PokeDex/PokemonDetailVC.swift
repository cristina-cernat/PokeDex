//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by Cristina C on 6/3/22.
//

import UIKit

class PokemonDetailVC: UIViewController, UICollectionViewDataSource {
    


    @IBOutlet weak var imagePokemonDetail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var collectionViewDetail: UICollectionView!
    
    
    var titleText = ""
    var imagePokemon = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleText
        imagePokemonDetail.image = imagePokemon
        collectionViewDetail.dataSource = self
        
        
    }
    
//    func setup(with pokemon: Pokemon) {
//
//    }
//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonDetailCollectionViewCell", for: indexPath) as! PokemonDetailCollectionViewCell

        cell.setup(with: globalPokemon!)
        return cell
    }

}


