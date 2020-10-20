//
//  PokeDetailViewModel.swift
//  MVVM-C
//
//  Created by SonHoang on 10/19/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias PokeDetailSectionModel = SectionModel<String, NamedAPIResource>

class PokeDetailViewModel: ViewModelType {
    
    struct Input {
        let loadPokemon: Observable<Int>
        let loadMorePokemon: Observable<LoadPokemonDirection>
        let showDetail: Observable<Void>
        let confirmError: Observable<Void>
    }
    
    enum Action {
        case loadPokemon(Int)
        case loadMorePokemon(LoadPokemonDirection)
        case showDetail
        case loadDetail(String)
        case loadPokemonResponse(Result<LoadPokesResponse, Error>)
        case loadMorePokemonResponse(Result<LoadPokesResponse, Error>)
        case loadedCurrentPokemonResponse(Result<Pokemon, Error>)
        case clearError
    }
    
    struct State {
        var hasMorePoke: [LoadPokemonDirection: Bool] = [.next: true, .previous: true]
        var offset: Int = 0
        var limit: Int = 5
        var pokes: [NamedAPIResource] = []
        var currentPokemon: Pokemon?
        var pokemonToShow: Pokemon?
        var error: Error?
    }

    struct Output {
        let pokes: Driver<[NamedAPIResource]>
        let currentPokemon: Signal<Pokemon?>
        let onShowDetailPoke: Signal<Pokemon?>
        let hasMorePoke: Signal<[LoadPokemonDirection: Bool]>
        let error: Signal<Error?>
    }
    
    func transform(enviroment: Enviroment) -> (Input) -> Output {
        let enviroment = enviroment as! PokeDetailEnviroment
        let fetchPokesRequest = fetchPokes(enviroment: enviroment)
        let loadDetailPokemonRequest = loadDetailPokemon(enviroment: enviroment)
        
        return { input in
            let store = Store<Action, State, Enviroment>(initial: State(), environment: enviroment) { (state, action, enviroment) -> Observable<Action> in
                switch action {
                case .loadPokemon(let offset):
                    let loadingOffset = offset >= 2 ? offset - 2 : 0
                    state.offset = loadingOffset
                    return fetchPokesRequest(loadingOffset, state.limit, .next)
                case .loadMorePokemon(let direction):
                    let offset = direction == .next ? state.offset + state.limit + 1 : state.offset - 1
                    return fetchPokesRequest(offset, 1, direction)
                case .showDetail:
                    state.pokemonToShow = state.currentPokemon
                case .loadDetail(let pokemonURL):
                    return loadDetailPokemonRequest(pokemonURL)
                case .loadPokemonResponse(.success(let pokesResponse)):
                    state.hasMorePoke = pokesResponse.hasMorePoke
                    state.pokes = pokesResponse.pokes
                    if let currentPokemon = pokesResponse.pokes[safe: 2] {
                        return loadDetailPokemonRequest(currentPokemon.url)
                    }
                case .loadMorePokemonResponse(.success(let pokesResponse)):
                    var loadedPokes = pokesResponse.pokes
                    if pokesResponse.currentDirection == .next {
                        state.pokes.removeFirst()
                        state.pokes.append(loadedPokes.removeLast())
                    } else {
                        state.pokes.removeLast()
                        state.pokes.append(loadedPokes.removeFirst())
                    }
                case .loadedCurrentPokemonResponse(.success(let pokemon)):
                    state.currentPokemon = pokemon
                case .loadPokemonResponse(.failure(let error)),
                     .loadMorePokemonResponse(.failure(let error)),
                     .loadedCurrentPokemonResponse(.failure(let error)):
                    state.error = error
                case .clearError:
                    state.error = nil
                }
                return .empty()
            }
            
            let action = Observable.merge(
                input.loadPokemon.map({ Action.loadPokemon($0) }),
                input.loadMorePokemon.map({ Action.loadMorePokemon($0) }),
                input.showDetail.map({ Action.showDetail }),
                input.confirmError.map({ Action.clearError })
            )
            
            _ = action.bind(to: store)
        
            return Output(pokes: store.state.map({ $0.pokes }).asDriver(onErrorJustReturn: []),
                          currentPokemon: store.state.compactMap({ $0.currentPokemon }).asSignal(onErrorJustReturn: nil),
                          onShowDetailPoke: store.state.compactMap({ $0.pokemonToShow }).asSignal(onErrorJustReturn: nil),
                          hasMorePoke: store.state.compactMap({ $0.hasMorePoke }).asSignal(onErrorJustReturn: [.next: true, .previous: true]),
                          error: store.state.map({ $0.error }).asSignal(onErrorJustReturn: nil))
        }
    }
    
}

private func fetchPokes(enviroment: PokeDetailEnviroment) -> (Int, Int, LoadPokemonDirection) -> Observable<PokeDetailViewModel.Action> {
    return { offset, limit, direction in
        return enviroment.fetchPokes(offset: offset, limit: limit, direction: direction)
            .map { Result.success($0) }
            .catchError({ .just(Result.failure($0)) })
            .trackActivity(enviroment.activityIndicator)
            .map { PokeDetailViewModel.Action.loadPokemonResponse($0) }
    }
}

private func loadDetailPokemon(enviroment: PokeDetailEnviroment) -> (String) -> Observable<PokeDetailViewModel.Action> {
    return { pokemonURL in
        return enviroment.loadPokemon(pokemonURL: pokemonURL)
            .map { Result.success($0) }
            .catchError({ .just(Result.failure($0)) })
            .map { PokeDetailViewModel.Action.loadedCurrentPokemonResponse($0) }
            .asObservable()
    }
}
