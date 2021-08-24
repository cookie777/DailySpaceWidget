//
//  PhotoMetadataStorageService.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-22.
//

import Foundation
import RxSwift
import RealmSwift

protocol PhotoMetadataStorageService: AnyObject {
  
  var realm : Realm { get }
  
  func shouldSkipFetching() -> Bool
  
  func storeLatestUpdateDate()
  
  func restorePhotoMetadata() -> [PhotoMetadata]
  
  func storePhotoMetadata(photosMetadata: [PhotoMetadata]) -> Bool
}


class PhotosMetadataStorageServiceImplementation: PhotoMetadataStorageService {
  
  var realm : Realm {
    do {
      let realm = try Realm()
      return realm
    } catch let error as NSError {
      print("couldn't open realm")
      print(error.localizedDescription)
      fatalError()
    }
  }
  
  func storeLatestUpdateDate() {
    let defaults = UserDefaults.standard
    defaults.setValue(Date(), forKey: "LatestUpdateDate")
  }
  
  func shouldSkipFetching() -> Bool {
    let defaults = UserDefaults.standard
    guard let latestUpdateDate = defaults.object(forKey: "LatestUpdateDate") as? Date else { return false }
    
    debugPrint(latestUpdateDate)
    let latestUpdateDay = Calendar.current.component(.day, from: latestUpdateDate)
    let currentDay = Calendar.current.component(.day, from: Date())
    
    return latestUpdateDay == currentDay
  }
  
  func restorePhotoMetadata() -> [PhotoMetadata] {
    let managedPhotosMetadata = realm.objects(ManagedPhotoMetadata.self)
    
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
    
    do {
      try realm.write {
        realm.add(managedPhotosMetadata)
      }
    } catch let error {
      print("couldn't save to realm")
      print(error.localizedDescription)
      return false
    }
    
    return true
  }
  
  
  
}
