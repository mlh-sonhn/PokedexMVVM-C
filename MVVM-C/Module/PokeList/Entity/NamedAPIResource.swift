//
//  BasePokemonUrlResult.swift
//  Pokedex
//
//  Created by TriBQ on 07/10/2020.
//

import Foundation
import RxDataSources

struct NamedAPIResource: Codable, Identifiable, IdentifiableType {
    var id = UUID().uuidString
    var name: String = ""
    var url: String = ""
    
    typealias Identity = String
    
    var identity: Identity {
      return id
    }
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}

extension NamedAPIResource: Equatable {
    static func ==(lhs: NamedAPIResource, rhs: NamedAPIResource) -> Bool {
      return lhs.id == rhs.id
    }
}
