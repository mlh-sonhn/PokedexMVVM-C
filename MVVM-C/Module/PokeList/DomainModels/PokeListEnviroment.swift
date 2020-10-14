//
//  PokeListService.swift
//  MVVM-C
//
//  Created by SonHoang on 9/11/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import RxSwift

protocol PokeListEnviroment: Enviroment {
    var activityIndicator: ActivityIndicator { get }
    func fetchPokes() -> Single<[PokeEntity]>
}

class MPokeListEnviroment: PokeListEnviroment {

    let activityIndicator = ActivityIndicator()
    
    func fetchPokes() -> Single<[PokeEntity]> {
        return Single.just([PokeEntity(name: "Pikachu", thumbImage: "url"),
                            PokeEntity(name: "Rayquaza", thumbImage: "url"),
                            PokeEntity(name: "Chemander", thumbImage: "url")])
            .delay(.milliseconds(100), scheduler: MainScheduler.instance)
    }

}
