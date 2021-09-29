//
//  DetailViewModel.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-21.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
  
  let coordinator: DetailCoordinator!
  
  let photoMetadata: PhotoMetadata
  let disposeBag = DisposeBag()
  
  // input, View -> ViewModel
  var didBackTapped = PublishSubject<Void>()
  
  init(coordinator: DetailCoordinator ,photoMetadata: PhotoMetadata) {
    self.coordinator = coordinator
    self.photoMetadata = photoMetadata
    
    
    didBackTapped
      .bind(onNext: { [weak self] _ in
        self?.coordinator.dismiss()
      })
      .disposed(by: disposeBag)
  }

}
