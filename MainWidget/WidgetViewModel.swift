//
//  WidgetViewModel.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-26.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class WidgetViewModel {
  
  let disposeBag = DisposeBag()
  
  var isFetching: Bool = false
  var count: Int = 0
  
  // out put,  vm -> view
  private var updatePhoto = PublishRelay<UIImage?>()
  
  private var photoStorageService: PhotoStorageService!
  private var photoFetchService: PhotoFetchService!
  
  init(
    photoStorageService: PhotoStorageService,
    photoFetchService: PhotoFetchService
  ) {
    self.photoStorageService = photoStorageService
    self.photoFetchService = photoFetchService
  }
  
  
  //  func getImage(completion: @escaping ((UIImage?)->()) ) {
  func getImage() -> Observable<UIImage?> {
    //    self.isFetching = true
    //
    //
    //    if photoStorageService.hasLatestMetadata() {
    //
    //      let latesMetadata = photoStorageService.restoreLatestMetaData()
    //
    //      if let hdURL = latesMetadata?.imageHDURL {
    //        KFManager.checkImageCache(key: hdURL) { image in
    //
    //          if let image = image {
    //            print("fetched from HD cache")
    //            completion(image)
    //          } else {
    //
    //            if let url = latesMetadata?.imageURL, let imageURL = URL(string: url) {
    //              KFManager.getImage(url: imageURL) { image in
    //                print("fetched normal image")
    //                completion(image)
    //              }
    //            } else {
    //              completion(nil)
    //            }
    //
    //
    //          }
    //
    //        }
    //      } else {
    //        if let url = latesMetadata?.imageURL, let imageURL = URL(string: url) {
    //          KFManager.getImage(url: imageURL) { image in
    //            print("fetched normal image")
    //            completion(image)
    //          }
    //        } else {
    //          completion(nil)
    //        }
    //      }
    //      return
    //    }
    // get metadata and save. + fetch one image
    return photoFetchService.getPhotosMetadata(days: Constant.Config.numOfDaysToKeep + 5)
      // eliminate error
      .filter { $0.0 != nil && $0.1 == nil }
      .compactMap {  photos, _  in
        // image type only, reverse and get latest n items
        photos?
          .filter({$0.mediaType == "image"})
          .reversed()
          .reduce(into: [NASAPhotoMetadata](), { result, metadata in
            if result.count < Constant.Config.numOfDaysToKeep {
              result.append(metadata)
            }
          })
      }
      // convert to `PhotoMetadata`
      .map { photos -> [PhotoMetadata] in
        print("w:fetchd")
        return photos.map { photo in
          let hdURL = photo.hdURL == nil ? nil : URL(string: photo.hdURL!)
          let url = photo.url == nil ? nil : URL(string: photo.url!)
          
          return PhotoMetadata(
            copyright: photo.copyright,
            date: DateFormatter.toDate(string: photo.date),
            explanation: photo.explanation,
            imageHDURL: hdURL,
            imageURL: url,
            title: photo.title
          )
        }
      }
      // store metadata to realm
      .do(onNext: { [weak self] items in
        if let res = self?.photoStorageService.storePhotoMetadata(photosMetadata: items), res {
          debugPrint("succeeded storing fetch items")
        }
        //        self?.photoStorageService.storeLatestUpdateDate()
      })
      .flatMap { items in
        return Observable<PhotoMetadata?>.just(items.first)
      }
      .flatMap({ item in
        Observable<UIImage?>.create { observer -> Disposable in
          
          KFManager.getImage(url: item?.imageHDURL) { image in
            print("fetched image from widget")
            print(image)
            observer.onNext(image)
            observer.onCompleted()
          }
          return Disposables.create()
          
        }
      })
    
    
  }
}
