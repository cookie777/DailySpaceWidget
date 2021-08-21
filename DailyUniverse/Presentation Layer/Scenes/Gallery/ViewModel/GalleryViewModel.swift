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
  
  var disposeBag = DisposeBag()
  var photosMetadata = BehaviorRelay<[PhotoMetadata]>(value: [])
  
  private var photoMetadataService: PhotoMetadataService!
  
  init(photoMetadataService: PhotoMetadataService) {
    self.photoMetadataService = photoMetadataService
  }
  
  // MARK: - Service Methods
  func getPhotoMetadata() {
    
    photoMetadataService.getPhotosMetadata(days: 10)
      // eliminate error
      .filter { $0.0 != nil && $0.1 == nil }
      .compactMap {  photos, _  in
      // image type only, latest n
        photos?
          .filter({$0.mediaType == "image"})
          .reversed()
          .reduce(into: [NASAPhotoMetadata](), { result, metadata in
            if result.count < 3 {
              result.append(metadata)
            }
        })
      }
      .map { photos in
        return photos.map { photo in
          let hdURL = photo.hdURL == nil ? nil : URL(string: photo.hdURL!)
          let url = photo.url == nil ? nil : URL(string: photo.url!)
          
          return PhotoMetadata(
            copyright: photo.copyright,
            date: photo.date,
            explanation: photo.explanation,
            imageHDURL: hdURL,
            imageURL: url,
            title: photo.title
          )
        }
      }
      .bind(to: photosMetadata)
      .disposed(by: disposeBag)
    
  }
  
  func getMockMetadata() {
    var photosMetadata: [PhotoMetadata] = []
    
    let placeHolder = URL(string: "https://raw.githubusercontent.com/cookie777/images/main/common/sample.png")
    for i in 0...10 {
      photosMetadata.append(PhotoMetadata(copyright: nil, date: nil, explanation: nil, imageHDURL: placeHolder, imageURL: placeHolder, title: String(i)))
    }
    
    self.photosMetadata.accept(photosMetadata)
    
  }
  
}
