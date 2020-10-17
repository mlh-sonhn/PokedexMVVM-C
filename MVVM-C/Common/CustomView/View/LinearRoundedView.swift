//
//  LinearRoundedView.swift
//  MVVM-C
//
//  Created by SonHoang on 10/17/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit

class LinearRoundedView: RoundedView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addFadeAnimation(duration: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addFadeAnimation(duration: 1)
    }
    
}
