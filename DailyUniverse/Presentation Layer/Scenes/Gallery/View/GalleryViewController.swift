//
//  GalleryViewController.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import UIKit
import RxSwift
import RxCocoa

class GalleryViewController: UIViewController {
  
  var viewModel: GalleryViewModel!
  var disposeBag = DisposeBag()
  
  var dataSource: DataSource!
  
  var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    cv.register(
      PhotoCell.self,
      forCellWithReuseIdentifier: PhotoCell.identifier
    )
    cv.backgroundColor = .systemPink
    cv.translatesAutoresizingMaskIntoConstraints = false
    return cv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpUI()
    setUpDiffableDataSource()

//    viewModel.getPhotoMetaData()
    
    viewModel.photos.accept([
      Photo(copyright: nil, date: nil, explanation: nil, imageUrl: nil, title: "test1"),
      Photo(copyright: nil, date: nil, explanation: nil, imageUrl: nil, title: "test2"),
      Photo(copyright: nil, date: nil, explanation: nil, imageUrl: nil, title: "test3"),
    ])
  
    viewModel.photos.bind { [weak self] photos in
      guard let self = self else { return }
      self.viewModel.snapshot.appendItems(Item.wrap(items: photos), toSection: .gallery)

      DispatchQueue.main.async {
          self.dataSource.apply(self.viewModel.snapshot, animatingDifferences: false) {
//            self.collectionView.scrollToItem(at: IndexPath(item: photos.count-1, section: 0), at: .right , animated: false)
          }
      }

    }.disposed(by: disposeBag)
    
  }

}

extension GalleryViewController {
  
    func setUpDiffableDataSource(){
  
      collectionView.register(
        PhotoCell.self,
        forCellWithReuseIdentifier: PhotoCell.identifier
      )
  
      dataSource = DataSource(
        collectionView: collectionView,
        cellProvider:
          { (collectionView, indexPath, item) -> UICollectionViewCell? in
  
            guard let item = item.photo else { return nil }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return nil }
            cell.titleLabel.text = item.title
            return cell
          }
      )
  
      dataSource?.apply(viewModel.snapshot, animatingDifferences: false, completion: nil)
    }
  
}

extension GalleryViewController {
  
  func setUpUI() {
    view.backgroundColor = .systemTeal
    view.addSubview(collectionView)
    
    collectionView.matchParent()
    collectionView.setCollectionViewLayout(createFocusCompositionalLayout(), animated: false)
    collectionView.isScrollEnabled = false
  }
  
  private func createGalleryCompositionalLayout() -> UICollectionViewCompositionalLayout {
    
    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.5),
      heightDimension: .fractionalWidth(0.5)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: itemSize.heightDimension
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 2
    )
    group.interItemSpacing = .fixed(16)
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    section.orthogonalScrollingBehavior = .none
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private func createFocusCompositionalLayout() -> UICollectionViewCompositionalLayout {
    
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
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .zero
    section.orthogonalScrollingBehavior = .groupPaging
    
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .horizontal
    config.contentInsetsReference = .automatic
    
    return UICollectionViewCompositionalLayout(section: section, configuration: config)
  }
  
}
