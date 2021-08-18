//
//  GalleryViewController.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import UIKit
import RxSwift

class GalleryViewController: UIViewController {
  
  var viewModel: GalleryViewModel!
  var disposeBag = DisposeBag()
  
  var dataSource: DataSource!
  var flip: Bool = false
  
  var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    cv.backgroundColor = .systemPink
    cv.translatesAutoresizingMaskIntoConstraints = false
    return cv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpUI()
    setUpDiffableDataSource()
    
    for i in 0...100 {
      viewModel.snapshot.appendItems([.photo(Photo(title: String(i)))], toSection: .gallery)
    }
    

    dataSource.apply(viewModel.snapshot, animatingDifferences: true, completion: nil)
    //    let s = PhotosMetaDataServiceImplementation()
    //    s.getPhoto(date: Date.getPastDate()).subscribe { (metas, error) in
    //      print(error)
    //      print(metas)
    //    }.disposed(by: disposeBag)

        collectionView.rx.itemSelected.subscribe { indexPath in
          
            if self.flip {
//              UIView.animate(withDuration: 0.5) {
                self.collectionView.setCollectionViewLayout(self.createGalleryCompositionalLayout(), animated: true)
//              }
//              self.collectionView.reloadData()
                self.flip = false
//              }
              
            } else {
//              DispatchQueue.main.async {
//                UIView.animate(withDuration: 0.5) {
                  self.collectionView.setCollectionViewLayout(self.createFocusCompositionalLayout(), animated: true)
//                  self.collectionView.scrollToItem(at: indexPath.element!, at: .bottom, animated: false)
                  self.flip = true
//                }
//              }
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
    // Config compositionalLayout
    collectionView.setCollectionViewLayout(createGalleryCompositionalLayout(), animated: false)
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
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 1
    )
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
//    section.orthogonalScrollingBehavior = .groupPaging

    return UICollectionViewCompositionalLayout(section: section)
  }

}
