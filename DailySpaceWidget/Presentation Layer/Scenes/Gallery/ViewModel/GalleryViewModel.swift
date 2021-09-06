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
  // input: View -> ViewModel
  var currentIndexPath: IndexPath? = IndexPath(item: 0, section: 0)
  var cellDescriptionTapped = PublishRelay<Int>()
  var cellPhotoFocusTapped = PublishRelay<Int>()
  // output: ViewModel -> View
  var photosMetadata = BehaviorRelay<[PhotoMetadata]>(value: [])
  
  let coordinator: GalleryCoordinator!
  private var photoFetchService: PhotoFetchService!
  private var photoStorageService: PhotoStorageService!
  
  var contentMode:UIView.ContentMode = .scaleAspectFit
  
  init(
    coordinator: GalleryCoordinator,
    photoStorageService: PhotoStorageService,
    photoFetchService: PhotoFetchService
  ) {
    self.coordinator = coordinator
    self.photoStorageService = photoStorageService
    self.photoFetchService = photoFetchService
    
    bindOnCellDescriptionTapped()
  }
  
  // MARK: - Bindings
  
  private func bindOnCellDescriptionTapped() {
    cellDescriptionTapped
      .bind { [weak self] index in
        guard let self = self else { return }
        // coordinate to next
        let photoMetaData = self.photosMetadata.value[index]
        self.coordinator.pushToDetail(photoMetadata: photoMetaData)
      }.disposed(by: disposeBag)
    
    cellPhotoFocusTapped
      .bind { [weak self] index in
        guard let self = self else { return }
        // coordinate to next
        let photoMetaData = self.photosMetadata.value[index]
        self.coordinator.pushToDetail(photoMetadata: photoMetaData)
      }.disposed(by: disposeBag)
  }


  // MARK: - Service Methods
  
  func getPhotoMetadata() {
    // if same day, restore from catch
    if photoStorageService.hasLatestMetadata() {
      let items = photoStorageService.restorePhotoMetadata()
      photosMetadata.accept(items)
      photoStorageService.storeLatestUpdateDate()
      debugPrint("restore items from realm")
      return
    }
    
    photoFetchService.getPhotosMetadata(days: Constant.Config.numOfDaysToKeep + 5)
      // eliminate error
      .filter { $0.0 != nil && $0.1 == nil }
      .compactMap {  photos, _  in
      // image type only, latest n
        photos?
          .filter({$0.mediaType == "image"})
          .reversed()
          .reduce(into: [NASAPhotoMetadata](), { result, metadata in
            if result.count < Constant.Config.numOfDaysToKeep {
              result.append(metadata)
            }
        })
      }
      .map { photos -> [PhotoMetadata] in
        return photos.map { photo in
          photo.toPhotoMetadata()
        }
      }
      .do(onNext: { [weak self] items in
        if let res = self?.photoStorageService.storePhotoMetadata(photosMetadata: items), res {
          debugPrint("succeeded storing fetch items")
        }
        self?.photoStorageService.storeLatestUpdateDate()
      })
      .bind(to: photosMetadata)
      .disposed(by: disposeBag)
  }
  
  func getMockMetadata() {
    var photosMetadata: [PhotoMetadata] = []
    
    let placeHolder = URL(string: "https://assets.newatlas.com/dims4/default/b89cd58/2147483647/strip/true/crop/925x617+0+232/resize/1200x800!/quality/90/?url=http%3A%2F%2Fnewatlas-brightspot.s3.amazonaws.com%2Farchive%2Fchandra-nasa-space-telescope-anniversary-4.jpg")
    
    for i in 0...10 {
      photosMetadata.append(
        PhotoMetadata(
          copyright: "©mock copyright",
          date: Date(),
          explanation: "Plowing through Earth's atmosphere at 60 kilometers per second, this bright perseid meteor streaks along a starry Milky Way. Captured in dark Portugal skies on August 12, it moves right to left through the frame. Its colorful trail starts near Deneb (alpha Cygni) and ends near Altair (alpha Aquilae), stars of the northern summer triangle. In fact this perseid meteor very briefly outshines both, two of the brightest stars in planet Earth's night. The trail's initial greenish glow is typical of the bright perseid shower meteors. The grains of cosmic sand, swept up dust from periodic comet Swift-Tuttle, are moving fast enough to excite the characteristic green emission of atomic oxygen at altitudes of 100 kilometers or so before vaporizing in an incandescent flash.   Notable APOD Image Submissions: Perseid Meteor Shower 2021",
          imageHDURL: placeHolder,
          imageURL: placeHolder,
          title: "mock title \(i)"
        )
      )
    }
    
    self.photosMetadata.accept(photosMetadata)
    
  }
  
}
