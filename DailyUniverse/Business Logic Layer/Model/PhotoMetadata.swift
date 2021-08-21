//
//  Photo.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-17.
//

import Foundation

struct PhotoMetadata: Hashable {
  let copyright: String?
  let date: String?
  let explanation: String?
  let imageHDURL: URL?
  let imageURL: URL?
  let title: String?
}
