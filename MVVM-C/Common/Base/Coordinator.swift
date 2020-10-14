//
//  Coordinator.swift
//  MVVM-C
//
//  Created by SonHoang on 8/24/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorType: class {

    var navigationController: UINavigationController { get set }
    var parentCoordinator: CoordinatorType? { get set }
    
    func start()
    func start(_ coordinator: CoordinatorType)
    func finish(_ coordinator: CoordinatorType)
    
}

class Coordinator: CoordinatorType {
 
    var navigationController = UINavigationController()
    var parentCoordinator: CoordinatorType?
    var childCoordinators: [CoordinatorType] = []
    
    func start() {
        fatalError("Start method must be implemented")
    }
    
    func start(_ coordinator: CoordinatorType) {
        self.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = coordinator
        coordinator.start()
    }
    
    func finish(_ coordinator: CoordinatorType) {
        if let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) {
            self.childCoordinators.remove(at: index)
        }
    }

}
