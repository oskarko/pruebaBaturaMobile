//
//  LocalCoreDataService.swift
//  PokeB
//
//  Created by Oscar Rodriguez Garrucho on 10/5/17.
//  Copyright © 2017 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation
import CoreData

class LocalCoreDataService {
    
    let pokemonService = PokemonService()
    let stack = CoreDataStack.sharedInstance
    
    func searchPokemon(byTerm: String, remoteHandler: @escaping ([Pokemon]?) -> Void) {
        
        pokemonService.searchPokemon(byTerm: byTerm) { pokemons in
            
            if let pokemons = pokemons {
                
                var modelPokemons = [Pokemon]()
                for pokemon in pokemons {
                    
                    let modelPokemon = Pokemon(id: pokemon["id"], name: pokemon["name"], weight: pokemon["weight"]!, height: pokemon["height"]!, image: pokemon["image"])
                    modelPokemons.append(modelPokemon)
                }
                remoteHandler(modelPokemons)
                
            } else {
                print("Error while calling REST services")
                remoteHandler(nil)
            }
            
        }
        
    }
    
    
    func getTopPokemons(localHandler: ([Pokemon]?) -> Void, remoteHandler: @escaping ([Pokemon]?) -> Void) {
        
        localHandler(self.queryTopPokemons())
        
        pokemonService.getTopPokemon() { pokemons in
            
            if let pokemons = pokemons {
                
                self.markAllPokemonsAsUnsync()
                
                var order = 1
                
                for pokemonDictionary in pokemons {
                    
                    if let pokemon = self.getPokemonById(id: pokemonDictionary["id"]!, favorite: false) {
                        
                        // update
                        self.updatePokemon(pokemonDictionary: pokemonDictionary, pokemon: pokemon, order: order)
                        
                    } else {
                        
                        // insert
                        self.insertPokemon(pokemonDictionary: pokemonDictionary, order: order)
                    }
                    
                    order += 1
                    
                }
                self.removeOldNotFavoritePokemons()
                
                remoteHandler(self.queryTopPokemons()) // devuelve de la base de datos
                
            } else {
                remoteHandler(nil)
            }
            
        }
        
        
        
    }
    
    
    func queryTopPokemons() -> [Pokemon]? {
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<PokemonManaged> = PokemonManaged.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "favorite = \(false)")
        request.predicate = predicate
        
        do {
            
            let fetchedPokemons = try context.fetch(request)
            
            var pokemons = [Pokemon]()
            for managedPokemon in fetchedPokemons {
                
                pokemons.append(managedPokemon.mappedObject())
            }
            return pokemons
            
        } catch {
            print("Error while getting pokemons from Core Data")
            return nil
        }
        
    }
    
    
    func markAllPokemonsAsUnsync() {
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<PokemonManaged> = PokemonManaged.fetchRequest()
        
        let predicate = NSPredicate(format: "favorite = \(false)")
        request.predicate = predicate

        do {
            
            let fetchedPokemons = try context.fetch(request)
        
            for managedPokemon in fetchedPokemons {
                
               managedPokemon.sync = false
            }

            try context.save()
            
        } catch {
            print("Error while updating Core Data")
        }

        
    }
    
    
    
    func getPokemonById(id: String, favorite: Bool) -> PokemonManaged? {
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<PokemonManaged> = PokemonManaged.fetchRequest()
        
        let predicate = NSPredicate(format: "id = \(id) and favorite = \(favorite)")
        request.predicate = predicate
        
        do {
            
            let fetchedPokemons = try context.fetch(request)
            if fetchedPokemons.count > 0 {
                return fetchedPokemons.last
            } else {
                return nil
            }
            
        } catch {
            print("Error while getting pokemon from Core Data")
            return nil
        }
        
    }
    
    
    func insertPokemon(pokemonDictionary: [String:String], order: Int) {
        
        let context = stack.persistentContainer.viewContext
        let pokemon = PokemonManaged(context: context)
        
        pokemon.id = pokemonDictionary["id"]
        
        updatePokemon(pokemonDictionary: pokemonDictionary, pokemon: pokemon, order: order)
        
    }
    
    func updatePokemon(pokemonDictionary: [String:String], pokemon: PokemonManaged, order: Int) {
        
        let context = stack.persistentContainer.viewContext
        
        pokemon.order = Int16(order)
        
        pokemon.name = pokemonDictionary["name"]
        pokemon.weight = pokemonDictionary["weight"]
        pokemon.height = pokemonDictionary["height"]
        pokemon.image = pokemonDictionary["image"]
        pokemon.sync = true
        do {
            try context.save()
        } catch {
            print("Error inserting pokemon")
        }
        
    }
    
    
    func removeOldNotFavoritePokemons() {
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<PokemonManaged> = PokemonManaged.fetchRequest()
        
        let predicate = NSPredicate(format: "favorite = \(false)")
        request.predicate = predicate
        
        do {
            
            let fetchedPokemons = try context.fetch(request)
            for managedPokemon in fetchedPokemons {
                
                if !managedPokemon.sync {
                    context.delete(managedPokemon)
                }
            }
            try context.save()
            
        } catch {
            print("Error while deleting from Core Data")
        }

        
    }
    
    
    func getFavoritePokemons() -> [Pokemon]? {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<PokemonManaged> = PokemonManaged.fetchRequest()
        
        let predicate = NSPredicate(format: "favorite = \(true)")
        request.predicate = predicate
        
        do {
            
            let fetchedPokemons = try context.fetch(request)
            
            var pokemons : [Pokemon] = [Pokemon]()
            for managedPokemon in fetchedPokemons {
                pokemons.append(managedPokemon.mappedObject())
            }
            return pokemons
            
        } catch {
            print("Error while getting favorites")
            return nil
        }
        
        

    }
    
    
    func isPokemonFavorite(pokemon: Pokemon) -> Bool {
        
        if let _ = getPokemonById(id: pokemon.id!, favorite: true) {
            return true
        } else {
            return false
        }
    }
    
    
    func markUnmarkFavorite(pokemon: Pokemon) {
        let context = stack.persistentContainer.viewContext
        
        if let exist = getPokemonById(id: pokemon.id!, favorite: true) {
            context.delete(exist)
        } else {
            // la guardamos en favoritos
            let favorite = PokemonManaged(context: context)
            
            favorite.id = pokemon.id
            favorite.name = pokemon.name
            favorite.height = pokemon.height
            favorite.weight = pokemon.weight
            favorite.image = pokemon.image
            favorite.favorite = true
            
            do {
                
                try context.save()
                
            } catch {
                print("Error while marking as favorite")
            }
        }
        
        updateFavoriteBadge()
        
        
    }
    
    
    func updateFavoriteBadge() {
        
        if let totalFavorites = getFavoritePokemons()?.count {
            let notificacion = Notification(name: Notification.Name("updateFavoritesBadgeNotification"), object: totalFavorites, userInfo: nil)
            
            NotificationCenter.default.post(notificacion)
        }
    }
    
    
    
}
