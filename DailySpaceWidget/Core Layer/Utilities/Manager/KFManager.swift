//
//  KFManager.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-26.
//

import Foundation
import Kingfisher

struct KFManager {
  private static let kfPath: String = "shared"
  private static let kfFileURL: URL = {
    FileManager
      .default
      .containerURL(forSecurityApplicationGroupIdentifier: Constant.Config.groupIdentifier)!
  } ()
  static var kfImageCache: ImageCache = {
    do {
      let cache = try ImageCache.init(name: kfPath, cacheDirectoryURL: kfFileURL)
      return cache
    } catch {
      print("cache error")
      fatalError("couldn't create cache")
    }
  } ()
}
