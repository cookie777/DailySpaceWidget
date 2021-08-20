//
//  PhotoMetaServices.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import Foundation
import RxSwift

protocol PhotoMetaDataService: AnyObject {
  /// Returns by default past 10 photos metadata
  func getPhotoMetaDatas(days: Int) -> Observable<([NASAPhotoMeta]?, Error?)>
  
  /// Returns a single photo metadata by the given **date**
  func getPhotoMetaData(date: String) -> Observable<(NASAPhotoMeta?, Error?)>
}
//
class PhotosMetaDataServiceImplementation: PhotoMetaDataService {
  
  let networkClient = NetworkClient(baseUrlString: BasicURLs.NASA)
  
  func getPhotoMetaDatas(days: Int) -> Observable<([NASAPhotoMeta]?, Error?)> {
    
    let parameter = [
      "api_key": APIKeys.NASA,
      "start_date": Date.getPastDate(days: days)
    ]
    
    return networkClient.getArray(
      [NASAPhotoMeta].self,
      EndPoints.NASAapod,
      parameters: parameter,
      printURL: true
    )
  }
  
  func getPhotoMetaData(date: String) -> Observable<(NASAPhotoMeta?, Error?)> {

    let parameter = [
      "api_key": APIKeys.NASA,
    ]
    
    return networkClient.get(
      NASAPhotoMeta.self,
      EndPoints.NASAapod,
      parameters: parameter,
      printURL: true
    )
  }

}
