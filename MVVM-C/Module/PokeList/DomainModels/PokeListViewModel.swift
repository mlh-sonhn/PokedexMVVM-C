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

typealias PokeSectionModel = SectionModel<String, NamedAPIResource>

class PokeListViewModel: ViewModelType {

    struct Input {
        let loadView: Observable<Void>
        let loadMore: Observable<Void>
        let showDetail: Observable<Pokemon>
    }
    
    enum Action {
        case fetchData
        case loadMore
        case showDetail(Pokemon)
        case dataResponse(Result<[NamedAPIResource], Error>)
    }
    
    struct State {
        var offset: Int = 0
        var limit: Int = 20
        var pokes: [PokeSectionModel] = []
        var pokeToShow: Pokemon?
        var error: Error?
    }

    struct Output {
        let pokes: Driver<[PokeSectionModel]>
        let onShowDetailPoke: Signal<Pokemon?>
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
                    return request(0, state.limit)
                case .loadMore:
                    return request(state.offset, state.limit)
                case .showDetail(let pokemon):
                    state.pokeToShow = pokemon
                case .dataResponse(.success(let pokemons)):
                    var currentPokemons: [NamedAPIResource] = state.pokes.first?.items ?? []
                    currentPokemons.append(contentsOf: pokemons)
                    let pokes = SectionModel(model: "", items: currentPokemons)
                    state.offset = currentPokemons.count
                    state.pokes = [pokes]
                case .dataResponse(.failure(let error)):
                    state.error = error
                }
                return .empty()
            }
            let action = Observable.merge(
                input.loadView.map({ Action.fetchData }),
                input.showDetail.map({ Action.showDetail($0) }),
                input.loadMore.map({ Action.loadMore })
            )
            _ = action.bind(to: store)
            return Output(pokes: store.state.map { $0.pokes }.asDriver(onErrorJustReturn: []),
                          onShowDetailPoke: store.state.compactMap { $0.pokeToShow }.asSignal(onErrorJustReturn: nil),
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


