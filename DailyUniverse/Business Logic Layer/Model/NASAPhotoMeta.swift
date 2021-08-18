//
//  NASAPhoto.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import Foundation

struct NASAPhotoMeta: Codable {
  let copyright: String?
  let date: String?
  let explanation: String?
  let hdUrl: String?
  let url: String?
  let mediaType: String?
  let title: String?
  
  enum CodingKeys: String, CodingKey {
    case copyright, date, explanation, url, title
    case hdUrl = "hdurl"
    case mediaType = "media_type"
  }
}

