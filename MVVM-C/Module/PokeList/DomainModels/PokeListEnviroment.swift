//
//  PokeListService.swift
//  MVVM-C
//
//  Created by SonHoang on 9/11/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD

protocol PokeListEnviroment: Enviroment {
    var activityIndicator: ActivityIndicator { get }
    func fetchPokes(offset: Int, limit: Int) -> Single<(Bool, [NamedAPIResource])>
}

class MPokeListEnviroment: PokeListEnviroment {
    
    private let disposeBag = DisposeBag()

    let activityIndicator = ActivityIndicator()
    
    init() {
        activityIndicator.asObservable()
            .bind(to: SVProgressHUD.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    func fetchPokes(offset: Int, limit: Int) -> Single<(Bool, [NamedAPIResource])> {
        return provider.rx.request(.pokemons(offset, limit)).map({ response -> (Bool, [NamedAPIResource]) in
            do {
                let pokemonResult = try JSONDecoder().decode(PokemonResult.self, from: response.data)
                return (pokemonResult.next != nil, pokemonResult.results)
            } catch let error {
                throw error
            }
        })
    }

}
