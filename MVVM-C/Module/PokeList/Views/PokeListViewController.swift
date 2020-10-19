//
//  PokeListViewController.swift
//  MVVM-C
//
//  Created by SonHoang on 8/24/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PokeListViewController: UIViewController {

    private lazy var dataSource = RxCollectionViewSectionedAnimatedDataSource<PokeSectionModel>(
        animationConfiguration: AnimationConfiguration(insertAnimation: .bottom,
                                                       reloadAnimation: .none,
                                                       deleteAnimation: .none),
        configureCell: { (_, collectionView, indexPath, item) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCollectionViewCell.className, for: indexPath) as? PokeCollectionViewCell else { return UICollectionViewCell() }
        cell.configCell(with: PokeCollectionCellViewModel(), enviroment: MPokeCollectionCellEnviroment(), namedAPIResource: item)
        return cell
    })

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private let loadViewRelay = PublishRelay<Void>()
    private let loadMorePage = PublishRelay<Void>()
    private let confirmError = PublishRelay<Void>()
    private var isLoading: Bool = false
    
    var viewModel: PokeListViewModel!
    var enviroment: Enviroment!
    var coordinator: PokeListCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        setupCollectionView()
        
        bindViewModel()
        
        // Start load items
        loadViewRelay.accept(())
    }
    
    private func setupNavigation() {
        title = "Pokemons"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black,
                                                                  .font: AppFont.getFont(font: .biotifBold) ?? UIFont.systemFont(ofSize: 17)]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = PokeListViewModel.Input(loadView: loadViewRelay.asObservable(),
                                            loadMore: loadMorePage.asObservable(),
                                            showDetail: collectionView.rx
                                                .modelSelected(NamedAPIResource.self).asObservable(),
                                            confirmError: confirmError.asObservable())
        let outPut = viewModel.transform(enviroment: enviroment)(input)
        
        
        let pokeEntitiesDispo = outPut.pokes
            .drive(collectionView.rx.items(dataSource: dataSource))
        
        let showDetailPokeDispo = outPut.onShowDetailPoke
            .emit(onNext: { [weak self] referencePokemon in
                guard let self = self, let referencePokemon = referencePokemon else { return }
                self.coordinator.startPokeDetail(referencePokemon)
            })
        
        let viewErrorDispo = outPut.error.asObservable()
            .flatMap { [weak self] error -> Observable<AlertAction> in
                guard let self = self, let error = error else { return .empty() }
                return self.showError(title: "ERROR", message: error.localizedDescription, confirmTitle: "OK", cancelTitle: nil)
            }.subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.handleErrorAlert(action)
            })
        
        disposeBag.insert([pokeEntitiesDispo, showDetailPokeDispo, viewErrorDispo])
    }
    
    private func handleErrorAlert(_ action: AlertAction) {
        switch action {
        case .confirm:
            confirmError.accept(())
        default: break
        }
    }

}

extension PokeListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 30) / 2
        let itemHeight = itemWidth / 1.45
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PokeCollectionViewCell else { return }
        cell.startFetchPokeDetail()
    }

}

extension PokeListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height != 0 else { return }
        
        let height = scrollView.frame.height
        let contentSizeHeight = scrollView.contentSize.height
        let offset = scrollView.contentOffset.y
        let reachedBottom = (offset + height >= contentSizeHeight - 40)
        
        if reachedBottom && !isLoading {
            isLoading = true
            loadMorePage.accept(())
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isLoading = false
    }
}
