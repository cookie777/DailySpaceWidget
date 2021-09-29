//
//  Constant.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-20.
//

import UIKit

struct Constant {
  
  struct UI {
    static let topMargin: CGFloat = 56
    static let leftMargin: CGFloat = 24
    static let rightMargin: CGFloat = 24
    static let bottomMargin: CGFloat = 56
    
    static var longerScreenLength: CGFloat {
      if UIDevice.current.orientation.isPortrait {
        return UIScreen.main.bounds.height
      } else {
        return UIScreen.main.bounds.width
      }
    }
    
    static var shorterScreenLength: CGFloat {
      if UIDevice.current.orientation.isPortrait {
        return UIScreen.main.bounds.width
      } else {
        return UIScreen.main.bounds.height
      }
    }
    
    static let placeholderImage: UIImage = UIImage.withColor(.black)
  }
  
  struct Config {
    static let groupIdentifier: String = "group.com.tak8.DailySpaceWidget"
    static let numOfDaysToKeep: Int = 4
  }

}
