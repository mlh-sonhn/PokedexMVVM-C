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
    
    let referencePokemon: NamedAPIResource
    
    init(referencePokemon: NamedAPIResource) {
        self.referencePokemon = referencePokemon
    }
    
    override func start() {
        let pokeDetailCoordinator = UIStoryboard.pokeDetail.controller(of: PokeDetailViewController.self)
        pokeDetailCoordinator.referencePokemon = referencePokemon
        navigationController.pushViewController(pokeDetailCoordinator, animated: true)
    }
    
    override func finish(_ coordinator: CoordinatorType) {
        super.finish(coordinator)
        navigationController.popViewController(animated: true)
    }
    
}
