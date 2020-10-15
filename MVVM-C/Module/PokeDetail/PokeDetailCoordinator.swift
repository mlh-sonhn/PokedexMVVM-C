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
    
    let poke: Pokemon
    
    init(poke: Pokemon) {
        self.poke = poke
    }
    
    override func start() {
        let pokeDetailCoordinator = UIStoryboard.pokeDetail.controller(of: PokeDetailViewController.self)
        pokeDetailCoordinator.poke = poke
        navigationController.pushViewController(pokeDetailCoordinator, animated: true)
    }
}
