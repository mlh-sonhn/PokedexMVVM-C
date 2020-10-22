//
//  PokemonBaseStat.swift
//  MVVM-C
//
//  Created by SonHoang on 10/20/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit

class PokemonBaseStat: UIView {
    
    @IBOutlet var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialView()
    }
    
    private func initialView() {
        _ = loadViewFromNib()
        self.backgroundColor = UIColor.clear
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }

}
