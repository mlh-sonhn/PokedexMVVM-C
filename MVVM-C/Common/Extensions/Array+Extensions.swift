//
//  Array+Extensions.swift
//  MVVM-C
//
//  Created by SonHoang on 9/11/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int?) -> Element? {
        guard let index = index, index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
    
    public subscript(safeAfter index: Int?) -> Element? {
        guard let index = index, index + 1 >= 0, index + 1 < endIndex else {
            return nil
        }
        return self[index + 1]
    }
    
    public subscript(safeBefore index: Int?) -> Element? {
        guard let index = index, index - 1 >= 0, index - 1 < endIndex else {
            return nil
        }
        return self[index - 1]
    }
}
