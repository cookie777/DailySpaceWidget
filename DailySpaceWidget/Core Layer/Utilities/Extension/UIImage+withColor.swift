//
//  UIImage+withColor.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-09-01.
//

import UIKit

extension UIImage {
  static func withColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    let image =  UIGraphicsImageRenderer(size: size, format: format).image { rendererContext in
      color.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: size))
    }
    return image
  }
}

