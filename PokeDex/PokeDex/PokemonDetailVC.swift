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
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var atkLabel: UILabel!
    @IBOutlet weak var defLabel: UILabel!
    @IBOutlet weak var spdLabel: UILabel!
    
    
    @IBOutlet weak var collectionViewDetail: UICollectionView!
    
    var titleText = ""
    var imagePokemon = UIImage()
    var images: [UIImage]?
    
//    var statsDict: [String:String] = ["weight": "", "height": "", "hp": "", "atk": "", "def": "", "spd": ""]

    
    var weightext = "Weight: "
    var heightText = "Height: "
    var hpText = "HP: "
    var atkText = "ATK: "
    var defText = "DEF: "
    var spdText = "SPD: "

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleText
        
        weightLabel.text = weightext
        heightLabel.text = heightText
        hpLabel.text = hpText
        atkLabel.text = atkText
        defLabel.text = defText
        spdLabel.text = spdText
        
        collectionViewDetail.dataSource = self
        
        collectionViewDetail.reloadData()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonDetailCollectionViewCell", for: indexPath) as! PokemonDetailCollectionViewCell
    
        if let safeImages = images {
            cell.setup(with: safeImages[indexPath.item])
        }
        
        return cell
    }

}


