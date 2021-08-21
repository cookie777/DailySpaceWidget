//
//  PhotoCell.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-17.
//

import UIKit

class PhotoCell: UICollectionViewCell {
  static let identifier = "photoCell"
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties

  lazy var imageViewContainer: PanZoomImageContainer = {
    let container = PanZoomImageContainer()
    container.translatesAutoresizingMaskIntoConstraints = false
    return container
  }()
  
  lazy var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    indicator.hidesWhenStopped = true
    indicator.center = self.contentView.center
    return indicator
  }()
  
  lazy var titleLabel: UILabel = {
    let uiLabel = UILabel()
    uiLabel.translatesAutoresizingMaskIntoConstraints = false
    return uiLabel
  }()
  
  
}

// MARK: - UI Setup
extension PhotoCell {
  private func setupUI() {
    self.contentView.addSubview(imageViewContainer)
    self.contentView.addSubview(activityIndicator)
//    self.addSubview(titleLabel)
    self.contentView.backgroundColor = .systemGreen
    self.contentView.layer.borderWidth = 4.0
    self.contentView.layer.borderColor = UIColor.black.cgColor
    
//    titleLabel.centerXYin(contentView)
    imageViewContainer.matchParent()
  }
}
