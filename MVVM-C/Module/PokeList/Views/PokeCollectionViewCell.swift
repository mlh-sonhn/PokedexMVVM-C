//
//  PokeCollectionViewCell.swift
//  MVVM-C
//
//  Created by SonHoang on 10/13/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Nuke

class PokeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pokemonNameTitleLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonTypeStackview: UIStackView!
    @IBOutlet weak var pokeballImageView: UIImageView!
    
    private let loadPokemonDetailRelay = PublishRelay<String>()
    private var disposeBag = DisposeBag()
    private var viewModel: PokeCollectionCellViewModel!
    private var namedAPIResource: NamedAPIResource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupCell() {
        containerView.viewCornerRadius = 20
        pokeballImageView.image = UIImage(named: "ic_pokeball")?.tintColor(with: .white)
    }
    
    func configCell(with injectViewModel: PokeCollectionCellViewModel, enviroment: Enviroment, namedAPIResource: NamedAPIResource) {
        viewModel = injectViewModel
        self.namedAPIResource = namedAPIResource
        
        let input = PokeCollectionCellViewModel.Input(loadPokemon: loadPokemonDetailRelay.asObservable())
        let outPut = viewModel.transform(enviroment: enviroment)(input)
        
        let pokemonDispo = outPut.pokemon
            .emit(onNext: { [weak self] pokemon in
                guard let self = self else { return }
                self.handlePokemonLoaded(pokemon: pokemon)
            })
        
        let errorDispo = outPut.error
            .emit(onNext: { [weak self] error in
                guard let self = self, let error = error else { return }
                self.handleError(error: error)
            })
        
        disposeBag.insert([pokemonDispo, errorDispo])
        
    }
    
    func startFetchPokeDetail() {
        guard let namedAPIResource = namedAPIResource else { return }
        loadPokemonDetailRelay.accept(namedAPIResource.url)
    }
    
    private func handlePokemonLoaded(pokemon: Pokemon) {
        pokemonNameTitleLabel.text = pokemon.name.capitalized
        add(strings: pokemon.types.map({ $0.type.name }), to: pokemonTypeStackview)
        containerView.backgroundColor = pokemon.mainType.color.background
        
        if let url = URL(string: pokemon.sprites.other.artwork.front ?? "") {
            let options = ImageLoadingOptions(
                placeholder: UIImage(named: "pokeball"),
                transition: .fadeIn(duration: 0.33)
            )
            Nuke.loadImage(with: url, options: options, into: pokemonImageView)
        }
    }
    
    private func handleError(error: Error) {
        pokemonNameTitleLabel.text = "XXXXXXXX"
    }
    
    private func add(strings: [String], to stackView: UIStackView) {
        stackView.subviews.forEach({ $0.removeFromSuperview() })
        
        for string in strings {
            let view = RoundedView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let label = RegularLabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = AppFont.getFont(font: .biotifRegular, fontSize: 14)
            label.textColor = .white
            label.text = string.capitalized
            
            view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: 2.5),
                label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2.5),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
            ])
            
            stackView.addArrangedSubview(view)
        }
    }
    
}
