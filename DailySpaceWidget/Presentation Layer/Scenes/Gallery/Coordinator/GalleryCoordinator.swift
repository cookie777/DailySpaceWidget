//
//  GalleryCoordinatorImplementation.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import UIKit

class GalleryCoordinator: Coordinator {
  unowned var navigationController: UINavigationController
  
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
  
  func presentDetail(photoMetadata: PhotoMetadata) {
    let coordinator = DetailCoordinator(
      navigationController: self.navigationController,
      photoMetadata: photoMetadata
    )
    coordinate(to: coordinator)
  }
  
  func presentPreview(image: UIImage, hdImageURL: URL?) {
    let coordinator = PreviewCoordinator(
      navigationController: self.navigationController,
      image: image,
      hdImageURL: hdImageURL
    )
    coordinate(to: coordinator)
  }
  
}
