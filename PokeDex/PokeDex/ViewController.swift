//
//  ViewController.swift
//  PokeDex
//
//  Created by Cristina C on 5/31/22.
//

import UIKit

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

    
    

}

// MARK: - CollectionView Delegate
extension UIViewController: UICollectionViewDelegate { // helps pickup interactions with the cells
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("You tapped me \(indexPath.item)")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pokemonDetail") as! PokemonDetailVC
//        vc.imagePokemon =
      //  present(vc, animated: true)
        
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
        cell.title = pokemon?.name
        
        cell.image = nil
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "pokemonDetail") as! PokemonDetailVC

        networker.image(pokemon: pokemon!) { data, error  in
            let img = self.image(data: data)
            DispatchQueue.main.async {
                cell.image = img
                vc.imagePokemon = img ?? UIImage(systemName: "picture")!
            }
        }
        
        
        return cell
    }
    
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
