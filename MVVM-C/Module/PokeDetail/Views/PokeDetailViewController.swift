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
    
    var pokemon: Pokemon!
    
    private lazy var pokemonNumberLabel: BoldLabel = {
        let label = BoldLabel()
        label.font = AppFont.getFont(font: .biotifBold, fontSize: 20)
        label.text = ""
        label.tag = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
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
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                  .font: AppFont.getFont(font: .biotifBold) ?? UIFont.systemFont(ofSize: 17)]
        addPokeNumberToNavigation()
        addFavoriteBarButton()
    }
    
    private func addPokeNumberToNavigation() {
        guard let targetView = navigationController?.navigationBar else { return }
        
        targetView.addSubview(pokemonNumberLabel)

        NSLayoutConstraint.activate([
            pokemonNumberLabel.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: -16),
            pokemonNumberLabel.bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: -6)
        ])
    }
    
    private func addFavoriteBarButton() {
        let favoriteBarButtonItem = UIBarButtonItem()
        favoriteBarButtonItem.title = "Love"
        navigationItem.rightBarButtonItem = favoriteBarButtonItem
    }
    
}
