//
//  PhotoCell.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-17.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoCell: UICollectionViewCell {
  static let identifier = "photoCell"
  let disposeBag = DisposeBag()
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties
  lazy var sv = UIView()
  lazy var imageViewContainer: PanZoomImageContainer = {
    let container = PanZoomImageContainer()
    return container
  }()

  let titleLabel: UILabel = {
    let uiLabel = UILabel()
    uiLabel.textColor = .white
    return uiLabel
  }()
  
  let dateLabel: UILabel = {
    let uiLabel = UILabel()
    uiLabel.textColor = .white
    return uiLabel
  }()
  
  let copyrightLabel: UILabel = {
    let uiLabel = UILabel()
    uiLabel.textColor = .white
    uiLabel.translatesAutoresizingMaskIntoConstraints = false
    return uiLabel
  }()
  
  lazy var titleStackView: VerticalStackView = {
    let sv = VerticalStackView(
      arrangedSubviews: [titleLabel, dateLabel],
      spacing: 16,
      alignment: .leading
    )
    return sv
  } ()

}


// MARK: - UI Setup

extension PhotoCell {
  private func setupUI() {

    self.contentView.addSubview(imageViewContainer)
    self.contentView.addSubview(copyrightLabel)
    self.contentView.addSubview(titleStackView)
    
    self.contentView.backgroundColor = .clear
    self.contentView.layer.borderWidth = 4.0
    self.contentView.layer.borderColor = UIColor.black.cgColor
    
    imageViewContainer.matchParent()
    
    NSLayoutConstraint.activate([
      titleStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
      titleStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Constant.UI.leftMargin),
      copyrightLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      copyrightLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
    ])
  }
  
  func updateUI(item: PhotoMetadata) {
    titleLabel.text = item.title
    dateLabel.text = item.date
    copyrightLabel.text = item.copyright
  }
}
