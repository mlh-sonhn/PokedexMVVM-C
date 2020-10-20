//
//  PokeDetailEnviroment.swift
//  MVVM-C
//
//  Created by SonHoang on 10/20/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

protocol PokeDetailEnviroment: Enviroment {
    var activityIndicator: ActivityIndicator { get }
    func fetchPokes(offset: Int, limit: Int, direction: LoadPokemonDirection) -> Single<LoadPokesResponse>
    func loadPokemon(pokemonURL: String) -> Single<Pokemon>
}

class MPokeDetailEnviroment: PokeDetailEnviroment {
    
    private let disposeBag = DisposeBag()

    let activityIndicator = ActivityIndicator()
    
    init() {
        activityIndicator.asObservable()
            .bind(to: SVProgressHUD.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    func fetchPokes(offset: Int, limit: Int, direction: LoadPokemonDirection) -> Single<LoadPokesResponse> {
        return provider.rx.request(.pokemons(offset, limit)).map({ response -> LoadPokesResponse in
            do {
                let pokemonResult = try JSONDecoder().decode(PokemonResult.self, from: response.data)
                let hasNext: Bool = pokemonResult.next != nil
                let hasPrevious: Bool = pokemonResult.previous != nil
                
                return LoadPokesResponse(currentDirection: direction,
                                         hasMorePoke: [.next: hasNext, .previous: hasPrevious],
                                         pokes: pokemonResult.results)
            } catch let error {
                throw error
            }
        })
    }
    
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
