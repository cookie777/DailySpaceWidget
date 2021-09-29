//
//  PreviewViewController.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-09-06.
//

import UIKit
import RxSwift


// MARK: - Properties

final class PreviewViewController: UIViewController {
  
  var viewModel: PreviewViewModel!
  let disposeBag = DisposeBag()
  let scrollView = PanZoomImageScrollView()
  
  let maskView: UIView = {
    let uiView = UIView()
    uiView.backgroundColor = .black.withAlphaComponent(0.24)
    uiView.translatesAutoresizingMaskIntoConstraints = false
    return uiView
  }()
  
  let guideLabel: UILabel = {
    let lb = UILabel()
    lb.text = """
              One tap: Display or hide guides
              
              Two top: Zoom or un-zoom a photo
              
              Drag   : Move a photo
              """
    lb.font = .systemFont(ofSize: 16, weight: .bold)
    lb.numberOfLines = 0
    lb.textColor = .white.withAlphaComponent(0.8)
    lb.translatesAutoresizingMaskIntoConstraints = false
    return lb
  }()
  
  lazy var closeButton: UIButton = {
    let bt = UIButton()
    let image = UIImage.createSFIcon(
      name: "multiply.circle.fill",
      size: 28,
      weight: .medium,
      scale: .default
    )
    bt.setImage(image, for: .normal)
    bt.setTitle("back", for: .normal)
    
    var filled = UIButton.Configuration.filled()
    filled.imagePadding = 8
    bt.configuration = filled
    
    return bt
  }()
  
//  let hdButton: UIButton = {
//    let bt = UIButton()
//    let image = UIImage.createSFIcon(
//      name: "sparkles",
//      size: 28,
//      weight: .medium,
//      scale: .default
//    )
//    bt.setImage(image, for: .normal)
//    bt.setTitle("HD", for: .normal)
//    bt.imageEdgeInsets.left -= 8
//    return bt
//  }()
  
  lazy var buttonsStackView: HorizontalStackView = {
    let stackView = HorizontalStackView(
      arrangedSubviews: [closeButton],
      alignment: .center,
      distribution: .equalSpacing
    )
    return stackView
  } ()
  
  
  // MARK: - Life cycle
  
  init(viewModel: PreviewViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    setUpUI()
    bindButtons()
    bindTapGesture()
  }
}


// MARK: - Bindings

extension PreviewViewController {
  private func bindButtons() {
    closeButton.rx
      .tap
      .bind(to: viewModel.didCloseButtonTapped)
      .disposed(by: disposeBag)
    
//    hdButton.rx
//      .tap
//      .bind(to: viewModel.didHDButtonTapped)
//      .disposed(by: disposeBag)
    
    viewModel.updateButtonsAlpha
      .bind(to: buttonsStackView.rx.alpha)
      .disposed(by: disposeBag)
  }
  
  private func bindTapGesture() {
    let singleTapGesture = UITapGestureRecognizer()
    scrollView.addGestureRecognizer(singleTapGesture)
    singleTapGesture.numberOfTapsRequired = 1
    singleTapGesture.require(toFail: scrollView.doubleTapRecognizer)
    
    singleTapGesture.rx.event
      .flatMap({ [weak self] _ in
        Observable.just(self?.viewModel.flipAlpha())
      })
      .compactMap{$0}
      .subscribe(on: MainScheduler.instance)
      .bind(onNext: { [weak self] alpha in
        UIView.animate(withDuration: 0.16, delay: 0, options: [.curveEaseOut]) {
          self?.maskView.alpha = alpha
          self?.guideLabel.alpha = alpha
          self?.buttonsStackView.alpha = alpha
        }
      })
      .disposed(by: disposeBag)
  }
  
//  private func bindImage() {
//    viewModel.updateHDImage
//      .bind { [weak self] image in
//        guard let image = image else { return }
//        self?.scrollView.imageView.image = image
//      }
//      .disposed(by: disposeBag)
//  }
}


// MARK: - UI

extension PreviewViewController {
  private func setUpUI() {
    // Actual views order (affects to gesture recognizer)
    view.addSubview(maskView)
    view.addSubview(scrollView)
    view.addSubview(buttonsStackView)
    view.addSubview(guideLabel)
    
    // Visual views order
    scrollView.layer.zPosition = 0
    maskView.layer.zPosition = 1
    buttonsStackView.layer.zPosition = 2
    guideLabel.layer.zPosition = 2
    
    scrollView.imageView.image = viewModel.image
    scrollView.matchParent()
    
    maskView.matchParent()
    
    NSLayoutConstraint.activate([
      guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      guideLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])

    buttonsStackView.anchors(
      topAnchor: nil,
      leadingAnchor: view.leadingAnchor,
      trailingAnchor: view.trailingAnchor,
      bottomAnchor: view.bottomAnchor,
      padding: .init(
        top: 0,
        left: Constant.UI.leftMargin,
        bottom: Constant.UI.bottomMargin,
        right: Constant.UI.rightMargin
      )
    )
  }
}
