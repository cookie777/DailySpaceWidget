//
//  PreviewViewModel.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-09-06.
//

import UIKit
import RxSwift
import RxCocoa

class PreviewViewModel {
  let coordinator: PreviewCoordinator!
  
  let image: UIImage
  let hdImageURL: URL?
  let disposeBag = DisposeBag()
  var alpha: CGFloat = 1.0
  
  // input, View -> ViewModel
  var didCloseButtonTapped = PublishSubject<Void>()
//  var didHDButtonTapped = PublishSubject<Void>()
  var didSingleTapped = PublishSubject<CGFloat?>()
  
  // output
  var updateButtonsAlpha = PublishRelay<CGFloat>()
//  var updateHDImage = PublishRelay<UIImage?>()
  
  init(coordinator: PreviewCoordinator ,image: UIImage, hdImageURL: URL?) {
    self.coordinator = coordinator
    self.image = image
    self.hdImageURL = hdImageURL
    
    didCloseButtonTapped
      .bind(onNext: { [weak self] _ in
        self?.coordinator.dismiss()
      })
      .disposed(by: disposeBag)
    
//    didHDButtonTapped
//      .flatMap({ _  -> Observable<UIImage?> in
//        CustomKFManager.getImage(url: hdImageURL)
//      })
//      .bind(to: updateHDImage)
//      .disposed(by: disposeBag)
    
    didSingleTapped
      .flatMap({ alpha in
        return Observable.just(alpha == 1.0 ? 0 : 1.0)
      })
      .bind(to: updateButtonsAlpha)
      .disposed(by: disposeBag)
  }
  
  func flipAlpha() -> CGFloat {
    alpha = alpha == 1.0 ? 0 : 1.0
    return alpha
  }
}
