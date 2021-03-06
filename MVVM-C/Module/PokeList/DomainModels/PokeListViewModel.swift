//
//  PokeListViewModel.swift
//  MVVM-C
//
//  Created by SonHoang on 8/24/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias PokeSectionModel = AnimatableSectionModel<String, NamedAPIResource>

class PokeListViewModel: ViewModelType {

    struct Input {
        let loadView: Observable<Void>
        let loadMore: Observable<Void>
        let showDetail: Observable<Int>
        let confirmError: Observable<Void>
    }
    
    enum Action {
        case fetchData
        case loadMore
        case showDetail(Int)
        case dataResponse(Result<(Bool, [NamedAPIResource]), Error>)
        case clearError
    }
    
    struct State {
        var hasMorePoke: Bool = true
        var offset: Int = 0
        var limit: Int = 20
        var pokes: [PokeSectionModel] = []
        var pokeToShow: Int?
        var error: Error?
    }

    struct Output {
        let pokes: Driver<[PokeSectionModel]>
        let onShowDetailPoke: Signal<Int?>
        let hasMorePoke: Signal<Bool>
        let error: Signal<Error?>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(enviroment: Enviroment) -> (_ input: Input) -> Output {
        let enviroment = enviroment as! PokeListEnviroment
        let request = fetchData(enviroment: enviroment)
        return { input in
            let store = Store<Action, State, Enviroment>(initial: State(), environment: enviroment) { (state, action, enviroment) -> Observable<Action> in
                switch action {
                case .fetchData:
                    state.hasMorePoke = true
                    return request(0, state.limit)
                case .loadMore:
                    return request(state.offset, state.limit)
                case .showDetail(let offset):
                    state.pokeToShow = offset
                case .dataResponse(.success((let hasMorePokemon, let pokemons))):
                    var currentPokemons: [NamedAPIResource] = state.pokes.first?.items ?? []
                    currentPokemons.append(contentsOf: pokemons)
                    let pokes = AnimatableSectionModel(model: "", items: currentPokemons)
                    state.hasMorePoke = hasMorePokemon
                    state.offset = currentPokemons.count
                    state.pokes = [pokes]
                case .dataResponse(.failure(let error)):
                    state.error = error
                case .clearError:
                    state.error = nil
                }
                return .empty()
            }
            let action = Observable.merge(
                input.loadView.map({ Action.fetchData }),
                input.showDetail.map({ Action.showDetail($0) }),
                input.loadMore.map({ Action.loadMore }),
                input.confirmError.map({ Action.clearError })
            )
            _ = action.bind(to: store)
            return Output(pokes: store.state.map { $0.pokes }.asDriver(onErrorJustReturn: []),
                          onShowDetailPoke: store.state.compactMap { $0.pokeToShow }.asSignal(onErrorJustReturn: nil),
                          hasMorePoke: store.state.map({ $0.hasMorePoke }).distinctUntilChanged().asSignal(onErrorJustReturn: true),
                          error: store.state.map { $0.error }.asSignal(onErrorJustReturn: nil))
        }
    }

}

private func fetchData(enviroment: PokeListEnviroment) -> (Int, Int) -> Observable<PokeListViewModel.Action> {
    return { offset, limit in
        return enviroment.fetchPokes(offset: offset, limit: limit)
            .map { Result.success($0) }
            .catchError({ .just(Result.failure($0)) })
            .trackActivity(enviroment.activityIndicator)
            .map { PokeListViewModel.Action.dataResponse($0) }
    }
}


