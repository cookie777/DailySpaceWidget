//
//  GalleryViewModel.swift
//  DailyUniverse
//
//  Created by Takayuki Yamaguchi on 2021-08-16.
//

import Foundation

class GalleryViewModel {
  
  var snapshot: Snapshot!
  
  init() {
    snapshot = Snapshot()
    snapshot.appendSections([.gallery])    
  }
  
}
