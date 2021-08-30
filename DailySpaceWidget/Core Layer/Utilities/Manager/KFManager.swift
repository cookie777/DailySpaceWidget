//
//  KFManager.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-26.
//

import Foundation
import Kingfisher

protocol KFManagerProtocol {
  static var imageCache: ImageCache { get }
}

struct KFManager: KFManagerProtocol {
  private static let path: String = "shared"
  private static let fileURL: URL = {
    FileManager
      .default
      .containerURL(forSecurityApplicationGroupIdentifier: Constant.Config.groupIdentifier)!
  } ()
  static var imageCache: ImageCache = {
    do {
      let cache = try ImageCache.init(name: path, cacheDirectoryURL: fileURL)
      return cache
    } catch {
      print("cache error")
      fatalError("couldn't create cache")
    }
  } ()
  
  
  /// Check if there is a  target image in cache.
  /// - Parameters:
  ///   - key: url of target image used for fetching
  ///   - completion: closure of completion handler. Pass Target image if cached. If not exist, return nil
  /// - Returns: Nothing
  static func checkImageCache(key: String, completion: @escaping(UIImage?) -> ()) {
    let cache = KFManager.imageCache
    cache.retrieveImage(forKey: key ) { result in
        switch result {
        case .success(let value):
          print(value)
          completion(value.image)
          
        case .failure(let error):
            print(error)
          completion(nil)
        }
    }
  }
  
  
  /// Get target Image by url. If there is a cache, use it. If not, try fetching.
  /// - Parameters:
  ///   - url:
  ///   - completion: closure of completion handler. Pass the target image if cached or fetched. If not exist, return nil
  /// - Returns: Nothing.
  static func getImage(url: URL?, completion: @escaping(UIImage?) -> ()) {
    guard let url = url else { return completion(nil) }
    
    KingfisherManager.shared.retrieveImage(
      with: url,
      options:  [
        .targetCache(KFManager.imageCache),
        .cacheOriginalImage
      ],
      completionHandler: { result in
        switch result {
          case .success(let value):
            completion(value.image)
          case .failure(let error):
            print(error)
            completion(nil)
        }
        
      }
    )
  }
}
