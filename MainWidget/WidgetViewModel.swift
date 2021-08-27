//
//  WidgetViewModel.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-26.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class WidgetViewModel {

  private var updatePhoto = PublishRelay<UIImage?>()
  
  private var photoStorageService: PhotoStorageServiceImplementation!
  init(photoStorageService: PhotoStorageServiceImplementation!) {
    self.photoStorageService = photoStorageService
  }
  
  func getImage() -> PublishRelay<UIImage?> {
    if photoStorageService.shouldSkipFetching() {
      photoStorageService.restoreLatestPhoto { image in
        self.updatePhoto.accept(image)
      }
    }
    
    return updatePhoto
  }
}
