//
//  PokeCollectionCellEnviroment.swift
//  MVVM-C
//
//  Created by SonHoang on 10/14/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import RxSwift

protocol PokeCollectionCellEnviroment: Enviroment {
    func loadPokemon(pokemonURL: String) -> Single<Pokemon>
}

class MPokeCollectionCellEnviroment: PokeCollectionCellEnviroment {

    func loadPokemon(pokemonURL: String) -> Single<Pokemon> {
        return provider.rx.request(.detailPokemon(pokemonURL)).map ({ response -> Pokemon in
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: response.data)
                return pokemon
            } catch let error {
                throw error
            }
        })
    }

}
