//
//  LoadPokesResponse.swift
//  MVVM-C
//
//  Created by SonHoang on 10/20/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation

struct LoadPokesResponse {
    var currentDirection: LoadPokemonDirection
    var hasMorePoke: [LoadPokemonDirection: Bool]
    var pokes: [NamedAPIResource]
}
