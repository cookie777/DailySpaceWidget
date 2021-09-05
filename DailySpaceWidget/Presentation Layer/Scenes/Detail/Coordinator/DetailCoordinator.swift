//
//  DetailCoordinator.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-21.
//

import UIKit
class DetailCoordinator: Coordinator {
  
  unowned let navigationController: UINavigationController
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
  
  func end() {
    guard let galleryViewController = navigationController.topViewController as? GalleryViewController else { return }
    galleryViewController.dismiss(animated: true, completion: nil)
  }
  
}

extension DetailCoordinator {
  var topController: UIViewController? {
    // get top view in navigation controller
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    guard var topController = keyWindow?.rootViewController else { return nil }
    while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
    }
    return topController
  }
}
