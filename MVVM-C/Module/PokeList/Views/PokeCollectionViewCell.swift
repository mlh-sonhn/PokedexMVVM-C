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
    @IBOutlet weak var firstClassTitleLabel: UILabel!
    @IBOutlet weak var secondClassTitleLabel: UILabel!
    
    private let loadPokemonDetailRelay = PublishRelay<String>()
    private var disposeBag = DisposeBag()
    private var viewModel: PokeCollectionCellViewModel!
    private var namedAPIResource: NamedAPIResource?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
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
        pokemonNameTitleLabel.text = pokemon.name
        firstClassTitleLabel.text = pokemon.types.first?.type.name
        containerView.backgroundColor = pokemon.mainType.color.background
        
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
        firstClassTitleLabel.text = "XXXXXXXX"
    }
    
}
