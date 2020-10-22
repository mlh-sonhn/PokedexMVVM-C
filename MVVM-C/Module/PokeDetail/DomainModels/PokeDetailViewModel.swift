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
        let confirmError: Observable<Void>
    }
    
    enum Action {
        case loadPokemon(Int)
        case loadMorePokemon(LoadPokemonDirection)
        case loadDetail(String)
        case loadPokemonResponse(Result<LoadPokesResponse, Error>)
        case loadMorePokemonResponse(Result<LoadPokesResponse, Error>)
        case loadedCurrentPokemonResponse(Result<Pokemon, Error>)
        case clearError
    }
    
    struct State {
        var hasMorePoke: [LoadPokemonDirection: Bool] = [.next: true, .previous: true]
        var offset: Int = 0
        var limit: Int = 7
        var pokes: [NamedAPIResource] = []
        var currentPokemon: Pokemon?
        var error: Error?
        
        func getNewOffset(from direction: LoadPokemonDirection) -> Int {
            return direction == .next ? offset + limit + 1 : offset - 1
        }
    }

    struct Output {
        let pokes: Driver<[NamedAPIResource]>
        let currentPokemon: Signal<Pokemon?>
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
                    let loadingOffset = offset >= 3 ? offset - 3 : 0
                    state.offset = loadingOffset
                    return fetchPokesRequest(false, loadingOffset, state.limit, .next)
                case .loadMorePokemon(let direction):
                    let offset = state.getNewOffset(from: direction)
                    return fetchPokesRequest(true, offset, 1, direction)
                case .loadDetail(let pokemonURL):
                    return loadDetailPokemonRequest(pokemonURL)
                case .loadPokemonResponse(.success(let pokesResponse)):
                    state.hasMorePoke = pokesResponse.hasMorePoke
                    state.pokes = pokesResponse.pokes
                    if let currentPokemon = pokesResponse.pokes[safe: 3] {
                        return loadDetailPokemonRequest(currentPokemon.url)
                    }
                case .loadMorePokemonResponse(.success(let pokesResponse)):
                    var loadedPokes = pokesResponse.pokes
                    var pokes = state.pokes
                    
                    if pokesResponse.currentDirection == .next {
                        pokes.removeFirst()
                        pokes.append(loadedPokes.removeLast())
                    } else {
                        pokes.removeLast()
                        pokes.insert(loadedPokes.removeFirst(), at: 0)
                    }
                    
                    state.offset = state.getNewOffset(from: pokesResponse.currentDirection)
                    state.pokes = pokes
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
                input.confirmError.map({ Action.clearError })
            )
            
            _ = action.bind(to: store)
        
            return Output(pokes: store.state.map({ $0.pokes }).asDriver(onErrorJustReturn: []),
                          currentPokemon: store.state.compactMap({ $0.currentPokemon }).asSignal(onErrorJustReturn: nil),
                          hasMorePoke: store.state.compactMap({ $0.hasMorePoke }).asSignal(onErrorJustReturn: [.next: true, .previous: true]),
                          error: store.state.map({ $0.error }).asSignal(onErrorJustReturn: nil))
        }
    }
    
}

private func fetchPokes(enviroment: PokeDetailEnviroment) -> (Bool, Int, Int, LoadPokemonDirection) -> Observable<PokeDetailViewModel.Action> {
    return { isLoadMore, offset, limit, direction in
        return enviroment.fetchPokes(offset: offset, limit: limit, direction: direction)
            .map { Result.success($0) }
            .catchError({ .just(Result.failure($0)) })
            .trackActivity(enviroment.activityIndicator)
            .map { isLoadMore ? PokeDetailViewModel.Action.loadMorePokemonResponse($0) : PokeDetailViewModel.Action.loadPokemonResponse($0) }
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
