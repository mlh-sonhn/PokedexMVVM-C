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
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, PokeEntity>> { (_, collectionView, indexPath, item) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCollectionViewCell.className, for: indexPath) as? PokeCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .red
        return cell
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private var loadViewRelay = PublishRelay<Void>()
    
    var viewModel: PokeListViewModel!
    var enviroment: PokeListEnviroment!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        bindViewModel()
        
        // Start load items
        loadViewRelay.accept(())
    }
    
    @objc private func reloadView() {
        
    }
    
    private func setupTableView() {
        collectionView.backgroundView = UIView()
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = PokeListViewModel.Input(loadView: loadViewRelay.asObservable(),
                                            showDetail: collectionView.rx.itemSelected.map { $0.row })
        let outPut = viewModel.transform(enviroment: enviroment)(input)
        
        
        let pokeEntitiesDispo = outPut.pokes
            .map { pokeEntities -> [SectionModel<String, PokeEntity>] in
                return pokeEntities.map({ SectionModel(model: "", items: [$0]) })
            }.drive(collectionView.rx.items(dataSource: dataSource))
        
        let viewErrorDispo = outPut.error.asObservable()
            .flatMap { [weak self] error -> Observable<AlertAction> in
                guard let self = self, let error = error else { return .empty() }
                return self.showError(title: "ERROR", message: error.localizedDescription, confirmTitle: "OK", cancelTitle: "")
            }.subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.handleErrorAlert(action)
            })
        
        disposeBag.insert([pokeEntitiesDispo, viewErrorDispo])
    }
    
    private func handleErrorAlert(_ action: AlertAction) {
        switch action {
        case .confirm:
            // TODO: Do something when user is confirm error
            print("Is confirm alert")
        default: break
        }
    }

}

extension PokeListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 10) / 2
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

}
