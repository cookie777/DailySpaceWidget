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
  
  func hasLatestMetadata() -> Bool
  
  func storeLatestUpdateDate()
  
  func restorePhotoMetadata() -> [PhotoMetadata]
  
  func storePhotoMetadata(photosMetadata: [PhotoMetadata]) -> Bool
  
  func restoreLatestMetaData() -> ManagedPhotoMetadata?

}

final class PhotoStorageServiceImplementation: PhotoStorageService {

  
  func storeLatestUpdateDate() {
    UserDefaultManager.save(key: UserDefaultManager.lastUpdateKey, item: Date())
  }
  
  func hasLatestMetadata() -> Bool {
    guard let latestUpdateDate: Date = UserDefaultManager.read(key: UserDefaultManager.lastUpdateKey) else { return false }
    debugPrint("Last update: \(latestUpdateDate)")
    
    // extract only day and compare
    let latestUpdateDay = Calendar.current.component(.day, from: latestUpdateDate)
    let currentDay = Calendar.current.component(.day, from: Date())
    
    return latestUpdateDay == currentDay
  }
  
  func restorePhotoMetadata() -> [PhotoMetadata] {
    let managedPhotosMetadata = RealmManager.read(ofType: ManagedPhotoMetadata.self)
    
    return managedPhotosMetadata.map { managed in
      managed.toPhotoMetadata()
    }
  }
  
  @discardableResult
  func storePhotoMetadata(photosMetadata: [PhotoMetadata]) -> Bool {
    let managedPhotosMetadata = photosMetadata.map { metadata in
      metadata.toManaged()
    }
    return RealmManager.save(items: managedPhotosMetadata)
  }
  
  func restoreLatestMetaData() -> ManagedPhotoMetadata? {
    let items = RealmManager.read(ofType: ManagedPhotoMetadata.self)
    return items.first
  }
  
}
