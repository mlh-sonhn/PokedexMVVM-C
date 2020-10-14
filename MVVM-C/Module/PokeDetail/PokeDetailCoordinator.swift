//
//  PokeDetailCoordinator.swift
//  MVVM-C
//
//  Created by SonHoang on 8/25/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import UIKit

class PokeDetailCoordinator: Coordinator {
    
    let pokeEntity: PokeEntity
    
    init(pokeEntity: PokeEntity) {
        self.pokeEntity = pokeEntity
    }
    
    override func start() {
        let pokeDetailCoordinator = UIStoryboard.pokeDetail.controller(of: PokeDetailViewController.self)
        pokeDetailCoordinator.pokeEntity = pokeEntity
        navigationController.pushViewController(pokeDetailCoordinator, animated: true)
    }
}
