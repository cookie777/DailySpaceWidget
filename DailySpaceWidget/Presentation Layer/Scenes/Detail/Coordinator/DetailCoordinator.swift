//
//  DetailCoordinator.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-21.
//

import UIKit
class DetailCoordinator: PresentCoordinator {
  
  unowned var navigationController: UINavigationController
  let photoMetadata: PhotoMetadata
  
  init(navigationController: UINavigationController, photoMetadata: PhotoMetadata) {
    self.navigationController = navigationController
    self.photoMetadata = photoMetadata
  }
  
  func start() {
    let detailViewModel = DetailViewModel(coordinator: self, photoMetadata: photoMetadata)
    let detailViewController = DetailViewController(viewModel: detailViewModel)
    
    navigationController.topViewController?.present(detailViewController, animated: true, completion: nil)
  }
  
  func dismiss() {
    guard let galleryViewController = navigationController.topViewController as? GalleryViewController else { return }
    galleryViewController.dismiss(animated: true, completion: nil)
  }
  
}

