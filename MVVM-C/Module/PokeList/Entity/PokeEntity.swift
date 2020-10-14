//
//  PokeEntity.swift
//  MVVM-C
//
//  Created by SonHoang on 8/25/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation

struct PokeEntity {

    var name: String?
    var thumbImage: URL?
    
    init(name: String, thumbImage: String) {
        self.name = name
        if let thumbImageURL = URL(string: thumbImage) {
            self.thumbImage = thumbImageURL
        }
    }

}
