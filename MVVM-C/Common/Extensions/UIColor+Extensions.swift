//
//  UIColor+Extensions.swift
//  MVVM-C
//
//  Created by SonHoang on 10/14/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit

extension UIColor {
    func colorFromHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") { hexString.remove(at: hexString.startIndex) }
        if hexString.count != 6 { return UIColor.black }

        var rgb: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb) // Allow this scanHex function into the rgb value
        return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255,
                       green: CGFloat((rgb & 0x00FF00) >> 8) / 255,
                       blue: CGFloat((rgb & 0x0000FF)) / 255,
                       alpha: alpha)
    }

    var hexString: String? {
        if let components = self.cgColor.components {
            let red = components[0]
            let grn = components[1]
            let blu = components[2]
            return String(format: "%02X%02X%02X", Int(red * 255), Int(grn * 255), Int(blu * 255))
        }
        return nil
    }
}
