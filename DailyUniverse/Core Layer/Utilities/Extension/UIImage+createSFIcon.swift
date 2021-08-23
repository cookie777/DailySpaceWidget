//
//  UIImage+createIcon.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-20.
//

import UIKit

extension UIImage {
  
  static func createSFIcon(
    name: String,
    size: CGFloat = 40,
    weight: UIImage.SymbolWeight = .bold,
    scale: UIImage.SymbolScale = .default
  ) -> UIImage? {
    
    let config = UIImage.SymbolConfiguration(
      pointSize: size,
      weight: weight,
      scale: scale
    )

    return  UIImage(
      systemName: name,
      withConfiguration: config
    )
  }
}


extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
