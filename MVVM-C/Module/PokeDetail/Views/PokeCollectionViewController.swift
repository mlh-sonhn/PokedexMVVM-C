//
//  PokeCollectionViewController.swift
//  MVVM-C
//
//  Created by SonHoang on 10/21/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias PokeCollectionSectionItem = AnimatableSectionModel<String, NamedAPIResource>

final class PokesCollectionFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // Page width used for estimating and calculating paging.
        let pageWidth = self.itemSize.width + self.minimumLineSpacing

        // Make an estimation of the current page position.
        let approximatePage = self.collectionView!.contentOffset.x / pageWidth

        // Determine the current page based on velocity.
        let currentPage = (velocity.x < 0.0) ? floor(approximatePage) : ceil(approximatePage)

        // Create custom flickVelocity.
        let flickVelocity = velocity.x * 0.3

        // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)

        // Calculate newHorizontalOffset.
        let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - self.collectionView!.contentInset.left

        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
}

class PokeCollectionViewController: UICollectionViewController {
    
    private var isLoading: Bool = false

    private lazy var sectionItems: Driver<[PokeCollectionSectionItem]> = {
        return sectionItemsRelay.map({ items -> [PokeCollectionSectionItem] in
            return [PokeCollectionSectionItem(model: "", items: items)]
        }).asDriver(onErrorJustReturn: [])
    }()
    
    private lazy var datasource = RxCollectionViewSectionedAnimatedDataSource<PokeCollectionSectionItem>(animationConfiguration: AnimationConfiguration(insertAnimation: .none, reloadAnimation: .none, deleteAnimation: .none), configureCell: { (_, collectionView, indexPath, pokemon) -> UICollectionViewCell in
        guard let pokesViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PokesViewCell.className, for: indexPath) as? PokesViewCell else { return UICollectionViewCell() }
        pokesViewCell.configCell(with: pokemon)
        return pokesViewCell
    })
    
    let disposeBag = DisposeBag()
    
    var sectionItemsRelay = BehaviorRelay<[NamedAPIResource]>(value: [])
    var loadMorePage = PublishRelay<LoadPokemonDirection>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindingObervable()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = nil
        collectionView.delegate = nil
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        let flowLayout = PokesCollectionFlowLayout()
        let itemWidth = collectionView.frame.width / 3
        let itemHeight = collectionView.frame.height
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    private func bindingObervable() {
        sectionItems.drive(collectionView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        sectionItems.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, !self.collectionView.contentOffset.x.isZero else { return }
                self.collectionView.scrollToItem(at: IndexPath(item: 3, section: 0), at: .centeredHorizontally, animated: false)
            }).disposed(by: disposeBag)

    }

}

extension PokeCollectionViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.width != 0 else { return }
        
        let width = scrollView.frame.height
        let contentSizeHeight = scrollView.contentSize.width
        let offset = scrollView.contentOffset.x
        let reachedBottom = offset + width >= contentSizeHeight - (width + width)
        let reachedTop = offset + width <= width + width

        if reachedBottom && !isLoading {
            isLoading = true
            loadMorePage.accept(.next)
        } else if reachedTop && !isLoading {
            isLoading = true
            loadMorePage.accept(.previous)
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isLoading = false
    }
}

