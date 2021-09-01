//
//  ManagedPhotoMetadata.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-22.
//

import Foundation
import RealmSwift

class ManagedPhotoMetadata: Object {
  @objc dynamic var copyright: String?
  @objc dynamic var date: Date?
  @objc dynamic var explanation: String?
  @objc dynamic var imageHDURL: String?
  @objc dynamic var imageURL: String?
  @objc dynamic var title: String?
  
  convenience init(
    copyright: String? = "",
    date: Date? = Date(),
    explanation: String? = "",
    imageHDURL: String? = "",
    imageURL: String? = "",
    title: String? = ""
  ) {
    self.init()
    self.copyright = copyright
    self.date = date
    self.explanation = explanation
    self.imageHDURL = imageHDURL
    self.imageURL = imageURL
    self.title = title
  }
}

extension ManagedPhotoMetadata {
  func toPhotoMetadata() -> PhotoMetadata {
    
    let hdURL = self.imageHDURL == nil ? nil : URL(string: self.imageHDURL!)
    let url = self.imageURL == nil ? nil : URL(string: self.imageURL!)
    
    return PhotoMetadata(
      copyright: self.copyright,
      date: self.date,
      explanation: self.explanation,
      imageHDURL: hdURL,
      imageURL: url,
      title: self.title
    )
  }
}
