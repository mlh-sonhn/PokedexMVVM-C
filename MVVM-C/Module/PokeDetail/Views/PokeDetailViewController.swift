//
//  PokeDetailViewController.swift
//  MVVM-C
//
//  Created by SonHoang on 8/25/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PokeDetailViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private let loadViewRelay = PublishRelay<Int>()
    private let loadMorePokemon = PublishRelay<LoadPokemonDirection>()
    private let confirmError = PublishRelay<Void>()
    private let pokeItemsRelay = BehaviorRelay<[NamedAPIResource]>(value: [])
    private var isLoading: Bool = false
    
    private lazy var pokemonNumberLabel: BoldLabel = {
        let label = BoldLabel()
        label.font = AppFont.getFont(font: .biotifBold, fontSize: 20)
        label.textColor = .white
        label.text = ""
        label.tag = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewModel: PokeDetailViewModel!
    var enviroment: Enviroment!
    var coordinator: PokeDetailCoordinator!
    
    var pokemonOffset: Int = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pokeCollectionViewController = segue.destination as? PokeCollectionViewController {
            pokeItemsRelay.bind(to: pokeCollectionViewController.sectionItemsRelay)
                .disposed(by: pokeCollectionViewController.disposeBag)
            pokeCollectionViewController.loadMorePage.bind(to: loadMorePokemon)
                .disposed(by: pokeCollectionViewController.disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        
        bindingViewModel()
        
        loadViewRelay.accept(pokemonOffset)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove pokemon number from navigation
        pokemonNumberLabel.removeFromSuperview()
    }

}

// MARK: - Navigation initial
extension PokeDetailViewController {
    
    private func setupNavigation() {
        title = "Pikachu"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                  .font: AppFont.getFont(font: .biotifBold) ?? UIFont.systemFont(ofSize: 17)]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white,
                                                                  .font: AppFont.getFont(font: .biotifBold, fontSize: 31) ?? UIFont.systemFont(ofSize: 31)]
        addPokeNumberToNavigation()
        addFavoriteBarButton()
    }
    
    private func addPokeNumberToNavigation() {
        guard let targetView = navigationController?.navigationBar else { return }
        
        targetView.addSubview(pokemonNumberLabel)

        NSLayoutConstraint.activate([
            pokemonNumberLabel.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: -16),
            pokemonNumberLabel.bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: -14)
        ])
    }
    
    private func addFavoriteBarButton() {
        let favoriteBarButtonItem = UIBarButtonItem()
        favoriteBarButtonItem.title = "Love"
        navigationItem.rightBarButtonItem = favoriteBarButtonItem
    }
    
}

extension PokeDetailViewController {
    private func bindingViewModel() {
        let input = PokeDetailViewModel.Input(loadPokemon: loadViewRelay.asObservable(),
                                              loadMorePokemon: loadMorePokemon.asObservable(),
                                              confirmError: confirmError.asObservable())
        
        let output = viewModel.transform(enviroment: enviroment)(input)
        
        let pokesDispo = output.pokes.drive(pokeItemsRelay)
        
        disposeBag.insert([pokesDispo])
        
    }
}
