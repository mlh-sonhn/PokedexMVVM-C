//
//  ViewModel.swift
//  MVVM-C
//
//  Created by SonHoang on 8/24/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation

protocol Enviroment {
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype Action
    associatedtype State
    
    func transform(enviroment: Enviroment) -> (_ input: Input) -> Output
}
