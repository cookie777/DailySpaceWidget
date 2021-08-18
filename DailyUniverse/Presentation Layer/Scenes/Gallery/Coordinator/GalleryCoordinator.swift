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
    let galleryViewController = GalleryViewController()
    galleryViewController.viewModel = GalleryViewModel()
    navigationController.pushViewController(galleryViewController, animated: true)
  }
  
  
}
