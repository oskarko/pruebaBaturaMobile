//
//  FavoritesViewController.swift
//  PokeB
//
//  Created by Oscar Rodriguez Garrucho on 11/5/17.
//  Copyright © 2017 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit
import Kingfisher

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewPadding: CGFloat = 0
    let dataProvider = LocalCoreDataService()
    var pokemons: [Pokemon] = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        setCollectionViewPadding()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    

    func setCollectionViewPadding() {
        
        let screenWidth = self.view.frame.width
        collectionViewPadding = (screenWidth - (3 * 113))/4
    }
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionViewPadding, left: collectionViewPadding, bottom: collectionViewPadding, right: collectionViewPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return collectionViewPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 170)
    }
    
    // para colocar el número de item sobre el icono
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if pokemons.count > 0 {
            self.collectionView.backgroundView = nil
        } else {
            let imageView = UIImageView(image: UIImage(named: "sin-favoritos"))
            imageView.contentMode = .center
            self.collectionView.backgroundView = imageView
        }
        return pokemons.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        
        let pokemon = pokemons[indexPath.row]
        
        self.configureCell(cell, withPokemon: pokemon)
        
        return cell
    }
    
    
    func configureCell(_ cell: PokemonCell, withPokemon pokemon: Pokemon) {
        
        if let imageData = pokemon.image {
            cell.pokemonImage.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!), placeholder: #imageLiteral(resourceName: "img-loading"), options: nil, progressBlock: nil, completionHandler: nil)
            
        }
    }

    
    
    
    func loadData() {
        if let pokemons = dataProvider.getFavoritePokemons() {
            
            self.pokemons = pokemons
            self.collectionView.reloadData() // refresh collectionView!
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" {
            
            if let indexPathSelected = collectionView.indexPathsForSelectedItems?.last {
                let selectedPokemon = pokemons[indexPathSelected.row]
                let detailVC = segue.destination as! PokemonViewController
                detailVC.pokemon = selectedPokemon
            }
       
        }
    }

    
    
}
