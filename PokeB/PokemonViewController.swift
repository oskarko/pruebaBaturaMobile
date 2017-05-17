//
//  PokemonViewController.swift
//  PokeB
//
//  Created by Oscar Rodriguez Garrucho on 11/5/17.
//  Copyright © 2017 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit
import Kingfisher

class PokemonViewController: UIViewController {

    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonHeight: UILabel!
    @IBOutlet weak var pokemonWeight: UILabel!

    let dataProvider = LocalCoreDataService()
    var pokemon : Pokemon?
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let pokemon = pokemon {
            
            if let image = pokemon.image {
                pokemonImage.kf.setImage(with: ImageResource(downloadURL: URL(string: image)!))
            }
            
            //movieTitle.text = pokemon.title
            
            //self.title = pokemon.title
            
            pokemonHeight.text = pokemon.height
            pokemonWeight.text = pokemon.weight 
            pokemonName.text = pokemon.name
            
            configureFavoriteButton()
            
        }
    }

    
    func configureFavoriteButton() {
        
        if let pokemon = self.pokemon {
            if dataProvider.isPokemonFavorite(pokemon: pokemon) {
                btnFavorite.setBackgroundImage(#imageLiteral(resourceName: "btn-on"), for: .normal)
                btnFavorite.setTitle("Dejar libre", for: .normal)
            } else {
                btnFavorite.setBackgroundImage(#imageLiteral(resourceName: "btn-off"), for: .normal)
                btnFavorite.setTitle("!Atrápalo!", for: .normal)
            }
        }
    }
   

    @IBAction func favoritePressed(_ sender: UIButton) {
        
        if let pokemon = self.pokemon {
            dataProvider.markUnmarkFavorite(pokemon: pokemon)
            configureFavoriteButton()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    

    
    
}
