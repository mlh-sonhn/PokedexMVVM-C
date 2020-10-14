//
//  AppCoordinator.swift
//  MVVM-C
//
//  Created by SonHoang on 8/24/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {

    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        // start first coordinator
        let pokelistCoordinator = PokeListCoordinator()
        pokelistCoordinator.navigationController = navigationController
        start(pokelistCoordinator)
    }
    
}
