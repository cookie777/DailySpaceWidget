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

  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    bindButton()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties
  
  static let identifier = "photoCell"
  private(set) var disposeBag = DisposeBag()
  var didTapedHandler: (()->())?
  
  var imageViewBackground: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let uiLabel = UILabel()
    uiLabel.textColor = .white.withAlphaComponent(0.72)
    uiLabel.font = .systemFont(ofSize: 28, weight: .heavy)
    uiLabel.numberOfLines = 0
    
    return uiLabel
  }()
  
  let copyrightLabel: UILabel = {
    let uiLabel = UILabel()
    uiLabel.textColor = .white.withAlphaComponent(0.48)
    uiLabel.font = .systemFont(ofSize: 12, weight: .semibold)
    return uiLabel
  }()
  
  let dateLabel: UILabel = {
    let uiLabel = UILabel()
    uiLabel.textColor = .white.withAlphaComponent(0.72)
    uiLabel.font = .systemFont(ofSize: 16, weight: .bold)
    return uiLabel
  }()
  
  let descriptionButton: UIButton = {
    let bt = UIButton()
    bt.setImage(UIImage.createSFIcon(name: "doc.text.fill", size: 40), for: .normal)
    return bt
  }()
  
  lazy var infoStackView: VerticalStackView = {
    let sv = VerticalStackView(
      arrangedSubviews: [titleLabel, copyrightLabel, dateLabel, descriptionButton],
      spacing: 2,
      alignment: .leading
    )
    sv.isLayoutMarginsRelativeArrangement = true
    sv.directionalLayoutMargins = .init(top: 24, leading: 24, bottom: 24, trailing: 24)
    
    sv.setCustomSpacing(14, after: copyrightLabel)
    sv.backgroundColor = .black
    sv.layer.cornerRadius = 16
    
    return sv
  } ()
}


// MARK: - 

extension PhotoCell {

  func bindButton() {
    descriptionButton.rx
      .tap
      .bind(onNext: { [weak self] _ in
        self?.didTapedHandler?()
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - UI Setup

extension PhotoCell {
  private func setupUI() {
    
    self.contentView.addSubview(imageViewBackground)
    self.contentView.addSubview(copyrightLabel)
    self.contentView.addSubview(infoStackView)
    
    self.contentView.backgroundColor = .black
    
    imageViewBackground.matchParent()
    infoStackView.anchors(
      topAnchor: nil,
      leadingAnchor: contentView.leadingAnchor,
      trailingAnchor: contentView.trailingAnchor,
      bottomAnchor: contentView.bottomAnchor,
      padding: .init(
        top: 0,
        left: Constant.UI.leftMargin,
        bottom: Constant.UI.bottomMargin,
        right: Constant.UI.rightMargin
      )
    )
  }
  
  func updateUI(item: PhotoMetadata) {
    titleLabel.text = item.title
    dateLabel.text = Formatter.dateToStringForApp(date: item.date)
    copyrightLabel.text = Formatter.copyrightWithNASA(string: item.copyright)
  }
}
