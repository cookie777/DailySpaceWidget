//
//  WidgetViewModel.swift
//  DailySpaceWidget
//
//  Created by Takayuki Yamaguchi on 2021-08-26.
//


import Kingfisher
import RxSwift
import RxCocoa


class WidgetViewModel {
  
  let disposeBag = DisposeBag()
  
  var isFetching: Bool = false
  var count: Int = 0
  
  private var photoStorageService: PhotoStorageService!
  private var photoFetchService: PhotoFetchService!
  
  init(
    photoStorageService: PhotoStorageService,
    photoFetchService: PhotoFetchService
  ) {
    self.photoStorageService = photoStorageService
    self.photoFetchService = photoFetchService
  }
  
  func getItem() -> Observable<(UIImage?, PhotoMetadata?)> {
    
    // If already has metadata, try to use it.
    if photoStorageService.hasLatestMetadata() {
      let latesMetadata = photoStorageService.restoreLatestMetaData()
      return CustomKFManager.checkImageCache(key: latesMetadata?.imageHDURL)
        .flatMap { image -> Observable<UIImage?> in
          // try to use hd image (don't fetch)
          if let image = image {
            debugPrint("Has metadata and hd cache. Success.")
            let downsampled = image.kf.resize(to: CustomKFManager.downsamplingImageSize, for: .aspectFit)
            return Observable.just(downsampled)
          // if no, use cache or fetch norma image
          } else {
            debugPrint("Has metadata and not hd, but normal. Success.")
            return CustomKFManager.getImage(key: latesMetadata?.imageURL)
          }
        }
        .flatMap { image in
          Observable.just((image, latesMetadata?.toPhotoMetadata()))
        }
    }

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
        return photos.map { $0.toPhotoMetadata()}
      }
      // store metadata to realm
      .do(onNext: { [weak self] items in
        if let res = self?.photoStorageService.storePhotoMetadata(photosMetadata: items), res {
          debugPrint("Success: storing fetch items")
        }
        self?.photoStorageService.storeLatestUpdateDate()
      })
      .flatMap({ items -> Observable<(UIImage?, PhotoMetadata?)> in
        debugPrint("Success: fetched metadata and fetched imageURL")
        return CustomKFManager.getImage(url: items.first?.imageURL)
          .flatMap { image in
            Observable.just((image, items.first))
          }
      })
    
    
  }
}
