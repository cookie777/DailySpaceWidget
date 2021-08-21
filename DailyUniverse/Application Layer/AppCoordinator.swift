//
//  AppCoordinator.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import UIKit

class AppCoordinator: Coordinator {
  let window: UIWindow?
  
  init(window: UIWindow?) {
    self.window = window
  }
  
  func start() {
    let navigationController = UINavigationController()
//    navigationController.hidesBarsOnTap = true
    navigationController.navigationBar.isHidden = true
    if #available(iOS 13.0, *) {
      navigationController.overrideUserInterfaceStyle = .light
    }
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    let galleryCoordinator = GalleryCoordinator(navigationController: navigationController)
    galleryCoordinator.start()
  }
}
