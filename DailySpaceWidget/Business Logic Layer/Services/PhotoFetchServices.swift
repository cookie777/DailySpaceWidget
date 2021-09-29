//
//  PhotoMetaServices.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import Foundation
import RxSwift

protocol PhotoFetchService: AnyObject {
  /// Returns by default past 10 photos metadata
  func getPhotosMetadata(days: Int) -> Observable<([NASAPhotoMetadata]?, Error?)>
  func getPhotosMetadataSync(days: Int) -> ([NASAPhotoMetadata]?, Error?)
}

final class PhotosFetchServiceImplementation: PhotoFetchService {
  private let networkClient = NetworkClient(baseUrlString: BasicURLs.NASA)
  
  func getPhotosMetadata(days: Int) -> Observable<([NASAPhotoMetadata]?, Error?)> {
    let parameter = [
      "api_key": APIKeys.NASA,
      "start_date": Date.getPastDate(days: days)
    ]
    
    return networkClient.getArray(
      [NASAPhotoMetadata].self,
      EndPoints.NASAapod,
      parameters: parameter,
      printURL: true
    )
  }
  
  func getPhotosMetadataSync(days: Int) -> ([NASAPhotoMetadata]?, Error?) {
    let parameter = [
      "api_key": APIKeys.NASA,
      "start_date": Date.getPastDate(days: days)
    ]

    return networkClient.getArraySync(
      [NASAPhotoMetadata].self,
      EndPoints.NASAapod,
      parameters: parameter,
      printURL: true
    )
  }
}
