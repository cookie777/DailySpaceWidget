//
//  PhotoMetaServices.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import Foundation
import RxSwift

protocol PhotoMetadataFetchService: AnyObject {
  /// Returns by default past 10 photos metadata
  func getPhotosMetadata(days: Int) -> Observable<([NASAPhotoMetadata]?, Error?)>
  
  /// Returns a single photo metadata by the given **date**
  func getPhotoMetadata(date: String) -> Observable<(NASAPhotoMetadata?, Error?)>
}
//
class PhotosMetadataFetchServiceImplementation: PhotoMetadataFetchService {
  
  let networkClient = NetworkClient(baseUrlString: BasicURLs.NASA)
  
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
  
  func getPhotoMetadata(date: String) -> Observable<(NASAPhotoMetadata?, Error?)> {

    let parameter = [
      "api_key": APIKeys.NASA,
    ]
    
    return networkClient.get(
      NASAPhotoMetadata.self,
      EndPoints.NASAapod,
      parameters: parameter,
      printURL: true
    )
  }

}
