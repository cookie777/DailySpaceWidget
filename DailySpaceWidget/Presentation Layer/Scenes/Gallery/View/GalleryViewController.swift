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
  
  var currentIndex: IndexPath? = IndexPath(item: 0, section: 0)
  
  var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    cv.register(
      PhotoCell.self,
      forCellWithReuseIdentifier: PhotoCell.identifier
    )
    cv.isScrollEnabled = false
    cv.backgroundColor = .black
    cv.translatesAutoresizingMaskIntoConstraints = false
    return cv
  }()
  
  let descriptionButton: UIButton = {
    let bt = UIButton()
    bt.setImage(UIImage.createSFIcon(name: "doc.text.fill", size: 40), for: .normal)
    bt.translatesAutoresizingMaskIntoConstraints = false
    bt.alpha = 0
    return bt
  }()
  
  let settingButton: UIButton = {
    let bt = UIButton()
    bt.setImage(UIImage.createSFIcon(name: "gear", size: 40), for: .normal)
    bt.translatesAutoresizingMaskIntoConstraints = false
    bt.alpha = 0
    return bt
  }()
  
  init(viewModel: GalleryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


// MARK: - Lifecycle Methods

extension GalleryViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpUI()
    bindCollectionView()
    bindOrientation()
    
    viewModel.getPhotoMetadata()
    
    collectionView.rx
      .itemSelected
      .bind { [weak self] indexPath in
        guard let cell = self?.collectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
        cell.infoStackView.alpha = cell.infoStackView.alpha == 1.0 ? 0.0 : 1.0
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - Bindings

extension GalleryViewController {
  
  private func bindCollectionView() {
    viewModel.photosMetadata
      .bind(to: collectionView.rx.items(
              cellIdentifier: PhotoCell.identifier,
              cellType: PhotoCell.self)) { row, item, cell in
        cell.updateUI(item: item)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.willDisplayCell
      .filter { $0.cell.isKind(of: PhotoCell.self) }
      .map { ($0.cell as! PhotoCell, $0.at.item) }
      // cell reset
      .do(onNext: { (cell, index) in
        // send action about "what do you do if tapped?"
        cell.didDescriptionTappedHandler = { [weak self] in
          self?.viewModel.cellDescriptionTapped.accept(index)
        }
        cell.didPreviewTappedHandler = { [weak self] in
          self?.viewModel.cellPreviewTapped.accept(index)
        }
        cell.imageViewBackground.image = Constant.UI.placeholderImage
      })
      // try to use widget image for placeholder if you have
      .flatMap({ [weak self] (cell, index) -> Observable<(PhotoCell, PhotoMetadata, UIImage?)> in
        guard let item = self?.viewModel.photosMetadata.value[index] else {
          fatalError("can not find item")
        }
        return ImageManager.checkImageCache(key: item.imageURL?.absoluteString)
          .flatMap { image in
            Observable.just((cell, item, image))
          }
      })
      // fetch and apply iamge
      .subscribe { (cell, item, widgetImage) in          
        KF.url(item.imageURL)
          .placeholder(widgetImage)
          .loadDiskFileSynchronously()
          .targetCache(ImageManager.imageCache)
          .cacheOriginalImage()
          .fade(duration: 0.25)
          .lowDataModeSource(.network(ImageResource(downloadURL: item.imageURL!)))
          .set(to: cell.imageViewBackground )
      }
      .disposed(by: disposeBag)
    
    
    // Keep track current index
    collectionView.rx.didEndDisplayingCell
      .filter { $0.cell.isKind(of: PhotoCell.self) }
      .map { ($0.cell as! PhotoCell, $0.at.item) }
      .subscribe { [weak self] (cell, index) in
        guard let index = self?.collectionView.indexPathsForVisibleItems.first?.item else { return }
        self?.viewModel.currentIndexPath?.item = index
      }.disposed(by: disposeBag)
  }
  
  private func bindOrientation() {
    // if rotate, try to keep current cell by scrolling
    NotificationCenter.default.rx
      .notification(UIDevice.orientationDidChangeNotification)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self, let indexPath = self.viewModel.currentIndexPath else { return }
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
      })
      .disposed(by: disposeBag)
  }
}


// MARK: - UI setups

extension GalleryViewController {
  
  func setUpUI() {
    view.addSubview(collectionView)
    view.addSubview(descriptionButton)
    view.addSubview(settingButton)
    
    collectionView.matchParent()
    collectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
    
    NSLayoutConstraint.activate([
      descriptionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constant.UI.rightMargin),
      descriptionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
    ])
    
    NSLayoutConstraint.activate([
      settingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constant.UI.rightMargin),
      settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
    ])
    
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
      subitems: [item]
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
