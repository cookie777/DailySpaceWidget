//
//  Photo.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-17.
//

import Foundation

struct PhotoMetadata: Hashable {
  let copyright: String?
  let date: Date?
  let explanation: String?
  let imageHDURL: URL?
  let imageURL: URL?
  let title: String?
}

extension PhotoMetadata {
  func toManaged() -> ManagedPhotoMetadata {
    return ManagedPhotoMetadata(
      copyright: self.copyright,
      date: self.date,
      explanation: self.explanation,
      imageHDURL: self.imageHDURL?.description,
      imageURL: self.imageURL?.description,
      title: self.title
    )
  }
}
