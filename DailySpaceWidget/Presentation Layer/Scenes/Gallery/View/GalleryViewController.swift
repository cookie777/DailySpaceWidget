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
    cv.backgroundColor = .systemPink
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
    bindButtons()
    
    viewModel.getPhotoMetadata()
    
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
      .do(onNext: { (cell, index) in cell.imageViewContainer.imageView.image = nil })
      .subscribe(onNext: { [weak self] (cell, index) in
        guard let self = self else { return }
        let item = self.viewModel.photosMetadata.value[index]
        //  Use `KF` builder
        KF.url(item.imageHDURL)
          .loadDiskFileSynchronously()
          .targetCache(KFManager.imageCache)
          .cacheOriginalImage()
          .fade(duration: 0.25)
          .lowDataModeSource(.network(ImageResource(downloadURL: item.imageURL!)))
          .onSuccess { result in  }
          .onFailure { error in }
          .set(to: cell.imageViewContainer.imageView )
      })
      .disposed(by: disposeBag)
    
    
    // Keep track current index
    collectionView.rx.didEndDisplayingCell
      .filter { $0.cell.isKind(of: PhotoCell.self) }
      .map { ($0.cell as! PhotoCell, $0.at.item) }
      .subscribe { [weak self] (cell, index) in
        guard let index = self?.collectionView.indexPathsForVisibleItems.first?.item else { return }
        self?.viewModel.currentIndex = index
      }.disposed(by: disposeBag)

    
  }
  
  
  private func bindButtons() {
    let tapGesture = UITapGestureRecognizer()
    view.addGestureRecognizer(tapGesture)

    // cancel single when double tap
    let doubleGesture = UITapGestureRecognizer()
    view.addGestureRecognizer(doubleGesture)
    doubleGesture.numberOfTapsRequired = 2
    tapGesture.require(toFail: doubleGesture)
    
    tapGesture.rx
      .event
      .bind(onNext: { [weak self] _ in
          self?.viewModel.didTappedOnce.accept(())
      })
      .disposed(by: disposeBag)    

    viewModel.updateButtons
      .observe(on: MainScheduler.instance)
      .bind { [weak self] alpha in
          UIView.animate(withDuration: 0.16) {
            self?.descriptionButton.alpha = alpha
            self?.settingButton.alpha = alpha
        }
      }.disposed(by: disposeBag)
    
    descriptionButton.rx
      .tap
      .flatMap({ Observable.just(())})
      .bind(to: viewModel.didDescriptionTapped)
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
      heightDimension: .absolute(Constant.UI.longerScreenLength)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: itemSize.heightDimension
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
  
  private func createLandscapeCompositionalLayout() -> UICollectionViewCompositionalLayout {
    
    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(UIScreen.main.bounds.width)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: itemSize.heightDimension
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
    config.contentInsetsReference = .none
    
    return UICollectionViewCompositionalLayout(section: section, configuration: config)
  }
  
}
