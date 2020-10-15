//
//  RegularLabel.swift
//  MVVM-C
//
//  Created by SonHoang on 10/15/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit

class RegularLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyFont()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyFont()
    }
    
    private func applyFont() {
        font = AppFont.getFont(font: .biotifRegular, fontSize: font.pointSize)
    }

}
