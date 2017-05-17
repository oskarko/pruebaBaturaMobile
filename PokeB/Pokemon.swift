//
//  Pokemon.swift
//  PokeB
//
//  Created by Oscar Rodriguez Garrucho on 10/5/17.
//  Copyright © 2017 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation

class Pokemon {
    
    let id : String?
    let name : String?
    let weight : String?
    let height : String?
    let image : String?
    
    
    init(id: String?, name: String?, weight: String?, height: String?, image: String?) {
        
        self.id = id
        self.name = name
        self.weight = weight
        self.height = height
        self.image = image
        
    }
    
    
}
