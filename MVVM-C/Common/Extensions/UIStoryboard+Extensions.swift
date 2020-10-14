//
//  UIStoryboard+Extensions.swift
//  MVVM-C
//
//  Created by SonHoang on 8/24/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation

import UIKit

extension UIStoryboard {
    static var pokeList: UIStoryboard {
        return UIStoryboard(name: "PokeList", bundle: nil)
    }
    static var pokeDetail: UIStoryboard {
        return UIStoryboard(name: "PokeDetail", bundle: nil)
    }
}

extension UIStoryboard {
    func controller<Controller: UIViewController>(of type: Controller.Type) -> Controller {
        return self.instantiateViewController(withIdentifier: String(describing: type)) as! Controller
    }
}
