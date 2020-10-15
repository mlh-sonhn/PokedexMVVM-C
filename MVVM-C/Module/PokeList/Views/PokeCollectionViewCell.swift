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
import RxNuke

class PokeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pokemonNameTitleLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonTypeStackview: UIStackView!
    
    private let loadPokemonDetailRelay = PublishRelay<String>()
    private var disposeBag = DisposeBag()
    private var viewModel: PokeCollectionCellViewModel!
    private var namedAPIResource: NamedAPIResource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.viewCornerRadius = 20
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonImageView.image = nil
        
        disposeBag = DisposeBag()
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
        let backgroundColor = pokemon.mainType.color.background
        
        add(strings: pokemon.types.map({ $0.type.name }),
            to: pokemonTypeStackview,
            backgroundColor: backgroundColor)
        containerView.backgroundColor = backgroundColor.withAlphaComponent(0.8)
        
        if let url = URL(string: pokemon.sprites.other.artwork.front ?? "") {
            ImagePipeline.shared.rx.loadImage(with: url).subscribe { [weak self] image in
                guard let self = self else { return }
                self.pokemonImageView.image = image.image
            } onError: { error in
                print("Error \(error.localizedDescription)")
            }.disposed(by: disposeBag)
        }
    }
    
    private func handleError(error: Error) {
        pokemonNameTitleLabel.text = "XXXXXXXX"
    }
    
    private func add(strings: [String], to stackView: UIStackView, backgroundColor: UIColor) {
        stackView.subviews.forEach({ $0.removeFromSuperview() })
        
        for string in strings {
            let view = RoundedView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let label = RegularLabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = AppFont.getFont(font: .biotifRegular, fontSize: 14)
            label.textColor = .white
            label.text = string.capitalized
            
            view.backgroundColor = backgroundColor
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
