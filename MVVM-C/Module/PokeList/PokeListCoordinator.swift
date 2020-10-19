//
//  PokeListCoordinator.swift
//  MVVM-C
//
//  Created by SonHoang on 8/24/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import UIKit

class PokeListCoordinator: Coordinator {

    override func start() {
        let pokeListViewController = UIStoryboard.pokeList.controller(of: PokeListViewController.self)
        let viewModel = PokeListViewModel()
        let enviroment = MPokeListEnviroment()
        pokeListViewController.viewModel = viewModel
        pokeListViewController.enviroment = enviroment
        pokeListViewController.coordinator = self
        
        navigationController.viewControllers = [pokeListViewController]
    }
    
    func startPokeDetail(_ pokemon: Pokemon) {
        let pokeDetailCoordinator = PokeDetailCoordinator(pokemon: pokemon)
        pokeDetailCoordinator.navigationController = navigationController
        start(pokeDetailCoordinator)
    }
    
}
