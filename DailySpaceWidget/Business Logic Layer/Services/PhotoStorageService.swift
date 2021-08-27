//
//  PhotoMetadataStorageService.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-22.
//

import Foundation
import RxSwift
import RealmSwift
import Kingfisher

protocol PhotoStorageService: AnyObject {
  
  func shouldSkipFetching() -> Bool
  
  func storeLatestUpdateDate()
  
  func restorePhotoMetadata() -> [PhotoMetadata]
  
  func storePhotoMetadata(photosMetadata: [PhotoMetadata]) -> Bool
  
  func restoreLatestPhoto(completion: @escaping(UIImage?) -> ())
}

class PhotoStorageServiceImplementation: PhotoStorageService {
  
  func storeLatestUpdateDate() {
    UserDefaultManager.save(key: UserDefaultManager.lastUpdateKey, item: Date())
  }
  
  func shouldSkipFetching() -> Bool {
    guard let latestUpdateDate: Date = UserDefaultManager.read(key: UserDefaultManager.lastUpdateKey) else { return false }
    debugPrint(latestUpdateDate)
    
    // extract only day and compare
    let latestUpdateDay = Calendar.current.component(.day, from: latestUpdateDate)
    let currentDay = Calendar.current.component(.day, from: Date())
    
    return latestUpdateDay == currentDay
  }
  
  func restorePhotoMetadata() -> [PhotoMetadata] {
    let managedPhotosMetadata = RealmManager.read(ofType: ManagedPhotoMetadata.self)
    
    return managedPhotosMetadata.map { managed in
      
      let imageHDURL = managed.imageHDURL == nil ? nil : URL(string: managed.imageHDURL!)!
      let imageURL = managed.imageURL == nil ? nil : URL(string: managed.imageURL!)!
      
      return PhotoMetadata(
        copyright: managed.copyright,
        date: managed.date,
        explanation: managed.explanation,
        imageHDURL: imageHDURL,
        imageURL: imageURL,
        title: managed.title
      )
    }
  }
  
  @discardableResult
  func storePhotoMetadata(photosMetadata: [PhotoMetadata]) -> Bool {
    
    let managedPhotosMetadata = photosMetadata.map { metadata in
      ManagedPhotoMetadata(
        copyright: metadata.copyright,
        date: metadata.date,
        explanation: metadata.explanation,
        imageHDURL: metadata.imageHDURL?.description,
        imageURL: metadata.imageURL?.description,
        title: metadata.title
      )
    }
    
    return RealmManager.save(items: managedPhotosMetadata)
  }
  
  
  func restoreLatestPhoto(completion: @escaping(UIImage?) -> ()) {
    let items = RealmManager.read(ofType: ManagedPhotoMetadata.self)
    let imageURL = items.first?.imageHDURL
  
    let cache = KFManager.kfImageCache
    cache.retrieveImage(forKey: imageURL! ) { result in
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
    
  
}
