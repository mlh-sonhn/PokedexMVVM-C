//
//  AboutPokemon.swift
//  MVVM-C
//
//  Created by SonHoang on 10/20/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit

class AboutPokemon: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var speciesLabel: BoldLabel!
    @IBOutlet weak var pokemonGifImageView: UIImageView!
    @IBOutlet weak var abilitiesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var abilitiesStackView: UIStackView!
    @IBOutlet weak var abilitiesDetailBackgroundView: UIView!
    @IBOutlet weak var abilitiesDetailTitleLabel: BoldLabel!
    @IBOutlet weak var abilitiesDescriptionLabel: RegularLabel!
    @IBOutlet weak var pokemonHeightLabel: BoldLabel!
    @IBOutlet weak var pokemonWeightLabel: BoldLabel!
    @IBOutlet weak var malePercentLabel: BoldLabel!
    @IBOutlet weak var femalePercentLabel: BoldLabel!
    @IBOutlet weak var eggGroupsLabel: BoldLabel!
    @IBOutlet weak var habitatLabel: BoldLabel!
        
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
    
    private func configView(with pokemon: Pokemon) {
        
    }
    
}
