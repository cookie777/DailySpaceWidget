//
//  GalleryViewModel.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import Foundation
import RxSwift
import RxCocoa

class GalleryViewModel {
  
  var snapshot: Snapshot!
  
  var disposeBag = DisposeBag()
  //  var photos: Array<Photo> = []
  var photos = BehaviorRelay<[Photo]>(value: [])
  
  private var photoMetaDataService: PhotoMetaDataService!
  
  init(photoMetaDataService: PhotoMetaDataService) {
    self.photoMetaDataService = photoMetaDataService
    snapshot = Snapshot()
    snapshot.appendSections([.gallery])
  }
  
  // MARK: - Service Methods
  func getPhotoMetaData() {
    
    photoMetaDataService.getPhotoMetaDatas(days: 10)
      .filter { $0.0 != nil && $0.1 == nil }
      .compactMap {  photos, _  in
        photos?.filter({$0.mediaType == "image"})
      }
      .flatMap { photos -> Observable<[NASAPhotoMeta]> in
        if photos.count > 7 {
          return Observable.just(Array(photos[0 ..< 7]))
        }
        return  Observable.just(photos)
      }
      .map { photos in
        photos.map { photo in
          Photo(
            copyright: photo.copyright,
            date: photo.date,
            explanation: photo.explanation,
            imageUrl: photo.url,
            title: photo.title
          )
        }
      }
      .bind(to: photos)
      .disposed(by: disposeBag)
    
  }
  
}
