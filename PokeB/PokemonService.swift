//
//  PokemonService.swift
//  PokeB
//
//  Created by Oscar Rodriguez Garrucho on 10/5/17.
//  Copyright © 2017 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PokemonService {
    
    // Get 9 random pokemons from API
    func getTopPokemon(completionHandler: @escaping ([[String:String]]?) -> Void) {
        
        var someIds = [Int]()
        var result = [[String:String]]()
        
        for _ in 0 ... 8 {
            var randomNumber = arc4random_uniform(100) // from zero to 8, we caught 9 random pokemons each time
            
            while (someIds.contains(Int(randomNumber))){
                randomNumber = arc4random_uniform(100)
            }
            someIds.append(Int(randomNumber))
            
            self.searchPokemon(byTerm: String(randomNumber)) { pokemons in
                
                if let pokemons = pokemons {
                    
                    for pokemon in pokemons {
                        
                        var newPokemon = [String:String]()
                        newPokemon["id"] = pokemon["id"]
                        newPokemon["name"] = pokemon["name"]
                        newPokemon["height"] = pokemon["height"]
                        newPokemon["weight"] = pokemon["weight"]
                        newPokemon["image"] = pokemon["image"]
                        
                        result.append(newPokemon)
                        
                    }
                    completionHandler(result)
                    
                } else {
                    print("Error while calling REST services")
                    completionHandler(nil)
                }
                
            }
            
        } // for

    }
    
    
    
    
    // Get a pokemon with an ID
    func searchPokemon(byTerm: String, completionHandler: @escaping ([[String:String]]?) -> Void) {
        
        let url = URL(string: "http://pokeapi.co/api/v2/pokemon/" + byTerm)!
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate().responseJSON() { response in
            
            switch response.result {
            case .success:
                
                var result = [[String:String]]()
                
                if let value = response.result.value {
                    
                    let json = JSON(value) // parseamos el JSON con SwiftJson
                    
                    var pokemon = [String:String]()
                    pokemon["id"] = json["id"].stringValue
                    pokemon["name"] = json["name"].stringValue
                    pokemon["height"] = json["height"].stringValue
                    pokemon["weight"] = json["weight"].stringValue
                    pokemon["image"] = json["sprites"]["front_default"].stringValue
                    
                    result.append(pokemon)
                }
                completionHandler(result)
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
            
        }
        
    }
    
    
    
    
    
    
}
