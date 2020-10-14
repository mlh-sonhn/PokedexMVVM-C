//
//  NSObject+Extensions.swift
//  MVVM-C
//
//  Created by SonHoang on 8/24/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    @nonobjc class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String {
        return type(of: self).className
    }
}
