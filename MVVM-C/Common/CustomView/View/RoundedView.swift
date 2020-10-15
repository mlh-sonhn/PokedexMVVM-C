//
//  RoundedView.swift
//  MVVM-C
//
//  Created by SonHoang on 10/15/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        viewCornerRadius = rect.size.height / 2
    }

}
