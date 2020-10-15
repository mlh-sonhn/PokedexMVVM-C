//
//  AppFont.swift
//  MVVM-C
//
//  Created by SonHoang on 10/15/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation
import UIKit

enum AppFont {
    
    case systemFont
    case boldSystemFont
    
    case biotifRegular
    case biotifBold
    
    private var name: String {
        switch self {
        case .biotifRegular:
            return "Biotif-Regular"
        case .biotifBold:
            return "Biotif-Bold"
        default:
            return ""
        }
    }
    
    static func getFont(font: AppFont, fontSize: CGFloat = 17.0) -> UIFont? {
        switch font {
        case .systemFont:
            return UIFont.systemFont(ofSize: fontSize)
        case .boldSystemFont:
            return UIFont.boldSystemFont(ofSize: fontSize)
        default:
            return UIFont(name: font.name, size: fontSize)
        }
    }
    
}
