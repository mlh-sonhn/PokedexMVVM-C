//
//  StringHelper.swift
//  MVVM-C
//
//  Created by SonHoang on 10/21/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation

struct StringHelper {
    static func getPokemonId(from url: String) -> Int {
        let base = AppConstants.baseURL + "pokemon"
        return Int(url.replacingOccurrences(of: base, with: "")
                    .replacingOccurrences(of: "/", with: "")) ?? 0
    }
}
