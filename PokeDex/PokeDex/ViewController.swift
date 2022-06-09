//
//  ViewController.swift
//  PokeDex
//
//  Created by Cristina C on 5/31/22.
//

import UIKit

var globalPokemon: Pokemon?

class ViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Local variables
    let networker = NetworkManager.shared
    var myPokemons: [Pokemon?] = []
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PokemonCollectionViewCell.nib(), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        
        for id in 1...20 {
            networker.Pokemons(id: id) { [weak self] pokemon, error in
                
            if let error = error {
                print("error", error)
                    return
                }

            self?.myPokemons += [pokemon]
                
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                }
            }
        }

    }

    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("You tapped \(indexPath.item)")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pokemonDetail") as! PokemonDetailVC
        let pokemon = myPokemons[indexPath.item]
        vc.titleText = pokemon!.name
        
        vc.heightText += String(pokemon!.height)
        vc.weightext += String(pokemon!.weight)
        
        for stat in pokemon!.stats {

            switch stat.stat.name {
            case "hp":
                vc.hpText += String(stat.base_stat)
            case "attack":
                vc.atkText += String(stat.base_stat)
            case "defense":
                vc.defText += String(stat.base_stat)
            case "speed":
                vc.spdText += String(stat.base_stat)

            default:
                print("default")
            }
            
        }
        
        // TODO: refactor with Pokemon.images dictionary
        // MARK: - Set images
        if let data = pokemon!.imageData, let data2 = pokemon!.imageDataBack, let data3 = pokemon!.imageDataShiny, let data4 = pokemon!.imageDataBackShiny {

            if let image1 = UIImage(data: data), let image2 = UIImage(data: data2), let image3 = UIImage(data: data3), let image4 = UIImage(data: data4) {
                vc.images = [image1, image2, image3, image4]
            }
            
        }
        
        present(vc, animated: true)
        
    }
    

}



// MARK: - CollectionView DataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPokemons.count < 20 ? myPokemons.count : 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
        cell.backgroundColor = .red
        
        let pokemon = myPokemons[indexPath.item]
        globalPokemon = pokemon
        cell.title = pokemon?.name
        
        cell.image = nil
        
        // TODO: - refactor with Pokemon.images dictionary
        // MARK: - Set the current cell, download and store img
        networker.image(pokemon: pokemon!, type: .front) { data, error  in
            let img = self.image(data: data)
            DispatchQueue.main.async {
                cell.image = img
                
            // Store image in pokemon structure
            if let data = img?.pngRepresentationData {  // If image type is PNG
                self.myPokemons[indexPath.item]?.imageData = data
            } else if let data = img?.jpegRepresentationData { // If image type is JPG/JPEG
                self.myPokemons[indexPath.item]?.imageData = data
                 }
            }
        }
        
        // MARK: - Download and store other images
        networker.image(pokemon: pokemon!, type: .back) { data, error  in
            let img = self.image(data: data)
            DispatchQueue.main.async {
                
            if let data = img?.pngRepresentationData {  // If image type is PNG
                self.myPokemons[indexPath.item]?.imageDataBack = data
            } else if let data = img?.jpegRepresentationData { // If image type is JPG/JPEG
                self.myPokemons[indexPath.item]?.imageDataBack = data
                 }
            }
        }
        
        networker.image(pokemon: pokemon!, type: .shiny) { data, error  in
            let img = self.image(data: data)
            DispatchQueue.main.async {
                
            if let data = img?.pngRepresentationData {  // If image type is PNG
                self.myPokemons[indexPath.item]?.imageDataShiny = data
            } else if let data = img?.jpegRepresentationData { // If image type is JPG/JPEG
                self.myPokemons[indexPath.item]?.imageDataShiny = data
                 }
            }
        }
        
        networker.image(pokemon: pokemon!, type: .back_shiny) { data, error  in
            let img = self.image(data: data)
            DispatchQueue.main.async {
                
            if let data = img?.pngRepresentationData {  // If image type is PNG
                self.myPokemons[indexPath.item]?.imageDataBackShiny = data
            } else if let data = img?.jpegRepresentationData { // If image type is JPG/JPEG
                self.myPokemons[indexPath.item]?.imageDataBackShiny = data
                 }
            }
        }
        
        for type in PhotoType.allCases {
            setImage(pokemon: pokemon!, type: type, index: indexPath.item)

        }
        return cell
    }
    
    // convert image
    func image(data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        return UIImage(systemName: "picture")
    }
    
    func setImage(pokemon: Pokemon, type: PhotoType, index: Int) {
        networker.image(pokemon: pokemon, type: type) { data, error  in
            let img = self.image(data: data)
            DispatchQueue.main.async {
                
                if let data = img?.pngRepresentationData {
                    self.myPokemons[index]?.imageDataBackShiny = data
                }
                
            }
        }
    }
   
}

// MARK: - CollectionView Delegate Flow Layout
extension UIViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}
