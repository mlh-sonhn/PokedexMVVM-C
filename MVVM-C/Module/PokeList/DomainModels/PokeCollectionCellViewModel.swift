//
//  PokeCollectionCellViewModel.swift
//  MVVM-C
//
//  Created by SonHoang on 10/14/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PokeCollectionCellViewModel: ViewModelType {
    
    struct Input {
        let loadPokemon: Observable<String>
    }
    
    enum Action {
        case loadPokemon(String)
        case dataResponse(Result<Pokemon, Error>)
    }
    
    struct State {
        var pokemon: Pokemon?
        var error: Error?
    }

    struct Output {
        let pokemon: Signal<Pokemon>
        let error: Signal<Error?>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(enviroment: Enviroment) -> (Input) -> Output {
        let enviroment = enviroment as! PokeCollectionCellEnviroment
        
        let request = loadDetailPokemon(enviroment: enviroment)
    
        return { input in
            let store = Store<Action, State, Enviroment>(initial: State(), environment: enviroment) { (state, action, enviroment) -> Observable<Action> in
                switch action {
                case .loadPokemon(let pokemonURL):
                    return request(pokemonURL)
                case .dataResponse(.success(let pokemon)):
                    state.pokemon = pokemon
                case .dataResponse(.failure(let error)):
                    state.error = error
                }
                return .empty()
            }
            
            let action = Observable.merge(
                input.loadPokemon.map({ Action.loadPokemon($0) })
            )
            
            _ = action.bind(to: store)
            
            return Output(pokemon: store.state.compactMap({ $0.pokemon }).asSignal(onErrorRecover: { _ in fatalError() }),
                          error: store.state.map({ $0.error }).asSignal(onErrorJustReturn: nil))
        }
    }

}

private func loadDetailPokemon(enviroment: PokeCollectionCellEnviroment) -> (String) -> Observable<PokeCollectionCellViewModel.Action> {
    return { pokemonURL in
        return enviroment.loadPokemon(pokemonURL: pokemonURL)
            .map { Result.success($0) }
            .catchError({ .just(Result.failure($0)) })
            .map { PokeCollectionCellViewModel.Action.dataResponse($0) }
            .asObservable()
    }
}
