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
    
    let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    override func start() {
        let pokeDetailCoordinator = UIStoryboard.pokeDetail.controller(of: PokeDetailViewController.self)
        pokeDetailCoordinator.pokemon = pokemon
        navigationController.pushViewController(pokeDetailCoordinator, animated: true)
    }
    
    override func finish(_ coordinator: CoordinatorType) {
        super.finish(coordinator)
        navigationController.popViewController(animated: true)
    }
    
}
