//
//  PokemonManaged+Mapping.swift
//  PokeB
//
//  Created by Oscar Rodriguez Garrucho on 10/5/17.
//  Copyright © 2017 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation

extension PokemonManaged {
    
    func mappedObject() -> Pokemon {
        
        return Pokemon(id: self.id, name: self.name, weight: self.weight, height: self.height, image: self.image)
        
    }
    
}
