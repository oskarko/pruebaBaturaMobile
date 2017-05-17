//
//  ListViewController.swift
//  PokeB
//
//  Created by Oscar Rodriguez Garrucho on 10/5/17.
//  Copyright © 2017 Oscar Rodriguez Garrucho. All rights reserved.
//

import UIKit
import Kingfisher

class ListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var pokemons : [Pokemon] = [Pokemon]()
    var collectionViewPadding : CGFloat = 0
    let refresh = UIRefreshControl()
    let dataProvider = LocalCoreDataService()
    
    var tapGesture : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        getData()
        
        refresh.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        collectionView.refreshControl?.tintColor = UIColor.white
        
        collectionView.refreshControl = refresh
        
        setCollectionViewPadding()

        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 170)
    }
    
    
    
    
    // métodos de la SearchBox
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.view.addGestureRecognizer(self.tapGesture)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    
    func hideKeyboard() {
        self.searchBar.resignFirstResponder()
        self.view.removeGestureRecognizer(self.tapGesture)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            dataProvider.searchPokemon(byTerm: term) { pokemons in
                
                if let pokemons = pokemons {
                    self.pokemons = pokemons
                    //en segundo plano
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        searchBar.resignFirstResponder()
                    }
                }
                
            }
        }
    }
    
    
    func getData() {
        
        dataProvider.getTopPokemons(localHandler: { pokemons in
            
            if let pokemons = pokemons {
                self.pokemons = pokemons
                //en segundo plano, de forma asíncrona
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                print("No hay registros en Core Data")
            }
            
        }, remoteHandler: { pokemons in
            
            if (self.pokemons.count == 0){
            if let pokemons = pokemons {
                self.pokemons = pokemons
                //en segundo plano, de forma asíncrona
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.refresh.endRefreshing() // para el spinner
                }
            }
            }
            
        })
        
    }

    
    // First, load from Core Data (getLoad). Then call WS to get new pokemons and save them in database.
    func loadData() {
        
        dataProvider.getTopPokemons(localHandler: { pokemons in
            
            // call to Web Service
            
        }, remoteHandler: { pokemons in
            
                if let pokemons = pokemons {
                    self.pokemons = pokemons
                    //en segundo plano, de forma asíncrona
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.refresh.endRefreshing() // para el spinner
                    }
                }

        })
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" {
            
            if let indexPathSelected = collectionView.indexPathsForSelectedItems?.last {
                let selectedPokemon = pokemons[indexPathSelected.row]
                let detailVC = segue.destination as! PokemonViewController
                detailVC.pokemon = selectedPokemon
            }
            hideKeyboard()
        }
    }
    
    
    
    
    
    
    
    

   
}
