//
//  KFManager.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-26.
//

import Foundation
import RxSwift
import Kingfisher

protocol KFManagerProtocol {
  static var imageCache: ImageCache { get }
}

struct CustomKFManager: KFManagerProtocol {
  
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
  
  /// This is applied for displaying widget image when using HD image cache.
  /// This is to prevent display too huge image widget which might causes memory leak
  static let downsamplingImageSize = CGSize(width: 400,height: 400)
  
  /// Check if there is a  target image in cache.
  /// - Parameter key: url of target image used for fetching
  /// - Returns: Observable object contains target image
  static func checkImageCache(key: String?) -> Observable<UIImage?> {
    guard let key = key else { return Observable.just(nil) }
    
    let cache = CustomKFManager.imageCache
    return Observable.create { observer in
      cache.retrieveImage(
        forKey: key
      ) { result in
        switch result {
          case .success(let value):
            observer.onNext(value.image)
            
          case .failure(let error):
            print(error)
            observer.onError(error)
        }
      }
      return Disposables.create()
    }
  }
  
  /// Get target Image by url. If there is a cache, use it. If not, try fetching.
  /// - Parameter url: url of target image used for fetching or cache key
  /// - Returns:  Observable object contains target image
  static func getImage(url: URL?) -> Observable<UIImage?> {
    
    guard let url = url else { return Observable.just(nil) }
    
    let options: KingfisherOptionsInfo = [
      .targetCache(CustomKFManager.imageCache),
      .scaleFactor(UIScreen.main.scale),
    ]

    return Observable.create { observer in
      KingfisherManager.shared.retrieveImage(
        with: url,
        options: options,
        completionHandler: { result in
          switch result {
            case .success(let value):
              print("Get image by fetching or cache from: \(url).")
              observer.onNext(value.image)
              observer.onCompleted()
            case .failure(let error):
              debugPrint(error)
              observer.onError(error)
          }
        }
      )
      return Disposables.create()
    }
  }
  
  
  /// Get target Image by key(string). If there is a cache, use it. If not, try fetching.
  /// - Parameter key: string
  /// - Returns:Observable object contains target image
  static func getImage(key: String?) -> Observable<UIImage?> {
    guard let key = key, let url = URL(string: key) else { return Observable.just(nil) }
    return getImage(url: url)
  }
}
