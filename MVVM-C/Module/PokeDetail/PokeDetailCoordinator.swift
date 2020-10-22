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
    
    let pokemonOffset: Int
    
    init(pokemonOffset: Int) {
        self.pokemonOffset = pokemonOffset
    }
    
    override func start() {
        let pokeDetailViewController = UIStoryboard.pokeDetail.controller(of: PokeDetailViewController.self)
        pokeDetailViewController.pokemonOffset = pokemonOffset
        pokeDetailViewController.viewModel = PokeDetailViewModel()
        pokeDetailViewController.enviroment = MPokeDetailEnviroment()
        pokeDetailViewController.coordinator = self
        navigationController.pushViewController(pokeDetailViewController, animated: true)
    }
    
    override func finish(_ coordinator: CoordinatorType) {
        super.finish(coordinator)
        navigationController.popViewController(animated: true)
    }
    
}
