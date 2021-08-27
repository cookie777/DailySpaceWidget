//
//  GalleryCoordinatorImplementation.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import UIKit

class GalleryCoordinator: Coordinator {
  unowned let navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let photoStorageService = PhotoStorageServiceImplementation()
    let photoFetchService = PhotosFetchServiceImplementation()
    
    let galleryViewModel = GalleryViewModel(
      coordinator: self,
      photoStorageService: photoStorageService,
      photoFetchService: photoFetchService
    )
    let galleryViewController = GalleryViewController(viewModel: galleryViewModel)
    
    navigationController.pushViewController(galleryViewController, animated: true)
  }
  
  func pushToDetail(photoMetadata: PhotoMetadata) {
    let coordinator = DetailCoordinator(
      navigationController: self.navigationController,
      photoMetadata: photoMetadata
    )
    
    coordinate(to: coordinator)
  }
  
}
