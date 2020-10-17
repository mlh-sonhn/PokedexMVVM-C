//
//  SlideFadeBoldLabel.swift
//  MVVM-C
//
//  Created by SonHoang on 10/17/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit

class SlideFadeBoldLabel: BoldLabel {
    
    func setText(_ string: String?, backgroundColor color: UIColor = .white) {
        text = string
        addAnimation(withBackgroundColor: color)
    }
    
    private func addAnimation(withBackgroundColor color: UIColor) {
        sizeToFit()
        addGardientLayerAndStartAnimation(duration: 0.5,
                                          animationDelegate: self,
                                          backgroundColor: color)
    }

}

extension SlideFadeBoldLabel: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        layer.mask?.removeFromSuperlayer()
    }
}
