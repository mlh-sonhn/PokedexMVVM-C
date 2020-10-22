//
//  PokesViewCell.swift
//  MVVM-C
//
//  Created by SonHoang on 10/21/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit
import Nuke

class PokesViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(with namedAPIResource: NamedAPIResource) {
        if let url = URL(string: String(format: AppConstants.baseImageURL, "\(StringHelper.getPokemonId(from: namedAPIResource.url))")) {
            let options = ImageLoadingOptions(
                placeholder: UIImage(named: "pokeball"),
                transition: .fadeIn(duration: 0.33)
            )
            Nuke.loadImage(with: url, options: options, into: pokemonImageView)
        }
    }
    
}
