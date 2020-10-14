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

class PokeListViewModel: ViewModelType {

    struct Input {
        let loadView: Observable<Void>
        let showDetail: Observable<Int>
    }

    struct Output {
        let pokes: Driver<[PokeEntity]>
        let onShowDetailPoke: Signal<PokeEntity?>
        let error: Signal<Error?>
    }

    struct State {
        var pokes: [PokeEntity] = []
        var pokeToShow: PokeEntity?
        var error: Error?
    }

    enum Action {
        case fetchData
        case showDetail(Int)
        case dataResponse(Result<[PokeEntity], Error>)
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(enviroment: Enviroment) -> (_ input: Input) -> Output {
        let enviroment = enviroment as! PokeListEnviroment
        let request = fetchData(enviroment: enviroment)
        return { input in
            let store = Store<Action, State, Enviroment>(initial: State(), environment: enviroment) { (state, action, enviroment) -> Observable<Action> in
                switch action {
                case .fetchData:
                    return request()
                case .showDetail(let index):
                    state.pokeToShow = state.pokes[index]
                case .dataResponse(.success(let pokeEntities)):
                    state.pokes = pokeEntities
                case .dataResponse(.failure(let error)):
                    state.error = error
                }
                return .empty()
            }
            let action = Observable.merge(
                input.loadView.map({ Action.fetchData }),
                input.showDetail.map({ Action.showDetail($0) })
            )
            _ = action.bind(to: store)
            return Output(pokes: store.state.map { $0.pokes }.asDriver(onErrorJustReturn: []),
                          onShowDetailPoke: store.state.compactMap { $0.pokeToShow }.asSignal(onErrorJustReturn: nil),
                          error: store.state.map { $0.error }.asSignal(onErrorJustReturn: nil))
        }
    }
    
    private func fetchData(enviroment: PokeListEnviroment) -> () -> Observable<Action> {
        return {
            return enviroment.fetchPokes()
                .map { Result.success($0) }
                .catchError({ .just(Result.failure($0)) })
                .trackActivity(enviroment.activityIndicator)
                .map { Action.dataResponse($0) }
        }
    }

}


