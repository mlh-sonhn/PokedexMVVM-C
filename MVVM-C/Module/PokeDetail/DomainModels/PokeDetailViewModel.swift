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

class PokeDetailViewModel: ViewModelType {
    
    struct Input {
        let loadView: Observable<Void>
        let loadMore: Observable<Void>
        let showDetail: Observable<NamedAPIResource>
        let confirmError: Observable<Void>
    }
    
    enum Action {
        case fetchData
        case loadMore
        case showDetail(NamedAPIResource)
        case dataResponse(Result<(Bool, [NamedAPIResource]), Error>)
        case clearError
    }
    
    struct State {
        var hasMorePoke: Bool = true
        var offset: Int = 0
        var limit: Int = 20
        var pokes: [PokeSectionModel] = []
        var pokeToShow: NamedAPIResource?
        var error: Error?
    }

    struct Output {
        let error: Signal<Error?>
    }
    
    func transform(enviroment: Enviroment) -> (Input) -> Output {
        return { _ in
            return Output(error: .just(nil))
        }
    }
    
}
