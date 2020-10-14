//
//  Store.swift
//  MVVM-C
//
//  Created by SonHoang on 9/30/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import RxSwift

final class Store<Action, State, Environment> {

    let state: Observable<State>

    init(initial: State, environment: Environment, reducer: @escaping (inout State, Action, Environment) -> Observable<Action>) {
        state = action
            .scan(into: initial) { [lock, action, disposeBag] in
                reducer(&$0, $1, environment)
                    .subscribe(onNext: {
                        lock.lock()
                        action.onNext($0)
                        lock.unlock()
                    })
                    .disposed(by: disposeBag)
            }
            .startWith(initial)
            .share(replay: 1)
    }

    deinit {
        lock.lock()
        action.onCompleted()
        lock.unlock()
    }

    private let action = ReplaySubject<Action>.createUnbounded()
    private let lock = NSRecursiveLock()
    private let disposeBag = DisposeBag()
}

extension Store: ObserverType {

    func on(_ event: Event<Action>) {
        if let element = event.element {
            lock.lock()
            action.onNext(element)
            lock.unlock()
        }
    }
}
