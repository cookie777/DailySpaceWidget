//
//  PreviewCoordinator.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-09-06.
//

import UIKit
class PreviewCoordinator: PresentCoordinator {
  
  unowned var navigationController: UINavigationController
  let image: UIImage
  let hdImageURL: URL?
  
  init(
    navigationController: UINavigationController,
    image: UIImage,
    hdImageURL: URL?
  ) {
    self.navigationController = navigationController
    self.image = image
    self.hdImageURL = hdImageURL
  }
  
  func start() {
    let previewViewModel = PreviewViewModel(coordinator: self, image: image, hdImageURL: hdImageURL)
    let previewViewController = PreviewViewController(viewModel: previewViewModel)
    previewViewController.modalPresentationStyle = .currentContext
    previewViewController.modalTransitionStyle = .crossDissolve
    navigationController.present(previewViewController, animated: true, completion: nil)
  }
  
  func dismiss() {
    guard let galleryViewController = navigationController.topViewController as? GalleryViewController else { return }
    galleryViewController.dismiss(animated: true, completion: nil)
  }
  
}
