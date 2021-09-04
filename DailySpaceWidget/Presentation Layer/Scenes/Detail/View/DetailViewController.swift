//
//  DetailViewController.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-21.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  
  lazy var scrollView: DynamicHeightScrollView = {
    let scrollView = DynamicHeightScrollView(
      contentView: scrollViewContent,
      padding: .init(top: 32, left: 32, bottom: 32, right: 32)
    )
    return scrollView
  } ()
  
  lazy var scrollViewContent: VerticalStackView = {
    let content = VerticalStackView(
      arrangedSubviews: [titleLabel, dateLabel, descriptionLabel],
      spacing: 32,
      alignment: .leading,
      distribution: .equalSpacing
    )
    return content
  } ()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  let copyrightLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage.createSFIcon(name: "photo.fill", size: 40), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  var viewModel: DetailViewModel!
  
  init(viewModel: DetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpUI()
    updateUI()
    
    bindButtons()

  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  private func setUpUI() {
    view.addSubview(scrollView)
    view.addSubview(backButton)
    
    scrollView.matchParent()
    NSLayoutConstraint.activate([
      backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constant.UI.bottomMargin),
      backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constant.UI.rightMargin)
    ])
  }
  
  private func updateUI() {
    titleLabel.text = viewModel.photoMetadata.title
    dateLabel.text = DateFormatter.toStringForApp(date: viewModel.photoMetadata.date)
    descriptionLabel.text = viewModel.photoMetadata.explanation
    copyrightLabel.text = viewModel.photoMetadata.copyright
  }
  
  private func bindButtons() {
    backButton.rx
      .tap
      .flatMap({ Observable<Void>.just(())})
      .bind(to: viewModel.didBackTapped)
      .disposed(by: disposeBag)
  }
}
