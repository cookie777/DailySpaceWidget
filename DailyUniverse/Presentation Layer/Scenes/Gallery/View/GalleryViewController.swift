//
//  GalleryViewController.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

// MARK: - Properties

class GalleryViewController: UIViewController {
  
  var viewModel: GalleryViewModel!
  var disposeBag = DisposeBag()
  
  var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    cv.register(
      PhotoCell.self,
      forCellWithReuseIdentifier: PhotoCell.identifier
    )
    cv.isScrollEnabled = false
    cv.backgroundColor = .systemPink
    cv.translatesAutoresizingMaskIntoConstraints = false
    return cv
  }()
  
}


// MARK: - Lifecycle Methods

extension GalleryViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpUI()
    bindCollectionView()
    
//    viewModel.getPhotoMetadata()
    viewModel.getMockMetadata()
  }
}

// MARK: - Bindings

extension GalleryViewController {
  private func bindCollectionView() {
    viewModel.photosMetadata
      .bind(to: collectionView.rx.items(
              cellIdentifier: PhotoCell.identifier,
              cellType: PhotoCell.self)) { row, item, cell in
        cell.titleLabel.text = item.title
      }
      .disposed(by: disposeBag)

    collectionView.rx.willDisplayCell
      .filter { $0.cell.isKind(of: PhotoCell.self) }
      .map { ($0.cell as! PhotoCell, $0.at.item) }
      .do(onNext: { (cell, index) in cell.imageViewContainer.imageView.image = nil })
      .subscribe(onNext: { [weak self] (cell, index) in
        guard let self = self else { return }
        
        let item = self.viewModel.photosMetadata.value[index]
       //  Use `KF` builder
        KF.url(item.imageHDURL)
          .loadDiskFileSynchronously()
          .cacheOriginalImage()
          .fade(duration: 0.25)
          .lowDataModeSource(.network(ImageResource(downloadURL: item.imageURL!)))
          .onSuccess { result in  }
          .onFailure { error in }
          .set(to: cell.imageViewContainer.imageView )
      })
      .disposed(by: disposeBag)
  }
}


// MARK: - UI setups

extension GalleryViewController {
  
  func setUpUI() {
    view.backgroundColor = .systemTeal
    view.addSubview(collectionView)
    
    collectionView.matchParent()
    collectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
  }
  
  private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
    
    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .horizontal
    config.contentInsetsReference = .automatic
    
    return UICollectionViewCompositionalLayout(section: section, configuration: config)
  }
  
}
