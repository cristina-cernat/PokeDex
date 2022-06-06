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
   // let url = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"
    // number.png; /shiny/number.png; /back.png; /back/shiny/number.png
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PokemonCollectionViewCell.nib(), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        
        // networker.getPokemons() { [weak self] pokemons, wrror in <error etc> self?.myPomekons = pokemons!
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
       // globalPokemon = pokemon
//        vc.setup(with: pokemon)
        
        
        if let data = pokemon!.imageData {
            // TODO: set image
            vc.imagePokemon = UIImage(data: data)!
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
        
        // MARK: - Download and store back image
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
        
        
        return cell
    }
    
    // convert image
    func image(data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        return UIImage(systemName: "picture")
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
