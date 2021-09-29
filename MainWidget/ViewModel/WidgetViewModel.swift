//
//  WidgetViewModel.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-26.
//

import UIKit

final class WidgetViewModel {

  private var photoStorageService: PhotoStorageService!
  private var photoFetchService: PhotoFetchService!
  
  init(
    photoStorageService: PhotoStorageService,
    photoFetchService: PhotoFetchService
  ) {
    self.photoStorageService = photoStorageService
    self.photoFetchService = photoFetchService
  }
  
  func getItem() -> (UIImage?, PhotoMetadata?) {
    guard let metadata = getMetadata() else { return (nil, nil) }
    let (image, _) = ImageManager.getImageSync(url: metadata.imageURL)

    return (image, metadata)
  }
  
  private func getMetadata() -> PhotoMetadata? {
    // Check necessity of fetching
//    if photoStorageService.hasLatestMetadata() {
//      return photoStorageService.restoreLatestMetaData()?.toPhotoMetadata()
//    }
    
    // Fetch
    let (nasaMetadata, error) = photoFetchService.getPhotosMetadataSync(days: Constant.Config.numOfDaysToKeep + 5)
    if let error = error {
      print(error.localizedDescription)
      return nil
    }
    guard let nasaMetadata = nasaMetadata else { return nil }
    
    // Filter only image type. Reverse and get last n items
    let photosMetadata = nasaMetadata
      .filter({$0.mediaType == "image"})
      .reversed()
      .reduce(into: [NASAPhotoMetadata](), { result, metadata in
        if result.count < Constant.Config.numOfDaysToKeep {
          result.append(metadata)
        }
      })
    // convert to `PhotoMetadata`
      .map { $0.toPhotoMetadata()}
    
    // store metadata to realm
    if self.photoStorageService.storePhotoMetadata(photosMetadata: photosMetadata) {
      debugPrint("Success: storing photo metadata")
      self.photoStorageService.storeLatestUpdateDate()
    } else {
      debugPrint("failed: storing photo metadata")
    }
    
    guard let firstMetadata = photosMetadata.first else {
      print("failed: no photo metadata")
      return nil
    }
    
    return firstMetadata
  }
}
