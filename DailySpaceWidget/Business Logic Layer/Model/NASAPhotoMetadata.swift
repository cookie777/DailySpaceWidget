//
//  NASAPhoto.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import Foundation

struct NASAPhotoMetadata: Codable {
  let copyright: String?
  let date: String?
  let explanation: String?
  let hdURL: String?
  let url: String?
  let mediaType: String?
  let title: String?
  
  enum CodingKeys: String, CodingKey {
    case copyright, date, explanation, url, title
    case hdURL = "hdurl"
    case mediaType = "media_type"
  }
}

extension NASAPhotoMetadata {
  func toPhotoMetadata() -> PhotoMetadata {
    let hdURL = self.hdURL == nil ? nil : URL(string: self.hdURL!)
    let url = self.url == nil ? nil : URL(string: self.url!)
    
    return PhotoMetadata(
      copyright: self.copyright,
      date: Formatter.stringToDate(string: self.date),
      explanation: self.explanation,
      imageHDURL: hdURL,
      imageURL: url,
      title: self.title
    )
  }
}

