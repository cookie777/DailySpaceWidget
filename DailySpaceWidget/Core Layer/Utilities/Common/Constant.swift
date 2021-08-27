//
//  Constant.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-20.
//

import UIKit
import Kingfisher

struct Constant {
  
  struct UI {
    static let topMargin: CGFloat = 24
    static let leftMargin: CGFloat = 24
    static let rightMargin: CGFloat = 24
    static let bottomMargin: CGFloat = 24
    
    static var longerScreenLength: CGFloat {
      if UIDevice.current.orientation.isPortrait {
        return UIScreen.main.bounds.height
      } else {
        return UIScreen.main.bounds.width
      }
    }
  }
  
  struct Config {
    static let groupIdentifier: String = "group.com.tak8.DailySpaceWidget"
  }

}
